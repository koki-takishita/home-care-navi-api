class Api::Specialists::OfficesController < ApplicationController
  before_action :authenticate_specialist!

  def show
    @office = current_specialist.office
    render json: @office
  end

  def create
    not_have_office = current_specialist.office.blank?
    not_have_office ? create_office : render_error
  end

  private

#  　送られてくるパラメーター構造
#     Parameters: {"offficeImages"=>[#<ActionDispatch::Http::UploadedFile:0x00007f7d2946bd30 @tempfile=#<Tempfile:/tmp/RackMultipart20220817-1-if3bfh.png>, @original_filename="いらすとや⑤.png", @content_type="image/png", @headers="Content-Disposition: form-data; name=\"offficeImages[]\"; filename=\"\xA4.png\"\r\nContent-Type: image/png\r\n">,
#     "office"=>"{\"name\":\"テスト\",\"title\":\"テスト\",\"flags\":30,\"business_day_detail\":\"テスト\",\"phone_number\":\"999-9999-9999\",\"fax_number\":\"999-9999-9999\",\"post_code\":\"999-9999\",\"address\":\"東京都墨田区\"}",
#     "detail"=>"{\"detail\":\"テスト\",\"service_type\":\"テスト用介護付きホーム\",\"open_date\":\"2022-08-16\",\"rooms\":25,\"requirement\":\"テスト\",\"facility\":\"テスト\",\"management\":\"テスト\",\"link\":\"https://test.toto\",\"comment_1\":\"テスト\",\"comment_2\":\"テスト\"}"}

    def office_params
      @params.require(:office)
             .permit(:name, :title, :flags, :business_day_detail, :address, :post_code, :phone_number, :fax_number, images: [])
    end

    def detail_params
      @params.require(:detail)
             .permit(:detail, :service_type, :open_date, :rooms, :requirement, :facility, :management, :link, :comment_1, :comment_2, images: [])
    end

#       params_json_parse後のOfficeデータ
#       [["name", "テスト"], ["title", "テスト"], ["flags", 30], ["business_day_detail", "テスト"], ["address", "東京都墨田区"], ["post_code", "9999999"], ["phone_number", "999-9999-9999"], ["fax_number", "999-9999-9999"], ["user_id", 474], ["created_at", "2022-08-17 02:15:55.158524"], ["updated_at", "2022-08-17 02:15:55.158524"], ["selected_flags", nil]]
#       [["key", "tr5pemvdn5847lzl6h7vhjpdejcx"], ["filename", "いらすとや⑤.png"], ["content_type", "image/png"], ["metadata", "{\"identified\":true}"], ["service_name", "amazon"], ["byte_size", 177969], ["checksum", "eChQRR2n2/hWwqj2/zLFWA=="], ["created_at", "2022-08-17 02:16:09.268221"]]
    def create_office
      params_json_parse
      office = current_specialist.build_office(office_params)
      if office.valid?
        office.save!
        render status: :ok, json: { message: 'オフィス作成成功' }
        if detail_params.present?
          create_office_detail(office)
        end
      else
        render status: :unauthorized, json: { errors: office.errors.full_messages }
      end
    end

    def create_office_detail(office)
      detail = office.build_office_detail(detail_params)
      if detail.valid?
        detail.save!
      else
        render status: :unauthorized, json: { errors: detail.errors.full_messages, message: 'オフィスのみ作成できました' }
      end
    end

    def render_error
      render status: :unauthorized, json: { errors: ['事業所はすでに存在しますので、二度目の登録はできません'] }
    end

    def params_json_parse
      office_hash = JSON.parse(params[:office])
      office_hash.store('images', params[:officeImages])
      detail_hash = JSON.parse(params[:detail])
      detail_hash.store('images', params[:detailImages])
      @params = ActionController::Parameters.new({
                                                   office: office_hash,
                                                   detail: detail_hash
                                                 })
    end
end
