require 'devise'

require 'devise_dacs_authenticatable/schema'
require 'devise_dacs_authenticatable/routes'
require 'devise_dacs_authenticatable/strategy'
require 'devise_dacs_authenticatable/exceptions'

module Devise
  # The base URL of the DACS server.  For example, http://dacs.example.com.  Specifying this
  # is mandatory.
  @@dacs_base_url = nil
  
  # Should devise_dacs_authenticatable attempt to create new user records for
  # unknown usernames?  True by default.
  @@dacs_create_user = true
  
  # The model attribute used for query conditions. :username by default
  @@dacs_username_column = :dacs_username

  @@dacs_jurisdiction = nil

  mattr_accessor :dacs_base_url, :dacs_jurisdiction, :dacs_create_user, :dacs_username_column

  def self.dacs_create_user?
    dacs_create_user
  end

  def self.dacs_service_url(base_url, mapping)
    dacs_action_url(base_url, mapping, "service")
  end
end
  
Devise.add_module(:dacs_authenticatable,
  :strategy => true,
  :model => 'devise_dacs_authenticatable/model')
