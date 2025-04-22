class Availability < ApplicationRecord
  belongs_to :user

  validates :weekday, :start_time, :end_time, presence: true
end
