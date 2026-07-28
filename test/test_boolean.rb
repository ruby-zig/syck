require 'helper'

module Syck
  ###
  # Test booleans from YAML spec:
  # http://yaml.org/type/bool.html
  class TestBoolean < Test::Unit::TestCase
    %w{ yes Yes YES true True TRUE on On ON }.each do |truth|
      define_method(:"test_#{truth}") do
        assert_equal true, Syck.load("--- #{truth}")
      end
    end

    %w{ no No NO false False FALSE off Off OFF }.each do |truth|
      define_method(:"test_#{truth}") do
        assert_equal false, Syck.load("--- #{truth}")
      end
    end

    ###
    # YAML spec says "y" and "Y" may be used as true, but Syck treats them
    # as literal strings
    def test_y
      assert_equal "y", Syck.load("--- y")
      assert_equal "Y", Syck.load("--- Y")
    end

    ###
    # YAML spec says "n" and "N" may be used as false, but Syck treats them
    # as literal strings
    def test_n
      assert_equal "n", Syck.load("--- n")
      assert_equal "N", Syck.load("--- N")
    end

    ###
    # https://github.com/ruby/syck/issues/22
    # A boolean-like prefix followed by a non-ASCII byte must not be
    # matched as a boolean
    def test_bool_prefix_with_non_ascii
      assert_equal "Noémie", Syck.load("--- Noémie")
      assert_equal ["Noémie"], Syck.load("--- [Noémie]")
      assert_equal "Yeså", Syck.load("--- Yeså")
      assert_equal "trueé", Syck.load("--- trueé")
      assert_equal "nullé", Syck.load("--- nullé")
    end
  end
end
