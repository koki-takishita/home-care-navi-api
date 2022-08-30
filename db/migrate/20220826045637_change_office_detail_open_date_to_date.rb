class ChangeOfficeDetailOpenDateToDate < ActiveRecord::Migration[7.0]
  def up
    change_column :office_details, :open_date, 'date USING CAST(open_date AS date)'
  end

  def down
    change_column :office_details, :open_date, :string
  end
end
