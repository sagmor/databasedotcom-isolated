module Databasedotcom
  module Isolated
    def self.perform(options,&block)
      Scope.new(options).perform(&block)
    end
  end
end
