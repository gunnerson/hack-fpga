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
      g_commandNumber += 6;
      fprintf(output, "\t@%d\n", c);
      fprintf(output, "\tD=A\n");
    } else if (!strcmp(arg1, "static")) {
      g_commandNumber += 6;
      fprintf(output, "\t@%s.%d\n", fname, c);
      fprintf(output, "\tD=M\n");
    } else if (!strcmp(arg1, "temp")) {
      g_commandNumber += 9;
      fprintf(output, "\t@%d\n", c);
      fprintf(output, "\tD=A\n");
      fprintf(output, "\t@5\n");
      fprintf(output, "\tA=D+A\n");
      fprintf(output, "\tD=M\n");
    } else if (!strcmp(arg1, "pointer")) {
      g_commandNumber += 6;
      (c) ? fprintf(output, "\t@THAT\n") : fprintf(output, "\t@THIS\n");
      fprintf(output, "D=M\n");
    } else {
      char symbol[5] = {0};
      if (!strcmp(arg1, "local")) {
        strcpy(symbol, "LCL");
      } else if (!strcmp(arg1, "argument")) {
        strcpy(symbol, "ARG");
      } else if (!strcmp(arg1, "this")) {
        strcpy(symbol, "THIS");
      } else if (!strcmp(arg1, "that")) {
        strcpy(symbol, "THAT");
      } else {
        printf("%s\n", arg1);
        EXIT_ERROR("Invalid segment reference");
      }
      g_commandNumber += 9;
      fprintf(output, "\t@%d\n", c);
      fprintf(output, "\tD=A\n");
      fprintf(output, "\t@%s\n", symbol);
      fprintf(output, "\tA=D+M\n");
      fprintf(output, "\tD=M\n");
    }
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M+1\n");
    fprintf(output, "\tA=M-1\n");
    fprintf(output, "\tM=D\n");
    // pop {{{2
  } else if (!strcmp(command, "pop")) {
    if (!strcmp(arg1, "static")) {
      g_commandNumber += 5;
      fprintf(output, "\t@SP\n");
      fprintf(output, "\tAM=M-1\n");
      fprintf(output, "\tD=M\n");
      fprintf(output, "\t@%s.%s\n", fname, arg2);
      fprintf(output, "\tM=D\n");
    } else {
      if (!strcmp(arg1, "temp") || !strcmp(arg1, "pointer")) {
        g_commandNumber += 12;
        fprintf(output, "\t@%d\n", c);
        fprintf(output, "\tD=A\n");
        fprintf(output, "\t@%d\n", (strcmp(arg1, "temp")) ? 3 : 5);
        fprintf(output, "\tD=D+A\n");
      } else {
        char symbol[5] = {0};
        if (!strcmp(arg1, "local")) {
          strcpy(symbol, "LCL");
        } else if (!strcmp(arg1, "argument")) {
          strcpy(symbol, "ARG");
        } else if (!strcmp(arg1, "this")) {
          strcpy(symbol, "THIS");
        } else if (!strcmp(arg1, "that")) {
          strcpy(symbol, "THAT");
        } else {
          printf("%s\n", arg1);
          EXIT_ERROR("Invalid segment reference");
        }
        g_commandNumber += 12;
        fprintf(output, "\t@%d\n", c);
        fprintf(output, "\tD=A\n");
        fprintf(output, "\t@%s\n", symbol);
        fprintf(output, "\tD=D+M\n");
      }
      fprintf(output, "\t@R13\n");
      fprintf(output, "\tM=D\n");
      fprintf(output, "\t@SP\n");
      fprintf(output, "\tAM=M-1\n");
      fprintf(output, "\tD=M\n");
      fprintf(output, "\t@R13\n");
      fprintf(output, "\tA=M\n");
      fprintf(output, "\tM=D\n");
    }
    // add {{{2
  } else if (!strcmp(command, "add")) {
    g_commandNumber += 10;
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M-1\n");
    fprintf(output, "\tA=M\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M-1\n");
    fprintf(output, "\tA=M\n");
    fprintf(output, "\tM=D+M\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M+1\n");
    // sub {{{2
  } else if (!strcmp(command, "sub")) {
    g_commandNumber += 10;
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M-1\n");
    fprintf(output, "\tA=M\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M-1\n");
    fprintf(output, "\tA=M\n");
    fprintf(output, "\tM=M-D\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M+1\n");
    // neg {{{2
  } else if (!strcmp(command, "neg")) {
    g_commandNumber += 3;
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tA=M-1\n");
    fprintf(output, "\tM=-M\n");
    // eq {{{2
  } else if (!strcmp(command, "eq")) {
    g_commandNumber += 18;
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tAM=M-1\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tAM=M-1\n");
    fprintf(output, "\tD=M-D\n");
    fprintf(output, "\t@%s$__eq_%zu__\n", foo_name, lineNumber);
    fprintf(output, "\tD;JEQ\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tA=M\n");
    fprintf(output, "\tM=0\n");
    fprintf(output, "\t@%s$__cont_%zu__\n", foo_name, lineNumber);
    fprintf(output, "\t0;JMP\n");
    fprintf(output, "(%s$__eq_%zu__)\n", foo_name, lineNumber);
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tA=M\n");
    fprintf(output, "\tM=-1\n");
    fprintf(output, "(%s$__cont_%zu__)\n", foo_name, lineNumber);
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M+1\n");
    // gt {{{2
  } else if (!strcmp(command, "gt")) {
    g_commandNumber += 18;
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tAM=M-1\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tAM=M-1\n");
    fprintf(output, "\tD=M-D\n");
    fprintf(output, "\t@%s$__gt_%zu__\n", foo_name, lineNumber);
    fprintf(output, "\tD;JGT\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tA=M\n");
    fprintf(output, "\tM=0\n");
    fprintf(output, "\t@%s$__cont_%zu__\n", foo_name, lineNumber);
    fprintf(output, "\t0;JMP\n");
    fprintf(output, "(%s$__gt_%zu__)\n", foo_name, lineNumber);
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tA=M\n");
    fprintf(output, "\tM=-1\n");
    fprintf(output, "(%s$__cont_%zu__)\n", foo_name, lineNumber);
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M+1\n");
    // lt {{{2
  } else if (!strcmp(command, "lt")) {
    g_commandNumber += 18;
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tAM=M-1\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tAM=M-1\n");
    fprintf(output, "\tD=M-D\n");
    fprintf(output, "\t@%s$__lt_%zu__\n", foo_name, lineNumber);
    fprintf(output, "\tD;JLT\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tA=M\n");
    fprintf(output, "\tM=0\n");
    fprintf(output, "\t@%s$__cont_%zu__\n", foo_name, lineNumber);
    fprintf(output, "\t0;JMP\n");
    fprintf(output, "(%s$__lt_%zu__)\n", foo_name, lineNumber);
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tA=M\n");
    fprintf(output, "\tM=-1\n");
    fprintf(output, "(%s$__cont_%zu__)\n", foo_name, lineNumber);
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M+1\n");
    // and {{{2
  } else if (!strcmp(command, "and")) {
    g_commandNumber += 6;
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tAM=M-1\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tA=M-1\n");
    fprintf(output, "\tM=D&M\n");
    // or {{{2
  } else if (!strcmp(command, "or")) {
    g_commandNumber += 6;
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tAM=M-1\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tA=M-1\n");
    fprintf(output, "\tM=D|M\n");
    // not {{{2
  } else if (!strcmp(command, "not")) {
    g_commandNumber += 3;
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tA=M-1\n");
    fprintf(output, "\tM=!M\n");
    // label {{{2
  } else if (!strcmp(command, "label")) {
    fprintf(output, "(%s$%s)\n", foo_name, arg1);
    // goto {{{2
  } else if (!strcmp(command, "goto")) {
    g_commandNumber += 2;
    fprintf(output, "\t@%s$%s\n", foo_name, arg1);
    fprintf(output, "\t0;JMP\n");
    // if-goto {{{2
  } else if (!strcmp(command, "if-goto")) {
    g_commandNumber += 5;
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tAM=M-1\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@%s$%s\n", foo_name, arg1);
    fprintf(output, "\tD;JNE\n");
    // call {{{2
  } else if (!strcmp(command, "call")) {
    strcpy(foo_name, arg1);
    g_commandNumber += 41;
    fprintf(output, "\t@%s$__return_%u__\n", foo_name, g_commandNumber);
    fprintf(output, "\tD=A\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M+1\n");
    fprintf(output, "\tA=M-1\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\t@LCL\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M+1\n");
    fprintf(output, "\tA=M-1\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\t@ARG\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M+1\n");
    fprintf(output, "\tA=M-1\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\t@THIS\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M+1\n");
    fprintf(output, "\tA=M-1\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\t@THAT\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M+1\n");
    fprintf(output, "\tA=M-1\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\tD=A+1\n");
    fprintf(output, "\t@%d\n", c + 5);
    fprintf(output, "\tD=D-A\n");
    fprintf(output, "\t@ARG\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@LCL\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\t@%s\n", foo_name);
    fprintf(output, "\t0;JMP\n");
    fprintf(output, "(%s$__return_%u__)\n", foo_name, g_commandNumber);
    // function {{{2
  } else if (!strcmp(command, "function")) {
    strcpy(foo_name, arg1);
    g_commandNumber += 11;
    fprintf(output, "(%s)\n", foo_name);
    fprintf(output, "\t@%s\n", arg2);
    fprintf(output, "\tD=A\n");
    fprintf(output, "\t@%s$__endinit__\n", foo_name);
    fprintf(output, "\tD;JEQ\n");
    fprintf(output, "(%s$__init__)\n", foo_name);
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=M+1\n");
    fprintf(output, "\tA=M-1\n");
    fprintf(output, "\tM=0\n");
    fprintf(output, "\tD=D-1\n");
    fprintf(output, "\t@%s$__init__\n", foo_name);
    fprintf(output, "\tD;JGT\n");
    fprintf(output, "(%s$__endinit__)\n", foo_name);
    // return {{{2
  } else if (!strcmp(command, "return")) {
    g_commandNumber += 41;
    fprintf(output, "\t@LCL\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@R14\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\t@5\n");
    fprintf(output, "\tA=D-A\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@R15\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tAM=M-1\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@ARG\n");
    fprintf(output, "\tA=M\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\tD=A+1\n");
    fprintf(output, "\t@SP\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\t@R14\n");
    fprintf(output, "\tAM=M-1\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@THAT\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\t@R14\n");
    fprintf(output, "\tAM=M-1\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@THIS\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\t@R14\n");
    fprintf(output, "\tAM=M-1\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@ARG\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\t@R14\n");
    fprintf(output, "\tA=M-1\n");
    fprintf(output, "\tD=M\n");
    fprintf(output, "\t@LCL\n");
    fprintf(output, "\tM=D\n");
    fprintf(output, "\t@R15\n");
    fprintf(output, "\tA=M\n");
    fprintf(output, "\t0;JMP\n");
    // }}}2
  } else {
    EXIT_ERROR("Invalid command");
  }
  return EXIT_SUCCESS;
}

// sys_init {{{1
void sys_init(FILE *ofile, const char *const name) {
  fprintf(ofile, "// %s\n\n", name);
  fprintf(ofile, "// [0] Bootstrap Sys.init\n");
  fprintf(ofile, "\t@%u\n", STACK_ADDRESS);
  fprintf(ofile, "\tD=A\n");
  fprintf(ofile, "\t@SP\n");
  fprintf(ofile, "\tM=D\n");
  g_commandNumber += 4;

  char foo_name_init[9];
  write_command("call", "Sys.init", "0", foo_name_init, "", 0, ofile);
  fprintf(ofile, "\n");
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
