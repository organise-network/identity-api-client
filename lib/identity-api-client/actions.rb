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

    def create_action(attributes)
      attributes['api_token'] = client.connection.configuration.options[:api_token]
      resp = client.post_request("/api/actions/create_without_member", attributes)
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

    # This shares some logic with find_by above, but returns in the same format as the
    # 'recent...' methods below.
    #
    def find_by_network_id(network_id)
      query_params = {network_id: network_id, api_token: api_token}
      resp = client.get_request("/api/actions/find_by_network_id", query_params)
      if resp.status == 200
        return resp.body
      else
        false
      end
    end

    # The following 'recent...' methods all use the same input params.
    #
    # If from_time is present, Identity will search for the relevant data starting at the
    # given timestamp. Identity will search up to the timestamp given in to_time (or up
    # to now, if to_time is not present).
    #
    # If from_time is not present, Identity will search for the relevant data starting
    # from the X hours ago, as given by the hours_ago param, and up to now.
    #
    # If neither from_time nor hours_ago are provided, Identity will default hours_ago
    # to 4 (ie. search from 4 hours ago up until now).

    def recently_updated(from_time: nil, to_time: nil, hours_ago: nil)
      query_params = recent_api_query_params(from_time, to_time, hours_ago)
      resp = client.get_request("/api/actions/recently_updated", query_params)
      if resp.status == 200
        return resp.body
      else
        false
      end
    end

    def recently_taken(from_time: nil, to_time: nil, hours_ago: nil)
      query_params = recent_api_query_params(from_time, to_time, hours_ago)
      resp = client.get_request("/api/actions/recently_taken", query_params)
      if resp.status == 200
        return resp.body
      else
        false
      end
    end

    def recent_sign_comments(from_time: nil, to_time: nil, hours_ago: nil)
      query_params = recent_api_query_params(from_time, to_time, hours_ago)
      resp = client.get_request("/api/actions/recent_sign_comments", query_params)
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

    def recent_api_query_params(from_time, to_time, hours_ago)
      {
        'api_token' => api_token,
        'from_time' => from_time,
        'to_time' => to_time,
        'hours_ago' => hours_ago
      }
    end
  end
end
