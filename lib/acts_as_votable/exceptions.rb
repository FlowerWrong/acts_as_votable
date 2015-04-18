##
# Author:: FuSheng Yang (mailto:sysuyangkang@gmail.com)
# Copyright:: Copyright (c) 2015 thecampus.cc
# License:: Distributes under the same terms as Ruby
# ActsAsVotable
module ActsAsVotable
  class NotAllowedVoteFlag < Exception
    def initialize(vote_flag)
      super "#{vote_flag} is not allowed, just up and down."
    end
  end
end
