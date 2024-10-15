require "administrate/base_dashboard"

class TranscriptionDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    user: Field::BelongsTo,
    ai_response: Field::String.with_options(searchable: false),
    audio_file_attachment: Field::HasOne,
    audio_file_blob: Field::HasOne,
    form_fields: Field::HasMany,
    page: Field::BelongsTo,
    status: Field::Select.with_options(searchable: false, collection: ->(field) { field.resource.class.send(field.attribute.to_s.pluralize).keys }),
    transcription_text: Field::Text,
    duration: Field::Number,
    prompt_tokens: Field::Number,
    completion_tokens: Field::Number,
    total_tokens: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    user
    page
    status
    duration
    prompt_tokens
    completion_tokens
    total_tokens
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    user
    ai_response
    form_fields
    page
    status
    transcription_text
    duration
    prompt_tokens
    completion_tokens
    total_tokens
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    user
    page
    status
    transcription_text
    duration
    prompt_tokens
    completion_tokens
    total_tokens
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how transcriptions are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(transcription)
  #   "Transcription ##{transcription.id}"
  # end
end
