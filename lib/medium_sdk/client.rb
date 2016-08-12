module MediumSdk
  class Client
    attr_accessor :connection
    attr_accessor :http
    attr_accessor :token

    def initialize(opts = {})
      @endpoint = 'https://api.medium.com/v1/'
      if opts.key? :integration_token
        @connection = MediumSdk::Connection::IntegrationToken.new opts
      elsif opts.key? :client_id
        @connection = MediumSdk::Connection::AuthCode.new opts
      end
    end

    def get_url(url)
      return @connection.http.get do |req|
        req.url url
      end
    end

    def body_key(res, key)
      return res.body.key?(key) ? res.body[key] : nil
    end

    def me()
      return body_key get_url('me'), 'data'
    end

    def user_publications(user_id)
      res = get_url File.join 'users', user_id, 'publications'
      return body_key(res, 'data')
    end

    def publication_post(publication_id, post)
      res = @connection.http.post do |req|
        req.url File.join 'publications', publication_id, 'posts'
        req.body = post
      end
    end

    def publication_contributors(publication_id)
      res = get_url File.join 'publications', publication_id, 'contributors'
      return body_key(res, 'data')
    end

  end
end
