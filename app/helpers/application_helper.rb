module ApplicationHelper

  def check_appointment_action(appointment)
    ((appointment.date == Date.today and appointment.time.strftime("%I:%M %p") > Time.now.strftime("%I:%M %p")) or appointment.date >= Date.today) and
    (current_user.has_role? :admin or (appointment.patient || appointment.doctor) == current_user)
  end
end
