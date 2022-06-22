class CreateCareRecipients < ActiveRecord::Migration[7.0]
  def change
    create_table :care_recipients do |t|
      t.string :name
      t.string :kana
      t.integer :age
      t.string :post_code
      t.string :address
      t.string :family
      t.references :offices, foreign_key: true
      t.references :staffs, foreign_key: true
      t.timestamps
    end
  end
end
