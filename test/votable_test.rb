require 'test_helper'
require 'awesome_print'

class VotableTest < ActiveSupport::TestCase
  def setup
    @post1 = Post.create name: 'post1'
    @post2 = Post.create name: 'post2'
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

    assert_equal 12, @post2.votes.where(vote_scope: 'range').sum(:vote_weight)
    assert_equal 12, @post2.down_votes.where(vote_scope: 'range').sum(:vote_weight)
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

  # down_votes and up_votes
  test "post2's down and up votes" do
    @post2.up_voted_by @user1
    @post2.down_voted_by @user2
    @post2.down_voted_by @user3
    assert_equal 3, @post2.votes.size
    assert_equal 2, @post2.down_votes.size
    assert_equal 2, @post2.negatives.size  # alias_method
    assert_equal 1, @post2.up_votes.size
    assert_equal 1, @post2.positives.size  # alias_method
  end

  # voted_by
  test 'post1 should voted_by user1 and user2' do
    @post1.voted_by voter: @user1, vote: 'up'
    @post1.voted_by voter: @user2, vote: 'down'
    assert_equal true, @post1.up_voted_by?(@user1)
    assert_equal true, @post1.down_voted_by?(@user2)
    assert_equal 1, ActsAsVotable::Vote.all.first.vote_weight
    assert_equal 'rank', ActsAsVotable::Vote.all.first.vote_scope
  end

  # voted_by vote raise
  test 'post1 voted_by user1 with hehe should raise NotAllowedVoteFlag' do
    assert_raise(ActsAsVotable::NotAllowedVoteFlag) {
      @post1.voted_by voter: @user1, vote: 'hehe'
    }
  end
end
