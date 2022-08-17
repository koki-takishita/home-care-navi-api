class ChangeColumnsAddNotnullAndIndexToAppointments < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:appointments, :meet_date, false)
    change_column_null(:appointments, :meet_time, false)
    change_column_null(:appointments, :name, false)
    change_column_null(:appointments, :age, false)
    change_column_null(:appointments, :phone_number, false)
    change_column_null(:appointments, :comment, false)
    change_column_null(:appointments, :called_status, false)

    add_index(:appointments, %i[office_id user_id], name: 'ci_appointments_01')
  end
end
