# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "librarian-chef-nochef"
  gem.version       = "0.1.0"
  gem.authors       = ["Emiliano Ticci", "Jay Feldblum"]
  gem.email         = ["emiticci@gmail.com", "y_feldblum@yahoo.com"]
  gem.summary       = %q{A Bundler for your Chef Cookbooks that does not depends on chef.}
  gem.description   = %q{A Bundler for your Chef Cookbooks that does not depends on chef.}
  gem.homepage      = "https://github.com/emyl/librarian-chef-nochef"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "librarian", "~> 0.1.0"
  gem.add_dependency "minitar", ">= 0.5.2"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "webmock"
end
