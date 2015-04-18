require 'awesome_print'
##
# Author:: FuSheng Yang (mailto:sysuyangkang@gmail.com)
# Copyright:: Copyright (c) 2015 thecampus.cc
# License:: Distributes under the same terms as Ruby
# ActsAsVotable
module ActsAsVotable
  module Votable
    extend ActiveSupport::Concern
    included do
    end

    module ClassMethods
      def acts_as_votable
        class_eval do
          has_many :votes,
                   class_name: 'ActsAsVotable::Vote',
                   as: :votable,
                   dependent: :delete_all
        end

        include ActsAsVotable::Votable::LocalInstanceMethods
      end
    end

    module LocalInstanceMethods
      def down_voted_by(voter, options = {})
        params = set_vote_option_params(options).merge(set_vote_basic_params(voter, false))
        ActsAsVotable::Vote.create(params) unless ActsAsVotable::Vote.exists?(params)
      end

      def down_voted_by?(voter)
        params = set_vote_basic_params voter, false
        ActsAsVotable::Vote.exists? params
      end

      def up_voted_by(voter, options = {})
        params = set_vote_option_params(options).merge(set_vote_basic_params(voter, true))
        ActsAsVotable::Vote.create(params) unless ActsAsVotable::Vote.exists?(params)
      end

      def up_voted_by?(voter)
        params = set_vote_basic_params voter, true
        ActsAsVotable::Vote.exists? params
      end

      def down_votes
        self.votes.where(vote_flag: false)
      end

      def up_votes
        self.votes.where(vote_flag: true)
      end

      alias_method :negatives, :down_votes
      alias_method :positives, :up_votes

      def voted_by(options = {})
        voter = options[:voter]
        vote = options[:vote]
        if vote == 'up'
          up_voted_by voter, options
        elsif vote == 'down'
          down_voted_by voter, options
        else
          raise ActsAsVotable::NotAllowedVoteFlag.new(vote)
        end
      end

      private

      def set_vote_option_params(options = {})
        {
          vote_scope: options[:vote_scope] || 'rank',
          vote_weight: options[:vote_weight] || 1
        }
      end

      def set_vote_basic_params(voter, flag)
        {
          voter_id: voter.id,
          voter_type: voter.class.name,
          votable_id: self.id,
          votable_type: self.class.name,
          vote_flag: flag
        }
      end
    end
  end
end

ActiveRecord::Base.send :include, ActsAsVotable::Votable
