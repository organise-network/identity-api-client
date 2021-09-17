module IdentityApiClient
  class Workplaces < Base
    def list
      resp = client.get_request("/api/workplaces?api_token=#{client.connection.configuration.options[:api_token]}")
      if resp.status == 200
        return resp.body
      else
        return false
      end
    end

    def approved
      resp = client.get_request("/api/workplaces/approved?api_token=#{client.connection.configuration.options[:api_token]}")
      if resp.status == 200
        return resp.body
      else
        return false
      end
    end

    def create(workplace)
      params = {
        'api_token' => client.connection.configuration.options[:api_token],
        'workplace' => workplace
      }
      resp = client.post_request('/api/workplaces', params)
      if resp.status == 200
        return resp.body
      else
        return resp.body['errors']
      end
    end
  end
end
