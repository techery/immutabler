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
          }
        end

        links = defs[:links]
        module_links = defs[:module_links]
        enums = defs[:enums]

        FileUtils.mkdir_p(group.output_directory)

        build_head(group_name, models, links, module_links, enums)
        build_body(group_name, models)
      end

      private

      def build_props(props)
        props.map do |prop|
          Immutabler::TypeMapper.map(prop.type, prop.options).merge(name: prop.name)
        end
      end

      def build_body(group_name, models)
        body_template = Immutabler::Template::BodyTemplate.new(group_name, models)
        body_content = body_template.render
        body_path = "#{group.output_directory}/#{group_name}.m"
        File.write(body_path, body_content)
      end

      def build_head(group_name, models, links, module_links, enums)
        header_template = Immutabler::Template::HeaderTemplate.new(models, links, module_links, enums)
        header_content = header_template.render
        header_path = "#{group.output_directory}/#{group_name}.h"
        File.write(header_path, header_content)
      end
    end
  end
end
