class Api::Specialists::OfficesController < ApplicationController
  before_action :authenticate_specialist!

  def show
    @office = current_specialist.office
    render json: @office
  end

  def create
    # detailとoffice両方作成
=begin
    office_data = JSON.parse(params[:office])
    office = Office.new(office_data)


=end
			string_to_actionController_parameters
      office = current_specialist.build_office(office_params)
      if office.valid?
        office.save!
        if !detail_params.empty?
          detail = office.build_office_detail(detail_params)
          if detail.valid?
            detail.save!
            render status: 200, json: "オフィス詳細作成成功"
             # image_comment = detail.image_comment.build(image_comment_params)
             # if image_comment.valid?
             #   image_comment.save!
             #   render json: { status: 200}
             # else
             #  render status: 401, json: { errors: image_comment.errors.full_messages }
             # end
          else
            render status: 401, json: { errors: detail.errors.full_messages, message: "オフィスのみ作成できました" }
          end
        else
          render status: 200, json: "オフィス作成成功"
        end
      else
        render status: 401, json: { errors: office.errors.full_messages }
      end
    end
  end

  private

  def office_params
    @params.require(:office)
    .permit(:name, :title, :flags, :business_day_detail, :address, :post_code, :phone_number, :fax_number, images: [])
  end

  def detail_params
    @params.require(:detail)
    .permit(:detail, :service_type, :open_date, :rooms, :requirement, :facility, :management, :link)
  end

  def image_comment_params
    @params.require(:image_comment)
    .permit(:comment_1, :comment_2, :image_1, :image_2)
  end

  def string_to_actionController_parameters
    officeHash = json_parse(params[:office])
    officeHash.store("images", params[:officeImages])
    detailHash = json_parse(params[:detail])
    imageHash  = json_parse(params[:imageCommnets])
    imageHash.store("image_1", params[:detailImage1])
    imageHash.store("image_2", params[:detailImage2])
	  @params = ActionController::Parameters.new({
	    office: officeHash,
	  	detail: detailHash,
      image_comment: imageHash
	  })
  end

	def json_parse(json)
		JSON.parse(json)
	end
