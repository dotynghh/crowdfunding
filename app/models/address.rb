class Address < ApplicationRecord
  validates :user_id, presence: true
  validates :address_type, presence: true
  validates :contact_name, presence: { message: "收货人不能为空" }
  validates :cellphone, presence: { message: "手机号不能为空" }
  validates :address, presence: { message: "地址不能为空" }

  belongs_to :user

  attr_accessor :set_as_default

  after_save :set_as_default_address
  before_destroy :remove_self_as_default_address

  module AddressType
    User = 'user'
    Order = 'order'
  end

  def address_tos
    "地址：" + address + " 姓名：" + contact_name + " 手机号：" + cellphone + " 邮编:" + zipcode
  end

  def self.getAddress address_id
    address = self.find_by(id: address_id)
    address.address_tos
  end

  private
  def set_as_default_address
    if self.set_as_default.to_i == 1
      self.user.default_address = self
      self.user.save!
    else
      remove_self_as_default_address
    end
  end

  def remove_self_as_default_address
    if self.user.default_address == self
      self.user.default_address = nil
      self.user.save!
    end
  end
end

# == Schema Information
#
# Table name: addresses
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  address_type :string(255)
#  contact_name :string(255)
#  cellphone    :string(255)
#  address      :string(255)
#  zipcode      :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
