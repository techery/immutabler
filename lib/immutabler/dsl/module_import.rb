module Immutabler
  module DSL
    class ModuleImport
      attr_accessor :module_name, :class_name

      def initialize(module_name, class_name)
        @module_name = module_name
        @class_name = class_name
      end
    end
  end
end
