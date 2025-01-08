module IdentityApiClient
  class Members < Base

    def get_by_id(id)
      return IdentityApiClient::Member.new(client: client, id: id.to_i)
    end

    def upsert(payload)
      params = payload.merge('api_token' => client.connection.configuration.options[:api_token])

      resp = client.put_request('/api/member/upsert', params)
      if resp.status < 400
        return IdentityApiClient::Member.new(client: client, id: resp.body['id'])
      else
        return resp.body['errors']
      end
    end

    def bulk_details(members)
      params = {'members' => members, 'api_token' => client.connection.configuration.options[:api_token]}
      resp = client.post_request('/api/member/bulk_details', params)
      resp.body
    end

    def bulk_upsert(members, callback_url = nil)
      params = {'members' => members, 'api_token' => client.connection.configuration.options[:api_token], 'callback_url' => callback_url }

      resp = client.put_request('/api/member/bulk_upsert', params)
      if resp.status < 400
        return resp.body['job_id']
      else
        return resp.body['errors']
      end
    end
  end
end
