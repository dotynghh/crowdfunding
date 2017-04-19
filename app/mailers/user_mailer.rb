class UserMailer < ApplicationMailer
  def send_email code,email
    @code = code
    @email = email || "479104983@qq.com"
    mail(to: @email, subject: "您的验证码为：#{@code}")
  end
end
