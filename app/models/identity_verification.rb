class IdentityVerification < ApplicationRecord
  validates :message, presence: true
end

# == Schema Information
#
# Table name: identity_verifications
#
#  id            :integer          not null, primary key
#  verify_type   :integer
#  user_id       :integer
#  title         :string(255)
#  image         :string(255)
#  verify_status :integer
#  message       :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  project_id    :integer
#
