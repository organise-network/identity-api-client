module IdentityApiClient
	class MailingApiBase < Base
		def route_url(url)
			path = client.connection.configuration.options[:mailing_api_path] || '/mailings'
			"#{path}#{url}"
		end
	end
end
