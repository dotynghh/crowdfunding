class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { order(created_at: :desc).limit(5) }
end

# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  recipient_id    :integer
#  actor_id        :integer
#  read_at         :datetime
#  action          :string(255)
#  notifiable_id   :integer
#  notifiable_type :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
