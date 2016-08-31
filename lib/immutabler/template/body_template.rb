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
              decode_template(arg.name, 'Bool')
            when 'NSInteger'
              decode_int(arg.name)
            when 'CGFloat'
              decode_template(arg.name, 'Float')
            when 'double'
              decode_template(arg.name, 'Double')
            else
              if !arg.is_ref 
                decode_int(arg.name)
              else
                decode_template(arg.name, 'Object')
              end
          end
        end

        helper(:encodeProperty) do |context, arg, block|
          case arg.type
            when 'BOOL'
              encode_template(arg.name, 'Bool')
            when 'NSInteger'
              encode_int(arg.name)
            when 'CGFloat'
              encode_template(arg.name, 'Float', 'float')
            when 'double'
              encode_template(arg.name, 'Double')
            else
              if !arg.is_ref 
                encode_int(arg.name)
              else
                encode_template(arg.name, 'Object')
              end
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

      def encode_template(arg_name, type, typecast = nil, leading_spaces_count = 8)
          typecast_expression = typecast ? "(#{typecast})" : ''
        "#{' ' * leading_spaces_count}[coder encode#{type}:#{typecast_expression}self.#{arg_name} forKey:@\"_#{arg_name}\"];"
      end
      def encode_int(arg_name)
         "        if (sizeof(_#{arg_name}) < 8) {\n\
                    #{encode_template(arg_name, 'Int32', nil, 0)} \n\
                }\n\
                else {\n\
                    #{encode_template(arg_name, 'Int64', nil, 0)} \n\
                }"
      end
      def decode_template(arg_name, type, leading_spaces_count = 8)
        "#{' ' * leading_spaces_count}_#{arg_name} = [coder decode#{type}ForKey:@\"_#{arg_name}\"];"
      end
      def decode_int(arg_name)
        "        if (sizeof(_#{arg_name}) < 8) {\n\
                    #{decode_template(arg_name, 'Int32', nil, 0)} \n\
                }\n\
                else {\n\
                    #{decode_template(arg_name, 'Int64', nil, 0)} \n\
                }"
      end
    end
  end
end