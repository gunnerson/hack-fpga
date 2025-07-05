//
// definitions {{{1
#include <ctype.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 128
#define MAX_TOKEN_LENGTH 8
#define INITIAL_CAPACITY 16
#define FNV_OFFSET 14695981039346656037UL
#define FNV_PRIME 1099511628211UL

#define START_SYMBOL_ADDRESS 16U
#define MAX_ADDRESS 57343U

#define EXIT_ERROR(t)                                                          \
  do {                                                                         \
    fprintf(stderr, "Error on line %zu: %s\n", lineNumber, t);                 \
    st_del(symbols);                                                           \
    return;                                                                    \
  } while (0)

// hash-table {{{1
// declarations {{{2
typedef struct {
  const char *key;
  unsigned value;
} Symbol;
typedef struct {
  Symbol *entries;
  size_t capacity;
  size_t length;
} SymbolTable;

// st_new {{{2
static SymbolTable *st_new(void) {
  SymbolTable *self = malloc(sizeof(SymbolTable));
  if (self == NULL) {
    perror("Failed to allocate memory!");
    return NULL;
  }
  self->length = 0;
  self->capacity = INITIAL_CAPACITY;
  self->entries = calloc(self->capacity, sizeof(Symbol));
  if (self->entries == NULL) {
    perror("Failed to allocate memory!");
    free(self);
    return NULL;
  }
  return self;
}

// st_del {{{2
static void st_del(SymbolTable *self) {
  for (size_t i = 0; i < self->capacity; i++) {
    free((void *)self->entries[i].key);
  }
  free(self->entries);
  free(self);
}

// st_hash {{{2
static uint64_t st_hash(const char *key) {
  uint64_t hash = FNV_OFFSET;
  for (const char *p = key; *p; p++) {
    hash ^= (uint64_t)(unsigned char)(*p);
    hash *= FNV_PRIME;
  }
  return hash;
}

// st_get {{{2
static int st_get(SymbolTable *self, const char *key) {
  uint64_t hash = st_hash(key);
  size_t index = (size_t)(hash & (uint64_t)(self->capacity - 1));
  while (self->entries[index].key != NULL) {
    if (strcmp(key, self->entries[index].key) == 0) {
      return self->entries[index].value;
    }
    index++;
    if (index >= self->capacity) {
      index = 0;
    }
  }
  return -1;
}

// st_set_entry {{{2
static const char *st_set_entry(Symbol *entries, size_t capacity,
                                const char *key, unsigned value,
                                size_t *length_ptr) {
  uint64_t hash = st_hash(key);
  size_t index = (size_t)(hash & (uint64_t)(capacity - 1));
  while (entries[index].key != NULL) {
    if (strcmp(key, entries[index].key) == 0) {
      entries[index].value = value;
      return entries[index].key;
    }
    index++;
    if (index >= capacity) {
      index = 0;
    }
  }
  if (length_ptr != NULL) {
    key = strdup(key);
    if (key == NULL) {
      perror("Failed to allocate memory!");
      return NULL;
    }
    (*length_ptr)++;
  }
  entries[index].key = (char *)key;
  entries[index].value = value;
  return key;
}

// st_expand {{{2
static bool st_expand(SymbolTable *self) {
  size_t new_capacity = self->capacity * 2;
  if (new_capacity < self->capacity) {
    return false;
  }
  Symbol *new_entries = calloc(new_capacity, sizeof(Symbol));
  if (new_entries == NULL) {
    perror("Failed to allocate memory!");
    return false;
  }
  for (size_t i = 0; i < self->capacity; i++) {
    Symbol entry = self->entries[i];
    if (entry.key != NULL) {
      st_set_entry(new_entries, new_capacity, entry.key, entry.value, NULL);
    }
  }
  free(self->entries);
  self->entries = new_entries;
  self->capacity = new_capacity;
  return true;
}

// st_set {{{2
static const char *st_set(SymbolTable *self, const char *key, unsigned value) {
  if (self->length >= self->capacity / 2) {
    if (!st_expand(self)) {
      return NULL;
    }
  }
  return st_set_entry(self->entries, self->capacity, key, value, &self->length);
}

