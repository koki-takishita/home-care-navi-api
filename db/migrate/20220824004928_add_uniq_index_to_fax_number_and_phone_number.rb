class AddUniqIndexToFaxNumberAndPhoneNumber < ActiveRecord::Migration[7.0]
  def change
    add_index(:offices, :fax_number, unique: true)
    add_index(:offices, :phone_number, unique: true)
    remove_index(:offices, :user_id)
    add_index(:offices, :user_id, unique: true)
  end
end
