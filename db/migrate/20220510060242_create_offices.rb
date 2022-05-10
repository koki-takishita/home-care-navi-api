class CreateOffices < ActiveRecord::Migration[7.0]
  def change
    create_table :offices do |t|

      t.string :name
      t.string :title
      t.integer :holiday
      t.string :business_day_detail
      t.string :address
      t.string :post_code
      t.string :phone_number, uniqueness: true
      t.string :fax_number
      t.integer :user_id, foreign_key: true

      t.timestamps

    end
  end
end
