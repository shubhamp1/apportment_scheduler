class AvailabilitiesController < ApplicationController
  before_action :find_availability, only: %i[edit update]

  def edit; end

  def update
    if @availability
      if @availability.update(availability_params)
        flash[:errors] = 'Availability has been updated'
      else
        flash[:errors] = @availability.errors.full_messages
      end
    else
      flash[:errors] = 'Availability cannot be found'
    end
    redirect_to root_path
  end

  private

  def find_availability
    @availability = Availability.find(params[:id])
  end

  def availability_params
    params.require(:availability).permit(:start_day, :end_day, :start_time, :end_time, :slot_range)
  end
end
