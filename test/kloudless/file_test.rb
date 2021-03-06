require_relative "../test_helper"

class Kloudless::FileTest < Minitest::Test
  def test_upload_file
    Kloudless.http.expect(:post, returns: {"id" => "foo"}, args: ["/accounts/1/files", params: {}]) do
      file = Kloudless::File.upload(account_id: 1)
      assert_kind_of Kloudless::File, file
    end
  end

  def test_retrieve_file_metadata
    Kloudless.http.expect(:get, returns: {"id" => "foo"}, args:["/accounts/1/files/2"]) do
      metadata = Kloudless::File.metadata(account_id: 1, file_id: 2)
      assert_kind_of Kloudless::File, metadata  # TODO: not really a type
    end
  end

  def test_rename_file
    Kloudless.http.expect(:patch, returns: {"id" => "foo"}, args:["/accounts/1/files/2", params: {name: "new-name.txt"}]) do
      file = Kloudless::File.rename(account_id: 1, file_id: 2, name: "new-name.txt")
      assert_kind_of Kloudless::File, file
    end
  end

  def test_download
    Kloudless.http.expect(:get_raw, returns: "FILE CONTENTS", args:["/accounts/1/files/2/contents"]) do
      contents = Kloudless::File.download(account_id: 1, file_id: 2)
      assert_equal "FILE CONTENTS", contents
    end
  end

  def test_copy
    Kloudless.http.expect(:post, returns: {"id" => "foo"}, args:["/accounts/1/files/2/copy", params: {parent_id: "parent-id"}]) do
      file = Kloudless::File.copy(account_id: 1, file_id: 2, parent_id: "parent-id")
      assert_kind_of Kloudless::File, file
    end
  end

  def test_delete
    Kloudless.http.expect(:delete, returns: {"id" => "foo"}, args:["/accounts/1/files/2", params: {permanent: true}]) do
      file = Kloudless::File.delete(account_id: 1, file_id: 2, permanent: true)
      assert_kind_of Kloudless::File, file
    end
  end

  def test_recent
    response = {"objects" => [{"id" => "foo"}]}
    Kloudless.http.expect(:get, returns: response, args:["/accounts/1,2/recent", params: {}]) do
      files = Kloudless::File.recent(account_ids: [1,2])
      assert_kind_of Kloudless::Collection, files
      assert_kind_of Kloudless::File, files.first
    end
  end

  def test_search
    response = {"objects" => [{"id" => "foo"}]}
    Kloudless.http.expect(:get, returns: response, args:["/accounts/1,2/search", params: {dropbox: "foo"}]) do
      files = Kloudless::File.search(account_ids: [1,2], dropbox: "foo")
      assert_kind_of Kloudless::Collection, files
      assert_kind_of Kloudless::File, files.first
    end
  end
end
