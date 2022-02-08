module IdentityApiClient
  class Actions < Base
    def hot_actions
      resp = client.get_request("/api/actions/hot_actions?api_token=#{client.connection.configuration.options[:api_token]}")
      if resp.status == 200
        return resp.body
      else
        false
      end
    end

    def find_by(action_attributes)
      resp = client.get_request("/api/actions/find_by?api_token=#{client.connection.configuration.options[:api_token]}", query: action_attributes)
      if resp.status == 200
        return IdentityApiClient::Action.new(client: client, id: resp.body['id'], attributes: resp.body)
      else
        false
      end
    end

    def search(query)
      resp = client.get_request("/api/actions/search?&api_token=#{client.connection.configuration.options[:api_token]}", query: query)
      if resp.status == 200
        return resp.body.map { |a| IdentityApiClient::Action.new(client: client, id: a['id'], attributes: a) }
      else
        false
      end
    end
  end
end