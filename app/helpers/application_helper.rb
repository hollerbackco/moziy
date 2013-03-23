module ApplicationHelper
  # @title is an array [boolean:true turns on localization, value: value of title]
  def title
    base_title = t 'common.title_prefix'
    page_title = @title[0] ? t(@title[1]) : @title[1]
    separator  = t 'common.title_separator'
    "#{page_title}#{separator}#{base_title}"
  end

  def description
    @description || t("meta.description")
  end

  def body_id
    "#{controller_name}-#{action_name}"
  end

  def current_user_json(channel_list=[], my_channels=[])
    if logged_in?
      current_user.as_json.merge({
        channel_list: channel_list.as_json,
        channels: my_channels.as_json,
        loggedIn: true}).to_json
    else
      "null"
    end
  end
end
