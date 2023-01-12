class Availability < ApplicationRecord
  belongs_to :doctor, class_name: 'Doctor', foreign_key: 'doctor_id'

  # enum
  enum start_day: %i[sunday monday tuesday wednesday thursday friday saturday], _prefix: true
  enum end_day: %i[sunday monday tuesday wednesday thursday friday saturday]

  # validations
  validates :start_day, :end_day, :start_time, :end_time, presence: true
  validates :slot_range, presence: true, format: { with: /\A[0-9]+\Z/, message: 'it should be number' }
  validate :check_role, on: :create


  def check_role
    errors.add(:user, 'is not a doctor') unless doctor&.is_doctor?
  end
end
