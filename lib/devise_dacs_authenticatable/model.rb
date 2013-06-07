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
          conditions = {::Devise.dacs_username_column => credentials} 
          resource = if respond_to?(:find_for_authentication)
            find_for_authentication(conditions)
          else
            find(:first, :conditions => conditions)
          end
          
          resource = new(conditions) if (resource.nil? and should_create_dacs_users?)
          
          if resource
            resource.save
          end

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
