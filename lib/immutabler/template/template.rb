require 'handlebars'

class String
  def unindent
    gsub(/^#{match(/^\s+/)}/, '')
  end
end

module Immutabler
  module Template
    class BaseTemplate
      attr_accessor :template_file

      def raw_template
        @raw_template ||= File.read(template_file)
      end

      def handlebars
        @handlebars ||= Handlebars::Context.new
      end

      def template
        @template ||= handlebars.compile(raw_template, {noEscape: true})
      end

      def helper(name, &helper_body)
        handlebars.register_helper(name) do |context, arg, block|
          helper_body.call(context, arg, block).unindent
        end
      end
    end
  end
end
