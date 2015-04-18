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
    end
  end
end
