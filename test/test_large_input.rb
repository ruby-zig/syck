require 'helper'

module Syck
  # Both of these sized an `alloca` from the document. They are run on a Thread
  # because a Ruby thread's stack is far smaller than the main stack, which is
  # the shape a web or job worker actually has.
  class TestLargeInput < Test::Unit::TestCase
    SIZE = 4 * 1024 * 1024

    def on_thread
      Thread.new { yield }.value
    end

    def test_long_ivar_name
      doc = "--- !ruby/object:Object\n" + ('n' * SIZE) + ": 1\n"
      obj = on_thread { Syck.load(doc) }
      assert_equal 1, obj.instance_variable_get("@#{'n' * SIZE}")
    end

    def test_long_compile_input
      doc = "--- \n" + (0...(SIZE / 20)).map { |i| "k#{i}: v#{i}\n" }.join
      bc = on_thread { Syck.compile(doc) }
      assert_equal "D\n", bc[0, 2]
    end
  end
end
