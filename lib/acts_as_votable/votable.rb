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
        include ActsAsVotable::Votable::LocalInstanceMethods
      end
    end

    module LocalInstanceMethods
      def down_voted_by(voter, options = {})
        params = set_vote_params voter, false, options
        ActsAsVotable::Vote.create(params) unless ActsAsVotable::Vote.exists?(params)
      end

      def down_voted_by?(voter, options = {})
        params = set_vote_params voter, false, options
        ActsAsVotable::Vote.exists? params
      end

      private

      def set_vote_params(voter, flag, options = {})
        vote_scope = options[:vote_scope] || 'rank'
        vote_weight = options[:vote_weight] || 1
        {
          voter_id: voter.id,
          voter_type: voter.class.name,
          votable_id: self.id,
          votable_type: self.class.name,
          vote_flag: flag,
          vote_scope: vote_scope,
          vote_weight: vote_weight
        }
      end
    end
  end
end

ActiveRecord::Base.send :include, ActsAsVotable::Votable
