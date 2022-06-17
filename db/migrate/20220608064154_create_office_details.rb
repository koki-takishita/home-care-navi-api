class CreateOfficeDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :office_details do |t|
      t.references :office,       null: false, foreign_key: true, index: true
      t.string     :detail,       null: false
      t.string     :service_type, null: false
      t.string     :open_date
      t.integer    :rooms
      t.string     :requirement
      t.string     :facility
      t.string     :management
      t.string     :link
      t.timestamps
    end
  end
end
