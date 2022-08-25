class ChangeColumnsAddNotNullAndAddUniqueToPhonenumberToOffice < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:offices, :name, false)
    change_column_null(:offices, :title, false)
    change_column_null(:offices, :business_day_detail, false)
    change_column_null(:offices, :post_code, false)
    change_column_null(:offices, :address, false)
    change_column_null(:offices, :phone_number, false)
  end
end
