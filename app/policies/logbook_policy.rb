# Assigns permissions to the actions in the directories controller.
class LogbookPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      case @user.role_scope
        when 'total'
          scope.all
        else
          scope.where(user_id: @user.id).where.not('options @> ? OR options @> ?', {requester_role_key: 'god'}.to_json,
                                                   {requester_role_key: 'backdoor'}.to_json)
      end
    end
  end
end
