require 'forwardable'

module Translator

  include Forwardable

  def translate(source, &block)
    translations = yield block
    translations.each do |actual, translated|
      def_delegator source.to_sym, actual, translated
    end
  end

end
