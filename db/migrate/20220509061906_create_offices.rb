class CreateOffices < ActiveRecord::Migration[7.0]
  def change
    create_table :offices do |t|
      t.string :name
      t.string :title
      t.integer :holiday
      t.string :business_day_detail
      t.string :address
      t.integer :post_code
      t.integer :phone_number
      t.integer :fax_number
      t.integer :user_id
      t.integer :specialist_id

      t.timestamps
    end
  end
end
