class ApiToken < ApplicationRecord
  belongs_to :user

  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true
  validates :name, presence: true

  before_validation :generate_token, on: :create

  scope :active, -> { where(active: true).where('expires_at > ?', Time.current) }

  private

  def generate_token
    self.token = SecureRandom.hex(20) unless token.present?
  end
end
