class GenericException < StandardError
  attr_reader :message, :code

  def initialize(message: "", code: :internal_server_error)
    @message = message
    super(@message)
    @code = code
  end

  def attributes
    {
      code: @code,
      message:,
    }
  end
end