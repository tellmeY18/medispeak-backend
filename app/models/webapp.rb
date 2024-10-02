class Webapp < ApplicationRecord
  belongs_to :user
  has_many :pages, dependent: :destroy
  has_many :form_fields, through: :pages

  validates :title, presence: true
  validates :fqdn, presence: true
end
