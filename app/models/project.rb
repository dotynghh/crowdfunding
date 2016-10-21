# == Schema Information
#
# Table name: projects
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  user_id      :integer
#  introduction :text(65535)
#  avatar       :string(255)
#  goals        :string(255)
#  category_id  :string(255)
#  start_at     :datetime
#  end_at       :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Project < ApplicationRecord
	include Paperclip::Glue
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
	belongs_to :user
end
