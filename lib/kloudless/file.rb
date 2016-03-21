module Kloudless
  # https://developers.kloudless.com/docs#files
  class File < Model
    def self.upload(account_id:, **params)
      path = "/accounts/#{account_id}/files"
      if overwrite = params.delete(:overwrite)
        path << "?overwrite=#{overwrite}"
      end
      new(http.post(path, params: params))
    end

    def self.metadata(account_id:, file_id:)
      path = "/accounts/#{account_id}/files/#{file_id}"
      new(http.get(path))
    end

    def self.rename(account_id:, file_id:, **params)
      path = "/accounts/#{account_id}/files/#{file_id}"
      new(http.patch(path, params: params))
    end

    # TODO: unclear how to post binary data over net-http
    def self.update
      raise NotImplementedError
    end

    def self.download(account_id:, file_id:)
      path = "/accounts/#{account_id}/files/#{file_id}/contents"
      http.get_raw(path)
    end

    def self.copy(account_id:, file_id:, parent_id:, **params)
      path = "/accounts/#{account_id}/files/#{file_id}/copy"
      params[:parent_id] = parent_id
      new(http.post(path, params: params))
    end

    def self.delete(account_id:, file_id:, **params)
      path = "/accounts/#{account_id}/files/#{file_id}"
      new(http.delete(path, params: params))
    end

    def self.recent(account_ids:, **params)
      path = "/accounts/#{account_ids.join(',')}/recent"
      Kloudless::Collection.new(self, http.get(path, params: params))
    end

    def self.search(account_ids:, **params)
      path = "/accounts/#{account_ids.join(',')}/search"
      Kloudless::Collection.new(self, http.get(path, params: params))
    end
  end
end
