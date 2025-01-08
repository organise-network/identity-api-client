# frozen_string_literal: true

module IdentityApiClient
  class Member < Base
    attr_accessor :id

    def attributes
      details
    end

    # Return a hash of member data if the API call succeeded (which will be an
    # empty hash if the member was not found in Identity), or false if the API
    # call failed
    def details(guid: nil, email: nil, country: false, load_current_consents: false, load_actions: false, load_employment: false)
      if guid.present?
        params = { 'guid' => guid, 'api_token' => client.connection.configuration.options[:api_token] }
      elsif email.present?
        params = {'email' => email, 'api_token' => client.connection.configuration.options[:api_token]}
      elsif id.present?
        params = {'id' => id, 'api_token' => client.connection.configuration.options[:api_token]}
      else
        raise 'Must have one of guid or email'
      end

      params['country'] = true if country
      params['load_current_consents'] = true if load_current_consents
      params['load_employment'] = true if load_employment
      params['load_actions'] = true if load_actions

      resp = client.post_request('/api/member/details', params)
      if resp.status == 200
        resp.body
      else
        false
      end
    end

    # Return true if the API call succeeded, false otherwise
    def create_trace(email:, kind:, happened_at:, details: '', ip_address: nil, address: nil)
      payload = {
        email: email,
        kind: kind,
        details: details,
        happened_at: happened_at,
        ip_address: ip_address,
        api_token: client.connection.configuration.options[:api_token],
        address: address
      }.compact

      resp = client.post_request('/api/member_traces', payload)
      resp.status == 200
    rescue Vertebrae::ResponseError => e
      false
    end

    # Return a hash of member data if the API call succeeded, false otherwise
    def upsert_member(attributes)
      attributes['api_token'] = client.connection.configuration.options[:api_token]
      resp = client.put_request('/api/member/upsert', attributes)
      if resp.status == 200
        resp.body
      else
        false
      end
    end

    # Return Identity member_guid if the API call succeeded and the provided
    # login token was valid; false otherwise
    #
    # Note that Identity returns the member_guid as a JSON object / hash, eg:
    # { member_guid: '1234567890' }
    def validate_login_token(login_token, user_ip = nil)
      payload = {
        login_token: login_token,
        user_ip: user_ip,
        api_token: client.connection.configuration.options[:api_token]
      }
      resp = client.post_request('/api/member_login/verify_login_token', payload)
      if resp.status == 200
        resp.body
      else
        false
      end
    end
  end
end
