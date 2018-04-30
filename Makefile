.POSIX:
CFLAGS = -std=c99 -Wall -Wextra -O3 -g3

tests: tests.c buf.h
	$(CC) $(LDFLAGS) $(CFLAGS) -o $@ tests.c $(LDLIBS)

test: check
check: tests
	./tests

clean:
	rm -f tests
