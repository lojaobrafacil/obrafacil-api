class WelcomesController < ApplicationController
  def index
    render json: { text: "Welcome" }, status: 200
  end
end
