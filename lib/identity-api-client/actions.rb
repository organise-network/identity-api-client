module IdentityApiClient
  class Actions < Base
    def find_by(action_attributes)
      resp = client.get_request("/api/actions/find_by", query: action_attributes)
      if resp.status == 200
        return IdentityApiClient::Action.new(client: client, id: resp.body['id'])
      else
        false
      end
    end
  end
end
