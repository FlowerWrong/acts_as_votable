$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_votable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_votable"
  s.version     = ActsAsVotable::VERSION
  s.authors     = ["flowerwrong"]
  s.email       = ["sysuyangkang@gmail.com"]
  s.homepage    = "https://github.com/FlowerWrong"
  s.summary     = "Votable ActiveRecord for Rails 4+."
  s.description = "Allow any model to be voted on, like/dislike, upvote/downvote, etc."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 4.2.1'

  s.add_development_dependency 'sqlite3'
end
