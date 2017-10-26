require_relative 'enum'
require_relative 'model'
require_relative 'model_attributes_builder'
require_relative 'enum_attributes_builder'
require_relative 'module_import'

module Immutabler
  module DSL
    class Group
      attr_accessor :name, :models, :enums, :prefix, :links, :module_links, :output_directory

      def initialize(name)
        @prefix = ''
        @base_model = 'NSObject'
        @name = name
        @models = []
        @enums = []
        @links = []
        @module_links = []
      end

      def prefix(prefix)
        self.prefix = prefix
      end

      def link_to(model_group_name)
        links << model_group_name
      end

      def module_link_to(module_name, file_name)
        module_links << ModuleImport.new(module_name, file_name)
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
        base_immutable = options.fetch(:base_immutable, false)
        gen_equatable = options.fetch(:gen_equatable, true)
        gen_coding = options.fetch(:gen_coding, true)
        builder_base = options.fetch(:builder_base, 'NSObject').to_s
        props = []
        ModelAttributesBuilder.new(props, &block)

        model = Model.new(prefix, base, base_immutable, gen_equatable, gen_coding, builder_base, props)

        models << model
      end

      def build
        {
          name: name,
          models: models,
          links: links,
          module_links: module_links,
          enums: enums,
        }
      end
    end
  end
end
