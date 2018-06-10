# encoding: utf-8
# frozen_string_literal: true

class Hash
  # Returns a new hash with all keys converted to UpperCamelCase strings.If th
  # is set to <tt>:lower</tt> then camelize produces lowerCamelCase.
  #
  #   hash = { my_name: 'Rob', my_age: '28' }
  #
  #   hash.camelize_keys
  #   # => {"MyName"=>"Rob", "MyAge"=>"28"}
  #
  #   hash.camelize_keys(:lower)
  #   # => {"myName"=>"Rob", "myAge"=>"28"}
  def camelize_keys(first_letter = :upper)
    transform_keys { |key| key.to_s.camelize(first_letter) rescue key }
  end

  # Destructively converts all keys to strings. Same as
  # +camelize_keys+, but modifies +self+.
  def camelize_keys!(first_letter = :upper)
    transform_keys! { |key| key.to_s.camelize(first_letter) rescue key }
  end
end
