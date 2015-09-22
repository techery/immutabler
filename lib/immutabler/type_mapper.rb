module Immutabler
  class TypeMapper
    TYPE_MAPPING = {
      'int' => {
        type: 'NSInteger',
        is_ref: false,
        ref_type: 'assign',
        name_prefix: ''
      },
      'float' => {
        type: 'CGFloat',
        is_ref: false,
        ref_type: 'assign',
        name_prefix: ''
      },
      'bool' => {
        type: 'BOOL',
        is_ref: false,
        ref_type: 'assign',
        name_prefix: ''
      },
      'array' => {
        type: 'NSArray',
        is_ref: true,
        ref_type: 'strong',
        name_prefix: '*'
      },
      'string' => {
        type: 'NSString',
        is_ref: true,
        ref_type: 'strong',
        name_prefix: '*'
      },
      'dict' => {
        type: 'NSDictionary',
        is_ref: true,
        ref_type: 'strong',
        name_prefix: '*',
      },
      'id' => {
        type: 'id',
        is_ref: true,
        ref_type: 'strong',
        name_prefix: ''
      }
    }

    def self.map(type, options)
      TYPE_MAPPING.fetch(type, default_mapping(type)).merge(options)
    end

    private

    def self.default_mapping(type)
      {
        type: type,
        is_ref: true,
        ref_type: 'strong',
        name_prefix: '*'
      }
    end
  end
end
