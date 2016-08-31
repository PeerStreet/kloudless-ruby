module Kloudless
  # https://developers.kloudless.com/docs#folders
  class Folder < Model
    # https://developers.kloudless.com/docs#folders-create-a-folder
    def self.create(account_id:, params: {}, **data)
      path = "/accounts/#{account_id}/storage/folders"
      new(http.post(path, params: params, data: data))
    end

    # https://developers.kloudless.com/docs#folders-retrieve-folder-metadata
    def self.metadata(account_id:, folder_id:, **params)
      path = "/accounts/#{account_id}/storage/folders/#{folder_id}"
      new(http.get(path, params: params))
    end

    # https://developers.kloudless.com/docs#folders-retrieve-folder-contents
    def self.retrieve(account_id:, folder_id:, **params)
      path = "/accounts/#{account_id}/storage/folders/#{folder_id}/contents"
      Kloudless::Collection.new(self, http.get(path, params: params))
    end

    # https://developers.kloudless.com/docs#folders-rename/move-a-folder
    def self.rename(account_id:, folder_id:, params: {}, **data)
      path = "/accounts/#{account_id}/storage/folders/#{folder_id}"
      new(http.patch(path, params: params, data: data))
    end

    # https://developers.kloudless.com/docs#folders-copy-a-folder
    def self.copy(account_id:, folder_id:, parent_id:, params: {}, **data)
      path = "/accounts/#{account_id}/storage/folders/#{folder_id}/copy"
      data[:parent_id] = parent_id
      new(http.post(path, params: params, data: data))
    end

    # https://developers.kloudless.com/docs#folders-delete-a-folder
    def self.delete(account_id:, folder_id:, **params)
      path = "/accounts/#{account_id}/storage/folders/#{folder_id}"
      new(http.delete(path, params: params))
    end
  end
end
