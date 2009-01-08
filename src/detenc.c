#include <stdio.h>
#include <unistd.h>
#include "libdetenc.h"
#include "usage.h"

void show_usage (void) {
  printf(USAGE_TEXT);
}

int main (int argc, char **argv) {
  FILE *fp;
  int quiet = 0;
  int opt;
  int i;
  char *filename;

  while ((opt = getopt(argc, argv, "qh")) != -1) {
    switch (opt) {
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
      printf("%s\n", detect_encoding(fp));
      fclose(fp);
    }
  }

  return 0;
}
