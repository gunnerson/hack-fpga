//
// definitions {{{1
#include <ctype.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MAX_LINE_LENGTH 128
#define MAX_SYMBOL_LENGTH 32
#define MAX_CONSTANT 32767
#define STACK_ADDRESS 256U

#define EXIT_ERROR(t)                                                          \
  do {                                                                         \
    fprintf(stderr, "Error on line %zu in file \"%s\": %s\n", lineNumber,      \
            g_file_name, t);                                                   \
    return EXIT_FAILURE;                                                       \
  } while (0)

static unsigned g_commandNumber = 0;
static const char *g_file_name;

// write_command {{{1
static int write_command(const char *const command, const char *const arg1,
                         const char *const arg2, char *foo_name,
                         const char *const fname, const size_t lineNumber,
                         FILE *output) {
  int c = atoi(arg2);
  if (c < 0 || c > MAX_CONSTANT) {
    EXIT_ERROR("Address out of bounds");
  }
  // push {{{2
  if (!strcmp(command, "push")) {
    if (!strcmp(arg1, "constant")) {
      g_commandNumber += 7;
      fprintf(output, "\t@%d\n\tD=A\n", c);
    } else if (!strcmp(arg1, "static")) {
      g_commandNumber += 7;
      fprintf(output, "\t@%s.%d\n\tD=M\n", fname, c);
    } else if (!strcmp(arg1, "temp")) {
      g_commandNumber += 7;
      fprintf(output, "\t@%d\n\tD=M\n", c + 5);
    } else if (!strcmp(arg1, "pointer")) {
      g_commandNumber += 7;
      (c) ? fprintf(output, "\t@THAT\n\tD=M\n")
          : fprintf(output, "\t@THIS\n\tD=M\n");
    } else {
      if (!strcmp(arg1, "local")) {
        fprintf(output, "\t@LCL\n");
      } else if (!strcmp(arg1, "argument")) {
        fprintf(output, "\t@ARG\n");
      } else if (!strcmp(arg1, "this")) {
        fprintf(output, "\t@THIS\n");
      } else if (!strcmp(arg1, "that")) {
        fprintf(output, "\t@THAT\n");
      } else {
        printf("%s\n", arg1);
        EXIT_ERROR("Invalid segment reference");
      }
      g_commandNumber += 10;
      fprintf(output, "\tD=M\n\t@%d\n\tA=D+A\n\tD=M\n", c);
    }
    fprintf(output, "\t@SP\n\tA=M\n\tM=D\n\t@SP\n\tM=M+1\n");
    // pop {{{2
  } else if (!strcmp(command, "pop")) {
    if (!strcmp(arg1, "static")) {
      g_commandNumber += 5;
      fprintf(output, "\t@SP\n\tAM=M-1\n\tD=M\n");
      fprintf(output, "\t@%s.%s\n\tM=D\n", fname, arg2);
    } else if (!strcmp(arg1, "pointer")) {
      g_commandNumber += 5;
      fprintf(output, "\t@SP\n\tAM=M-1\n\tD=M\n");
      (c) ? fprintf(output, "\t@THAT\n\tM=D\n")
          : fprintf(output, "\t@THIS\n\tM=D\n");
    } else {
      if (!strcmp(arg1, "temp")) {
        g_commandNumber += 10;
        fprintf(output,
                "\t@%d\n\tD=A\n\t@R13\n\tM=D\n\t@SP\n\tAM=M-1\n\tD=M\n"
                "\t@R13\n\tA=M\n\tM=D\n",
                c + 5);
      } else {
        if (!strcmp(arg1, "local")) {
          fprintf(output, "\t@LCL\n");
        } else if (!strcmp(arg1, "argument")) {
          fprintf(output, "\t@ARG\n");
        } else if (!strcmp(arg1, "this")) {
          fprintf(output, "\t@THIS\n");
        } else if (!strcmp(arg1, "that")) {
          fprintf(output, "\t@THAT\n");
        } else {
          printf("%s\n", arg1);
          EXIT_ERROR("Invalid segment reference");
        }
        g_commandNumber += 12;
        fprintf(output,
                "\tD=M\n\t@%d\n\tD=D+A\n\t@R13\n\tM=D\n\t@SP\n\tAM=M-1\n"
                "\tD=M\n\t@R13\n\tA=M\n\tM=D\n",
                c);
      }
    }
    // add {{{2
  } else if (!strcmp(command, "add")) {
    g_commandNumber += 6;
    fprintf(output, "\t@SP\n\tAM=M-1\n\tD=M\n\t@SP\n\tA=M-1\n\tM=D+M\n");
    // sub {{{2
  } else if (!strcmp(command, "sub")) {
    g_commandNumber += 6;
    fprintf(output, "\t@SP\n\tAM=M-1\n\tD=M\n\t@SP\n\tA=M-1\n\tM=M-D\n");
    // neg {{{2
  } else if (!strcmp(command, "neg")) {
    g_commandNumber += 3;
    fprintf(output, "\t@SP\n\tA=M-1\n\tM=-M\n");
    // eq {{{2
  } else if (!strcmp(command, "eq")) {
    g_commandNumber += 12;
    fprintf(output,
            "\t@SP\n\tAM=M-1\n\tD=M\n\t@SP\n\tA=M-1\n\tD=M-D\n\tM=-1\n"
            "\t@%s$__eq_%zu__\n\tD;JEQ\n\t@SP\n\tA=M-1\n\tM=0\n"
            "\t(%s$__eq_%zu__)\n\t",
            foo_name, lineNumber, foo_name, lineNumber);
    // gt {{{2
  } else if (!strcmp(command, "gt")) {
    g_commandNumber += 12;
    fprintf(output,
            "\t@SP\n\tAM=M-1\n\tD=M\n\t@SP\n\tA=M-1\n\tD=M-D\n\tM=-1\n"
            "\t@%s$__gt_%zu__\n\tD;JGT\n\t@SP\n\tA=M-1\n\tM=0\n"
            "\t(%s$__gt_%zu__)\n\t",
            foo_name, lineNumber, foo_name, lineNumber);
    // lt {{{2
  } else if (!strcmp(command, "lt")) {
    g_commandNumber += 12;
    fprintf(output,
            "\t@SP\n\tAM=M-1\n\tD=M\n\t@SP\n\tA=M-1\n\tD=M-D\n\tM=-1\n"
            "\t@%s$__lt_%zu__\n\tD;JLT\n\t@SP\n\tA=M-1\n\tM=0\n"
            "\t(%s$__lt_%zu__)\n\t",
            foo_name, lineNumber, foo_name, lineNumber);
    // and {{{2
  } else if (!strcmp(command, "and")) {
    g_commandNumber += 6;
    fprintf(output, "\t@SP\n\tAM=M-1\n\tD=M\n\t@SP\n\tA=M-1\n\tM=D&M\n");
    // or {{{2
  } else if (!strcmp(command, "or")) {
    g_commandNumber += 6;
    fprintf(output, "\t@SP\n\tAM=M-1\n\tD=M\n\t@SP\n\tA=M-1\n\tM=D|M\n");
    // not {{{2
  } else if (!strcmp(command, "not")) {
    g_commandNumber += 4;
    fprintf(output, "\t@SP\n\tA=M-1\n\tM=-M\n\tM=M-1\n");
    // label {{{2
  } else if (!strcmp(command, "label")) {
    fprintf(output, "(%s)\n", arg1);
    // goto {{{2
  } else if (!strcmp(command, "goto")) {
    g_commandNumber += 2;
    fprintf(output, "\t@%s\n\t0;JMP\n", arg1);
    // if-goto {{{2
  } else if (!strcmp(command, "if-goto")) {
    g_commandNumber += 5;
    fprintf(output, "\t@SP\n\tAM=M-1\n\tD=M\n\t@%s\n\tD;JNE\n", arg1);
    // call {{{2
  } else if (!strcmp(command, "call")) {
    strcpy(foo_name, arg1);
    g_commandNumber += 47;
    fprintf(output,
            "\t@%s$__return_%u__\n\tD=A\n\t@SP\n\tA=M\n\tM=D\n\t@SP\n\tM=M+1\n"
            "\t@LCL\n\tD=M\n\t@SP\n\tA=M\n\tM=D\n\t@SP\n\tM=M+1\n"
            "\t@ARG\n\tD=M\n\t@SP\n\tA=M\n\tM=D\n\t@SP\n\tM=M+1\n"
            "\t@THIS\n\tD=M\n\t@SP\n\tA=M\n\tM=D\n\t@SP\n\tM=M+1\n"
            "\t@THAT\n\tD=M\n\t@SP\n\tA=M\n\tM=D\n\t@SP\n\tM=M+1\n"
            "\t@%d\n\tD=A\n\t@SP\n\tD=M-D\n\t@ARG\n\tM=D\n"
            "\t@SP\n\tD=M\n\t@LCL\n\tM=D\n"
            "\t@%s\n\t0;JMP\n\t(%s$__return_%u__)\n",
            foo_name, g_commandNumber, c + 5, foo_name, foo_name,
            g_commandNumber);
    // function {{{2
  } else if (!strcmp(command, "function")) {
    strcpy(foo_name, arg1);
    fprintf(output, "(%s)\n", foo_name);
    for (int i = atoi(arg2); i > 0; --i) {
      g_commandNumber += 5;
      fprintf(output, "\t@SP\n\tA=M\n\tM=0\n\t@SP\n\tM=M+1\n");
    }
    // g_commandNumber += 12;
    // fprintf(output,
    // "\t@%s\n\tD=A\n\t@%s$__endinit__\n\tD;JEQ\n(%s$__init__)\n",
    //         arg2, foo_name, foo_name);
    // fprintf(output,
    //         "\t@SP\n\tA=M\n\tM=0\n\t@SP\n\tM=M+1\n"
    //         "\tD=D-1\n\t@%s$__init__\n\tD;JGT\n(%s$__endinit__)\n",
    //         foo_name, foo_name);
    // return {{{2
  } else if (!strcmp(command, "return")) {
    g_commandNumber += 39;
    fprintf(output, "\t@5\n\tD=A\n\t@LCL\n\tA=M-D\n\tD=M\n\t@R13\n\tM=D\n"
                    "\t@SP\n\tA=M-1\n\tD=M\n\t@ARG\n\tA=M\n\tM=D\n"
                    "\tD=A\n\t@SP\n\tM=D+1\n"
                    "\t@LCL\n\tAM=M-1\n\tD=M\n\t@THAT\n\tM=D\n"
                    "\t@LCL\n\tAM=M-1\n\tD=M\n\t@THIS\n\tM=D\n"
                    "\t@LCL\n\tAM=M-1\n\tD=M\n\t@ARG\n\tM=D\n"
                    "\t@LCL\n\tA=M-1\n\tD=M\n\t@LCL\n\tM=D\n"
                    "\t@R13\n\tA=M\n\t0;JMP\n");
    // }}}2
  } else {
    EXIT_ERROR("Invalid command");
  }
  return EXIT_SUCCESS;
}

