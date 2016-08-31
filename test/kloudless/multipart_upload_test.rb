require_relative "../test_helper"

class Kloudless::MultipartUploadTest < Minitest::Test
  def test_init_multipart_upload
    Kloudless.http.expect(:post, returns: {"id" => "foo"}, args:[
                            "/accounts/1/storage/multipart", params: {overwrite: true}, data: {parent_id: "foo"}]) do
      upload = Kloudless::MultipartUpload.create(account_id: 1, params: {overwrite: true}, parent_id: "foo")
      assert_kind_of Kloudless::MultipartUpload, upload
    end
  end

  def test_retrieve_multipart_upload
    Kloudless.http.expect(:get, returns: {"id" => "foo"}, args:["/accounts/1/storage/multipart/2"]) do
      upload = Kloudless::MultipartUpload.retrieve(account_id: 1, multipart_id: 2)
      assert_kind_of Kloudless::MultipartUpload, upload
    end
  end

  def test_upload_multipart_upload
    Kloudless.http.expect(:put, args: ["/accounts/1/storage/multipart/2", data: "FILE CONTENTS",
                                       headers: {'Content-Type' => 'application/octet-stream'},
                                       params: {part_number: 1},
                                       parse_request: false]) do
      upload = Kloudless::MultipartUpload.upload(account_id: 1, multipart_id: 2,
                                                 data: "FILE CONTENTS", part_number: 1)
      assert_kind_of Kloudless::MultipartUpload, upload
    end
  end

  def test_finalize_multipart_upload
    Kloudless.http.expect(:post, args: ["/accounts/1/storage/multipart/2/complete", params: {}, data: {}]) do
      upload = Kloudless::MultipartUpload.finalize(account_id: 1, multipart_id: 2)
      assert_kind_of Kloudless::MultipartUpload, upload
    end
  end

  def test_abort_multipart_upload
    Kloudless.http.expect(:delete, args: ["/accounts/1/storage/multipart/2", params: {}]) do
      upload = Kloudless::MultipartUpload.abort(account_id: 1, multipart_id: 2)
      assert_kind_of Kloudless::MultipartUpload, upload
    end
  end
end
