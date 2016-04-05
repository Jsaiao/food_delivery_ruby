class Users::RegistrationsController < Devise::RegistrationsController
  layout 'out_system', only: [:new, :create]
  add_breadcrumb I18n.t('breadcrumbs.users'), :user_registrations_path

  before_action :set_user, only: [:show, :edit_user, :update_user, :destroy]
  before_action :set_current_user, only: [:edit, :update]
  skip_before_action :is_authorized, only: [:edit, :update, :new, :create]

  # before_filter :configure_sign_up_params, only: [:create]
  # before_filter :configure_account_update_params, only: [:update]

  # GET /users
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

  # GET /resource/sign_up
  # def new
  # super
  # end

  # GET /users/new_user
  def new_user
    @user = User.new
  end

  # GET /resource/edit
  def edit
    super
  end

  # GET /roles/1/edit
  def edit_user
  end

  # POST /resource
  # def create
  # super
  # end

  # POST /users
  # POST /users.json
  def create_user
    @user = User.new(sign_up_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_registrations_path, notice: 'User created correctly' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new_user }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /resource
  def update
    super
  end

  # PATCH/PUT /roles/1
  # PATCH/PUT /roles/1.json
  def update_user
    if @user.update(account_update_params)
      format.html { redirect_to user_registrations_path, notice: 'User updated correctly' }
      format.json { render :show, status: :created, location: @user }
    else
      format.html { render :new_user }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

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
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_current_user
    @user = current_user
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :first_name, :last_name,
                                 :maiden_name, :role_id)
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :first_name, :last_name,
                                 :maiden_name, :role_id)
  end
end
