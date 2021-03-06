class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token, only: [:one_less_product, :add_product_to_cart, :delete_product_from_cart]

  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :authenticate_user!, :is_authorized

  # Checks whether a user can make a specific action on the system.
  def authorize_with(record, query = nil, devise_controller = nil)
    query ||= params[:action].to_s
    @_pundit_policy_authorized = true
    policy = policy(record)
    unless policy.public_send('general_policy', record, query, devise_controller)
      raise NotAuthorizedError.new(query: query, record: record, policy: policy)
    end
    true
  end

  # Creates the logbook records
  def track_actions(object, extra_parameters = nil)
    action = request.path_parameters[:action]
    controller = request.path_parameters[:controller].gsub('/', '-')

    Logbook.create_by_object(current_user, object, controller, action, extra_parameters)
  end

  # POST /generate_report
  # POST /generate_report.json
  def generate_report
      report_file = Logbook.generate_report_file(current_user)
      send_data report_file.spreadsheet.to_stream.read, filename: report_file.file_name
  end

  private

  # If the user doesn't have permission to perform an action is redirected.
  def user_not_authorized
    flash[:alert] = 'You cannot perform this action.'
    redirect_to(request.referrer || authenticated_root_path || unauthenticated_root_path)
  end

  # Verifies the user permissions before performing an action.
  def is_authorized
    controller = params[:controller].classify
    exception = controller.split(':').first
    if exception.include? 'User'
      exception = controller.split(':').last
      devise_controller = controller.split(':').first
    end

    unless Rails.configuration.x.controller_exceptions.include? exception
      return true if current_user.god?
      if devise_controller
        authorize_with devise_controller.classify.constantize, params[:action].to_s, controller
      else
        authorize_with exception.classify.constantize
      end
    end
  end

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end
end
