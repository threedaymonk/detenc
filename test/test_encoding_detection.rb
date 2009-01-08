require File.join(File.dirname(__FILE__), 'common')

class EncodingDetectionTest < Test::Unit::TestCase
  include DetencHelper

  SAMPLE = "Pâté: €3.20"

  def test_should_recognise_utf8
    sample = SAMPLE
    encoding = UTF_8
    assert_equal encoding, detenc(sample)
  end

  def test_should_recognise_windows_1252
    encoding = WINDOWS_1252
    sample = Iconv.new(encoding, UTF_8).iconv(SAMPLE)
    assert_equal encoding, detenc(sample)
  end

  def test_should_recognise_iso_8859_15
    encoding = ISO_8859_15
    sample = Iconv.new(encoding, UTF_8).iconv(SAMPLE)
    assert_equal encoding, detenc(sample)
  end

  def test_should_be_us_ascii_if_empty
    assert_equal US_ASCII, detenc('')
  end
end

