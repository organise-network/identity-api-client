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

    def upsert_network_action(attributes)
      attributes['api_token'] = client.connection.configuration.options[:api_token]
      resp = client.post_request("/api/actions/upsert_network_action", attributes)
      if resp.status == 200
        return true
      else
        return false
      end
    end

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

    # This shares some logic with find_by above, but returns in the same format as the
    # 'recent...' methods below.
    #
    def find_by_external_id(external_id:, external_system:)
      query_params = {
        external_id: external_id,
        external_system: external_system,
        api_token: api_token
      }
      resp = client.get_request("/api/actions/find_by_external_id", query_params)
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
