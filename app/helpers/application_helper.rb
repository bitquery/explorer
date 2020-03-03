module ApplicationHelper

  def external_css name
    "#{BITQUERY_PROJECT_URL}/css/#{name}"
  end

  def external_image name
    "#{BITQUERY_PROJECT_URL}/images/#{name}"
  end

  def image_pack_path path
    resolve_path_to_image path
  end

end
