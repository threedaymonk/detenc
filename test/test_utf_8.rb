require File.join(File.dirname(__FILE__), 'common')

class UTF8StressTest < Test::Unit::TestCase
  include DetencHelper

  # From Markus Kuhn's stress tests
  # http://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-test.txt

  def assert_valid(data)
    detected = detenc(data)
    allowed = [US_ASCII, UTF_8]
    assert allowed.include?(detected), "Expected #{detected.inspect} to be one of #{allowed.inspect}"
  end

  def assert_invalid(data)
    detected = detenc(data)
    disallowed = [US_ASCII, UTF_8]
    assert !disallowed.include?(detected), "Expected #{detected.inspect} not to be one of #{disallowed.inspect}"
  end

  def test_should_accept_greek_kosme
    assert_valid "\xce\xba\xe1\xbd\xb9\xcf\x83\xce\xbc\xce\xb5"
  end

  def test_should_accept_first_possible_sequence_for_1_byte_sequence
    assert_valid "\x00"
  end

  def test_should_accept_first_possible_sequence_for_2_byte_sequence
    assert_valid "\xc2\x80"
  end

  def test_should_accept_first_possible_sequence_for_3_byte_sequence
    assert_valid "\xe0\xa0\x80"
  end

  def test_should_accept_first_possible_sequence_for_4_byte_sequence
    assert_valid "\xf0\x90\x80\x80"
  end

  def test_should_reject_first_possible_sequence_for_5_byte_sequence_restricted_by_rfc_3629
    assert_invalid "\xf8\x88\x80\x80\x80"
  end

  def test_should_reject_first_possible_sequence_for_6_byte_sequence_restricted_by_rfc_3629
    assert_invalid "\xfc\x84\x80\x80\x80\x80"
  end

  def test_should_accept_last_possible_sequence_for_1_byte_sequence
    assert_valid "\x7f"
  end

  def test_should_accept_last_possible_sequence_for_2_byte_sequence
    assert_valid "\xdf\xbf"
  end

  def test_should_accept_last_possible_sequence_for_3_byte_sequence
    assert_valid "\xef\xbf\xbf"
  end

  def test_should_reject_last_possible_sequence_for_4_byte_sequence
    assert_invalid "\xf7\xbf\xbf\xbf"
  end

  def test_should_reject_last_possible_sequence_for_5_byte_sequence_restricted_by_rfc_3629
    assert_invalid "\xfb\xbf\xbf\xbf\xbf"
  end

  def test_should_reject_last_possible_sequence_for_6_byte_sequence_restricted_by_rfc_3629
    assert_invalid "\xfd\xbf\xbf\xbf\xbf\xbf"
  end

  def test_should_accept_various_boundary_conditions_under_U10FFFF
    assert_valid "\xed\x9f\xbf"
    assert_valid "\xee\x80\x80"
    assert_valid "\xef\xbf\xbd"
  end

  def test_should_accept_U10FFFF
    assert_valid "\xf4\x8f\xbf\xbf"
  end

  def test_should_reject_U110000
    assert_invalid "\xf4\x90\x80\x80"
  end

  def test_should_reject_unexpected_continuation_bytes
    assert_invalid "\x80"
    assert_invalid "\xbf"
    assert_invalid "\x80\xbf"
    assert_invalid "\x80\xbf\x80"
    assert_invalid "\x80\xbf\x80\xbf"
    assert_invalid "\x80\xbf\x80\xbf\x80"
    assert_invalid "\x80\xbf\x80\xbf\x80\xbf"
    assert_invalid "\x80\xbf\x80\xbf\x80\xbf\x80"
  end

  def test_should_reject_sequence_of_all_possible_continuation_bytes
    assert_invalid "\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8a\x8b\x8c\x8d\x8e\x8f\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9a\x9b\x9c\x9d\x9e\x9f\xa0\xa1\xa2\xa3\xa4\xa5\xa6\xa7\xa8\xa9\xaa\xab\xac\xad\xae\xaf\xb0\xb1\xb2\xb3\xb4\xb5\xb6\xb7\xb8\xb9\xba\xbb\xbc\xbd\xbe\xbf"
  end

  def test_should_reject_isolated_first_bytes_of_2_byte_sequence
    assert_invalid "\xc0\x20\xc1\x20\xc2\x20\xc3\x20\xc4\x20\xc5\x20\xc6\x20\xc7\x20\xc8\x20\xc9\x20\xca\x20\xcb\x20\xcc\x20\xcd\x20\xce\x20\xcf\x20\xd0\x20\xd1\x20\xd2\x20\xd3\x20\xd4\x20\xd5\x20\xd6\x20\xd7\x20\xd8\x20\xd9\x20\xda\x20\xdb\x20\xdc\x20\xdd\x20\xde\x20\xdf\x20"
  end

  def test_should_reject_isolated_first_bytes_of_3_byte_sequence
    assert_invalid "\xe0\x20\xe1\x20\xe2\x20\xe3\x20\xe4\x20\xe5\x20\xe6\x20\xe7\x20\xe8\x20\xe9\x20\xea\x20\xeb\x20\xec\x20\xed\x20\xee\x20\xef\x20"
  end

  def test_should_reject_isolated_first_bytes_of_4_byte_sequence
    assert_invalid "\xf0\x20\xf1\x20\xf2\x20\xf3\x20\xf4\x20\xf5\x20\xf6\x20\xf7\x20"
  end

  def test_should_reject_isolated_first_bytes_of_5_byte_sequence
    assert_invalid "\xf8\x20\xf9\x20\xfa\x20\xfb\x20"
  end

  def test_should_reject_isolated_first_bytes_of_6_byte_sequence
    assert_invalid "\xfc\x20\xfd\x20"
  end

  def test_should_reject_sequences_with_last_continuation_byte_missing
    assert_invalid "\xc0"
    assert_invalid "\xe0\x80"
    assert_invalid "\xf0\x80\x80"
    assert_invalid "\xf8\x80\x80\x80"
    assert_invalid "\xfc\x80\x80\x80\x80"
    assert_invalid "\xdf"
    assert_invalid "\xef\xbf"
    assert_invalid "\xf7\xbf\xbf"
    assert_invalid "\xfb\xbf\xbf\xbf"
    assert_invalid "\xfd\xbf\xbf\xbf\xbf"
    assert_invalid "\xc0\xe0\x80\xf0\x80\x80\xf8\x80\x80\x80\xfc\x80\x80\x80\x80\xdf\xef\xbf\xf7\xbf\xbf\xfb\xbf\xbf\xbf\xfd\xbf\xbf\xbf\xbf"
  end

  def test_should_reject_impossible_bytes
    assert_invalid "\xfe"
    assert_invalid "\xff"
    assert_invalid "\xfe\xfe\xff\xff"
  end

  # The tests that follow are not necessary for this implementation. They have
  # been left in to clarify the limitations of the state machine detection
  # method.
  #
  # From Markus Kuhn's page:
  # The following sequences are not malformed according to the letter of the
  # Unicode 2.0 standard. However, they are longer then necessary and a correct
  # UTF-8 encoder is not allowed to produce them.

  def disabled_test_should_reject_overlong_ascii_characters
    assert_invalid "\xc0\xaf"
    assert_invalid "\xe0\x80\xaf"
    assert_invalid "\xf0\x80\x80\xaf"
    assert_invalid "\xf8\x80\x80\x80\xaf"
    assert_invalid "\xfc\x80\x80\x80\x80\xaf"
  end

  def disabled_test_should_reject_maximum_overlong_sequences
    assert_invalid "\xc1\xbf"
    assert_invalid "\xe0\x9f\xbf"
    assert_invalid "\xf0\x8f\xbf\xbf"
    assert_invalid "\xf8\x87\xbf\xbf\xbf"
    assert_invalid "\xfc\x83\xbf\xbf\xbf\xbf"
  end

  def disabled_test_should_reject_overlong_nul_sequences
    assert_invalid "\xc0\x80"
    assert_invalid "\xe0\x80\x80"
    assert_invalid "\xf0\x80\x80\x80"
    assert_invalid "\xf8\x80\x80\x80\x80"
    assert_invalid "\xfc\x80\x80\x80\x80\x80"
  end

  def disabled_test_should_reject_single_utf16_surrogates
    assert_invalid "\xed\xa0\x80"
    assert_invalid "\xed\xad\xbf"
    assert_invalid "\xed\xae\x80"
    assert_invalid "\xed\xaf\xbf"
    assert_invalid "\xed\xb0\x80"
    assert_invalid "\xed\xbe\x80"
    assert_invalid "\xed\xbf\xbf"
  end

  def disabled_test_should_reject_paired_utf16_surrogates
    assert_invalid "\xed\xa0\x80\xed\xb0\x80"
    assert_invalid "\xed\xa0\x80\xed\xbf\xbf"
    assert_invalid "\xed\xad\xbf\xed\xb0\x80"
    assert_invalid "\xed\xad\xbf\xed\xbf\xbf"
    assert_invalid "\xed\xae\x80\xed\xb0\x80"
    assert_invalid "\xed\xae\x80\xed\xbf\xbf"
    assert_invalid "\xed\xaf\xbf\xed\xb0\x80"
    assert_invalid "\xed\xaf\xbf\xed\xbf\xbf"
  end

  def disabled_test_should_reject_illegal_code_positions
    assert_invalid "\xef\xbf\xbe"
    assert_invalid "\xef\xbf\xbf" 
  end
end
