class CartsController < ApplicationController
  before_action :set_cart, only: [:show, :edit, :update, :destroy]

  # GET /carts
  # GET /carts.json
  def index
    @carts = Cart.all.paginate(page: params[:page], per_page: 15)
  end

  # GET /carts/1
  # GET /carts/1.json
  def show
  end

  # GET /carts/new
  def new
    @cart = Cart.new
  end

  # GET /carts/1/edit
  def edit
  end

  # POST /carts
  # POST /carts.json
  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /carts/1
  # PATCH/PUT /carts/1.json
  def update
    respond_to do |format|
      if @cart.update(cart_params)
        format.html { redirect_to @cart, notice: 'Cart was successfully updated.' }
        format.json { render :show, status: :ok, location: @cart }
      else
        format.html { render :edit }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /carts/1
  # DELETE /carts/1.json
  def destroy
    @cart.destroy
    respond_to do |format|
      format.html { redirect_to carts_url, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def user_cart
    @user = current_user
    @cart_products = @user.carts
  end

  def generate_cart_json
    json = []
    @user = current_user
    @cart_products = @user.carts
    @cart_products.each_with_index do |cart, index|
      new_json = {}
      new_json[:name] = cart.product.name
      new_json[:product_id] = cart.product.id
      new_json[:quantity] = cart.quantity
      new_json[:id] = cart.id
      new_json[:price] = cart.product.price
      new_json[:number] = index + 1
      new_json[:total_price] = (cart.product.price * cart.quantity).round(2)
      json << new_json
    end
    render json: json
  end

  def place_order
    @user = current_user
    @cart_products = @user.carts
    @order = Order.new
  end

  def make_order
    @address = Address.find(params[:address_id])
    @cart = current_user.carts
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params.require(:cart).permit(:user_id, :product_id, :quantity)
    end
end
