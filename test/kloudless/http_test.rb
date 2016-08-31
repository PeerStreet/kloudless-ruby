require_relative "../test_helper"

class Kloudless::HTTPTest < Minitest::Test
  def http
    Kloudless::HTTP
  end

  def last_request
    Kloudless::HTTP.last_request
  end

  def test_get
    http.mock_response(Struct.new(:body).new('{"foo": "bar"}')) do
      json = http.get("/foo")

      assert_equal URI.parse("https://api.kloudless.com/v1/foo"), last_request.uri
      assert_kind_of Net::HTTP::Get, last_request

      expected = {"foo" => "bar"}
      assert_equal expected, json
    end
  end

  def test_delete
    http.mock_response(Struct.new(:body).new('{}')) do
      json = http.delete("/foo/1")

      assert_equal URI.parse("https://api.kloudless.com/v1/foo/1"), last_request.uri
      assert_kind_of Net::HTTP::Delete, last_request
    end
  end

  def test_params
    http.mock_response(Struct.new(:body).new('{"foo": "bar"}')) do
      http.get("/foo", params: {page: 2})
      assert_equal URI.parse("https://api.kloudless.com/v1/foo?page=2"), last_request.uri
    end
  end

  def test_headers
    http.mock_response(Struct.new(:body).new('{"foo": "bar"}')) do
      http.post("/foo", headers: {"X-CUSTOM" => "header-value"})
      assert_equal "header-value", last_request["X-CUSTOM"]
      assert_equal "application/json", last_request["Content-Type"]

      http.patch("/foo")
      assert_equal "application/json", last_request["Content-Type"]
    end
  end

  def test_error
    http.mock_response(Struct.new(:body).new('{"error_code": "bad_request"}')) do
      assert_raises Kloudless::BadRequestError do
        http.get("/foo")
      end
    end
  end
end
