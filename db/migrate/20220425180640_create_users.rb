class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false, index: { unique: true, name: 'ui_user_01' }
      t.string :password_digest, null: false
      t.string :phone_number, null: false
      t.integer :post_code, null: false
      t.string :address, null: false
      t.integer :user_type, null: false, default: 0
      t.string :activation_digest, null: false
      t.timestamps
    end
    add_index :users, [:phone_number], unique: true
  end
end
