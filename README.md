= ActsAsVotable

This project rocks and uses MIT-LICENSE.

Thx [ryanto](https://github.com/ryanto/acts_as_votable)

#### Install

```ruby
gem 'acts_as_votable', github: 'FlowerWrong/acts_as_votable', branch: 'master'
bundle install
rails generate acts_as_votable:migration
rake db:migrate
```

## How to write a rails acts_as_xxx plugin

##### [Create a plugin with rails cmd](http://guides.rubyonrails.org/plugins.html)

```ruby
rails plugin new acts_as_votable
cd acts_as_votable

# edit gemspec
# push to github

# Test it
rake -T
rake test

# Add migration generator and model
# plan your methods

cd test/dummy
rails generate acts_as_votable:migration
rails g model Post name
rails g model User name


```

##### Methods

```ruby
class Post < ActiveRecord::Base
  acts_as_votable
end

class User < ActiveRecord::Base
  acts_as_voter
end


@post.down_voted_by @user2
@post.down_voted_by? @user2
@post.up_voted_by @user3
@post.up_voted_by? @user3

@post.votes.size  # => 5 总投票数(包含up, down)
@post.up_votes.size  # => 3
@post.down_votes.size  # => 2

@user.up_voted @post2
@user.up_voted? @post2
@user.down_voted @post2  # => true
@user.down_voted? @post2  # => true
@user.voted_up_on? @post1  # => true
@user.voted_down_on? @post1  # => false
@user.voted? @post1  # 是否对 @post1 进行了投票

@user.voted_items  # 总投票项目(包含up, down)
@user.up_voted_items
@user.down_voted_items

@post.positives.size  # => 积极(包含up)
@post.negatives.size  # => 消极(包含down)

# 不能重复投票
@user.up_votes @post2
@user.up_votes @post2
@post.votes.size  # => 1
@post.upvotes.size  # => 1

# Adding weights to your votes, The default value is 1.
@post.voted_by :voter => @user5, :vote => 'up', :vote_scope => 'rank', :vote_weight => 3
@post.down_voted_by @user2, :vote_scope => 'rank', :vote_weight => 1
@post.up_voted_by @user2, :vote_scope => 'rank', :vote_weight => 1

# tally them up!
@post.votes(:vote_scope => 'rank').sum(:vote_weight)  # => 10
@post.up_votes(:vote_scope => 'rank').sum(:vote_weight)  # => 6
@post.down_votes(:vote_scope => 'rank').sum(:vote_weight)  # => 4
```
