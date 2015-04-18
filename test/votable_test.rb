require 'test_helper'
require 'awesome_print'

class VotableTest < ActiveSupport::TestCase
  def setup
    @post1 = Post.create name: 'post1'
    @post2 = Post.create name: 'post2'
    @user1 = User.create name: 'user1'
    @user2 = User.create name: 'user2'
  end

  def teardown
    @post1 = nil
    @post2 = nil
    @user1 = nil
    @user2 = nil
  end

  test 'post1 should be down voted by user1 and user2' do
    @post1.down_voted_by @user1
    @post1.down_voted_by @user2
    assert_equal true, @post1.down_voted_by?(@user1)
    assert_equal true, @post1.down_voted_by?(@user2)
  end
end
