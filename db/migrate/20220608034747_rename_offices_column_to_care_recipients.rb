class RenameOfficesColumnToCareRecipients < ActiveRecord::Migration[7.0]
  def change
    rename_column :care_recipients, :offices_id, :office_id
  end
end
