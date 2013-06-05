require 'spec_helper'

describe Devise do
  before do
    Devise.dacs_base_url = "http://www.example.com/dacs_server"
  end
  
