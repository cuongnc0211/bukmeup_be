class Booking < ApplicationRecord
  belongs_to :user

  validates :client_name, :client_email, :start_time, :end_time, presence: true
  validates :status, inclusion: { in: %w[pending confirmed cancelled] }
end
