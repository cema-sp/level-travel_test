class SecondTestMailer < ActionMailer::Base
  default from: 's.a.pisarev@gmail.com'

  def countries_email(email, date, nights, countries)
    @email, @date, @nights, @countries = email, date, nights, countries

    mail(to: @email, subject: "Страны, доступные #{@date} на #{@nights} ночей")
  end
end
