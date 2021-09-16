module IdentityApiClient
  class Industries < Base
    def list
      resp = client.get_request(route_url("/api/industries?api_token=#{client.connection.configuration.options[:api_token]}"))
      if resp.status == 200
        return resp.body
      else
        return false
      end
    end

    def approved
      resp = client.get_request(route_url("/api/industries/approved?api_token=#{client.connection.configuration.options[:api_token]}"))
      if resp.status == 200
        return resp.body
      else
        return false
      end
    end

    def create(industry)
      params = {
        'api_token' => client.connection.configuration.options[:api_token],
        'industry' => industry
      }
      resp = client.post_request(route_url('/api/industries'), params)
      if resp.status < 400
        return resp.body
      else
        return resp.body['errors']
      end
    end
  end
end
