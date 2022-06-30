class Api::Specialists::OfficesController < ApplicationController
  before_action :authenticate_specialist!

  def show
    @office = current_specialist.office
    render json: @office
  end

  def create
    # detailとoffice両方作成
    if(detail_exist?(detail_params.to_hash))
      office = current_specialist.build_office(office_params)
      if office.valid?
        office.save!
        detail = office.build_office_detail(detail_params)
        if detail.valid?
          detail.save!
          render json: { status: 200}
        else
         render status: 401, json: { errors: detail.errors.full_messages }
        end
      else
        render status: 401, json: { errors: office.errors.full_messages }
      end
      #officeのみ作成
    else
      office = current_specialist.build_office(office_params)
      if office.valid?
        office.save!
        render json: { status: 200}
      else
        render status: 401, json: { errors: office.errors.full_messages }
      end
    end
  end

  private

  def detail_exist?(hash)
    test = true
    hash.each{|key, value|
      if value.to_s.length == 0
        test = false
        break
      end
    }
    return test
  end

    def office_params
      params.require(:office)
      .permit(:name, :title, :flags, :business_day_detail, :address, :post_code, :phone_number, :fax_number, images: [])
    end

    def detail_params
      params.require(:office_detail_attribute)
      .permit(:detail, :service_type, :open_data, :rooms, :requirement, :facility, :management, :link)
    end
  end
