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
        include ActsAsVotable::Voter::LocalInstanceMethods
      end
    end

    module LocalInstanceMethods

    end
  end
end

ActiveRecord::Base.send :include, ActsAsVotable::Voter
