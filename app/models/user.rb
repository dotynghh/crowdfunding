# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_admin               :boolean          default(FALSE)
#  user_name              :string(255)
#  image                  :string(255)
#  aasm_state             :string(255)
#  phone_number           :string(255)
#  captcha                :string(255)
#  country_code           :string(255)      default("+86")
#  weibo                  :string(255)
#  description            :string(255)
#

#  phone_number           :integer
#  captcha                :integer

#  aasm_state             :string

#
# Indexes
#
#  index_users_on_aasm_state            (aasm_state)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # validates :contact_phone_number, format: { with: /^1[0-9]{10}$/, message: "请输入正确的手机号码！"}, :multiline => true
  # validates_uniqueness_of :phone_number
  # validates :phone_number, phone: { possible: false, allow_blank: true, types: [:mobile] }
  # validates :captcha, presence: true


  after_create :generate_account

  mount_uploader :image, HeadimageUploader

  def admin?
    is_admin
  end

  has_many :orders
  has_many :projects
  has_one :account
  has_many :identiy_verifications

  def generate_account
    Account.create!(user_id: id)
  end

  include AASM

  aasm do
    state :user_registered, initial: true
    state :request_verify
    state :passed_verified
    state :unpassed_verified

    event :apply_for_certify do
      transitions from: %i(user_registered unpassed_verified), to: :request_verify
    end
    event :approve do
      # transitions from: :request_verify, to: :passed_verified
      transitions from: :user_registered, to: :passed_verified
    end
    event :reject do
      transitions from: :request_verify, to: :unpassed_verified
    end
  end
end
