class CreateBookmarks < ActiveRecord::Migration[7.0]
  def change
    create_table :bookmarks do |t|
      t.references :office, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
    add_index(:bookmarks, [:office_id, :user_id], unique: true, name: 'ci_bookmarks_01')
  end
end
