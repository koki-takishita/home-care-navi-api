namespace :office_fax_number do
  desc 'officesテーブル内のfax_numberの値が空白のものをnilへ移行する'
  task blank_to_nil: :environment do
    offices = Office.where(fax_number: '')
    offices.each do |office|
      office.fax_number = nil
      office.save!
    end
    puts '空白nilへ変換完了'
  end

  desc 'officesテーブル内のfax_numberを全件調べて、重複があればレコード数が新しい方をnilに移行する'
  task duplication_to_nil: :environment do
    fax_numbers = []
    Office.find_each do |office|
      fax_numbers.delete(nil)
      if fax_numbers.include?(office.fax_number)
        office.fax_number = nil
        office.save!
        puts office.user.attributes
      else
        fax_numbers.push(office.fax_number)
      end
    end
    puts '重複したfax_numberをnilへ移行完了 nilにしたユーザー情報を確認してください'
  end
end
