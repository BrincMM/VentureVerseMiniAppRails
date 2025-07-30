class LogInHistory < ApplicationRecord
  belongs_to :user

  validates :timestamp, presence: true
  validates :metadata, presence: true
  validate :validate_metadata_json

  private

  def validate_metadata_json
    return if metadata.blank?
    
    begin
      JSON.parse(metadata)
    rescue JSON::ParserError
      errors.add(:metadata, "must be valid JSON")
    end
  end
end 