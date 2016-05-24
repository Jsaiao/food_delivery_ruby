class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update, :destroy, :dishes, :view_restaurant_users]
  skip_before_action :authenticate_user!, :is_authorized, :verify_authenticity_token, only: [:index_mobile]

  # GET /restaurants
  # GET /restaurants.json
  def index
    @search_restaurants = Restaurant.all.ransack(params[:q])
    @restaurants = @search_restaurants.result.paginate(page: params[:page], per_page: 15)
  end

  def index_mobile
    render json: Restaurant.all, status: :ok
  end

  def dishes
    @search_products = @restaurant.products.all.ransack(params[:q])
    @products = @search_products.result.paginate(page: params[:page], per_page: 15)
  end

  # GET /restaurants/1
  # GET /restaurants/1.json
  def show
  end

  # GET /restaurants/new
  def new
    @restaurant = Restaurant.new
  end

  # GET /restaurants/1/edit
  def edit
  end

  # POST /restaurants
  # POST /restaurants.json
  def create
    @restaurant = Restaurant.new(restaurant_params)

    respond_to do |format|
      if @restaurant.save
        track_actions(@restaurant)
        format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully created.' }
        format.json { render :show, status: :created, location: @restaurant }
      else
        format.html { render :new }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /restaurants/1
  # PATCH/PUT /restaurants/1.json
  def update
    extra_parameters = {old_name: @restaurant.name}
    respond_to do |format|
      if @restaurant.update(restaurant_params)
        track_actions(@restaurant, extra_parameters)
        format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully updated.' }
        format.json { render :show, status: :ok, location: @restaurant }
      else
        format.html { render :edit }
        format.json { render json: @restaurant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /restaurants/1
  # DELETE /restaurants/1.json
  def destroy
    @restaurant.destroy
    track_actions(@restaurant)
    respond_to do |format|
      format.html { redirect_to restaurants_url, notice: 'Restaurant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def view_restaurant_users
    @users = @restaurant.users
    respond_to do |format|
      format.js { render 'display_users' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_restaurant
      @restaurant = Restaurant.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def restaurant_params
      params.require(:restaurant).permit(:name, :description, :address)
    end
end
