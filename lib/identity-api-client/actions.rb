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
      resp = client.get_request("/api/actions/find_by", action: action_attributes)
      if resp.status == 200
        return IdentityApiClient::Mailing.new(client: client, id: resp.body['id'])
      else
        false
      end
    end
  end
end