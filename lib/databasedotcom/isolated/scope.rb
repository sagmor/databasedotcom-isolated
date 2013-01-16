module Databasedotcom
  module Isolated
    # Shared functionatily of an isolated scope
    class Scope
      CLIENT_OPTIONS = [:client_id,:client_secret]
      AUTHENTICATION_OPTIONS = [:username, :password, :token]


      class << self
        attr_accessor :options, :client

        def new(options = {})
          Class.new(self).tap do |scope|
            scope.options = options
            scope.client = options[:client]
          end
        end

        def client
          @client ||= Databasedotcom::Client.new(self.options.slice(*CLIENT_OPTIONS)).tap do |client|
            client.sobject_module = scope
            self.options.slice(*AUTHENTICATION_OPTIONS).tap do |auth_options|
              client.authenticate(auth_options) unless auth_options.empty?
            end
          end
        end

        def perform(&block)
          (self.class_eval(block.to_source)).call
          self
        end

        # Search for missing constants on the current list of sobjects if available
        def const_missing(sym)
          if self.list_sobjects.include?(sym.to_s)
            self.client.materialize(sym.to_s)
          else
            super
          end
        end

        def list_sobjects
          @list_sobjects ||= self.client.list_sobjects
        end
      end
    end
  end
end
