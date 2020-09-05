$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "guider_cms/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "guider_cms"
  spec.version     = GuiderCms::VERSION
  spec.authors     = ["Minat Silvester"]
  spec.email       = ["minatsilvester@gmail.com"]
  spec.homepage    = "https://github.com/lakesidelab/guider_cms"
  spec.summary     = "A simple cms for rails application."
  spec.description = "A cms system to create basic pages such as about us, privacy policies, user guides and blogs"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 5.0"

  spec.add_dependency "bootstrap"

  spec.add_dependency "closure_tree"

  spec.add_dependency "friendly_id"

  spec.add_dependency "jquery-rails"

  spec.add_dependency "acts_as_list"

  spec.add_dependency "kaminari"

  spec.add_development_dependency "pg"

end
