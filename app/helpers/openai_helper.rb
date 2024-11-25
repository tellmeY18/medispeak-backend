module OpenaiHelper
  def client
    validate_api_credentials
    @client ||= OpenAI::Client.new(
      access_token: ENV["OPENAI_ACCESS_TOKEN"],
      organization_id: ENV["OPENAI_ORGANIZATION_ID"]
    )
  end

  def ai_transcribe(file)
    begin
      response = client.audio.translate(parameters: { model: "whisper-1", file: File.open(file) })
      response["text"]
    rescue Faraday::Error => e
      handle_openai_error(e)
    end
  end

  def system_prompt(transcription)
    return transcription.page.prompt if transcription.page.prompt.present?

    "You are an AI assitant filling the form for an user. Make sure that you do not populate the form with any data that the user did not provide. Ensure all data shared by users are correctly split into function arguments."
  end

  def ai_generate_completion(transcription)
    begin
      response =
        client.chat(
          parameters: {
            model: "gpt-3.5-turbo-1106",
            messages: [
              {
                "role": "system",
                "content": system_prompt(transcription)
              },
              {
                "role": "user",
                "content": transcription.transcription_text
              }
            ],
            tools: [
              {
                type: "function",
                function: {
                  name: "fill_form",
                  description: "Fill out a form with the data from the user's message",
                  parameters: {
                    type: :object,
                    properties: { **create_types_form_form_fields(transcription.form_fields, transcription.context) },
                    required: []
                  }
                }
              }
            ]
          },
        )
    rescue Faraday::Error => e
      handle_openai_error(e)
    end

    message = response.dig("choices", 0, "message")
    usage = response.dig("usage")

    if message["role"] == "assistant" && message["tool_calls"]
      message["tool_calls"].each do |tool_call|
        tool_name = tool_call.dig("function", "name")
        args =
          JSON.parse(
            tool_call.dig("function", "arguments"),
            symbolize_names: true
          )
        case tool_name
        when "fill_form"
          transcription.update!(ai_response: args, status: :completion_generated, **usage_tokens(transcription, usage))
        else
          transcription.update!(status: :failed, **usage_tokens(transcription, usage))
        end
      end
    end
  end

  def smart_description(form_field, context)
    if context[form_field.title]
      "#{form_field.description}; Context: #{context[form_field.title]}"
    else
      form_field.description
    end
  end

  def usage_tokens(transcription, usage)
    {
      prompt_tokens: usage["prompt_tokens"] + transcription.prompt_tokens,
      completion_tokens: usage["completion_tokens"] + transcription.completion_tokens,
      total_tokens: usage["total_tokens"] + transcription.total_tokens
    }
  end

  def create_types_form_form_fields(form_fields, context)
    fields = {}
    form_fields.each do |form_field|
      fields[form_field.title] = {
        type: :string,
        description: smart_description(form_field, context)
      }
    end
    fields
  end

  private

  def validate_api_credentials
    missing_keys = []
    missing_keys << "API key" unless ENV["OPENAI_ACCESS_TOKEN"].present?
    missing_keys << "Organization ID" unless ENV["OPENAI_ORGANIZATION_ID"].present?

    if missing_keys.any?
      raise GenericException.new(
        message: "OpenAI #{missing_keys.join(' and ')} is missing. Please set it in the environment variable OPENAI_ACCESS_TOKEN and OPENAI_ORGANIZATION_ID.",
        code: :failed_dependency
      )
    end
  end

  def handle_openai_error(error)
    raise GenericException.new(
        message: "The OpenAI request was unsuccessful. " \
          "Please verify your API key, organization ID, plan, " \
          "and billing details before attempting again. Error: #{error.message}",
        code: :failed_dependency
      )
  end
end
