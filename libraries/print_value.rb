# Module Extensions
module Extensions
  # Module Templates
  module Templates
    # An extension method for convenient printing of values in ERB templates.
    #
    # The method provides several ways how to evaluate the value:
    #
    # 1. Using the key as a node attribute:
    #
    #    <%= print_value 'bar' -%> is evaluated as: `node.elasticsearch[:bar]`
    #
    #    You may use a dot-separated key for nested attributes:
    #
    #    <%= print_value 'foo.bar' -%> is evaluated in multiple ways in this order:
    #
    #    a) as `node.elasticsearch['foo.bar']`,
    #    b) as `node.elasticsearch['foo_bar']`,
    #    c) as `node.elasticsearch.foo.bar` (ie. `node.elasticsearch[:foo][:bar]`)
    #
    # 2. You may also provide an explicit value for the method, which is then used:
    #
    #    <%= print_value 'bar', node.elasticsearch[:foo] -%>
    #
    # You may pass a specific separator to the method:
    #
    #    <%= print_value 'bar', separator: '=' -%>
    #
    # Do not forget to use an ending dash (`-`) in the ERB block, so lines for missing values are not printed!
    #
    def print_value(key, value = nil, options = {})
      separator = options[:separator] || ': '
      existing_value   = value

      # NOTE: A value of `false` is valid, we need to check for `nil` explicitely
      begin
        existing_value = node.elasticsearch[key] if existing_value.nil? && !node.elasticsearch[key].nil?
        existing_value = node.elasticsearch[key.tr('.', '_')] if existing_value.nil? && !node.elasticsearch[key.tr('.', '_')].nil?
        existing_value = key.to_s.split('.').reduce(node.elasticsearch) { |(result, attr)| result[attr] }
      rescue
        existing_value = nil if existing_value.nil?
      end
      [key, separator, existing_value.to_s, "\n"].join unless existing_value.nil?
    end
  end
end
