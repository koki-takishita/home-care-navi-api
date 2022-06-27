class CreateThanks < ActiveRecord::Migration[7.0]
  def change
    create_table :thanks do |t|
      t.references :user,     null: false, foreign_key: true
      t.references :office,   null: false, foreign_key: true
      t.references :staff,    null: false, foreign_key: true
      t.string     :comments, null: false

      t.timestamps
    end
    add_index(:thanks, [:user_id, :office_id, :staff_id], unique: true, name: 'ci_thanks_01')
  end
end
