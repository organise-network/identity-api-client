module IdentityApiClient
  class Member < Base
    # Return a hash of member data if the API call succeeded (which will be an
    # empty hash if the member was not found in Identity), or false if the API
    # call failed
    def details(guid: nil, email: nil, load_current_consents: false, load_employment: false)
      if guid.present?
        params = {'guid' => guid, 'api_token' => client.connection.configuration.options[:api_token]}
      elsif email.present?
        params = {'email' => email, 'api_token' => client.connection.configuration.options[:api_token]}
      else
        raise "Must have one of guid or email"
      end

      if load_current_consents
        params['load_current_consents'] = true
      end

      if load_employment
        params['load_employment'] = true
      end

      resp = client.post_request('/api/member/details', params)
      if resp.status == 200
        return resp.body
      else
        return false
      end
    end

    # Return true if the API call succeeded, false otherwise
    def create_trace(email:, kind:, details:, happened_at:)
      payload = {
        email: email,
        kind: kind,
        details: details,
        happened_at: happened_at,
        api_token: client.connection.configuration.options[:api_token]
      }

      resp = client.post_request('/api/member_traces', payload)
      if resp.status == 200
        return true
      else
        return false
      end
    end

    # Return a hash of member data if the API call succeeded, false otherwise
    def upsert_member(attributes)
      attributes['api_token'] = client.connection.configuration.options[:api_token]
      resp = client.put_request("/api/member/upsert", attributes)
      if resp.status == 200
        return resp.body
      else
        return false
      end
    end

    # Return Identity member_guid if the API call succeeded and the provided
    # login token was valid; false otherwise
    def validate_login_token(login_token, user_ip = nil)
      payload = {
        login_token: login_token,
        user_ip: user_ip,
        api_token: client.connection.configuration.options[:api_token]
      }
      resp = client.post_request("/api/member_login/verify_login_token", payload)
      if resp.status == 200
        return resp.body
      else
        return false
      end
    end
  end
end
