require 'forwardable'

module Translator

  include Forwardable

  def translate(source, &block)
    translations = yield block

    translations.each do |translated, actual|
      if simple_alias?(actual)
        # delegate method call to source using aliased name
        def_delegator source.to_sym, actual, translated
      else
        # define new method executing given proc
        actual_method_name, func = actual
        define_method(translated) do
          func.call(send(source).send(actual_method_name))
        end
      end
    end
  end

  def simple_alias?(actual)
    actual.is_a?(Symbol)
  end

end
