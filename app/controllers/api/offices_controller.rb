class Api::OfficesController < ApplicationController
  before_action :set_office, only: [:show]

  def index
    offices = search_office_from_params
    result = if(offices.empty?)
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
    offices = if(params[:prefecture])
                offices = Office.where("address LIKE ?", "%#{params[:prefecture]}%")
                if(offices.exists? && params[:cities])
                  tmp        = params[:cities]
                  cities     = tmp.split(',')
                  search_sql = []
                  cities = cities.map{|city|
                    search_sql.push('address LIKE ?')
                    "%#{city}%"
                  }
                  @count = { count: offices.where(search_sql.join(' or '), *cities ).count }
                  offices = offices.where(search_sql.join(' or '), *cities ).limit(10).offset(params[:page].to_i * 10)
                  if(offices.empty?)
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
      office      = build_json_from_office_table_attributes(office)
      result      = office.merge(thank, detail, staff_count, @count)
    }
    result
  end

  def build_json_from_thank_table_attributes(office)
    thank = if(office_exists_check(office) && office.thanks.exists?)
      { thank: office.thanks.sample.attributes }
    else
      { thank: { message: 'お礼の投稿はまだありません'} }
    end
  end

  def build_json_from_detail_table_attributes(office)
    detail = if(office_exists_check(office) && !office.office_detail.nil?)
      { detail: office.office_detail.attributes }
    else
      { detail: { message: '詳細情報は登録されていません'} }
    end
  end

  def build_json_from_office_table_attributes(office)
    office = if(office_exists_check(office))
                office.attributes
              else
                office
              end
  end

  def build_json_from_staff_table_count_json(office)
    staffInfo = if(office_exists_check(office) && office.staffs.exists?)
                  office.staff_ids.length
                else
                  0
                end
    { staffCount: staffInfo }
  end

  def office_exists_check(office)
    unless(office.class == Office)
      return office[:message].empty?
    else
      true
    end
  end
end
