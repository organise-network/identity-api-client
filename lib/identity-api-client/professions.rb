module IdentityApiClient
  class Professions < Base
    def list
      resp = client.get_request("/api/professions?api_token=#{client.connection.configuration.options[:api_token]}")
      if resp.status == 200
        return resp.body
      else
        return false
      end
    end

    def create(profession)
      params = {
        'api_token' => client.connection.configuration.options[:api_token],
        'profession' => profession
      }
      resp = client.post_request('/api/professions', params)
      if resp.status < 400
        return resp.body
      else
        return resp.body['errors']
      end
    end
  end
end
