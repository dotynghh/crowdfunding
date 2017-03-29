
class Order < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :plan

  scope :paid, -> { where(aasm_state: "paid") }

  before_create :calculate_total

  def calculate_total
    self.total_price = quantity * price
  end

  include AASM

  aasm do
    state :order_placed, initial: true
    state :paid
    state :shipping
    state :shipped
    state :order_cancelled
    state :good_returned
    state :appling_cancel_order
    state :appling_good_return

    event :make_payment do
      transitions from: :order_placed, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :shipping
    end

    event :deliver do
      transitions from: :shipping, to: :shipped
    end

    event :return_good do
      transitions from: %i(shipped appling_good_return), to: :good_returned
    end

    event :cancel_order do
      transitions from: %i(order_placed paid appling_cancel_order), to: :order_cancelled
    end

    event :apply_cancel_order do
      transitions from: %i(order_placed paid), to: :appling_cancel_order
    end

    event :apply_good_return do
      transitions from: :shipped, to: :appling_good_return
    end
  end

  validates :backer_name, presence: true

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.uuid
  end

  def pay!(payment_method)
    unless paid?
      update_column(:payment_method, payment_method)
      make_payment!
      # OrderMailer.notify_order_placed(self).deliver!
    end
  end
end

# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  total_price      :integer
#  plan_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  creator_name     :string(255)
#  backer_name      :string(255)
#  price            :integer
#  quantity         :integer          default(1)
#  payment_method   :string(255)
#  token            :string(255)
#  aasm_state       :string(255)      default("order_placed")
#  user_id          :integer
#  project_id       :integer
#  plan_description :text(65535)
#  project_name     :string(255)
#  address          :string(255)
#
