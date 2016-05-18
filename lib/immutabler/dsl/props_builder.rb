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
        prop_options[:is_ref] = options[:is_ref] if options.key?(:is_ref)
        prop_options[:ref_type] = options[:ref_type] if options.key?(:ref_type)
        prop_options[:name_prefix] = options[:name_prefix] if options.key?(:name_prefix)
        prop_options[:is_id] = options[:is_id] if options.key?(:is_id)
        @props << Prop.new(name.to_s, type.to_s, prop_options)
      end
    end
  end
end
