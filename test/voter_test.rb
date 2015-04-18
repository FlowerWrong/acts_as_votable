require 'test_helper'
require 'awesome_print'

class VoterTest < ActiveSupport::TestCase
  def setup
    @post1 = Post.create name: 'post1'
    @post2 = Post.create name: 'post2'
    @post3 = Post.create name: 'post3'
    @user1 = User.create name: 'user1'
    @user2 = User.create name: 'user2'
    @user3 = User.create name: 'user3'
  end

  def teardown
    @post1 = nil
    @post2 = nil
    @user1 = nil
    @user2 = nil
  end

  test 'post1 should be down and up voted by user1 and user2' do
    @user1.down_voted @post1
    @user2.up_voted @post1
    assert_equal true, @user1.down_voted?(@post1)
    assert_equal true, @user2.up_voted?(@post1)
    assert_equal 1, ActsAsVotable::Vote.all.first.vote_weight
    assert_equal 'rank', ActsAsVotable::Vote.all.first.vote_scope
  end

  test 'post2 should be down voted by user1 and user2 with scope and weight' do
    @user1.down_voted @post2, vote_scope: 'range', vote_weight: 6
    @user2.up_voted @post2, vote_scope: 'range', vote_weight: 6
    assert_equal true, @user1.down_voted?(@post2)
    assert_equal true, @user2.up_voted?(@post2)
    assert_equal true, @user1.voted_down_on?(@post2)
    assert_equal true, @user2.voted_up_on?(@post2)

    assert_equal 6, ActsAsVotable::Vote.all.first.vote_weight
    assert_equal 'range', ActsAsVotable::Vote.all.first.vote_scope
  end

  # voted?
  test 'user1 voted? post1 and user2 not voted? post1' do
    @user1.down_voted @post1
    assert_equal true, @user1.voted?(@post1)
    assert_equal false, @user2.voted?(@post1)
  end

  # voted_items
  test 'voted_items = up_voted_items + down_voted_items' do
    @user1.down_voted @post1
    @user1.down_voted @post2
    @user1.up_voted @post3
    @user2.up_voted @post1
    @user3.up_voted @post1
    assert_equal true, @user1.down_voted?(@post1)
    assert_equal true, @user2.up_voted?(@post1)
    assert_equal true, @user3.up_voted?(@post1)
    assert_equal 3, @user1.voted_items.size
    assert_equal (@user1.up_voted_items.size + @user1.down_voted_items.size), @user1.voted_items.size
  end
end
