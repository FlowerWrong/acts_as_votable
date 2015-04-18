##
# Author:: FuSheng Yang (mailto:sysuyangkang@gmail.com)
# Copyright:: Copyright (c) 2015 thecampus.cc
# License:: Distributes under the same terms as Ruby
# ActsAsVoter
module ActsAsVotable
  module Voter
    extend ActiveSupport::Concern

    included do
    end

    module ClassMethods
      def acts_as_voter
        class_eval do
          has_many :votes,
                   class_name: 'ActsAsVotable::Vote',
                   as: :voter,
                   dependent: :delete_all
        end
        include ActsAsVotable::Voter::LocalInstanceMethods
      end
    end

    module LocalInstanceMethods
      def down_voted(votable, options = {})
        params = set_vote_option_params(options).merge(set_vote_basic_params(votable, false))
        ActsAsVotable::Vote.create(params) unless ActsAsVotable::Vote.exists?(params)
      end

      def down_voted?(votable)
        params = set_vote_basic_params votable, false
        ActsAsVotable::Vote.exists? params
      end

      def up_voted(votable, options = {})
        params = set_vote_option_params(options).merge(set_vote_basic_params(votable, true))
        ActsAsVotable::Vote.create(params) unless ActsAsVotable::Vote.exists?(params)
      end

      def up_voted?(votable)
        params = set_vote_basic_params votable, true
        ActsAsVotable::Vote.exists? params
      end

      alias_method :voted_up_on?, :up_voted?
      alias_method :voted_down_on?, :down_voted?

      def voted?(votable)
        down_voted?(votable) || up_voted?(votable)
      end

      private

      def set_vote_option_params(options = {})
        {
          vote_scope: options[:vote_scope] || 'rank',
          vote_weight: options[:vote_weight] || 1
        }
      end

      def set_vote_basic_params(votable, flag)
        {
          voter_id: self.id,
          voter_type: self.class.name,
          votable_id: votable.id,
          votable_type: votable.class.name,
          vote_flag: flag
        }
      end
    end
  end
end

ActiveRecord::Base.send :include, ActsAsVotable::Voter
