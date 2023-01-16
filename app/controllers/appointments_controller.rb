class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :get_appointment, only: %i[edit update cancel_appointment]

  def index
    @appointments = Appointment.all
  end

  def new
    appointment_objects
    @appointment = @doctor.appointments.build
  end

  def edit
    appointment_objects
  end

  def update
    if @appointment
      if @appointment.update(appointment_params)
        flash[:notice] = 'Appointment has been updated'
      else
        flash[:errors] = @appointment.errors.full_messages
      end
    else
      flash[:errors] = 'Appointment cannot be found'
    end
    redirect_to root_path
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

  def cancel_appointment
    @appointment.destroy
    redirect_to home_index_path, alert: 'appointment has been deleted'
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
                            .availability.slot_range - 1).minute)
                         .strftime('%I:%M %p')]
    end
    respond_to do |format|
      format.json { render json: @disabled_slots }
    end
  end

  private

  def get_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:doctor_id, :patient_id, :date, :time)
  end

  def appointment_objects
    @doctor = Doctor.find(@appointment&.doctor_id || params[:id])
    @availability = @doctor.availability
    @disabled_days = Doctor.disabled_days(@availability)
  end
end
