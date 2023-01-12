class CreateAppointments < ActiveRecord::Migration[6.0]
  def change
    create_table :appointments do |t|
      t.references :patient, null: false
      t.references :doctor, null: false, foreign_key: true
      t.date :date
      t.time :time
      t.integer :status

      t.timestamps
    end
  end
end
