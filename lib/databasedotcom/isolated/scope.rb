module Databasedotcom
  module Isolated
    # Shared functionatily of an isolated scope
    class Scope
      CLIENT_OPTIONS = [:client_id,:client_secret]
      AUTHENTICATION_OPTIONS = [:username, :password, :token]

      def Scope.new(options = {})
        Class.new(self).tap do |scope|
          scope.options = options
          scope.client = options[:client]
        end
      end

      class << self
        attr_accessor :options, :client, :binding

        def client
          @client ||= Databasedotcom::Client.new(self.options.slice(*CLIENT_OPTIONS)).tap do |client|
            client.sobject_module = self
            self.options.slice(*AUTHENTICATION_OPTIONS).tap do |auth_options|
              client.authenticate(auth_options) unless auth_options.empty?
            end
          end
        end

        def perform(&block)
          # self.new.instance_eval(&block)
          self.binding = block.binding
          (self.class_eval(block.to_source)).call
          self.binding = nil

          # self.class_eval( &eval(block.to_source) )

          self
        end

        # Force a class materialization
        def materialize(klass)
          self.const_set(klass, self.client.materialize(klass.to_s))
        end

        def method_missing(sym,*args)
          if args.empty?
            eval(sym.to_s,binding)
          else
            context = eval("self",binding)
            context.send(sym,*args)
          end
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
