module ApplicationHelper
  # Just return host with protocol and port like
  # https://sr1.localhost:3000
  def host_path
    "#{request.protocol}#{request.host_with_port}"
  end

  # Return full url path with subdomain
  # Like: https://sr1.localhost:3000/news/1
  def full_url
    "#{host_path}#{request.fullpath}"
  end
end
