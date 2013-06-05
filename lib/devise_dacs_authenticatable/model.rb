module Devise
  module Models
    # Extends your User class with support for DACS ticket authentication.
    module DacsAuthenticatable
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        # Authenticate a DACS credential set and return the resulting user object.  Behavior is as follows:
        # 
        # * Find a matching user by username (will use find_for_authentication if available).
        # * If the user does not exist, but Devise.dacs_create_user is set, attempt to create the
        #   user object in the database.  
        # * Return the resulting user object.
        def authenticate_with_dacs(credentials)
          if credentials.length > 0 
            resource = nil
            credentials.find do |cred|
              Rails.logger.debug(cred.to_s)
              Rails.logger.debug("DEBUG::Looking for #{::Devise.dacs_username_column} => #{cred['name']}")
              conditions = {::Devise.dacs_username_column => cred[:name]} 
              # We don't want to override Devise 1.1's find_for_authentication
              resource = if respond_to?(:find_for_authentication)
                find_for_authentication(conditions)
              else
                find(:first, :conditions => conditions)
              end
              
              resource = new(conditions) if (resource.nil? and should_create_dacs_users?)
              
              if resource
                resource.save
              end
            end
          end

          Rails.logger.debug("DEBUG::" + (resource ? resource.to_s : "Resource Nil"))
          return resource
        end

        private
        def should_create_dacs_users?
          respond_to?(:dacs_create_user?) ? dacs_create_user? : ::Devise.dacs_create_user?
        end
      end
    end
  end
end
