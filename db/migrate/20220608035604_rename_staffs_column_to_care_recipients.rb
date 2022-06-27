class RenameStaffsColumnToCareRecipients < ActiveRecord::Migration[7.0]
  def change
    rename_column :care_recipients, :staffs_id, :staff_id
  end
end
