class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.references :office, foreign_key: true, after: :id
      t.string :meet_date
      t.string :meet_time
      t.string :name
      t.string :age
      t.string :phone_number
      t.string :comment
      t.references :user, foreign_key: true, after: :id
      t.integer :called_status, default: 0
      t.timestamps
    end
  end
end
