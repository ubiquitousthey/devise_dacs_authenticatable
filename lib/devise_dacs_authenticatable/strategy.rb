require 'devise/strategies/base'
require 'net/http'
require 'date'

module Devise
  module Strategies
    class DacsAuthenticatable < Base
      SUB_DOMAINLABEL = "(?:[#{URI::REGEXP::PATTERN::ALNUM}](?:[-_#{URI::REGEXP::PATTERN::ALNUM}]*[#{URI::REGEXP::PATTERN::ALNUM}])?)"

      # True if the mapping supports authenticate_with_dacs.
      def valid?
        mapping.to.respond_to?(:authenticate_with_dacs) && cookies.any? do |k,v| 
          k.start_with?("DACS") && 
          (!Devise.dacs_jurisdiction ||
            k.split(":")[3] == Devise.dacs_jurisdiction)
        end
      end
      
      # Try to authenticate a user using the DACS cookie 
      # If the ticket is valid and the model's authenticate_with_dacs method
      # returns a user, then return success.  If the ticket is invalid, then either
      # fail (if we're just returning from the DACS server, based on the referrer)
      # or attempt to redirect to the DACS server's login URL.
      def authenticate!
        cred = fetch_credentials()
        if cred 
          Rails.logger.debug("Failing in cred=true")
          if resource = mapping.to.authenticate_with_dacs(cred)
            success!(resource)
          else
            fail!(:invalid)
          end
        else
          Rails.logger.debug("Failing in cred=false")
          fail!(:invalid)
        end
      end
      
      protected

      def convert_time(time_attr)
        if time_attr
          time_attr_parts = time_attr.split(" ")
          return DateTime.strptime(time_attr_parts[0], '%s')
        end
        return nil
      end
      
      def fetch_credentials()
        cookie = cookies.find{|k,v| k.start_with?("DACS") && k.split(":")[3] == Devise.dacs_jurisdiction}
        return nil unless cookie 
        
        p = URI::Parser.new(:HOSTNAME=>"(?:#{SUB_DOMAINLABEL}\\.)#{URI::REGEXP::PATTERN::DOMLABEL}\\.#{URI::REGEXP::PATTERN::TOPLABEL}\\.?")
        uri = p.parse("#{Devise.dacs_base_url}/dacs_current_credentials")
        uri.query = URI.encode_www_form({:FORMAT => 'JSON', :DETAIL => 'yes'})
        cookie_header = "#{cookie[0]}=#{cookie[1]}; path=/; domain=#{uri.host[uri.host.index('.')..-1]}"
        http = Net::HTTP.new(uri.host, uri.port)
        response = http.get(uri.request_uri, {"Cookie" => "#{cookie_header}"})
        Rails.logger.debug(response.code)
        return nil unless response.code = 200

        Rails.logger.debug(response.body)
        credentials = JSON.parse(response.body)
        Rails.logger.debug(credentials.to_s)
        return credentials
      end
    end
  end
end

Warden::Strategies.add(:dacs_authenticatable, Devise::Strategies::DacsAuthenticatable)
