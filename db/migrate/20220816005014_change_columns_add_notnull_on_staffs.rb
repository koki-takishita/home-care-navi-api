class ChangeColumnsAddNotnullOnStaffs < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:staffs, :name, false)
    change_column_null(:staffs, :kana, false)
    change_column_null(:staffs, :introduction, false)
  end
end
