require 'net/http'

class NetHelper
  class << self
    def post(url, data)
      uri = URI.parse(url)
      req = Net::HTTP::Post.new(uri.path,{'Content-Type' => 'application/json'})
      req.body = data.to_json
      res = Net::HTTP.new(uri.host, uri.port).start{|http| http.request(req)}

      res.body
    end
  end
end
