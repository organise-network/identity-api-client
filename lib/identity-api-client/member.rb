module IdentityApiClient
  class Member < Base
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
      resp.body
    end

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

    def upsert_member(attributes)
      attributes['api_token'] = client.connection.configuration.options[:api_token]
      resp = client.put_request("/api/member/upsert", attributes)
      if resp.status == 200
        return resp.body
      else
        return false
      end
    end
  end
end
