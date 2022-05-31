class Change < ActiveRecord::Migration[7.0]
  def up
    change_column :contacts, :types, :string
  end

  def down
    change_column :contacts, :types, :integer
  end
end
