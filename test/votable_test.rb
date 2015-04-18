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
    assert_equal 1, ActsAsVotable::Vote.all.first.vote_weight
    assert_equal 'rank', ActsAsVotable::Vote.all.first.vote_scope
  end

  test 'post2 should be down voted by user1 and user2 with scope and weight' do
    @post2.down_voted_by @user1, vote_scope: 'range', vote_weight: 6
    @post2.down_voted_by @user2, vote_scope: 'range', vote_weight: 6

    assert_equal true, @post2.down_voted_by?(@user1)
    assert_equal true, @post2.down_voted_by?(@user2)

    assert_equal 6, ActsAsVotable::Vote.all.first.vote_weight
    assert_equal 'range', ActsAsVotable::Vote.all.first.vote_scope
  end

  test 'post1 should be up voted by user1 and user2' do
    @post1.up_voted_by @user1
    @post1.up_voted_by @user2
    assert_equal true, @post1.up_voted_by?(@user1)
    assert_equal true, @post1.up_voted_by?(@user2)
    assert_equal 1, ActsAsVotable::Vote.all.first.vote_weight
    assert_equal 'rank', ActsAsVotable::Vote.all.first.vote_scope
  end

  test 'post2 should be up voted by user1 and user2 with scope and weight' do
    @post2.up_voted_by @user1, vote_scope: 'range', vote_weight: 6
    @post2.up_voted_by @user2, vote_scope: 'range', vote_weight: 6

    assert_equal true, @post2.up_voted_by?(@user1)
    assert_equal true, @post2.up_voted_by?(@user2)

    assert_equal 6, ActsAsVotable::Vote.all.first.vote_weight
    assert_equal 'range', ActsAsVotable::Vote.all.first.vote_scope
  end

  # votes.size
  test "post1's votes" do
    @post1.up_voted_by @user1
    @post1.down_voted_by @user2
    assert_equal 2, @post1.votes.size
  end
end
