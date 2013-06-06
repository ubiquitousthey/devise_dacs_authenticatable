devise_dacs_authenticatable
==========================

Written by Heath Robinson<br/>
Taking a lot of inspiration from [devise_cas_authenticatable](http://github.com/nbudin/devise_cas_authenticatable)

devise_dacs_authenticatable is [DACS](http://dacs.dss.ca/) single sign-on support for
[Devise](http://github.com/plataformatec/devise) applications.  It acts as a replacement for
database_authenticatable.  It uses an existing cookie from DACS for authentication.

Requirements
------------

- Rails 2.3 or greater (works with 3.x versions as well)
- Devise 1.0 or greater

Installation
------------

    gem install --pre devise_dacs_authenticatable
    
and in your config/environment.rb (on Rails 2.3):

    config.gem 'devise', :version => '~> 1.0.6'
    config.gem 'devise_dacs_authenticatable'

or Gemfile (Rails 3.x):

    gem 'devise'
    gem 'devise_dacs_authenticatable'

Setup
-----

Once devise\_dacs\_authenticatable is installed, add the following to your user model:

    devise :dacs_authenticatable
    
You can also add other modules such as token_authenticatable, trackable, etc.  Please do not
add database_authenticatable as this module is intended to replace it.

You'll also need to set up the database schema for this:

    create_table :users do |t|
      t.string :dacs_username, :null => false
    end

We also recommend putting a unique index on the `username` column:

    add_index :users, :dacs_username, :unique => true

Finally, you'll need to add some configuration to your config/initializers/devise.rb in order
to tell your app how to talk to your CAS server:

    Devise.setup do |config|
      ...
      config.dacs_base_url = "https://cas.myorganization.com/cgi-bin/dacs"
      
      # By default, devise_cas_authenticatable will create users.  If you would rather
      # require user records to already exist locally before they can authenticate via
      # CAS, uncomment the following line.
      # config.cas_create_user = false
    end


See also
--------

* [DACS](http://dacs.dss.ca/)
* [Devise](http://github.com/plataformatec/devise)
* [Warden](http://github.com/hassox/warden)

TODO
----

* Make it work
* Move session controller from app into plugin
* Move login flow changes from app into plugin
* Figure out how to mock DACS so it can be tested

License
-------

`devise_dacs_authenticatable` is released under the terms and conditions of the MIT license.  See the LICENSE file for more
information.
