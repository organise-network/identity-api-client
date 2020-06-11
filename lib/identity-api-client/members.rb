module IdentityApiClient
  class Members < Base
    def upsert(payload)
      params = payload.merge('api_token' => client.connection.configuration.options[:api_token])

      resp = client.put_request('/api/member/upsert', params)
      if resp.status < 400
        return IdentityApiClient::Member.new(client: client, id: resp.body['id'])
      else
        return resp.body['errors']
      end
    end
  end
end
