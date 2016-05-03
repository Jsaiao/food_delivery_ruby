class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :add_product_to_cart,
                                     :set_quantity, :one_less_product, :delete_product_from_cart]
  skip_before_action :authenticate_user!, :is_authorized, only: [:index_mobile]


  # GET /products
  # GET /products.json
  def index
    if current_user.has_restaurant_scope?
      @products = current_user.restaurant.products.paginate(page: params[:page], per_page: 15)
    else
      @products = Product.all.paginate(page: params[:page], per_page: 15)
    end
  end

  def index_mobile
    @products = Restaurant.find(params[:restaurant_id]).products
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
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
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
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
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

    respond_to do |format|
      format.js {render template: 'carts/update_cart.js.erb'}
    end
  end

  def set_quantity
    @cart = current_user.carts.where(product_id: @product.id).first.update(quantity: params[:quantity])

    respond_to do |format|
      format.js {render template: 'carts/update_cart.js.erb'}
    end
  end

  def one_less_product
    @cart = current_user.carts.where(product_id: @product.id).first
    @cart.quantity -= 1
    @cart.save

    respond_to do |format|
      format.js {render template: 'carts/update_cart.js.erb'}
    end
  end

  def delete_product_from_cart
    @cart = current_user.carts.where(product_id: @product.id).first.destroy

    respond_to do |format|
      format.js {render template: 'carts/update_cart.js.erb'}
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
