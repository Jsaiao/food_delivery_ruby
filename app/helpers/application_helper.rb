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
end
