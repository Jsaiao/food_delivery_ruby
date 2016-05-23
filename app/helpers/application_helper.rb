module ApplicationHelper
  def custom_paginator(resource, resource_class = '')
    will_paginate resource, class: "pagination pagination-sm #{resource_class}",
                  next_label: '<i class="fa fa-chevron-right"></i>'.html_safe,
                  previous_label: '<i class="fa fa-chevron-left"></i>'.html_safe
  end

  def has_policy(record, actions, devise_controller = nil)
    return true if current_user.god?
    record = record.classify.constantize if record.is_a? String
    actions.each { |query| return true if policy(record).send('general_policy', record, query, devise_controller) }
    false
  end

  def collection_scope(user, scope)
    policy_name = (scope.to_s + 'Policy').classify.constantize
    policy_name::ScopeActions.new(user, scope).collection_scope
  end

  def show_image_record(logbook)
    if logbook.blank?
      ActionController::Base.helpers.asset_path('user.png')
    end
  end

  def asset_data_base64(path)
    asset = Rails.application.assets.find_asset(path)
    throw "Could not find asset '#{path}'" if asset.nil?
    base64 = Base64.encode64(asset.to_s).gsub(/\s+/, "")
    "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
  end

  def get_total_price(orders)
    total_price = 0
    orders.order_products.each do |order|
      total_price +=  order.product.price * order.quantity
    end
    total_price.round(2)
  end
end
