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
end
