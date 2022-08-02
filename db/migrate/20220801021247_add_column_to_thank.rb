class AddColumnToThank < ActiveRecord::Migration[7.0]
  def change
    add_column :thanks, :name, :string, limit: 30
    add_column :thanks, :age, :integer, limit: 3

    change_column_null(:thanks, :name, false, "Untitled")
    change_column_null(:thanks, :age, false, 0)
  end
end
