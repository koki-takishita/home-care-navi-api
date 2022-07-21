class Api::Customer::OfficesController < ApplicationController
  before_action :set_office, only: [:show]

  def index
    offices = search_office_from_params
    result = if(offices.size <= 0)
                []
              else
                build_json(offices)
              end
    render json: result
  end

  def show
    staffs = add_image_h(@staffs)
    render json: {
      office: @office,
      officeImages: @office.image_url,
      staffs: staffs
    }, staus: :ok
  end

  private

  def set_office
    @office = Office.find(params[:id])
    @staffs = @office.staffs.select('staffs.*', 'count(staffs.id) AS thanks')
                     .left_joins(:thanks)
                     .group("staffs.id").order('thanks DESC')
    @thanks = @office.thanks
  end

  def add_image_h(records)
    array = []
    records.each{|re|
      hash = add_image(re)
      if re.thanks.exists?
        thanks = re.thanks
        hash[:thanks] = thanks
      end
      array.push(hash)
    }
    array
  end

  def add_image(obj)
    hash = obj.attributes
    hash[:image] = nil
    if obj.image.attached?
      image = obj.image_url
      hash[:image] = image
    end
    hash
  end

  def search_office_from_params
    if(area_exist?)
      tmp        = params[:cities]
      cities     = tmp.split(',')
      search_sql = []
      cities = cities.map{|city|
        search_sql.push('offices.address LIKE ?')
        "%#{city}%"
      }
      #set_offices(search_sql, params[:prefecture], cities)
      search_area_offices(search_sql, params[:prefecture], cities).limit(10).offset(params[:page].to_i * 10)
    elsif(keywords_exist?)
      keyword = partial_match(params[:keywords])
      post_cord = exact_match(params[:postCodes])
      search_keywords_offices(keyword, post_cord).limit(10).offset(params[:page].to_i * 10)
    else
      return []
    end
  end

  def partial_match(string)
    return if(string.nil?)
    arry = string.split(',')
    result = arry.map{|ele| "%#{ele}%" }
  end

  def exact_match(string)
    return if(string.nil?)
    arry = string.split(',')
    result = arry.map{|ele| "#{ele}" }
  end

  def keywords_exist?
    parameters = params.permit(:prefecture, :cities, :page, :keywords, :postCodes).to_h
    if(parameters.empty? || parameter_exist?(parameters[:keywords]) && parameter_exist?(parameters[:postCodes]))
      false
    else
      true
    end
  end

  def area_exist?
    parameters = params.permit(:prefecture, :cities, :page, :keywords, :postCodes).to_h
    if(parameters.empty? || parameter_exist?(parameters[:prefecture]) || parameter_exist?(parameters[:cities]))
      false
    else
      true
    end
  end

  def parameter_exist?(obj)
    (obj.nil? || obj&.empty?) ? true : false
  end

  def search_area_offices(sql, prefecture, cities)
    @offices = Office.eager_load(:thanks, :office_detail, :staffs, :bookmarks)
    .with_attached_images
    .where("offices.address LIKE ?", Office.sanitize_sql_like(prefecture) + "%")
    .where(sql.join(' or '), *cities )
  end

  def search_keywords_offices(keywords, post_codes)
    return if(keywords.nil? && post_codes.nil?)
    @offices = Office.eager_load(:thanks, :office_detail, :staffs, :bookmarks)
    .with_attached_images
    .where.like(address: keywords)
    .or(Office.eager_load(:thanks, :office_detail, :staffs, :bookmarks)
    .with_attached_images
    .where.like(name: keywords))
    .or(Office.eager_load(:thanks, :office_detail, :staffs, :bookmarks)
    .with_attached_images
    .where.like(post_code: post_codes))
  end

  def get_offices
    @offices || ""
  end

  def get_offices_count
    get_offices.size
  end

  def build_json(offices)
    if customer_signed_in?
      
    end
    result = offices.each_with_index.map{|office, index|
      thank       = build_json_from_thank_table_attributes(office)
      detail      = build_json_from_detail_table_attributes(office)
      staff_count = build_json_from_staff_table_count_json(office)
      bookmark    = build_json_from_bookmark_table(office)
      image       = build_json_image(office)
      office      = office.attributes
      result = if(index == 0)
                 office.merge(thank, detail, image, staff_count, bookmark, {count: get_offices_count})
               else
                 office.merge(thank, detail, image, staff_count, bookmark)
               end
    }
    result
  end

  def build_json_image(office)
    image = if(office.images.size > 0)
              image_url = return_random_image_url(office)
              { image: image_url }
            else
              { image: [] }
            end
  end

  # active_storageに保存してあるランダムな画像のurlを返す
  def return_random_image_url(obj)
    images_ids_to_arry = obj.images_attachment_ids
    find_id = images_ids_to_arry.sample
    obj.images.find(find_id).url
  end

  def build_json_from_thank_table_attributes(office)
    thank = if(office.thanks.size > 0)
      { thank: office.thanks.sample.attributes }
    else
      { thank: { message: 'お礼の投稿はまだありません'} }
    end
  end

  def build_json_from_detail_table_attributes(office)
    detail = if(!office.office_detail.nil?)
      { detail: office.office_detail.attributes }
    else
      { detail: { message: '詳細情報は登録されていません'} }
    end
  end

  def build_json_from_staff_table_count_json(office)
    staffInfo = if(office.staffs.size > 0)
                  office.staffs.size
                else
                  0
                end
    { staffCount: staffInfo }
  end

  def build_json_from_bookmark_table(office)
    if customer_signed_in?
      if office.bookmarks.exists?
        bookmarks = office.bookmarks.where(user_id: current_customer.id)
        # 配列の中のオブジェクトを取り出す
        { bookmark: bookmarks.first }
      else
        { bookmark: nil}
      end
    else
      { bookmark: nil}
    end
  end
end
