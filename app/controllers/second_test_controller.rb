class SecondTestController < ApplicationController
  def index
  end

  def send_message
    @date = send_message_params[:date]
    @nights = send_message_params[:nights]
    @email = send_message_params[:email]

    fan_date = Date.parse(@date).strftime('%d.%m.%Y')

    TestWorker.perform_async(@email, fan_date, @nights)
  end

  private

  def send_message_params
    params.permit(:date, :nights, :email)
  end
end
