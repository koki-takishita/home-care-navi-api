class ChangeDatatypePostCodePhoneNumberFaxNumberOfOffices < ActiveRecord::Migration[7.0]
  def change
    change_column :offices, :post_code, :string
    change_column :offices, :phone_number, :string
    change_column :offices, :fax_number, :string
  end
end
