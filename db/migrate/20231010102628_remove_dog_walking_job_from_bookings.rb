class RemoveDogWalkingJobFromBookings < ActiveRecord::Migration[7.0]
  def change
    remove_reference :bookings, :dog_walking_job, index: true, foreign_key: true
  end
end
