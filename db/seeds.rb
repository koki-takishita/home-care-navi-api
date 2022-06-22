puts "テーブル全削除処理スタート"
exclusion_tables = [
  'active_storage_variant_records',
  'active_storage_blobs',
  'active_storage_attachments',
  'schema_migrations',
  'ar_internal_metadata'
]
all_tables = ActiveRecord::Base.connection.tables
tables = all_tables.difference(exclusion_tables)
tables.each{|table|
  table.classify.constantize.destroy_all
}
flag = false
tables.each {|table|
  if table.classify.constantize.exists?
    puts "#{table}テーブルが削除できてない"
    flag = true
  end
}
puts !flag ? "テーブル全削除完了" : "Destroy Error 削除できてないテーブルがあります"

