require 'open-uri'

Rails.application.reloader.wrap do
  def dl_image
    retry_count = 0
    begin
      faker_image_path = Faker::Avatar.image
      image = URI.open(faker_image_path)
    rescue OpenURI::HTTPError => e
      puts "#{e.class} #{e.message}"
      puts e.backtrace
      retry_count += 1
      if retry_count <= 3
        retry 
      else
        image = nil
      end
    end
    return image
  end

  def build_image
    Faker::Config.locale = :en
    image = dl_image
    Faker::Config.locale = :ja
    unless image.nil?
      ActionDispatch::Http::UploadedFile.new(tempfile: image, filename: 'avatar_image', type: image.content_type)
    else
      nil
    end
  end
  
  def create_staffs(office: , count: 6)
    office.staffs.destroy_all
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
  
  def set_progressbar(total: nil)
    @progressbar = ProgressBar.create(:format => '%a |%b>>%i| %p%% %t',
                                     :starting_at => 0,
                                     :total => total,
                                     :length => 80) 
  end

  def create_office_staffs
    # use https://github.com/jfelchner/ruby-progressbar/wiki/Options
    # ProgressBar.create(:title => "Items", :starting_at => 20, :total => 200)
    offices = Office.eager_load(:staffs).with_attached_images.limit(1000)
    set_progressbar(total: offices.count)
    offices.each{|office|
      create_staffs(office: office)
      @progressbar.increment
    }
  end
end

create_office_staffs
