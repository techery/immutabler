require_relative 'template'

module Immutabler
  module Template
    class HeaderTemplate < BaseTemplate
      attr_accessor :models, :links, :enums

      def initialize(models, links, enums)
        self.template_file = File.expand_path("#{__dir__}/../../../templates/header_template.hbs")
        self.links = links
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
            prop_arguments = "@property(nonatomic, #{prop[:ref_type]}, #{access_type})"
            prop_field = "#{prop[:type]} #{prop[:name_prefix]}#{prop[:name]}"

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
      end

      def build_enums(enums)
        enums.map do |enum|
          attributes = enum.attributes.map { |attr| { name: attr.name } }

          {
            name: enum.name,
            attributes: attributes
          }
        end
      end

      def render
        template.call(models: models, links: links, enums: enums)
      end
    end
  end
end
