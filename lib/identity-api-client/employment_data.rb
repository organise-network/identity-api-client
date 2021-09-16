module IdentityApiClient
  class EmploymentData < Base
    def list
      resp = client.get_request(route_url("/api/employment?api_token=#{client.connection.configuration.options[:api_token]}"))
      if resp.status == 200
        return EmploymentDataResult.new(resp.body)
      else
        return false
      end
    end
  end

  class EmploymentDataResult
    attr_reader :employment_statuses, :approved_workplaces, :approved_industries, :approved_professions

    def initialize(body)
      @employment_statuses = body.employment_statuses.map.with_index do |employment_status, i|
        {
          slug: employment_status,
          label: body.employment_status_labels[i]
        }
      end

      @approved_workplaces = body.workplaces
      @approved_industries = body.industries
      @approved_professions = body.professions
    end
  end
end
