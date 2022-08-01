class CreateHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :office, null: false, foreign_key: true
      t.timestamps
    end
    add_index(:histories, [:user_id, :office_id], unique: true, name: 'ci_histories_01')
  end
end
