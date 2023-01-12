class CreateAvailabilities < ActiveRecord::Migration[6.0]
  def change
    create_table :availabilities do |t|
      t.references :doctor, null: false, foreign_key: true
      t.integer :start_day
      t.integer :end_day
      t.time :start_time
      t.time :end_time
      t.integer :slot_range
      t.integer :status

      t.timestamps
    end
  end
end
