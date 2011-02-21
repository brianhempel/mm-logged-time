# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mm_logged_time/version"

Gem::Specification.new do |s|
  s.name        = "mm-logged-time"
  s.version     = MmLoggedTime::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brian Hempel"]
  s.email       = ["wezzex@parrett.net"]
  s.homepage    = "http://github.com/brianhempel/mm-logged-time"
  s.summary     = "Logging of query time and load time for MongoMapper"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency 'mongo_mapper', '>=0.8.6'
  s.add_dependency 'i18n' # active_support complains without this
  
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'jnunemaker-matchy', '~> 0.4.0'
  s.add_development_dependency 'shoulda'
end