// st_dump {{{2
[[maybe_unused]] static void st_dump(SymbolTable *self) {
  for (size_t i = 0; i < self->capacity; i++) {
    printf("%s\t%u\n", self->entries[i].key, self->entries[i].value);
  }
}

// assemble {{{1
void assemble(FILE *ifile, FILE *ofile) {
  // initialize symbols table {{{2
  SymbolTable *symbols = st_new();
  if (symbols == NULL) {
    perror("Failed to allocate memory!");
    return;
  }
  st_set(symbols, "SP", 0);
  st_set(symbols, "LCL", 1);
  st_set(symbols, "ARG", 2);
  st_set(symbols, "THIS", 3);
  st_set(symbols, "THAT", 4);
  st_set(symbols, "R0", 0);
  st_set(symbols, "R1", 1);
  st_set(symbols, "R2", 2);
  st_set(symbols, "R3", 3);
  st_set(symbols, "R4", 4);
  st_set(symbols, "R5", 5);
  st_set(symbols, "R6", 6);
  st_set(symbols, "R7", 7);
  st_set(symbols, "R8", 8);
  st_set(symbols, "R9", 9);
  st_set(symbols, "R10", 10);
  st_set(symbols, "R11", 11);
  st_set(symbols, "R12", 12);
  st_set(symbols, "R13", 13);
  st_set(symbols, "R14", 14);
  st_set(symbols, "R15", 15);
  st_set(symbols, "BUT", 16384);
  st_set(symbols, "SW", 16385);
  st_set(symbols, "LED", 16386);
  st_set(symbols, "SEG", 16387);
  st_set(symbols, "STATUS", 16388);

  st_set(symbols, "0", 42);
  st_set(symbols, "1", 63);
  st_set(symbols, "-1", 58);
  st_set(symbols, "D", 12);
  st_set(symbols, "A", 48);
  st_set(symbols, "!D", 13);
  st_set(symbols, "!A", 49);
  st_set(symbols, "-D", 15);
  st_set(symbols, "-A", 51);
  st_set(symbols, "D+1", 31);
  st_set(symbols, "A+1", 55);
  st_set(symbols, "D-1", 14);
  st_set(symbols, "A-1", 50);
  st_set(symbols, "D+A", 2);
  st_set(symbols, "D-A", 19);
  st_set(symbols, "A-D", 7);
  st_set(symbols, "D&A", 0);
  st_set(symbols, "D|A", 21);
  st_set(symbols, "M", 112);
  st_set(symbols, "!M", 113);
  st_set(symbols, "-M", 115);
  st_set(symbols, "M+1", 119);
  st_set(symbols, "M-1", 114);
  st_set(symbols, "D+M", 66);
  st_set(symbols, "D-M", 83);
  st_set(symbols, "M-D", 71);
  st_set(symbols, "D&M", 64);
  st_set(symbols, "D|M", 85);

  st_set(symbols, "@M", 1);
  st_set(symbols, "@D", 2);
  st_set(symbols, "MD", 3);
  st_set(symbols, "@A", 4);
  st_set(symbols, "AM", 5);
  st_set(symbols, "AD", 6);
  st_set(symbols, "AMD", 7);

  st_set(symbols, "JGT", 1);
  st_set(symbols, "JEQ", 2);
  st_set(symbols, "JGE", 3);
  st_set(symbols, "JLT", 4);
  st_set(symbols, "JNE", 5);
  st_set(symbols, "JLE", 6);
  st_set(symbols, "JMP", 7);

  // first pass {{{2
  char line[MAX_LINE_LENGTH] = {0};
  unsigned instrNumber = 0;
  for (size_t lineNumber = 1; fgets(line, sizeof(line), ifile); lineNumber++) {
    size_t j = 0;
    char symbol[MAX_LINE_LENGTH] = {0};
    bool isLabel = false;
    bool isInstr = false;

    for (size_t i = 0; i < strlen(line); i++) {
      char c = line[i];

      if (isLabel) {
        if (c == ')') {
          break;
        } else if (c == '_' || c == '.' || c == '$' || c == ':' ||
                   (c >= '0' && c <= '9') || (c >= 'a' && c <= 'z') ||
                   (c >= 'A' && c <= 'Z')) {
          symbol[j++] = c;
          continue;
        }
        EXIT_ERROR("Invalid label");
      }

      if (c == '\r' || c == '\n' || c == '/') {
        break;
      }
      if (c == ' ' || c == '\t')
        continue;
      if (c == '(') {
        isLabel = true;
        continue;
      }
      if (c == '@' || c == '0' || c == '1' || c == '-' || c == 'D' ||
          c == 'A' || c == 'M' || c == '!') {
        isInstr = true;
        break;
      }
      EXIT_ERROR("Invalid instruction");
    }

    if (*symbol) {
      if (instrNumber > MAX_ADDRESS) {
        EXIT_ERROR("Instruction address limit reached");
      }
      st_set(symbols, symbol, instrNumber);
    } else if (isInstr) {
      instrNumber++;
    }
  }

  // second pass {{{2
  rewind(ifile);
  unsigned nextAddress = START_SYMBOL_ADDRESS;
  for (size_t lineNumber = 1; fgets(line, sizeof(line), ifile); lineNumber++) {
    char aInstr[MAX_LINE_LENGTH] = {0};
    char token[MAX_LINE_LENGTH] = {0};
    char opcode[MAX_TOKEN_LENGTH] = {0};
    char dest[MAX_TOKEN_LENGTH] = {0};
    char comp[MAX_TOKEN_LENGTH] = {0};
    char jmp[MAX_TOKEN_LENGTH] = {0};
    size_t j = 0;
    int addr;
    unsigned comp_d = 0;
    unsigned dest_d = 0;
    unsigned jmp_d = 0;
    bool hasJump = false;
    bool isAInstr = false;

    for (size_t i = 0; i < strlen(line); i++) {
      char c = line[i];

      if (c == '/' || c == '\r' || c == '\n' || c == '(')
        break;
      if (!*opcode) {
        if (c == ' ' || c == '\t')
          continue;
        if (c == '@') {
          strcpy(opcode, "0");
          isAInstr = true;
        } else {
          strcpy(opcode, "111");
          token[j++] = c;
        }

      } else {
        if (isspace(c))
          break;
        if (isAInstr) {
          aInstr[j++] = c;
        } else {
          if (c == '=') {
            if (!strcmp(token, "M") || !strcmp(token, "D") ||
                !strcmp(token, "A")) {
              // Add "@" before dest M|D|A to diff symbol from comp
              snprintf(dest, MAX_TOKEN_LENGTH, "@%s", token);
            } else
              strcpy(dest, token);
            memset(token, 0, j);
            j = 0;
          } else if (c == ';') {
            strcpy(comp, token);
            j = 0;
            hasJump = true;
          } else
            token[j++] = c;
        }
      }
    }

    if (isAInstr) {
      if (isdigit(aInstr[0])) {
        addr = atoi(aInstr);
        if (addr > MAX_ADDRESS) {
          EXIT_ERROR("Address out of bounds");
        }
      } else {
        if (!strcmp(aInstr, "SP") || !strcmp(aInstr, "R0")) {
          addr = 0;
        } else {
          addr = st_get(symbols, aInstr);
          if (addr == -1) {
            if (nextAddress >= MAX_ADDRESS) {
              EXIT_ERROR("Instruction address limit reached");
            }
            addr = nextAddress++;
            st_set(symbols, aInstr, addr);
          }
        }
      }
      fprintf(ofile, "%016b\n", addr);

    } else if (!(strncmp(opcode, "111", 3))) {
      (hasJump) ? strcpy(jmp, token) : strcpy(comp, token);
      comp_d = st_get(symbols, comp);
      if (!comp_d) {
        EXIT_ERROR("Invalid instruction");
      }
      if (*dest) {
        dest_d = st_get(symbols, dest);
        if (!dest_d) {
          EXIT_ERROR("Invalid instruction");
        }
      }
      if (*jmp) {
        jmp_d = st_get(symbols, jmp);
        if (!jmp_d) {
          EXIT_ERROR("Invalid instruction");
        }
      }
      fprintf(ofile, "%s%07b%03b%03b\n", opcode, comp_d, dest_d, jmp_d);
    }
  }
  // }}}2
  st_del(symbols);
  return;
}
