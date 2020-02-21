module ApplicationHelper

  def external_css name
    "#{BITQUERY_PROJECT_URL}/css/#{name}"
  end

  def external_image name
    "#{BITQUERY_PROJECT_URL}/images/#{name}"
  end

end
