json.extract! form_field, :id, :title, :description, :page_id, :metadata, :created_at, :updated_at, :friendly_name, :field_type, :minimum, :maximum, :enum_options
json.url form_field_url(form_field, format: :json)
