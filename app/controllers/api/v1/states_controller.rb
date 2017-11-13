class Api::V1::StatesController < ApplicationController

  def index
    states = State.all
    render json: states, status: 200
  end

  def show
    state = State.find(params[:id])
    render json: state, status: 200
  end

  def create
    state = State.new(state_params)

    if state.save
      render json: state, status: 201
    else
      render json: { errors: state.errors }, status: 422
    end
  end

  def update
    state = State.find(params[:id])
    if state.update(state_params)
      render json: state, status: 200
    else
      render json: { errors: state.errors }, status: 422
    end
  end

  def destroy
    state = State.find(params[:id])
    state.destroy
    head 204
  end

  private

  def state_params
    params.require(:state).permit(:name, :acronym, :region_id)
  end
end
