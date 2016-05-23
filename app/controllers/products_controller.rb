class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :add_product_to_cart,
                                     :set_quantity, :one_less_product, :view_product, :add_product_to_cart_mobile, :one_less_product_mobile]
  skip_before_action :authenticate_user!, :is_authorized, only: [:index_mobile, :add_product_to_cart_mobile, :one_less_product_mobile, :set_quantity_mobile]
  skip_before_filter :verify_authenticity_token, only: [:add_product_to_cart_mobile, :one_less_product_mobile, :set_quantity_mobile]



  # GET /products
  # GET /products.json
  def index
    if current_user.has_restaurant_scope?
      @search_products = current_user.restaurant.products.ransack(params[:q])
      @products = @search_products.result.paginate(page: params[:page], per_page: 15)
    else
      @search_products = Product.all.ransack(params[:q])
      @products = @search_products.result.paginate(page: params[:page], per_page: 15)
    end
  end

  def index_mobile
    if params[:restaurant_id] == '0'
      @products = Product.all
    else
      @products = Restaurant.find(params[:restaurant_id]).products
    end
    render json: @products, status: :ok
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new(active: true)
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @product.restaurant_id = current_user.restaurant_id unless @product.restaurant_id

    respond_to do |format|
      if @product.save
        track_actions(@product)
        format.html { redirect_to products_url, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    extra_parameters = {old_name: @product.name}
    respond_to do |format|
      if @product.update(product_params)
        track_actions(@product, extra_parameters)
        format.html { redirect_to products_url, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    track_actions(@product)
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def add_product_to_cart
    if current_user.carts.where(product_id: @product.id).empty?
      @cart = current_user.carts.create(product_id: @product.id, quantity: 1)
    else
      @cart = current_user.carts.where(product_id: @product.id).first
      @cart.quantity += 1
      @cart.save
    end

    render nothing: true, status: :ok, content_type: 'text/html'
<<<<<<< a442bb92fbd9e3897757c48e538dcee9bc970191
  end

  def add_product_to_cart_mobile
    user = User.find(params[:user_id])
    if user.carts.where(product_id: @product.id).empty?
      @cart = user.carts.create(product_id: @product.id, quantity: 1)
    else
      @cart = user.carts.where(product_id: @product.id).first
      @cart.quantity += 1
      @cart.save
    end

    render json: @cart, status: :ok
  end

  def one_less_product_mobile
    user = User.find(params[:user_id])

    @cart = user.carts.where(product_id: @product.id).first

    if @cart.quantity > 0
      @cart.quantity -= 1
      @cart.save
    end

    render json: @cart, status: :ok
=======
>>>>>>> Se modifica estructura de jquery a angular para gestionar un carrito
  end

  def set_quantity
    @cart = current_user.carts.where(product_id: @product.id).first.update(quantity: params[:quantity])

    respond_to do |format|
      format.js { render template: 'carts/update_cart.js.erb' }
    end
  end

  def set_quantity_mobile
    user = User.find(params[:id])
    @cart = user.carts.where(product_id: params[:product_id]).first.update(quantity: params[:quantity])
    render json: @cart, status: :ok
  end

  def one_less_product
    @cart = current_user.carts.where(product_id: @product.id).first

    if @cart.quantity > 1
      @cart.quantity -= 1
      @cart.save
    end

    render nothing: true, status: :ok, content_type: 'text/html'
  end

  def delete_product_from_cart
    @cart = Cart.find(params[:id])
    @cart.destroy

    render nothing: true, status: :ok, content_type: 'text/html'
  end

  def view_product
    respond_to do |format|
      format.js
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:name, :description, :price, :restaurant_id, :image, :active)
  end
end
