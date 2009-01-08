#include <stdio.h>
#include "detectors.h"

char const *detect_encoding (FILE *fp) {
  long interesting_offset;

  interesting_offset = find_first_non_us_ascii(fp);
  if (interesting_offset == -1)
    return ENC_US_ASCII;

  fseek(fp, interesting_offset, SEEK_SET);
  if (is_utf_8(fp))
    return ENC_UTF_8;

  fseek(fp, interesting_offset, SEEK_SET);
  if (is_iso_8859_15(fp))
    return ENC_ISO_8859_15;

  fseek(fp, interesting_offset, SEEK_SET);
  if (is_windows_1252(fp))
    return ENC_WINDOWS_1252;

  return ENC_UNKNOWN;
}
