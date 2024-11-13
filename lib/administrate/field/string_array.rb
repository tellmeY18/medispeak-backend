require "administrate/field/base"

module Administrate
  module Field
    class StringArray < Administrate::Field::Base
      def to_s
        data&.join("\n")
      end

      def self.permitted_attribute(attr, _options = nil)
        ["#{attr}_raw", attr => []]
      end

      def self.html_class
        "string_array"
      end
    end
  end
end
