class RenameHolidayToFlagsInOffices < ActiveRecord::Migration[7.0]
  def up
    rename_column :offices, :holiday, :flags
    change_column_null :offices, :flags, false
    change_column_default :offices, :flags, 0
  end

  def down
    rename_column :offices, :flags, :holiday
    change_column_null :offices, :holiday, true
    change_column_default :offices, :holiday, nil
  end
end
