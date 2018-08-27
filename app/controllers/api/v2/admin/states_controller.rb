class Api::V2::Admin::StatesController < Api::V2::Admin::BaseController

  def index
    states = policy_scope [:admin, State]
    render json: states.as_json(only: [:id, :name, :acronym]), status: 200
  end

  def show
    state = State.find(params[:id])
    authorize [:admin, state]
    render json: state, status: 200
  end

  def create
    state = State.new(state_params)
    authorize [:admin, state]
    if state.save
      render json: state, status: 201
    else
      render json: { errors: state.errors }, status: 422
    end
  end

  def update
    state = State.find(params[:id])
    authorize [:admin, state]
    if state.update(state_params)
      render json: state, status: 200
    else
      render json: { errors: state.errors }, status: 422
    end
  end

  def destroy
    state = State.find(params[:id])
    authorize [:admin, state]
    state.destroy
    head 204
  end

  private

  def state_params
    params.permit(policy([:admin, State]).permitted_attributes)
  end
end
