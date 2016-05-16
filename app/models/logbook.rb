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

  # Creates the spreadsheet of the records searched.
  def self.generate_report_file(user)
    spreadsheet = Axlsx::Package.new
    workbook = spreadsheet.workbook
    default_workbook(Logbook.all, workbook)

    ReportFile.new(file_name(user), spreadsheet)
  end

  # Creates the general workbook of the spreadsheet.
  def self.default_workbook(logbooks, workbook)
    total_rows = 0
    workbook.add_worksheet(name: 'Detailed logbook') do |sheet|
      sheet.add_row %w(Date User Name Role IP_address Login_count Description)
      sheet.column_widths 13, 15, 25, 11, 15, 15, 110
      sheet.add_style 'A1:G1', b: true, bg_color: 'B0B090'
      Array(logbooks).each do |logbook|
        total_rows += 1
        sheet.add_row [I18n.l(logbook.created_at.to_time, format: :views), logbook.options['requester_username'],
                       logbook.options['requester_full_name'], logbook.options['requester_role_name'],
                       logbook.options['requester_ip'], logbook.options['requester_sing_count'],
                       (I18n.t("home.#{string_translation(logbook)}_html", requester: logbook.options['requester_full_name'],
                               resource: logbook.options['name'], user: logbook.options['user_full_name'],
                               site: logbook.options['site_name'], directory_site: logbook.options['directory_site'],
                               status: logbook.options['status'])).sanitize]

      end
      %w(A B C D E F G).each do |letter|
        sheet.add_style "#{letter}2:#{letter}#{total_rows.to_s}", bg_color: 'F5F5EB'
      end
    end
    total_rows
    workbook.apply_styles
  end

  # Creates the name of xlsx file.
  def self.file_name(user)
    user.username + '_' + Time.now.strftime('%Y%d%m_%H%M%S') + '.xlsx'
  end

  ReportFile = Struct.new(:file_name, :spreadsheet)
end
