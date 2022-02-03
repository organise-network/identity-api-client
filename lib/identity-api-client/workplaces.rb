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

    def update_single_member(email:, created_at:, originator:, **employment_data)
      required_employment_data = %i{employment_status employer industry profession} # Must have at least one of these
      permitted_employment_data = required_employment_data.merge(%i{other_emp_status})

      raise(ArgumentError, 'email must be present & non-nil') unless email

      if required_employment_data.none? { |key| employment_data.key?(key) }
        raise(ArgumentError, 'at least one of employment_status, employer, industry or profession must be passed')
      end

      payload = employment_data.slice(*permitted_employment_data).transform_keys(&:to_s)
      payload.merge!({
        'email' => email,
        'created_at' => created_at,
        'originator' => originator,
        'api_token' => client.connection.configuration.options[:api_token]
      })

      resp = client.post_request('/api/workplaces/update_single_member', payload)

      if resp.status == 200
        return resp.body
      else
        return false
      end
    end
  end
end
