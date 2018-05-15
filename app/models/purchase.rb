class Purchase < ApplicationRecord
  belongs_to :user
  validates :amount, presence: true, numericality: { greater_than: 0.0 }
  validates_presence_of :description
  validates_presence_of :vendor

  scope :purchases_by, ->(user) { where(user_id: user.id) }
end
