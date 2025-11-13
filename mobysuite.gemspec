# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mobysuite/version"

Gem::Specification.new do |spec|
  spec.name          = "mobysuite"
  spec.version       = Mobysuite::VERSION
  spec.authors       = ["Matias"]
  spec.email         = ["mmenares@mobysuite.com"]

  spec.summary       = "Summary of Mobysuite."
  spec.description   = "Gem to connect with mobysuite API"
  spec.homepage      = "https://mobysuite.com"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this sectfion to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end
  spec.add_dependency 'httparty'

  # spec.files         = `git ls-files -z`.split("\x0").reject do |f|
  #   f.match(%r{^(test|spec|features)/})
  # end
  spec.files = Dir["lib/**/*.rb", "exe/*", ".env"]

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "dotenv", "~> 2.8.1"
end
