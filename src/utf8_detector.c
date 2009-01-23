#include <stdio.h>

int is_utf_8 (FILE *fp) {
  int byte;

utf8_null:
  byte = fgetc(fp);
  if (byte == EOF)
    goto utf8_finished;
  if (byte < 0x7F)         // US-ASCII
    goto utf8_null;
  if (byte >> 5 == 0x06)   // 110x xxxx  2-byte sequence
    goto utf8_2b_1;
  if (byte >> 4 == 0x0E)   // 1110 xxxx  3-byte-sequence
    goto utf8_3b_1;
  if (byte >> 3 == 0x1E) { // 1111 0xxx  4-byte sequence
    if (byte < 0xF4)       // 1111 0100
      goto utf8_4b_1;      // No chance of being > U+10FFFF
    if (byte == 0xF4)
      goto utf8_4b_1_max;  // Last possible leading byte for codepoints >= U+10FFFF
  }
  goto utf8_error;

utf8_2b_1:
  byte = fgetc(fp);
  if (byte == EOF)
    goto utf8_error;
  if (byte >> 6 == 0x02) // 10xx xxxx
    goto utf8_null;
  goto utf8_error;

utf8_3b_1:
  byte = fgetc(fp);
  if (byte == EOF)
    goto utf8_error;
  if (byte >> 6 == 0x02) // 10xx xxxx
    goto utf8_3b_2;
  goto utf8_error;

utf8_3b_2:
  byte = fgetc(fp);
  if (byte == EOF)
    goto utf8_error;
  if (byte >> 6 == 0x02) // 10xx xxxx
    goto utf8_null;
  goto utf8_error;

utf8_4b_1:
  byte = fgetc(fp);
  if (byte == EOF)
    goto utf8_error;
  if (byte >> 6 == 0x02) // 10xx xxxx
    goto utf8_4b_2;
  goto utf8_error;

utf8_4b_1_max:
  byte = fgetc(fp);
  if (byte == EOF)
    goto utf8_error;
  if (byte >= 0x90)      // 1001 0000
    goto utf8_error;
  if (byte >> 6 == 0x02) // 10xx xxxx
    goto utf8_4b_2;
  goto utf8_error;

utf8_4b_2:
  byte = fgetc(fp);
  if (byte == EOF)
    goto utf8_error;
  if (byte >> 6 == 0x02) // 10xx xxxx
    goto utf8_4b_3;
  goto utf8_error;

utf8_4b_3:
  byte = fgetc(fp);
  if (byte == EOF)
    goto utf8_error;
  if (byte >> 6 == 0x02) // 10xx xxxx
    goto utf8_null;
  goto utf8_error;

utf8_error:
  return 0;

utf8_finished:
  return 1;
}
