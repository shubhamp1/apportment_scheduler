class CreateDoctors < ActiveRecord::Migration[6.0]
  def change
    create_table :doctors do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.integer :min_fees

      t.timestamps
    end
  end
end
