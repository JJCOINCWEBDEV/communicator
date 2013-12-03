$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "communicator/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "communicator"
  s.version     = Communicator::VERSION
  s.authors     = ["Carier"]
  s.email       = ["carierboy@gmail.com"]
  s.homepage    = ""
  s.summary     = "Communicator."
  s.description = "Description of Communicator."

  s.require_paths = ["lib"]
  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "redis", ">= 3.0.0"
  s.add_dependency "json"
end
