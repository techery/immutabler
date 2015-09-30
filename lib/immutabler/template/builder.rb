require 'fileutils'

require_relative '../type_mapper'
require_relative 'header_template'
require_relative 'body_template'

module Immutabler
  module Template
    class Builder
      attr_accessor :group

      def initialize(group)
        @group = group
      end

      def build
        defs = group.build

        group_name = defs[:name]
        models = defs[:models].map do |model|
          {
            name: model.name,
            base_class: model.base,
            base_immutable: model.base_immutable,
            builder_base_class: model.builder_base,
            props: build_props(model.props),
            any_mappings: model.mappings.any?,
            array_mappings: model.mappings.select(&:array?),
            dict_mappings:  build_dict_mappings(model.mappings),
            custom_mappers: build_custom_mappers(model.mappings),
            mappings: build_mappings(model.mappings)
          }
        end

        links = defs[:links]
        enums = defs[:enums]

        FileUtils.mkdir_p(group.output_directory)

        build_head(group_name, models, links, enums)
        build_body(group_name, models)
      end

      private

      def build_props(props)
        props.map do |prop|
          Immutabler::TypeMapper.map(prop.type, prop.options).merge(name: prop.name)
        end
      end

      def build_dict_mappings(mappings)
        mappings.select(&:dict?).map do |mapping|
          attributes = mapping.dict_mappings.map do |dict_mapping|
            {
              origin_name:      dict_mapping[:origin_name],
              destination_name: dict_mapping[:destination_name]
            }
          end

          {
            name: mapping.destination_name,
            attributes: attributes
          }
        end
      end

      def build_mappings(mappings)
        mappings.map do |mapping|
          {
            origin_name: mapping.origin_name,
            destination_name: mapping.destination_name
          }
        end
      end

      def build_custom_mappers(mappings)
        mappings.select(&:custom?).map do |mapping|
          {
            origin_name: mapping.origin_name,
            transformer_name: mapping.custom_transformer
          }
        end
      end

      def build_body(group_name, models)
        body_template = Immutabler::Template::BodyTemplate.new(group_name, models)
        body_content = body_template.render
        body_path = "#{group.output_directory}/#{group_name}.m"
        File.write(body_path, body_content)
      end

      def build_head(group_name, models, links, enums)
        header_template = Immutabler::Template::HeaderTemplate.new(models, links, enums)
        header_content = header_template.render
        header_path = "#{group.output_directory}/#{group_name}.h"
        File.write(header_path, header_content)
      end
    end
  end
end
