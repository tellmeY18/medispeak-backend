class Template < ApplicationRecord
  has_many :domains, dependent: :destroy
  has_many :pages, dependent: :destroy

  scope :archived, -> { where(archived: true) }
  scope :active, -> { where(archived: false) }
end
