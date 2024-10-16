json.extract! page, :id, :template_id, :name, :created_at, :updated_at
json.url page_url(page, format: :json)
json.form_fields page.form_fields do |form_field|
  json.partial! "form_fields/form_field", form_field: form_field
end
