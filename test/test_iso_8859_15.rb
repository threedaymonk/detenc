require File.join(File.dirname(__FILE__), 'common')

class ISO_8859_15_Test < Test::Unit::TestCase
  include DetencHelper

  INVALID_BYTES = (0x00..0x08).to_a + (0x0E..0x1F).to_a + (0x7F..0x9F).to_a

  def test_should_be_iso_8859_15_if_it_contains_all_valid_bytes
    sample = (0..0xFF).inject(''){ |s, b|
      s << [b].pack('C') unless INVALID_BYTES.include?(b)
      s
    }
    assert_equal ISO_8859_15, detenc(sample)
  end

  def test_should_not_be_iso_8859_15_if_it_contains_one_invalid_byte
    INVALID_BYTES.each do |invalid_byte|
      sample = (0..0xFF).inject(''){ |s, b|
        s << [b].pack('C') unless (INVALID_BYTES - [invalid_byte]).include?(b)
        s
      }
      assert_not_equal ISO_8859_15, detenc(sample), "Byte 0x%02X is not in %s" % [invalid_byte, ISO_8859_15]
    end
  end
end

