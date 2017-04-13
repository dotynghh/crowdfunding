class NotificationService
  # def initialize(order, user, project)
  def initialize(options)
    @to_phone_number = options[:phone_number] unless options[:phone_number].nil?
    @code = options[:code] unless options[:code].nil?
  end

  def send_sms
    UserMailer.send_email(@code).deliver!
    return true
  end
end
