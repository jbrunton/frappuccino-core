# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "frappuccino-core/version"

Gem::Specification.new do |s|
  s.name        = "frappuccino-core"
  s.version     = Frappuccino::Core::VERSION
  s.authors     = ["John Brunton"]
  s.email       = ["john_brunton@hotmail.co.uk"]
  s.homepage    = ""
  s.summary     = %q{framework core}
  s.description = %q{a structured MVC framework for CoffeeScript apps, heavily influenced by Rails & MS Prism}

  s.files         = Dir["{lib,vendor}/**/*"]
  s.require_paths = ["lib"]
  
  s.add_dependency "railties", "~> 3.1"
end
