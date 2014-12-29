class SecondTestMailer < ActionMailer::Base
  default from: 's.a.pisarev@gmail.com'

  def countries_email(email, date, nights, countries)
    @email, @date, @nights, @countries = email, date, nights, countries

    mail(to: @email, subject: "Countries on #{@date} for #{@nights} nights")
  end
end
