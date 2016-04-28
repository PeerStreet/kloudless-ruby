require 'json'

module Kloudless
  # https://developers.kloudless.com/docs#files
  class File < Model
    def self.upload(account_id:, data:, parent_id:, file_name:, **params)
      headers = {
        'X-Kloudless-Metadata' => {parent_id: parent_id, name: file_name}.to_json,
        'Content-Type' => 'application/octet-stream'
      }
      path = "/accounts/#{account_id}/files"
      if overwrite = params.delete(:overwrite)
        path << "?overwrite=#{overwrite}"
      end
      new(http.post(path, params: params, data: data, headers: headers,
                    parse_request: false))
    end

    def self.upload_from_url(account_id:, params: {}, **data)
      path = "/accounts/#{account_id}/files"
      new(http.post(path, params: params, data: data))
    end

    def self.metadata(account_id:, file_id:, **params)
      path = "/accounts/#{account_id}/files/#{file_id}"
      new(http.get(path, params: params))
    end

    def self.rename(account_id:, file_id:, params: {}, **data)
      path = "/accounts/#{account_id}/files/#{file_id}"
      new(http.patch(path, params: params, data: data))
    end

    def self.update(account_id:, file_id:, data:)
      path = "/accounts/#{account_id}/files/#{file_id}"
      new(http.put(path, data: data, parse_request: false,
                   headers: {'Content-Type' => 'application/octet-stream'}))
    end

    def self.download(account_id:, file_id:, **params)
      path = "/accounts/#{account_id}/files/#{file_id}/contents"
      http.get(path, params: params, parse_response: false)
    end

    def self.copy(account_id:, file_id:, parent_id:, params: {}, **data)
      path = "/accounts/#{account_id}/files/#{file_id}/copy"
      data[:parent_id] = parent_id
      new(http.post(path, params: params, data: data))
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

    def self.convert_id(account_id:, raw_id:, type:, params: {}, **data)
      path = "/accounts/#{account_id}/convert_id"
      data[:raw_id] = raw_id
      data[:type] = type
      http.post(path, params: params, data: data)
    end
  end
end
