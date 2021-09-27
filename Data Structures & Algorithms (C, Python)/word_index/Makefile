CC = gcc

define CFLAGS
-std=c11 \
-g3 \
-fsanitize=address \
-Wpedantic \
-Wall \
-Wextra \
-Wformat=2 \
-Wsign-conversion \
-Wswitch-enum \
-Wno-switch-default \
-Wunused \
-Wfloat-equal \
-Wconversion \
-Wpointer-arith \
-Wtype-limits \
-Wcast-qual \
-Wenum-compare \
-Wsizeof-pointer-memaccess \
-Wstrict-prototypes
endef

LDFLAGS = -fsanitize=address

# Flags needed for the check library
CHECK_LDFLAGS = $(LDFLAGS) `pkg-config --libs check`

PROG = lookup
TESTS = check_array check_hash_table

all: $(PROG)

*.o: *.c

lookup: array.o hash_table.o hash_func.o main.o
	$(CC) -o $@  $^ $(CFLAGS)

clean:
	rm -f *.o $(PROG) $(TESTS)

tarball: hash_table_submit.tar.gz

hash_table_submit.tar.gz: main.c array.c hash_table.c hash_func.c hash_func.h AUTHORS
	tar -czf $@ $^

check_array: check_array.o array.o
	$(CC) -o $@ $^ $(CHECK_LDFLAGS)

check_hash_table: check_hash_table.o array.o hash_func.o hash_table.o
	$(CC) -o $@ $^ $(CHECK_LDFLAGS)

check: all $(TESTS)
	@echo "Checking array implementation..."
	./check_array
	@echo "\nChecking hash table implementation..."
	./check_hash_table
	@echo "\nChecking lookup table output..."
	./check_lookup.sh
