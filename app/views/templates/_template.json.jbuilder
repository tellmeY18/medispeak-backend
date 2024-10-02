json.extract! template, :id, :name, :description, :archived, :created_at, :updated_at
json.pages template.pages do |page|
  json.partial! "pages/page", page: page
end
