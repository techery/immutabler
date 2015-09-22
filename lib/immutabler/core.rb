require_relative 'type_mapper'
require_relative 'template/builder'
require_relative 'dsl/group'

module Immutabler
  def self.group(group_name, &block)
    group = DSL::Group.new(group_name)
    group.instance_eval(&block)

    builder = Template::Builder.new(group)
    builder.build
  end
end
