class ChangeAppointmentsMeetDateToDate < ActiveRecord::Migration[7.0]
  def up
    change_column :appointments, :meet_date, 'date USING CAST(meet_date AS date)'
  end

  def down
    change_column :appointments, :meet_date, :string
  end
end
