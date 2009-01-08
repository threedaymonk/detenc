#ifndef __detectors_h__

#define ENC_US_ASCII     "US-ASCII"
#define ENC_UTF_8        "UTF-8"
#define ENC_WINDOWS_1252 "WINDOWS-1252"
#define ENC_ISO_8859_15  "ISO-8859-15"
#define ENC_UNKNOWN      "UNKNOWN"

long find_first_non_us_ascii (FILE *fp);
int is_utf_8 (FILE *fp);
int is_iso_8859_15 (FILE *fp);
int is_windows_1252 (FILE *fp);

#define __detectors_h__
#endif
