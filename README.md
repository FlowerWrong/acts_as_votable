= ActsAsVotable

This project rocks and uses MIT-LICENSE.

Thx [ryanto](https://github.com/ryanto/acts_as_votable)

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
```

##### Methods

```ruby
class Post < ActiveRecord::Base
  acts_as_votable
end

class User < ActiveRecord::Base
  acts_as_voter
end


@post.downvoted_by @user2
@post.upvoted_by @user3
@post.downvoted_by? @user2
@post.upvoted_by? @user3

@post.votes.size  # => 5 总投票数(包含up, down)
@post.upvotes.size  # => 3
@post.downvotes.size  # => 2

@user.up_votes @post2
@user.down_votes @post2
@user.voted_up_on? @post1  # => true
@user.voted_down_on? @post1  # => false
@user.voted? @post1  # 是否对 @post1 进行了投票

@user.voted_items  # 总投票项目(包含up, down)
@user.up_voted_items
@user.down_voted_items

@hat.vote_registered?  # => true

@hat.positives.size  # => 积极(包含up)
@hat.negatives.size  # => 消极(包含down)

# 不能重复投票
@user.up_votes @post2
@user.up_votes @post2
@shoe.votes.size  # => 1
@shoe.upvotes.size  # => 1
```
