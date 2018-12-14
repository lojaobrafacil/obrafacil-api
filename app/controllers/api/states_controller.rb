class Api::StatesController < Api::BaseController

  def index
    @states = policy_scope State
    render json: @states.as_json(only: [:id, :name, :acronym]), status: 200
  end

  def show
    @state = State.find_by(id: params[:id])
    if @state
      authorize @state
      render json: @state, status: 200
    else
      head 404
    end
  end

  def create
    @state = State.new(state_params)
    authorize @state
    if @state.save
      render json: @state, status: 201
    else
      render json: { errors: @state.errors }, status: 422
    end
  end

  def update
    @state = State.find(params[:id])
    authorize @state
    if @state.update(state_params)
      render json: @state, status: 200
    else
      render json: { errors: @state.errors }, status: 422
    end
  end

  def destroy
    @state = State.find(params[:id])
    authorize @state
    @state.destroy
    head 204
  end

  private

  def state_params
    params.permit(policy(State).permitted_attributes)
  end
end
