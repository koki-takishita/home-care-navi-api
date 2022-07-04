def build_image
  Faker::Config.locale = :en
  faker_image_path = Faker::Avatar.image
  image = URI.open(faker_image_path)
  Faker::Config.locale = :ja
  ActionDispatch::Http::UploadedFile.new(tempfile: image, filename: 'avatar_image', type: image.content_type)
end

def create_staffs(office: , count: 10)
  count.times{
    name = Faker::Name.name
    image = build_image
    office.staffs.create!(
      name: name,
      kana: name.yomi,
      introduction: "#{office.name}の#{name}です。素晴らしいスタッフです。",
      image: image
    )
  }
end

def create_office_staffs
  # use https://github.com/jfelchner/ruby-progressbar/wiki/Options
  # ProgressBar.create(:title => "Items", :starting_at => 20, :total => 200)
  progressbar = ProgressBar.create(:format => '%a |%b>>%i| %p%% %t',
                                   :starting_at => 10,
                                   :total => Office.count,
                                   :length => 80) 

  Office.find_each(batch_size: 100) do |office|
    progressbar.increment
    create_staffs(office: office)
  end
end

# 実行program
create_office_staffs
