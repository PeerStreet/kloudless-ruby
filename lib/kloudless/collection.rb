module Kloudless
  class Collection
    include Enumerable

    def initialize(model, json)
      @model = model
      @json = json
    end

    def total
      @json["total"]
    end

    def count
      @json["count"]
    end

    def page
      @json["page"]
    end

    def next_page
      @json["next_page"]
    end

    def objects
      @json["objects"]
    end

    def each
      @json["objects"].each do |attrs|
        yield @model.new(attrs)
      end
    end
  end
end
