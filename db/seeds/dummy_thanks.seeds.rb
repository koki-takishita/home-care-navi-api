# customerが5人いる前提
def create_thanks(count: 5, office: nil)
  office.thanks.destroy_all

  customers = User.customer
  unless(customers.count > 4)
    e = <<-TEXT
    customerの数が足りません
    最後まで実行したい場合1か2の指示に従ってください。
    1. rails db:seed:dummy_customer
    2. customerを5人以上作成してください
    TEXT

    raise e
  end

  staffs    = office.staffs
  unless(staffs.count > 4)
    #raise "staffの数が足りません rails db:seed:dummy_staffsを実行するか、staffを5人以上作成してください"
    e = <<-TEXT
    staffの数が足りません.
    最後まで実行したい場合1か2の指示に従ってください。
    1. rails db:seed:dummy_staffs
    2. id「#{office.id}」のofficeに紐付いているstaffを5人以上にする
    TEXT

    raise e
  end

  count.times{|n|
    customers[n].thanks.create!(
      name: "利用者#{n}",
      age: rand(60..120),
      comments: "#{staffs[n].name}さんは素晴らしいケアマネージャーです。",
      office_id: office.id,
      staff_id:  staffs[n].id
    )
  }
end

def set_progressbar(total: nil)
  @progressbar = ProgressBar.create(:format => '%a |%b>>%i| %p%% %t',
                                   :starting_at => 0,
                                   :total => total,
                                   :length => 80)
end

def create_customer_thanks
  offices = Office.eager_load(:staffs).with_attached_images.limit(1000)
  set_progressbar(total: offices.count)
  offices.each{|office|
    create_thanks(office: office)
    @progressbar.increment
  }
end

create_customer_thanks