// sys_init {{{1
void sys_init(FILE *ofile, const char *const name) {
  g_commandNumber += 6;
  fprintf(ofile, "// %s\n\n// [0] Bootstrap Sys.init\n", name);
  fprintf(ofile, "\t@%u\n\tD=A\n\t@SP\n\tM=D\n\t@Sys.init\n\t0;JMP\n\n",
          STACK_ADDRESS);
}

// parse_file {{{1
void translate(FILE *ifile, FILE *ofile, const char *const name) {
  g_file_name = name;
  fprintf(ofile, "// %s\n", name);
  char line[MAX_LINE_LENGTH];
  char foo_name[MAX_SYMBOL_LENGTH] = "foo";
  for (size_t lineNumber = 1; fgets(line, sizeof(line), ifile); lineNumber++) {
    char command[MAX_SYMBOL_LENGTH] = {0};
    char arg1[MAX_SYMBOL_LENGTH * 2] = "";
    char arg2[MAX_SYMBOL_LENGTH] = {0};
    char *c = line;
    char token[sizeof(arg1)] = "";

    for (size_t i = 0; i < MAX_SYMBOL_LENGTH * 2; c++) {
      if (isspace(*c) || *c == '/' || *c == '\0' ||
          i == MAX_SYMBOL_LENGTH * 2 - 1) {
        if (*token) {
          token[i] = '\0';
          if (!*command) {
            strncpy(command, token, sizeof(command) - 1);
          } else if (!*arg1) {
            strcpy(arg1, token);
          } else {
            strncpy(arg2, token, sizeof(arg2) - 1);
            break;
          }
          *token = '\0';
          i = 0;
          if (!*c)
            strcpy(c, "\n\0");
        }
        if (*c == '/' || *c == '\0') {
          break;
        }
      } else if (*c) {
        token[i++] = *c;
      }
    }

    if (*command) {
      fprintf(ofile, "// [%u] %s %s %s\n", g_commandNumber, command, arg1,
              arg2);
      if (write_command(command, arg1, arg2, foo_name, name, lineNumber, ofile))
        break;
    }
  }
  fprintf(ofile, "\n");
}
