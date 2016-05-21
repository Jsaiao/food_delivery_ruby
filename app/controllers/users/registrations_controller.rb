class Users::RegistrationsController < Devise::RegistrationsController
  layout 'out_system', only: [:new, :create]
  before_action :set_user, only: [:show, :edit_user, :update_user, :destroy, :change_user_password, :save_user_password,
                                  :get_user_image]
  before_action :set_current_user, only: [:edit, :update, :change_password, :save_password]
  skip_before_filter :require_no_authentication, only: [:new, :create]
  skip_before_filter :authenticate_scope!, only: [:edit, :update, :destroy]
  skip_before_action :is_authorized, only: [:edit, :update, :change_password, :save_password, :get_user_image,
                                            :show, :new, :create]

  # GET /users
  # GET /users.json
  def index
    @users = policy_scope(User).paginate(page: params[:page], per_page: 15)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  def new_user
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create_user
    @user = User.new(sign_up_params)
    respond_to do |format|
      if @user.save
        track_actions(@user)
        format.html { redirect_to user_registrations_path, notice: 'User created correctly' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new_user }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  #def create
  #  super
  #end

  # PATCH/PUT /users/1
  def update
    prev_unconfirmed_email = @user.unconfirmed_email if @user.respond_to?(:unconfirmed_email)
    if @user.update_attributes(profile_update_params)
      track_actions(@user)
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ? :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      set_flash_message :notice, :updated
      sign_in @user, bypass: true
      render 'edit'
    else
      render 'edit'
    end
  end

  # DELETE /resource
  def destroy
    @user.destroy
    track_actions(@user)
    respond_to do |format|
      format.html { redirect_to user_registrations_url }
      format.json { head :no_content }
    end
  end

  # Métodos para modificar la propia contraseña.
  def change_password
  end

  def save_password
    respond_to do |format|
      if @user.update_with_password(profile_update_params) && @user.update(profile_update_params)
        # Sign in the user by passing validation in case their password changed
        sign_in @user, bypass: true
        track_actions(@user)
        format.html { redirect_to authenticated_root_path, notice: 'User updated correctly' }
        format.json { head :no_content }
      else
        format.html { render :change_password }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Métodos utilizados para editar usuarios como administrador.
  def edit_user
  end

  def update_user
    prev_unconfirmed_email = @user.unconfirmed_email if @user.respond_to?(:unconfirmed_email)

    if @user.update(account_update_params)
      track_actions(@user)
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ? :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      flash.now[:notice] = 'User updated correctly'
      redirect_to user_registrations_path
    else
      render 'edit_user'
    end
  end

  def change_user_password
  end

  def save_user_password
    flag = true if @user.eql? current_user
    user = @user

    respond_to do |format|
      if @user.update(account_update_params)
        # Sign in the user by passing validation in case their password changed
        sign_in user, bypass: true if flag
        track_actions(@user)
        format.html { redirect_to user_registrations_path,
                                  notice: 'User updated correctly' }
        format.json { head :no_content }
      else
        format.html { render :change_user_password }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def get_user_image
    respond_to do |format|
      if @user.update_attributes(update_avatar)
        format.json { render json: @user.avatar_image.to_json }
      end
    end
  end


  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  protected

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_current_user
    @user = current_user
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :mother_last_name, :username,
                                 :role_id, :avatar, :avatar_original_w, :avatar_original_h, :avatar_box_w, :restaurant_id,
                                 :avatar_aspect, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
                                 addresses_attributes: [:id, :street, :city, :zipcode, :phone_number,:state, :_destroy])
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :mother_last_name, :username,
                                 :role_id, :avatar, :avatar_original_w, :avatar_original_h, :avatar_box_w, :restaurant_id,
                                 :avatar_aspect, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
                                 addresses_attributes: [:id, :street, :city, :zipcode, :phone_number,:state, :_destroy])
  end

  def profile_update_params
    params.require(:user).permit(:email, :current_password, :password, :password_confirmation, :first_name, :last_name, :username,
                                 :mother_last_name, :avatar, :avatar_original_w, :avatar_original_h, :avatar_box_w, :restaurant_id,
                                 :avatar_aspect, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
                                 addresses_attributes: [:id, :street, :city, :zipcode, :phone_number,:state, :_destroy])
  end

  def update_avatar
    params.require(:user).permit(:avatar)
  end

  def needs_password?
    @user.email != params[:user][:email] || params[:user][:password].present?
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    super(resource)
  end
end
