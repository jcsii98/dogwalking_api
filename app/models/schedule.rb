class Schedule < ApplicationRecord
  belongs_to :dog_walking_job
  validates :day, uniqueness: { scope: :dog_walking_job_id }
  validates :day, inclusion: { in: 1..7 }


end
