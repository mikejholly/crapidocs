module Helpers
  def app
    Sinatra::Application
  end

  def get_json(path)
    get path, nil, 'Content-Type' => 'application/json'
  end

  def post_json(path, body)
    post path, body.to_json, 'Content-Type' => 'application/json'
  end
end
