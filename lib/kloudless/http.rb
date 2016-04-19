require "net/http"
require "json"

module Kloudless
  # Net::HTTP wrapper
  class HTTP
    # Public: Headers global to all requests
    def self.headers
      @headers ||= {}
    end

    def self.request(method, path, params: {}, data: {}, headers: {},
                     parse_request: true, parse_response: true)
      uri = URI.parse(Kloudless::API_URL + path)
      uri.query = URI.encode_www_form(params) if !params.empty?

      if ['post', 'put', 'patch'].member?(method)
        headers["Content-Type"] ||= "application/json"
      end

      request = Net::HTTP.const_get(method.capitalize).new(uri)
      request.initialize_http_header(headers)

      if !data.empty?
        data = data.to_json if parse_request
        request.body = data
      end

      execute(request, parse_response: parse_response)
    end

    def self.get(path, **kwargs)
      self.request('get', path, **kwargs)
    end

    def self.post(path, params: {}, data: {}, headers: {}, **kwargs)
      self.request('post', path, params: params, data: data,
                   headers: headers, **kwargs)
    end

    def self.put(path, params: {}, data: {}, headers: {}, **kwargs)
      self.request('put', path, params: params, data: data,
                   headers: headers, **kwargs)
    end

    def self.patch(path, params: {}, data: {}, headers: {}, **kwargs)
      self.request('patch', path, params: params, data: data,
                   headers: headers, **kwargs)
    end

    def self.delete(path, params: {}, headers: {}, **kwargs)
      self.request('delete', path, params: params, headers: headers, **kwargs)
    end

    def self.execute(request, parse_response: true)
      uri = request.uri
      @last_request = request
      headers.each {|k,v| request[k] = v}

      response = @mock_response || Net::HTTP.start(uri.hostname, uri.port, use_ssl: (uri.scheme == "https")) {|http|
        http.request(request)
      }

      if parse_response
        json = JSON.parse(response.body)
        raise Kloudless::Error.from_json(json) if json["error_code"]
        json
      else
        response.body
      end
    end

    # Internal: Returns `response` the next time #execute is invoked for the
    # duration of `blk`. Used for testing.
    #
    #  mock = Struct.new(:body).new("{}")
    #  Kloudless::HTTP.mock_response(mock) do
    #    Kloudless::HTTP.get "/foo"  # returns {}
    #  end
    def self.mock_response(response = nil, &blk)
      @mock_response = response || Struct.new(:body).new("{}")
      blk.call
    ensure
      @mock_response = nil
    end

    require 'minitest/mock'
    def self.expect(method, returns: nil, args: [], &blk)
      begin
        mock = MiniTest::Mock.new
        Kloudless.http = mock
        mock.expect(method, returns, args)
        blk.call
        mock.verify
      ensure
        Kloudless.http = Kloudless::HTTP
      end
    end

    # Internal: Returns the last Net::HTTP request sent by #execute.
    def self.last_request
      @last_request
    end
  end
end
