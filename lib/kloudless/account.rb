module Kloudless
  # Each account represents a cloud storage account that a user has connected to
  # your app.
  #
  # https://developers.kloudless.com/docs#accounts
  class Account < Model
    # Public: Returns Kloudless::Collection. Raises Kloudless::Error.
    def self.list(**params)
      Kloudless::Collection.new(self, http.get("/accounts", params: params))
    end

    def self.retrieve(account_id:, **params)
      new(http.get("/accounts/#{account_id}", params: params))
    end

    def self.update(account_id:, params: {}, **data)
      new(http.patch("/accounts/#{account_id}", params: params, data: data))
    end

    def self.delete(account_id:)
      new(http.delete("/accounts/#{account_id}"))
    end

    # Public: TODO: Returns ???. Raises Kloudless::Error.
    def self.import(params: {}, **data)
      http.post("/accounts", params: params, data: data)
    end

    class << self
      alias_method :create, :import
    end
  end
end
