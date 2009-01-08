#include <stdio.h>

long find_first_non_us_ascii (FILE *fp) {
  int byte;

  while (1) {
    byte = fgetc(fp);
    if (byte == EOF)
      return -1;
    if (byte >= 0x80)
      return ftell(fp) - 1;
  }
}

int is_iso_8859_15 (FILE *fp) {
  int byte;

  while (1) {
    byte = fgetc(fp);
    if (byte == EOF)
      return 1;
    if (byte >= 0x80 && byte <= 0x9F)
      return 0;
  }
}

int is_windows_1252 (FILE *fp) {
  int byte;

  while (1) {
    byte = fgetc(fp);
    if (byte == EOF)
      return 1;
    // Shortcut common case of bytes under 0x81
    if (byte >= 0x81 && (byte == 0x81 || byte == 0x8D || byte == 0x8F || byte == 0x90 || byte == 0x9D))
      return 0;
  }
}
