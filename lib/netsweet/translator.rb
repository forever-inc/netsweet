require 'forwardable'

# Translate NetSuite fields returned to/from ruby object methods
#
# ==== Usage
# * called as a block where the source is the hash returned from NetSuite
#
# * simple: translate ruby field name to netsuite field name
#
#    translate :source do
#      {
#        my_accessor_name:   :netsuite_accessor_name
#      }
#    end
#
#
# * advanced: translate ruby field name to netsuite field name,
#             custom getter function,
#             custom setter function
#
#    translate :source do
#      {
#        my_accessor_name:  [:netsuite_accessor_name,  ->(v) { # additional get logic }, ->(v) { { # additional set logic } }],
#      }
#    end
module Translator
  include Forwardable

  def translate(source, &block)
    translations = yield block

    translations.each do |translated, actual|
      if simple_alias?(actual)
        # delegate method call to source using aliased name
        def_delegator source.to_sym, actual, translated
        def_delegator source.to_sym, "#{actual}=", "#{translated}="
      else
        actual_method_name, get_func, set_func = actual
        proc_getter(source, get_func, translated, actual_method_name) if get_func
        proc_setter(source, set_func, translated, actual_method_name) if set_func
      end
    end
  end

  def simple_alias?(actual)
    actual.is_a?(Symbol)
  end

  def proc_getter(source, get_func, translated_method_name, actual_method_name)
    define_method(translated_method_name) do
      get_func.call(send(source).send(actual_method_name) || {})
    end
  end

  def proc_setter(source, set_func, translated_method_name, actual_method_name)
    define_method("#{translated_method_name}=") do |val|
      send(source).send("#{actual_method_name}=", set_func.call(val))
    end
  end
end
