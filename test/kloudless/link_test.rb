require_relative "../test_helper"

class Kloudless::LinkTest < Minitest::Test
  def test_list_links
    response = {"objects" => [{"id" => 1}]}
    Kloudless.http.expect(:get, returns: response, args: ["/accounts/1,2/links", params: {active: false}]) do
      links = Kloudless::Link.list(account_ids: [1,2], active: false)
      assert_kind_of Kloudless::Collection, links
      assert_kind_of Kloudless::Link, links.first
    end
  end

  def test_create_link
    Kloudless.http.expect(:post, args: ["/accounts/1/links", params: {}, data: {file_id: "file-id"}]) do
      link = Kloudless::Link.create(account_id: 1, file_id: "file-id")
      assert_kind_of Kloudless::Link, link
    end
  end

  def test_retrieve_link
    Kloudless.http.expect(:get, args: ["/accounts/1/links/2", params: {active: true}]) do
      link = Kloudless::Link.retrieve(account_id: 1, link_id: 2, active: true)
      assert_kind_of Kloudless::Link, link
    end
  end

  def test_update_link
    Kloudless.http.expect(:patch, args: ["/accounts/1/links/2", params: {}, data: {password: "foo"}]) do
      link = Kloudless::Link.update(account_id: 1, link_id: 2, password: "foo")
      assert_kind_of Kloudless::Link, link
    end
  end

  def test_delete_link
    Kloudless.http.expect(:delete, args: ["/accounts/1/links/2", params: {}]) do
      link = Kloudless::Link.delete(account_id: 1, link_id: 2)
      assert_kind_of Kloudless::Link, link
    end
  end
end
