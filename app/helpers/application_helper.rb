module ApplicationHelper
  
  def absolute_javascript_url(source)
    uri = URI.parse(root_url)
    uri.merge(javascript_path(source))
  end
end
