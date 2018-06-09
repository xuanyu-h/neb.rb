# encoding: utf-8
# frozen_string_literal: true

class String
  # By default, +camelize+ converts strings to UpperCamelCase. If the argument to camelize
  # is set to <tt>:lower</tt> then camelize produces lowerCamelCase.
  #
  # +camelize+ will also convert '/' to '::' which is useful for converting paths to namespaces.
  #
  #   'active_record'.camelize                # => "ActiveRecord"
  #   'active_record'.camelize(:lower)        # => "activeRecord"
  #   'active_record/errors'.camelize         # => "ActiveRecord::Errors"
  #   'active_record/errors'.camelize(:lower) # => "activeRecord::Errors"
  def camelize(first_letter = :upper)
    case first_letter
    when :upper
      uppercase_first_letter = true
    when :lower
      uppercase_first_letter = false
    else
      raise ArgumentError, "Invalid option, use either :upper or :lower."
    end

    string = self.to_s
    if uppercase_first_letter
      string = string.sub(/^[a-z\d]*/) { |match| match.capitalize }
    else
      string = string.sub(/^(?:(?=a)b(?=\b|[A-Z_])|\w)/) { |match| match.downcase }
    end
    string.gsub!(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
    string.gsub!("/".freeze, "::".freeze)
    string
  end
end
