class CreateStaffs < ActiveRecord::Migration[7.0]
  def change
    create_table :staffs do |t|
      t.integer :office_id
      t.string :name
      t.string :kana
      t.string :introduction

      t.timestamps
    end
  end
end
