# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{devise_dacs_authenticatable}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Heath Robinson"]
  s.description = %q{DACS authentication module for Devise}
  s.license = "MIT"
  s.email = %q{heath@midnighthour.org}
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.extra_rdoc_files = [
    "README.md"
  ]
  
  s.homepage = %q{http://github.com/nbudin/devise_dacs_authenticatable}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.0}
  s.summary = %q{DACS authentication module for Devise}

  s.add_runtime_dependency(%q<devise>, [">= 1.2.0"])
  s.add_runtime_dependency(%q<rest-client>, [">= 1.6.7"])
    
  s.add_development_dependency("rails", ">= 3.0.7")
  s.add_development_dependency("rspec-rails")
  s.add_development_dependency("sqlite3")
  # s.add_development_dependency("mocha")
  # s.add_development_dependency("shoulda", "~> 3.4.0")
  # s.add_development_dependency("sham_rack")
  # s.add_development_dependency("capybara", "~> 1.1.4")
  # s.add_development_dependency('crypt-isaac')
  # s.add_development_dependency('launchy')
  # s.add_development_dependency('timecop')
  # s.add_development_dependency('pry')
end

