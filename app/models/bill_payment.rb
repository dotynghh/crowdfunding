class BillPayment < ApplicationRecord
  scope :bill_payment_by_project_id, -> (bill_status) { select("project_id, project_name, backer_name, SUM(amount) as amount, created_at, bill_status").where("bill_status = ? or bill_status = ?", bill_status[0], bill_status[1]).group("project_id") }

  scope :success_payment_by_project, -> (project_id) { where("project_id = ? and (bill_status = 'success' or bill_status = 'paid')", project_id) }
end

# == Schema Information
#
# Table name: bill_payments
#
#  id               :integer          not null, primary key
#  order_id         :string(255)
#  channel_id       :string(255)
#  amount           :integer
#  user_id          :integer
#  project_id       :integer
#  plan_id          :integer
#  bill_status      :string(255)
#  payment_method   :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  project_name     :string(255)
#  backer_name      :string(255)
#  plan_description :text(65535)
#
