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

You can specify base class for model builder using `builder_base` option:

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
    prop :fieldName, :fieldType
```

There are predefined types:
* int
* float
* bool
* string
* array
* dict
* id

When you use custom type and it will be transformed into the same.

You can pass additional parameters for prop:

+ prefix: prefix used in Objective-C code (e.g. `*` for referential types).
+ ref: reference type in Objective-C code (e.g. `weak`)

Example:
```ruby
  fields do
    prop :modelId,     :int
    prop :address,     :string
    prop :phone,       :string
    prop :walkIns,     :array
    prop :workingDays, :dict
    prop :state,       :TEState, prefix: '', ref: :weak
end
```

## Mappings

All mappings are describing in `mapping` block
```ruby
mapping do

end
```

### Simple mapping

Simple mappings are describing wih `map`:

```ruby
map :json_field_name, :classFieldName
```

You can specify custom transformer class using `with` option:

```ruby
map :phone, :phoneNumber, with: :CustomPhoneTransformer
```

### Array mapping

You can describe mapping array of records using `array`:

```ruby
array :json_field_name, :classFieldName, :ClassName
```

### Dict mapping

You can describe mapping json field to custom value (e.g. into enum) with `dict`:

```ruby
dict  :json_state, :modelState do
  map :active,   :TEServiceStateActive
  map :archived, :TEServiceStateArchived
end
```

# Full example
```ruby
require 'immutabler'

gen_path = './MasterApp/gen'

Immutabler.group :TESalonModels do

  output_dir(gen_path)
  prefix('TE')
  base_model('MTLModel<MTLJSONSerializing>') # Defaut base model for group

  enum :ServiceState do
    attr :Archived
    attr :Active
  end

  model :Salon, base: 'CustomModel', builder_base: 'CustomBuilder' do
    fields do
      prop :modelId,     :int
      prop :address,     :string
      prop :phone,       :string
      prop :walkIns,     :array
      prop :workingDays, :dict
      prop :state,       :TEState, ref: :weak, prefix: '*'
    end

    mapping do
      map   :id,       :modelId
      map   :phone,    :phone, with: :CustomPhoneTransformer
      array :walk_ins, :walkIns, :TEWalkIn
      dict  :state,    :state do
        map :active,   :TEServiceStateActive
        map :archived, :TEServiceStateArchived
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
