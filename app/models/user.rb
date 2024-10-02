class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :api_tokens, dependent: :destroy
  has_many :transcriptions, dependent: :destroy
  has_many :webapps, dependent: :destroy
end
