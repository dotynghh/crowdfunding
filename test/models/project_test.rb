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

require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
