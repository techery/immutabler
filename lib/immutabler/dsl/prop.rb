module Immutabler
  module DSL
    class Prop
      attr_accessor :name, :type, :options

      def initialize(name, type, options)
        @name = name
        @type = type
        @options = options
      end
    end
  end
end
