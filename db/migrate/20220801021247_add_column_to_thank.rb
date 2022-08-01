class AddColumnToThank < ActiveRecord::Migration[7.0]
  def change
    add_column :thanks, :name, :string
    add_column :thanks, :age, :integer
  end
end
