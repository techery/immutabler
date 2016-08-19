module Immutabler
  class TypeMapper
    TYPE_MAPPING = {
      'int' => {
        type: 'NSInteger',
        is_ref: false
      },
      'float' => {
        type: 'CGFloat',
        is_ref: false
      },
      'double' => {
        type: 'double',
        is_ref: false
      },
      'bool' => {
        type: 'BOOL',
        is_ref: false
      },
      'array' => {
        type: 'NSArray',
        is_ref: true
      },
      'string' => {
        type: 'NSString',
        is_ref: true
      },
      'dict' => {
        type: 'NSDictionary',
        is_ref: true
      },
      'id' => {
        type: 'id',
        is_ref: true,
        ref_type: 'strong',
        is_id: true
      }
    }

    def self.map(type, options)
      default_mapping(type).merge(TYPE_MAPPING.fetch(type, default_mapping(type))).merge(options)
    end

    private

    def self.default_mapping(type)
      {
        type: type,
        is_ref: true,
        ref_type: 'strong',
        is_id: false
      }
    end
  end
end
