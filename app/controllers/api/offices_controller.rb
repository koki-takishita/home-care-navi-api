class Api::OfficesController < ApplicationController
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
    render json: {office: @office, images: @office.image_url, staffs: @staffs}
  end

  private

  def set_office
    @office = Office.find(params[:id])
    @staffs = @office.staffs
  end

  def search_office_from_params
    # 県と市の情報が存在する前提のコードを記述する フロント側でalertで弾く
    offices = if(params[:prefecture] && params[:prefecture].length > 0)
 #   User.includes(:posts).where(posts: { name: 'example' })
                offices = Office.includes(:thanks, :office_detail, :staffs).with_attached_images.where("offices.address LIKE ?", "%#{params[:prefecture]}%")

                if(params[:cities] && params[:cities].length > 0 && offices.size > 0)
                  tmp        = params[:cities]
                  cities     = tmp.split(',')
                  search_sql = []
                  cities = cities.map{|city|
                    search_sql.push('offices.address LIKE ?')
                    "%#{city}%"
                  }
                  @size = { count: offices.where(search_sql.join(' or '), *cities ).size }
                  offices = offices.includes(:thanks, :office_detail, :staffs).where(search_sql.join(' or '), *cities ).with_attached_images.limit(10).offset(params[:page].to_i * 10)
                  if(offices.size <= 0)
                    return []
                  end
                  offices
                else
                  return []
                end
              else
                return []
              end
  end

  def build_json(offices)
    result = offices.map{|office|
      thank       = build_json_from_thank_table_attributes(office)
      detail      = build_json_from_detail_table_attributes(office)
      staff_count = build_json_from_staff_table_count_json(office)
      image       = build_json_image(office)
      office      = office.attributes
      result      = office.merge(thank, detail, image, staff_count, @size)
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

end
