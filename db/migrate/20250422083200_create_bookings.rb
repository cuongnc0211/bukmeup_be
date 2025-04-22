class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :client_name
      t.string :client_email
      t.datetime :start_time
      t.datetime :end_time
      t.string :status

      t.timestamps
    end
  end
end
