class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false,unique: true
      t.integer :phone_number, null: false,unique: true
      t.integer :post_code, null: false
      t.string :address, null: false
      t.integer :user_type, null: false
      t.boolean :activated, null: false, default: false
      t.string :activation_digest, null: false

      t.timestamps
    end
  end
end
