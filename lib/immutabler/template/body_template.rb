require_relative 'template'

module Immutabler
  module Template
    class BodyTemplate < BaseTemplate
      attr_accessor :name, :models

      def initialize(name, models)
        self.template_file = File.expand_path("#{__dir__}/../../../templates/body_template.hbs")
        self.name = name
        self.models = models

        helper(:dict) do |context, arg, block|
          body = "@{\n"

          if arg
            body << arg.map { |m| "@\"#{m.destination_name}\" : @\"#{m.origin_name}\"" }.join(",\n")
          end

          body << "\n};"
        end

        helper(:enum_mapping_dict) do |context, arg, block|
          body = "@{\n"

          if arg
            body << arg.map { |m| "@\"#{m.origin_name}\" : @(#{m.destination_name})" }.join(",\n")
          end

          body << "\n};"
        end

        helper(:init_with_builder) do |context, arg, block|
          if arg[:base_immutable]
            "    self = [super initWithBuilder:builder modelVersion:modelVersion];\n"
          else
            "    self = [super init];\n"
          end
        end

        helper(:init_with_coder) do |context, arg, block|
          if arg[:base_immutable]
            "    self = [self init];\n"
          else
            "    self = [super init];\n"
          end
        end

        helper(:decodeProperty) do |context, arg, block|
          case arg.type
            when 'BOOL'
              "        _#{arg.name} = [coder decodeBoolForKey:@\"_#{arg.name}\"];"
            when 'NSInteger'
              "        if (sizeof(_#{arg.name}) < 8) {\n            \
                        _#{arg.name} = [coder decodeInt32ForKey:@\"_#{arg.name}\"];\n\
                        }\n\
                        else {\n\
                        _#{arg.name} = [coder decodeInt64ForKey:@\"_#{arg.name}\"]; \n\
                        }"
            when 'CGFloat'
              "        _#{arg.name} = [coder decodeFloatForKey:@\"_#{arg.name}\"];"
            when 'double'
              "        _#{arg.name} = [coder decodeDoubleForKey:@\"_#{arg.name}\"];"
            else
              "        _#{arg.name} = [coder decodeObjectForKey:@\"_#{arg.name}\"];"
          end
        end

        helper(:encodeProperty) do |context, arg, block|
          case arg.type
            when 'BOOL'
              "        [coder encodeBool:self.#{arg.name} forKey:@\"_#{arg.name}\"];"
            when 'NSInteger'
              "        if (sizeof(_#{arg.name}) < 8) {\n            \
                        [coder encodeInt32:self.#{arg.name} forKey:@\"_#{arg.name}\"];\n\
                        }\n\
                        else {\n\
                        [coder encodeInt64:self.#{arg.name} forKey:@\"_#{arg.name}\"]; \n\
                        }"
            when 'CGFloat'
              "        [coder encodeFloat:self.#{arg.name} forKey:@\"_#{arg.name}\"];"
            when 'double'
              "        [coder encodeDouble:self.#{arg.name} forKey:@\"_#{arg.name}\"];"
            else
              "        [coder encodeObject:self.#{arg.name} forKey:@\"_#{arg.name}\"];"
          end
        end

        helper(:base_immutable_interface) do |context, arg, block|
          if arg[:base_immutable]
            [
              "#ifndef #{arg[:base_class]}_Private",
              "#define #{arg[:base_class]}_Private",
              "@interface #{arg[:base_class]}(Private)",
              '- (instancetype)initWithBuilder:(id)builder modelVersion:(NSInteger)modelVersion;',
              '@end',
              "#endif"
            ].join("\n")
          else
            ''
          end
        end
      end

      def render
        template.call(models: models, name: name)
      end
    end
  end
end
