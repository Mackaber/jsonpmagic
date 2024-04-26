require 'json'
require 'jsonpath'
require 'faraday'

app = Proc.new do |env|
  req = Rack::Request.new(env)

  if req['url'] && req['jsonp']
    url = req['url']
    jsonp = req['jsonp']

    res = Faraday.get url

    response = JsonPath.on(res.body, jsonp).to_json
  else
    response = { usage: "http://jsonpmagic.mackaber.me/?url=http://example.com/resource.json&jsonp=$(some jsonp expression)" }.to_json
  end

  [200, { 'content-type' => 'application/json' }, [ response ]]
end

run app