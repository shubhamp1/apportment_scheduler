class Appointment < ApplicationRecord
  belongs_to :patient, class_name: 'User', foreign_key: 'patient_id'
  belongs_to :doctor

  # validations
  validates :date, presence: true, uniqueness: { scope: %i[time doctor_id] }
  validates :time, presence: true
  validate :appointment_validations, on: :create

  # enum
  enum status: %i[approved canceled]

  # methods
  private
  def appointment_validations
    start_time = doctor.availability.start_time
    end_time = doctor.availability.end_time
    slots = []
    slots << start_time
    while end_time > start_time
      start_time = start_time + doctor.availability.slot_range.minutes
      slots << start_time
    end
    # destroy_booked_slots(slots)
    unless slots.include?(time)
      errors.add(:time,"select proper slot")
    end
    start_time = doctor.availability.start_time
    if time.present?
      time = to_time(self.time.to_time)
      if time.between?(to_time(start_time), to_time(end_time))
        if date == Date.today
          unless time > to_time(Time.now)
            errors.add(:time, "must be greater than #{Time.now.strftime('%H:%M')}")
          end
        end
      else
        errors.add(:time, 'slot cannot be booked')
      end
    else
      errors.add(:time,' should be in proper format')
    end
  end

  def destroy_booked_slots(slots)
    dr_appointments = doctor.appointments.where(date: self.date)
    dr_appointments.map { |appointment| slots.delete(appointment) if slots.include?(appointment) }
  end

  def to_time(time)
    time.strftime('%H:%M')
  end
end
