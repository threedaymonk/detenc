#include <stdio.h>
#define non_printing_control_char(byte) ((byte) <= 0x08 || ((byte) >= 0x0E && (byte) <= 0x1F))

long find_first_non_us_ascii (FILE *fp) {
  int byte;

  while (1) {
    byte = fgetc(fp);
    if (byte == EOF)
      return -1;
    if (byte >= 0x7F || non_printing_control_char(byte))
      return ftell(fp) - 1;
  }
}

int is_iso_8859_15 (FILE *fp) {
  int byte;

  while (1) {
    byte = fgetc(fp);
    if (byte == EOF)
      return 1;
    if (byte >= 0x7F && byte <= 0x9F)
      return 0;
    if (non_printing_control_char(byte))
      return 0;
  }
}

int is_windows_1252 (FILE *fp) {
  int byte;

  while (1) {
    byte = fgetc(fp);
    if (byte == EOF)
      return 1;
    // Shortcut common case
    if (byte >= 0x7F && (byte == 0x7F || byte == 0x81 || byte == 0x8D || byte == 0x8F || byte == 0x90 || byte == 0x9D))
      return 0;
    if (non_printing_control_char(byte))
      return 0;
  }
}
