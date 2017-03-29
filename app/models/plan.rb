
class Plan < ApplicationRecord
  validates :description, presence: true
  validates :need_add, inclusion: {in: [true, false]}
  validates :price, presence: true
  validates :price, numericality: { greater_than: 0, less_than: 1_000_000 }
  validates :plan_goal, numericality: { greater_than: 0, less_than: 1_000_000 }
  belongs_to :project, counter_cache: true
  has_many :orders
  scope :normal, -> { where(plan_type: 1) }
  scope :recent, -> { order("created_at DESC") }
  scope :price, -> {order("price DESC")}

  before_validation :check_plan_goal

  def check_plan_goal
    if plan_goal.blank?
      self.plan_goal = 999
    end
  end
end

# == Schema Information
#
# Table name: plans
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  description     :text(65535)
#  quantity        :integer          default(1)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  price           :integer
#  project_id      :integer
#  plan_goal       :integer
#  plan_progress   :integer          default(0)
#  backer_quantity :integer          default(0)
#  plan_type       :integer          default(1)
#  need_add        :boolean
#
