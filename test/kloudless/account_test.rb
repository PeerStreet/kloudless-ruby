require_relative "../test_helper"

class Kloudless::AccountTest < Minitest::Test
  def test_list_accounts
    json = JSON.parse <<-JSON
    {
      "total": 2,
      "count": 2,
      "page": 1,
      "objects": [
        {
            "id": 90817234,
            "account": "someone@gmail.com",
            "service": "box",
            "service_name": "Box",
            "admin": false,
            "active": true,
            "created": "2015-03-17T20:42:17.954885Z",
            "modified": "2015-03-17T20:42:17.954885Z",
            "token_expiry": "2015-04-17T20:42:17.954885Z",
            "refresh_token_expiry": null
        },
        {
            "id": 6535892,
            "account": "someone-else@gmail.com",
            "service": "egnyte",
            "service_name": "Egnyte",
            "admin": false,
            "active": true,
            "created": "2015-03-17T20:42:18.627533Z",
            "modified": "2015-03-17T20:42:18.627533Z",
            "token_expiry": "2015-04-17T20:42:18.627533Z",
            "refresh_token_expiry": null
        }
      ]
    }
    JSON

    Kloudless.http.expect(:get, returns: json, args: ["/accounts", {params: {}}]) do
      accounts = Kloudless::Account.list
      assert_kind_of Kloudless::Collection, accounts
      assert_kind_of Kloudless::Account, accounts.first
    end
  end

  def test_import_account
    attributes = {
      account: "someone@gmail.com",
      service: "copy",
      token: "foo",
      token_secret: "bar"
    }
    Kloudless.http.expect(:post, args: ["/accounts", {params: {}, data: attributes}]) do
      Kloudless::Account.import(**attributes)
    end
  end

  def test_retrieve_account
    Kloudless.http.expect(:get, args: ["/accounts/1", {params: {active: false}}]) do
      account = Kloudless::Account.retrieve(account_id: 1, active: false)
      assert_kind_of Kloudless::Account, account
    end
  end

  def test_update_account
    Kloudless.http.expect(:patch, args: ["/accounts/1", {params: {}, data: {active: true}}]) do
      account = Kloudless::Account.update(account_id: 1, active: true)
      assert_kind_of Kloudless::Account, account
    end
  end

  def test_delete_account
    Kloudless.http.expect(:delete, args: ["/accounts/1"]) do
      account = Kloudless::Account.delete(account_id: 1)
      assert_kind_of Kloudless::Account, account
    end
  end
end
