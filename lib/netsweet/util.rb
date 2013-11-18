# Encoding: utf-8

module Netsweet
  module Util
    def bool_setter(*attrs)
      attrs.each do |attr|
        define_method "#{attr}=".to_sym do |bool|
          instance_variable_set("@#{attr}".to_sym,
                                !(bool == 'false' || bool.nil?))
        end
      end
    end
  end
end
