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
  end
end
