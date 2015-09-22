require_relative 'enum'
require_relative 'model'
require_relative 'model_attributes_builder'
require_relative 'enum_attributes_builder'

module Immutabler
  module DSL
    class Group
      attr_accessor :name, :models, :enums, :prefix, :links, :output_directory

      def initialize(name)
        @prefix = ''
        @base_model = 'NSObject'
        @name = name
        @models = []
        @enums = []
        @links = []
      end

      def prefix(prefix)
        self.prefix = prefix
      end

      def link_to(model_group_name)
        links << model_group_name
      end

      def output_dir(dir)
        self.output_directory = dir
      end

      def base_model(name)
        @base_model = name
      end

      def enum(name, &block)
        attributes = []
        prefix = "#{@prefix}#{name}"
        EnumAttributesBuilder.new(attributes, prefix, &block)
        @enums << Enum.new(prefix, attributes)
      end

      def model(name, options = {}, &block)
        prefix = @prefix + name.to_s
        base = options.fetch(:base, @base_model).to_s
        props = []
        mappings = []
        ModelAttributesBuilder.new(props, mappings, &block)

        model = Model.new(prefix, base, props, mappings)

        models << model
      end

      def build
        {
          name: name,
          models: models,
          links: links,
          enums: enums
        }
      end
    end
  end
end
