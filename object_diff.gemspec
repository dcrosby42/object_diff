# -*- encoding: utf-8 -*-
require File.expand_path('../lib/object_diff/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["David Crosby"]
  gem.email         = ["crosby@atomicobject.com"]
  gem.name          = "object_diff"
  gem.description   = %q{Diff Ruby values by recursively collecting differences between Hashes, Arrays and scalar values.}
  gem.summary       = %q{Diff Ruby values by recursively collecting differences between Hashes, Arrays and scalar values.}
  gem.homepage      = "https://github.com/dcrosby42/object_diff"

  gem.executables   = [] #`git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n") - [".gitignore", ".rspec", ".rvmrc", ".ruby-version", "NOTES.txt", "TODO"]
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]
  gem.version       = ObjectDiff::VERSION

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "pry"
end
