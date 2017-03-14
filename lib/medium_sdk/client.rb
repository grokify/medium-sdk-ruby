module MediumSdk
  class Client
    attr_accessor :connection

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
      if res.status >= 400
        raise "HTTP Error #{res.status} " + res.pretty_inspect
      end
      return res.body.key?(key) ? res.body[key] : nil
    end

    def me(reload = nil)
      if @_me.nil? || reload
        @_me = body_key get_url('me'), 'data'
      end
      return @_me
    end

    def me_id
      me unless @_me
      unless @_me.is_a?(Hash) && @_me.key?('id') && @_me['id'].to_s.length>0
        raise 'Authorized User Id is unknown'
      end
      return @_me['id']
    end

    def user_publications(user_id = nil)
      user_id = me_id if user_id.nil?
      res = get_url File.join 'users', user_id.to_s, 'publications'
      return body_key(res, 'data')
    end

    def contributing_publications(user_id = nil)
      publications = []
      user_id = me_id if user_id.nil?
      all_publications = user_publications(user_id)
      all_publications_ids = all_publications.map { |x| x["id"] }
      all_publications_ids.each do |pub_id|
        publication_contributors(pub_id).each do |contributor|
          if contributor["userId"] == user_id && contributor["role"] == "editor"
            publications << all_publications.select {|pub| pub["id"] == contributor["publicationId"] }
          end
        end 
      end
      return publications.flatten
    end

    def post(post)
      url = ''
      if post.key? :publicationId
        publication_id = post[:publicationId].clone
        post.delete :publicationId
        url = File.join 'publications', publication_id, 'posts'
      else
        url = File.join 'users', me_id(), 'posts'
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
