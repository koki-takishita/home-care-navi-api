class Api::Specialists::ThanksController < ApplicationController
  before_action :authenticate_specialist!

	# {
	# 	'thanks': [
	# 		{
  #       "id": 50627,
	# 			. thanksカラムすべて
	# 			.
	# 			"staff": {
	# 				"id": 22083,
	# 				.staffsのカラムすべてk
	# 				.
	# 			},
	# 			"office": {
	# 				"id": 22083,
	# 				.officeのカラムすべて
	# 				.
	# 			}
	# 		},
	# 		{
  #       "id": 50627,
	# 			. thanksカラムすべて
	# 			.
	# 			"staff": {
	# 				"id": 22083,
	# 				.staffsのカラムすべてk
	# 				.
	# 			},
	# 			"office": {
	# 				"id": 22083,
	# 				.officeのカラムすべて
	# 				.
	# 			}
	# 		},
	# 	],
	# 	"thank_total": 5
	# }
  def index
    office_id = current_specialist.office.id
    # office_idに紐づくお礼のリストを、update_atの大きい順に取得
    thank_list = Thank.thank_list_of_office(office_id)
    # ページネーション対応ver
    thanks = thank_list.limit(10).offset(params[:page].to_i * 10)
		# お礼の全件の数
    thank_list_total = thank_list.count
    render json: {
      thanks: thanks.as_json(include: [:staff, :office]),
      thank_total: thank_list_total
    }
  end

end
