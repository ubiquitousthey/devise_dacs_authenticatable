require 'devise/version'

# Devise 2.1 removes schema stuff
if Devise::VERSION < "2.1"
  require 'devise/schema'

  module Devise
    module Schema
      # Adds the required fields for dacs_authenticatable to the schema.  Currently
      # this is just username (String).
      def dacs_authenticatable
        if respond_to? :apply_devise_schema
          apply_devise_schema :dacs_username, String
        else
          apply_schema :dacs_username, String
        end
      end
    end
  end
end