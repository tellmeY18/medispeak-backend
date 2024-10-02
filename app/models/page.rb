class Page < ApplicationRecord
  belongs_to :template
  has_many :form_fields, dependent: :destroy
  has_many :transcriptions, dependent: :destroy
end
