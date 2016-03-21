require "net/http"

module Kloudless
  # Net::HTTP wrapper
  class HTTP
    # Public: Headers global to all requests
    def self.headers
      @headers ||= {}
    end

    def self.get(path, params: {}, headers: {})
      uri = URI.parse(Kloudless::API_URL + path)
      uri.query = URI.encode_www_form(params) if !params.empty?

      request = Net::HTTP::Get.new(uri)
      request.initialize_http_header(headers)

      execute(request)
    end

    # TODO: decouple Kloudless::HTTP methods from #execute. Have methods return
    # request object, defaults to json parsing, but allow the option for raw
    def self.get_raw(path)
      uri = URI.parse(Kloudless::API_URL + path)
      request = Net::HTTP::Get.new(uri)
      request.initialize_http_header(headers)

      execute(request, parse_json: false)
    end


    def self.post(path, params: {}, headers: {})
      uri = URI.parse(Kloudless::API_URL + path)
      headers["Content-Type"] = "application/json"

      request = Net::HTTP::Post.new(uri)
      request.initialize_http_header(headers)
      request.body = params.to_json if !params.empty?

      execute(request)
    end

    def self.patch(path, params: {}, headers: {})
      uri = URI.parse(Kloudless::API_URL + path)
      headers["Content-Type"] = "application/json"

      request = Net::HTTP::Post.new(uri)
      request.initialize_http_header(headers)
      request.set_form_data(params) if !params.empty?

      execute(request)
    end

    def self.delete(path, params: {}, headers: {})
      uri = URI.parse(Kloudless::API_URL + path)
      uri.query = URI.encode_www_form(params) if !params.empty?

      request = Net::HTTP::Delete.new(uri)
      request.initialize_http_header(headers)

      execute(request)
    end

    def self.execute(request, parse_json: true)
      uri = request.uri
      @last_request = request
      headers.each {|k,v| request[k] = v}

      response = @mock_response || Net::HTTP.start(uri.hostname, uri.port, use_ssl: (uri.scheme == "https")) {|http|
        http.request(request)
      }

      if parse_json
        json = JSON.parse(response.body)
        raise Kloudless::Error.from_json(json) if json["error_code"]
        json
      else
        response
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
