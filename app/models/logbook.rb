class Logbook < ActiveRecord::Base
  def self.create_by_object(user, object, controller, action, params)
      self.create(user_id: user.id, action: action, controller: controller, options: parse_options(user, object, params))
  end

  # Gather all the options of a logbook record.
  def self.parse_options(user, object, extra_parameters)
    old_name = extra_parameters.try(:[], :old_name)

    options = {name: object.try(:name), old_name: old_name, id: object.try(:id),
               created_at: object.try(:created_at), updated_at: object.try(:updated_at),
               requester_username: user.username, requester_full_name: user.full_name,
               user_full_name: object.try(:full_name), user_role: object.try(:role_name),
               username: object.try(:username), requester_ip: user.try(:current_sign_in_ip).try(:to_s),
               user_email: object.try(:email), requester_role_name: user.role_name,
               requester_role_key: user.role_key,
               requester_sing_count: user.sign_in_count}.compact
    options
  end

  # Create a string that allows to go and look for the corresponding translation.
  def self.string_translation(logbook)
    translation = logbook.action + '.' + logbook.controller
    case
      when translation.include?('pages')
        if logbook.options['change']
          translation + '.' + logbook.options['change']
        else
          translation + '.' + 'same'
        end
      when translation.include?('block_user'), translation.include?('toggle')
        translation + '.' + logbook.options['change'].to_s
      when translation.include?('asset_file_record')
        translation + '.' + logbook.options['fileable_type'].downcase
      else
        translation
    end
  end

  def logbook_old_name?(logbook)
    logbook.options['old_name'] && logbook.options['old_name'] != logbook.options['name']
  end

  def logbook_username?(logbook)
    logbook.options['username'] && logbook.options['username'] != logbook.options['requester_username'] &&
        logbook.action != 'save_user_password'
  end
end
