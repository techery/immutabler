require_relative 'template'

module Immutabler
  module Template
    class HeaderTemplate < BaseTemplate
      attr_accessor :models, :links, :module_links, :enums

      def initialize(models, links, module_links, enums)
        self.template_file = File.expand_path("#{__dir__}/../../../templates/header_template.hbs")
        self.links = links
        self.module_links = build_module_imports(module_links)
        self.models = models
        self.enums = build_enums(enums)

        helper(:interface) do |context, arg, block|
          [
            "@interface #{arg[:name]} : #{arg[:base_class]}",
            '',
            "#{block.fn(context)}",
            '@end',
            ''
          ].join("\n")
        end

        helper(:declare_props) do |context, arg, block|
          arg.map do |prop|
            options = block[:hash]
            access_type = options[:readOnly] ? 'readonly' : 'readwrite'
            asterisk = prop[:is_ref] && !prop[:is_id] ? '*' : ''
            asterisk_and_prefix = "#{asterisk}#{prop[:name_prefix]}"
            memory_management = prop[:is_ref] ? prop[:ref_type] : 'assign';
            prop_arguments = "@property(nonatomic, #{memory_management}, #{access_type})"
            prop_field = "#{prop[:type]} #{asterisk_and_prefix}#{prop[:name]}"
            "#{prop_arguments} #{prop_field};"
          end.join("\n")
        end

        helper(:enum) do |context, arg, block|
          [
            'typedef enum {',
            arg[:attributes].map(&:name).join(",\n"),
            "} #{arg[:name]};",
          ].join("\n")
        end

        helper(:module_import) do |context, arg, block|
          [
            "#import <#{arg[:module_name]}/#{arg[:class_name]}.h>\n"
          ].join("\n")
        end
      end

      def build_module_imports(module_links)
        module_links.map do |module_link|
          dict_mapping = {
            module_name: module_link.module_name,
            class_name: module_link.class_name,
          }
        end
      end

      def build_enums(enums)
        enums.map do |enum|
          attributes = enum.attributes.map { |attr| {name: attr.name} }

          {
            name: enum.name,
            attributes: attributes
          }
        end
      end

      def render
        template.call(models: models, links: links, module_links:module_links, enums: enums)
      end
    end
  end
end
