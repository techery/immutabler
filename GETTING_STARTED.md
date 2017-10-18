Getting Started
====================

# Syntax

##Groups

Groups are on the root level

```ruby
Immutabler.group :GroupName do
  output_dir('./project/output')
  prefix('GroupPrefix')
  base_model('NSObject')
end
```

Inside of immutabler you can describe enums, fields and mappings.

## Models

Model is describing in `model` block:

```ruby
model :ModelName do

end
```

You can specify base class for model using `base` option:

```ruby
model :User, base: MyModel do

end
```

If base class is immutable and must be instantiated with builder, you can use `base_immutable` option:

```ruby
model :User, base: MyModel, base_immutable: true do

end
```

You can avoid generating `isEqual:` method for you by specifying `gen_equatable` option to `false` (`true` by default):
```ruby
model :User, gen_equatable: false do

end
```

You can specify base class for model builder using `builder_base` option (`NSObject` by default):

```ruby
model :User, builder_base: :CustomBuilder do

end
```

## Enums

Enum is describing in `enum` block:

```ruby
enum :EnumName do

end
```

Generated enum will have group prefix.

Generated enum members will have a group prefix and the enum name.

For example: `GroupPrefixEnumNameMember1`

Example:
```ruby
enum :EnumName do
  attr :Member1
  attr :Member2
end
```

## Fields

Fields are defing in `fields` block:

```ruby
fields do

end
```

Each field is defining by

```ruby
    prop :fieldName, :fieldType, :name_prefix => your_custom_prefix(string, optional), :is_ref => true or false(optional), :ref_type => 'assign', 'weak', 'strong'(optional), :is_id => true or false(optional), :default => string_or_number_to_put_inplace(optional)
```

There are predefined types:
* int -> NSInteger in Objective-C
* float -> CGFloat in Objective-C
* double -> double in Objective-C
* bool -> BOOL in Objective-C
* string -> NSString* in Objective-C
* array -> NSArray* in Objective-C
* dict -> NSDictionary* in Objective-C
* id -> id in Objective-C

When you use custom type and it will be transformed into the same.

You can pass additional parameters for prop:

+ name_prefix: name_prefix to include (please, don't use it for adding/supressing asterisk before property name - use `is_ref`, `is_id` instead)
+ is_ref: defines whether property is reference type (pointer) or value type
+ ref_type: property memory management specifier (`weak`, `strong`, `assign`, default - `strong` when `is_ref` is `true`, `assign` when `is_ref` is `false`)
+ is_id: `id` is Objective-C special built-in type. Despite it's reference type, '*' is assumed implicitly and shouldn't be specified manually. Whenever you want to define something of type like `id<MyAwesomeProtocol>` don't forget to add :is_id => true to property definition to suppress asterisk
+ default: defines the default value which will be set when you use `-init`, `+new` or `+create:` constructors.

Example:
```ruby
  fields do
    prop :modelId,     :int, default: 3
    prop :address,     :string, default: '@""'
    prop :phone,       :string
    prop :walkIns,     :array, default: "@[]"
    prop :workingDays, :dict, default: "@{}"
    prop :numberOfItems, :NSNumber, default: "@3"
    prop :state,       :TEState, name_prefix: 'pref_', ref_type: :weak
  end
```

# Full example
```ruby
require 'immutabler'

gen_path = './MasterApp/gen'

Immutabler.group :TESalonModels do

  output_dir(gen_path)
  prefix('TE')
  link_to :TEState # #import "TEState.h"
  module_link_to :Mantle, :MTLModel # #import <Mantle/MTLModel.h>
  base_model('MTLModel') # Default base model for group

  enum :ServiceState do
    attr :Archived
    attr :Active
  end

  model :Salon, base: 'CustomModel',
                base_immutable: true,
                builder_base: 'CustomBuilder' do
    fields do
      prop :modelId,     :int, default: 3
      prop :address,     :string, default: '@""'
      prop :phone,       :string
      prop :walkIns,     :array, default: "@[]"
      prop :workingDays, :dict, default: "@{}"
      prop :numberOfItems, :NSNumber, default: "@3"
      prop :state,       :TEState, name_prefix: 'pref_', ref_type: :weak
    end
  end
end
```

# How to run

Run in command line from project root directory
```shell
ruby MasterApp/models.rb
```

Output files will be generated in the specified `output_dir`
