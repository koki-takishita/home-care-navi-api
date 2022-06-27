class ChangeStaffOfficeIdToReferences < ActiveRecord::Migration[7.0]
  def change
    remove_column :staffs, :office_id, :integer
    add_reference :staffs, :office, foreign_key: true, after: :id
  end
end
