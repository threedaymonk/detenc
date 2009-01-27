require File.join(File.dirname(__FILE__), 'common')

class US_ASCII_Test < Test::Unit::TestCase
  include DetencHelper

  def test_should_be_us_ascii_if_it_contains_all_printable_bytes_under_0x7F
    sample = ((0x09..0x0D).to_a + (0x20..0x7E).to_a).inject(''){ |s, b|
      s << [b].pack('C')
    }
    assert_equal US_ASCII, detenc(sample)
  end

  def test_should_not_be_us_ascii_if_it_contains_any_non_printable_bytes_under_0x7F
    ((0x00..0x08).to_a + (0x0E..0x1F).to_a).each do |invalid_byte|
      sample = [invalid_byte].pack('C')
      assert_not_equal US_ASCII, detenc(sample), "%02X is not #{US_ASCII}" % invalid_byte
    end
  end

  def test_should_not_be_us_ascii_if_it_contains_any_byte_of_0x7F_or_more
    (0x7F..0xFF).each do |invalid_byte|
      sample = [invalid_byte].pack('C')
      assert_not_equal US_ASCII, detenc(sample), "%02X is not #{US_ASCII}" % invalid_byte
    end
  end
end

