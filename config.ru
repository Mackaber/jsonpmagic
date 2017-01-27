require 'json'
require 'jsonpath'
require 'faraday'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  url = req['url']
  jsonp = req['jsonp']

  response = Faraday.get url

  [200, { 'Content-Type' => 'application/json' }, [ JsonPath.on(response.body, jsonp).to_json ]]
end

run app