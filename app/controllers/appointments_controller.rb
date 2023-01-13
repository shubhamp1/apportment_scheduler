class AppointmentsController < ApplicationController
  def index
    @appointments = Appointment.all
  end

  def new
    @doctor = Doctor.find(params[:id])
    @appointment = @doctor.appointments.build
    @availability = @doctor.availability
    @disabled_days = Doctor.disabled_days(@availability)
  end

  def create
    appointment = Appointment.new appointment_params
    flash[:errors] = if appointment.save
                       'Your appointment has been boooked'
                     else
                       appointment.errors.full_messages
                     end
    redirect_to home_index_path, alert: appointment.errors.full_messages
  end

  def show
    @doctor_name = Doctor.find(params[:id]).name
    @appointments = Appointment.where(doctor_id: params[:id])
  end

  def find_appointment
    @appointment = Appointment.where(doctor_id: params[:doctor_id],
                                     date: params[:date])
    @disabled_slots = []
    @appointment.each do |appointment|
      @disabled_slots << [appointment.time.strftime('%I:%M %p'),
                          (appointment.time + (appointment.doctor
                            .availability.slot_range - 1).minute)  #ask this question to prince
                         .strftime('%I:%M %p')]
    end
    respond_to do |format|
      format.json { render json: @disabled_slots }
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:doctor_id, :patient_id, :date, :time)
  end
end
