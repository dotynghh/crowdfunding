class VerificationCode < ApplicationRecord
end

# == Schema Information
#
# Table name: verification_codes
#
#  id                :integer          not null, primary key
#  phone_number      :string(255)
#  verification_code :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  code_status       :boolean          default(TRUE)
#
