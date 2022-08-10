class AddCommentToOfficeDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :office_details, :comment_1, :string
    add_column :office_details, :comment_2, :string
  end
end
