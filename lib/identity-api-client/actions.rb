module IdentityApiClient
  class Actions < Base
    def create_member_action(attributes)
      attributes['api_token'] = client.connection.configuration.options[:api_token]
      resp = client.post_request("/api/member_actions/create", attributes)
      if resp.status == 200
        return true
      else
        return false
      end
    end

    def create_network_action(attributes)
      attributes['api_token'] = client.connection.configuration.options[:api_token]
      resp = client.post_request("/api/actions/create_network_action", attributes)
      if resp.status == 200
        return true
      else
        return false
      end
    end

    def find_by(action_attributes)
      resp = client.get_request("/api/actions/find_by", query: action_attributes)
      if resp.status == 200
        return IdentityApiClient::Mailing.new(client: client, id: resp.body['id'])
      else
        false
      end
    end

    def recently_updated(hours_ago = 4)
      resp = client.get_request("/api/actions/recently_updated?api_token=#{api_token}&hours_ago=#{hours_ago}")
      if resp.status == 200
        return resp.body
      else
        false
      end
    end

    def recently_taken(hours_ago = 4)
      resp = client.get_request("/api/actions/recently_taken?api_token=#{api_token}&hours_ago=#{hours_ago}")
      if resp.status == 200
        return resp.body
      else
        false
      end
    end

    private

    def api_token
      client.connection.configuration.options[:api_token]
    end
  end
end
