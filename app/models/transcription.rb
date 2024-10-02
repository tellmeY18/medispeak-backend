class Transcription < ApplicationRecord
  belongs_to :user
  belongs_to :page
  has_many :form_fields, through: :page

  has_one_attached :audio_file

  enum status: {pending: "pending", transcribed: "transcribed", completion_generated: "completion_generated", failed: "failed"}
end
