module Api
  class ContactsController < ApplicationController
    def create
    render json: {
      status: "success"
    }
    end
  end
end

