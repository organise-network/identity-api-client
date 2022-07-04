module IdentityApiClient
  class Interests < Base
    def list
      resp = client.get_request("/api/interests?api_token=#{client.connection.configuration.options[:api_token]}")
      if resp.status == 200
        return resp.body
      else
        return false
      end
    end
  end
end
