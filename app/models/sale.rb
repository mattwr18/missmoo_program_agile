class Sale < ApplicationRecord
  belongs_to :user
  validates :amount, presence: true, numericality: { greater_than: 0.0 }
  validates_presence_of :description

  scope :sales_by, ->(user) { where(user_id: user.id) }
end
