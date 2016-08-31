module Kloudless
  # Public: Base class for different API resources. e.g. Account, Files, Folders.
  class Model
    def self.http
      Kloudless.http
    end

    def http
      self.class.http
    end

    def initialize(attributes = {})
      @attributes = attributes
    end

    def method_missing(name, *args, &blk)
      @attributes[name.to_s] || super
    end
  end
end
