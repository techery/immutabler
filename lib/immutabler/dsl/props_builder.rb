require_relative 'prop'

module Immutabler
  module DSL
    class PropsBuilder
      def initialize(props, &block)
        @props = props
        instance_eval(&block)
      end

      def prop(name, type, options={})
        prop_options = {}
        prop_options[:is_ref] = !!options[:ref] if options.key?(:ref)
        prop_options[:ref_type] = options[:ref] if options.key?(:ref)
        prop_options[:name_prefix] = options[:prefix] if options.key?(:prefix)
        @props << Prop.new(name.to_s, type.to_s, prop_options)
      end
    end
  end
end
