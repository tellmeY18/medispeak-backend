class Domain < ApplicationRecord
  belongs_to :template

  validates :fqdn, presence: true, uniqueness: true
  validates :template, presence: true
end
