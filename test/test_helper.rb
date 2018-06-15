$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "neb"
require "minitest/autorun"
require "pry"

class Neb::TestCase < Minitest::Test

  def teardown
    clear_tmp_file
  end

  def clear_tmp_file
    Dir.glob("#{Neb.root.join('tmp')}/*.json") { |f| File.delete(f) }
  end
end
