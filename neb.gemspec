
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "neb/version"

Gem::Specification.new do |spec|
  spec.name          = "neb"
  spec.version       = Neb::VERSION
  spec.authors       = ["Spirit"]
  spec.email         = ["neverlandxy.naix@gmail.com"]

  spec.summary       = %q{the Nebulas compatible Ruby API}
  spec.description   = %q{the Nebulas compatible Ruby API}
  spec.homepage      = "https://github.com/NaixSpirit/neb.rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-minitest", "~> 2.4"

  spec.add_dependency "rest-client", "~> 2.0"
  spec.add_dependency "activesupport", "~> 5"
  spec.add_dependency "bitcoin-secp256k1", "~> 0.4"
  spec.add_dependency "ffi", "~> 1.9"
  spec.add_dependency "sha3", "~> 1.0"
  spec.add_dependency "base58", "~> 0.2"
  spec.add_dependency "scrypt", "~> 3.0"
  spec.add_dependency "google-protobuf", "~> 3.5"
end
