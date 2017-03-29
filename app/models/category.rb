class Category < ApplicationRecord
  has_many :projects
end

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  chs_name   :string(255)      default("Simplified Chinese")
#
