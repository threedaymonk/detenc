#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include "libdetenc.h"

void show_usage (void) {
  printf(
    #include "usage.inc"
  );
}

int main (int argc, char **argv) {
  FILE *fp;
  int quiet = 0;
  int show_offset = 0;
  int opt;
  int i;
  char *filename;
  const char *encoding;

  while ((opt = getopt(argc, argv, "oqh")) != -1) {
    switch (opt) {
      case 'o':
        show_offset = 1;
        break;
      case 'q':
        quiet = 1;
        break;
      case 'h':
        show_usage();
        return 0;
      default:
        fprintf(stderr, "Unknown option -%c", opt);
        show_usage();
        return 1;
    }
  }

  if (optind == argc) {
    fprintf(stderr, "No files specified.\n");
    show_usage();
    return 1;
  }

  for (i = optind; i < argc; i++) {
    filename = argv[i];
    fp = fopen(filename, "rb");

    if (fp == NULL) {
      fprintf(stderr, "Can't open file '%s' for reading.\n", filename);
    } else {
      if (!quiet)
        printf("%s: ", filename);
      encoding = detect_encoding(fp);
      printf("%s", encoding);
      if (show_offset && strcmp("UNKNOWN", encoding) == 0)
        printf(" near offset %ld (0x%lX)", (long)ftell(fp), (long)ftell(fp));
      printf("\n");
      fclose(fp);
    }
  }

  return 0;
}
