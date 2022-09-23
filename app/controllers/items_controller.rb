class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :invalid

  def index
    if params[:user_id] # if you got here using nested route
      # only want set of items that belong to specific user
      items = User.find(params[:user_id]).items
      render json: items
    else
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    # if you want specific item for specific user
    item = User.find(params[:user_id]).items.find(params[:id])
    render json: item
  end

  def create
    item = User.find(params[:user_id]).items.create!(item_params)
    render json: item, status: :created
  end

private

def render_not_found_response
  render json: {error: 'Record not found'}, status: :not_found
end

def item_params
  params.permit(:name, :description, :price)
end

def invalid
  render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
end

end
