class Api::OfficesController < ApplicationController
  before_action :set_office, only: [:show]

  def index
    tmp        = params[:cities]
    cities     = tmp.split(',')
    offices = Office.where("address LIKE ?", "%#{params[:prefecture]}%")
    puts "県で絞り込み#{offices}"
    search_sql = []
    cities = cities.map{|city|
      search_sql.push('address LIKE ?')
      "%#{city}%"
    }
    puts "cities map #{cities}"
    offices = offices.where(search_sql.join(' or '), *cities )
    arry = offices.map{|office|
      office_data = {
        office: office,
        thank:  office.thanks.sample,
        detail: office.office_detail
      }
    }
    puts arry
    render json: { data: arry }
  end

  def show
    render json:@office.as_json{ :@office }
  end

  private
   def set_office
      @office = Office.find(params[:id])
   end
end
