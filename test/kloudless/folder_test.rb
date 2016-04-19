require_relative "../test_helper"

class Kloudless::FolderTest < Minitest::Test
  def test_create
    Kloudless.http.expect(:post, args: ["/accounts/1/folders", params: {}, data: {name: "foo"}]) do
      folder = Kloudless::Folder.create(account_id: 1, name: "foo")
      assert_kind_of Kloudless::Folder, folder
    end
  end

  def test_metadata
    Kloudless.http.expect(:get, args: ["/accounts/1/folders/2", params: {}]) do
      folder = Kloudless::Folder.metadata(account_id: 1, folder_id: 2)
      assert_kind_of Kloudless::Folder, folder
    end
  end

  def test_retrieve
    response = {"objects" => [{"id" => "1"}]}
    Kloudless.http.expect(:get, returns: response, args: ["/accounts/1/folders/2/contents", params: {page_number: 1, page_size: 1}]) do
      folders = Kloudless::Folder.retrieve(account_id: 1, folder_id: 2, page_number: 1, page_size: 1)
      assert_kind_of Kloudless::Collection, folders
      assert_kind_of Kloudless::Folder, folders.first
    end
  end

  def test_rename
    Kloudless.http.expect(:patch, args: ["/accounts/1/folders/2", params: {}, data: {name: "foo.md"}]) do
      folder = Kloudless::Folder.rename(account_id: 1, folder_id: 2, name: "foo.md")
      assert_kind_of Kloudless::Folder, folder
    end
  end

  def test_copy
    Kloudless.http.expect(:post, args: ["/accounts/1/folders/2/copy", params: {}, data: {parent_id: "parent-id"}]) do
      folder = Kloudless::Folder.copy(account_id: 1, folder_id: 2, parent_id: "parent-id")
      assert_kind_of Kloudless::Folder, folder
    end
  end

  def test_delete
    Kloudless.http.expect(:delete, args: ["/accounts/1/folders/2", params: {recursive: true, permanent: true}]) do
      folder = Kloudless::Folder.delete(account_id: 1, folder_id: 2, recursive: true, permanent: true)
      assert_kind_of Kloudless::Folder, folder
    end
  end
end
