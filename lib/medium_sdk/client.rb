module MediumSdk
  class Client
    attr_accessor :connection

    attr_reader :me

    def initialize(opts = {})
      if opts.key? :client_id
        @connection = MediumSdk::Connection::AuthCode.new opts
      elsif opts.key? :integration_token
        @connection = MediumSdk::Connection::IntegrationToken.new opts
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
      @me = body_key get_url('me'), 'data'
      return @me
    end

    def user_publications(user_id)
      res = get_url File.join 'users', user_id, 'publications'
      return body_key(res, 'data')
    end

    def post(post)
      url = ''
      if post.key? :publicationId
        publication_id = post[:publicationId].clone
        post.delete :publicationId
        url = File.join 'publications', publication_id, 'posts'
      else
        me unless @me
        unless @me.is_a?(Hash) && @me.key?('id') && @me['id'].to_s.length>0
          raise 'Authorized User Id is unknown'
        end
        id = @me['id']
        url = File.join 'users', id, 'posts'
      end
      res = @connection.http.post do |req|
        req.url url
        req.body = post
      end
      return body_key(res, 'data')
    end

    def publication_contributors(publication_id)
      res = get_url File.join 'publications', publication_id, 'contributors'
      return body_key(res, 'data')
    end

  end
end
