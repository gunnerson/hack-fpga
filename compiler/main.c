//
// definitiions {{{1
#include <dirent.h>
#include <libgen.h>
#include <linux/limits.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define DT_REG 8
#define DT_UNKNOWN 0
#define MAX_NAME 64
#define MAX_SYMBOL_LENGTH 32
#define SLASH '/'

extern char *realpath(const char *restrict path, char *restrict resolved_path);
extern void compile(FILE *ifile, FILE *ofile);
extern void translate(FILE *ifile, FILE *ofile, const char *const name);
extern void assemble(FILE *ifile, FILE *ofile);
extern void hack2hex(FILE *ifile, FILE *ofile);
extern void sys_init(FILE *ofile, const char *const name);
//  }}}1

int main(int argc, char *argv[]) {
  // handle args {{{1
  if (argc < 2) {
    fprintf(stderr, "Usage: %s <path>\n", argv[0]);
    return EXIT_FAILURE;
  }

  char *path = realpath(argv[1], NULL);
  if (path == NULL) {
    perror("Couldn't resolve path");
    return EXIT_FAILURE;
  }

  struct stat *path_stat = malloc(sizeof(struct stat));
  if (path_stat == NULL) {
    perror("Error allocating memory");
    free(path);
    return EXIT_FAILURE;
  }
  if (stat(path, path_stat) == -1) {
    perror("Errot getting file attributes");
    free(path_stat);
    free(path);
    return EXIT_FAILURE;
  }

  // handle single file {{{1
  if (S_ISREG(path_stat->st_mode)) {
    char *dot = strrchr(path, '.');
    int file_type = 4;
    if (dot && !strcmp(dot, ".jack"))
      file_type = 0;
    else if (dot && !strcmp(dot, ".vm"))
      file_type = 1;
    else if (dot && !strcmp(dot, ".asm"))
      file_type = 2;
    else if (dot && !strcmp(dot, ".hack"))
      file_type = 3;
    else {
      fprintf(stderr, "Invalid file type\n");
      free(path_stat);
      free(path);
      return EXIT_FAILURE;
    }

    FILE *ifile = fopen(path, "r");
    switch (file_type) {

    case 0: // *.jack
      if (!ifile)
        break;
      strcpy(dot, ".vm");
      FILE *ofile = fopen(path, "w");
      if (ofile) {
        compile(ifile, ofile);
        fclose(ofile);
        fclose(ifile);
      }
      ifile = fopen(path, "r");

    case 1: // *.vm
      if (!ifile)
        break;
      strcpy(dot, ".asm");
      ofile = fopen(path, "w");
      if (ofile) {
        translate(ifile, ofile, "");
        fclose(ofile);
        fclose(ifile);
      }
      ifile = fopen(path, "r");

    case 2: // *.asm
      if (!ifile)
        break;
      strcpy(dot, ".hack");
      ofile = fopen(path, "w");
      if (ofile) {
        assemble(ifile, ofile);
        fclose(ofile);
        fclose(ifile);
      }
      ifile = fopen(path, "r");

    case 3: // *.hack
      if (!ifile)
        break;
      strcpy(dot, ".hex");
      ofile = fopen(path, "w");
      if (ofile) {
        hack2hex(ifile, ofile);
        fclose(ofile);
        fclose(ifile);
      }
    }

    free(path_stat);
    free(path);
    return EXIT_SUCCESS;
  }

  // handle directory {{{1
  DIR *dir = opendir(path);

  if (!dir) {
    perror("Error opening directory");
    free(path);
    return EXIT_FAILURE;
  }

  char *file_path = malloc(PATH_MAX);
  if (!file_path) {
    perror("Error allocating memory");
    free(path);
    return EXIT_FAILURE;
  }

  char project_name[MAX_NAME] = {};
  strcpy(project_name, basename(path));
  struct dirent *entry;

  // First pass: compile all *.jack files
  while ((entry = readdir(dir))) {
    if (entry->d_type == DT_REG || entry->d_type == DT_UNKNOWN) {
      char *dot = strrchr(entry->d_name, '.');
      if (dot && !strcmp(dot, ".jack")) {
        snprintf(file_path, PATH_MAX, "%s%c%s", path, SLASH, entry->d_name);
        printf("[+] Compiling %s\n", file_path);
        FILE *ifile = fopen(file_path, "r");
        if (ifile) {
          strcpy(dot, ".vm");
          snprintf(file_path, PATH_MAX, "%s%c%s", path, SLASH, entry->d_name);
          FILE *ofile = fopen(file_path, "w");
          if (ofile) {
            compile(ifile, ofile);
            fclose(ofile);
          } else
            perror("Error opening/creating file");
          fclose(ifile);
        } else
          perror("Error opening in file");
      }
    }
  }

  // Second pass: translate all *.vm files
  rewinddir(dir);
  snprintf(file_path, PATH_MAX, "%s%c%s.asm", path, SLASH, project_name);
  FILE *ofile = fopen(file_path, "w");
  if (ofile) {
    sys_init(ofile, project_name);
    while ((entry = readdir(dir))) {
      if (entry->d_type == DT_REG || entry->d_type == DT_UNKNOWN) {
        char *dot = strrchr(entry->d_name, '.');
        if (dot && !strcmp(dot, ".vm")) {
          snprintf(file_path, PATH_MAX, "%s%c%s", path, SLASH, entry->d_name);
          FILE *ifile = fopen(file_path, "r");
          if (ifile) {
            *dot = '\0';
            entry->d_name[MAX_SYMBOL_LENGTH - 1] = '\0';
            translate(ifile, ofile, entry->d_name);
            fclose(ifile);
          } else
            perror("Error opening in file");
        }
      }
    }
    fclose(ofile);
  } else
    perror("Error opening out file");

  // Third pass: translate *.asm to *.hack binary
  snprintf(file_path, PATH_MAX, "%s%c%s.asm", path, SLASH, project_name);
  FILE *ifile = fopen(file_path, "r");
  if (ifile) {
    snprintf(file_path, PATH_MAX, "%s%c%s.hack", path, SLASH, project_name);
    FILE *ofile = fopen(file_path, "w");
    if (ofile) {
      assemble(ifile, ofile);
      fclose(ofile);
    } else
      perror("Error opening out file");
    fclose(ifile);
  } else
    perror("Error opening in file");
  // }}}1

  // Forth pass: translate *.hack to *.hex binary
  snprintf(file_path, PATH_MAX, "%s%c%s.hack", path, SLASH, project_name);
  ifile = fopen(file_path, "r");
  if (ifile) {
    snprintf(file_path, PATH_MAX, "%s%c%s.hex", path, SLASH, project_name);
    FILE *ofile = fopen(file_path, "w");
    if (ofile) {
      hack2hex(ifile, ofile);
      fclose(ofile);
    } else
      perror("Error opening out file");
    fclose(ifile);
  } else
    perror("Error opening in file");
  // }}}1

  closedir(dir);
  free(path_stat);
  free(path);
  free(file_path);
  return EXIT_SUCCESS;
}
