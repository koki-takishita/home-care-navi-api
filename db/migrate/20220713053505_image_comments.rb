class ImageComments < ActiveRecord::Migration[7.0]
  def change
    create_table :image_comments do |t|
      t.references :office_detail, foreign_key: true
      t.string    :comment
      t.timestamps
    end
  end
end
