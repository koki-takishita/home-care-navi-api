class AddSelectedFlagsToOffices < ActiveRecord::Migration[7.0]
  def change
    add_column :offices, :selected_flags, :string
  end
end
