module NewRelicHTTP
  class HTTPResponse
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def [](key)
      response.headers.each do |k,v|
        if key.downcase == k.downcase
          return v
        end
      end
      nil
    end

    def to_hash
      response.headers
    end
  end

  class HTTPRequest
    attr_reader :request, :uri

    def initialize(request)
      @request = request
      @uri = request.uri
    end

    def type
      "http.rb"
    end

    def method
      request.verb
    end

    def host
      request.socket_host
    end

    def [](key)
      request.headers[key]
    end

    def []=(key, value)
      request.headers[key] = value
    end
  end
end
