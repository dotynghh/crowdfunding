class UserMailer < ApplicationMailer
  def send_email code,email
    @code = code
    email = email || "demo@11.com"
    mail(to: email, subject: "您的验证码为：#{@code}")
  end
end
