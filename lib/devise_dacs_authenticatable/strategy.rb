require 'devise/strategies/base'

module Devise
  module Strategies
    class DacsAuthenticatable < Base
      # True if the mapping supports authenticate_with_dacs.
      def valid?
        auth_with_dacs = mapping.to.respond_to?(:authenticate_with_dacs) && (!Devise.dacs_jurisdiction || request.env.fetch('DACS_JURISDICTION',nil) == Devise.dacs_jurisdiction) && request.env.fetch('DACS_USERNAME',Devise.test_user)
        Rails.logger.info "Try Dacs? #{auth_with_dacs}"
        Rails.logger.info "Try Dacs? #{Devise.dacs_jurisdiction}"
        Rails.logger.info "Try Dacs? #{Devise.test_user}"
        Rails.logger.info "Try Dacs? #{request.env.fetch('DACS_JURISDICTION',nil)}"
        Rails.logger.info "Try Dacs? #{request.env.fetch('DACS_USERNAME',Devise.test_user)}"
        return auth_with_dacs
      end
      
      # Use the DACS_USERNAME to identify the user
      def authenticate!
        cred = request.env.fetch('DACS_USERNAME',Devise.test_user) 
        if cred 
          if resource = mapping.to.authenticate_with_dacs(cred)
            Rails.logger.info "Login success"
            success!(resource)
          else
            fail!(:invalid)
          end
        else
          fail!(:invalid)
        end
      end
    end
  end
end

Warden::Strategies.add(:dacs_authenticatable, Devise::Strategies::DacsAuthenticatable)
