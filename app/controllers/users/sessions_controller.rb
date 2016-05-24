class Users::SessionsController < Devise::SessionsController
  layout 'out_system'
  skip_before_filter :verify_authenticity_token, only: :create_mobile_session

  # before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  def create_mobile_session
    if User.exists?(email: params[:email])
      user = User.find_by(email: params[:email])
      if user.valid_password? params[:password]
        render json: user, status: :ok
      else
        render status: 404
      end
    else
      render status: 404
    end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
