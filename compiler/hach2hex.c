#include <stdio.h>
#include <stdlib.h>

#define MAX_LINE_LENGTH 32
#define MEMORY_SIZE 65536

void hack2hex(FILE *ifile, FILE *ofile) {
  char line[MAX_LINE_LENGTH] = {0};
  for (unsigned i = 0; i < MEMORY_SIZE; ++i) {
    unsigned data = 0;
    if (fgets(line, sizeof(line), ifile))
      data = (unsigned)strtol(line, NULL, 2);
    unsigned sum = 2;
    unsigned char *byte_ptr = (unsigned char *)&i;
    for (int j = 0; j < sizeof(i); ++j) {
      sum += byte_ptr[j];
    }
    byte_ptr = (unsigned char *)&data;
    for (int j = 0; j < sizeof(data); ++j) {
      sum += byte_ptr[j];
    }
    unsigned checksum = (~(sum & 0xff) + 1) & 0xff;
    fprintf(ofile, ":02%04X00%04X%02X\n", i, data, checksum);
  }
  fprintf(ofile, ":00000001FF\n");
  return;
}
