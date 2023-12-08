# Makefile for the C code in async-socket-server.
#
# Eli Bendersky [http://eli.thegreenplace.net]
# This code is in the public domain.
CC = gcc
CCFLAGS = -std=gnu99 -Wall -O3 -g -DNDEBUG -pthread
LDFLAGS = -lpthread -pthread

# It's possible to compile uv-server after installing libuv. The full
# instructions for installation I used (including `make install`) are from:
# https://github.com/libuv/libuv/blob/master/README.md.
# libuv compiles into a shared library which is placed alongside the .a in the
# installation directory.
LDLIBUV = -luv -Wl,-rpath=/usr/local/lib

EXECUTABLES = \
	sequential-server \
	threaded-server \
	blocking-listener \
	nonblocking-listener \
	select-server \
	epoll-server \
	uv-server \
	uv-timer-sleep-demo \
	uv-timer-work-demo \
	uv-isprime-server \
	threadspammer \


all: $(EXECUTABLES)

sequential-server: utils.c 01_sequential-server.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS)

threadspammer: 02_threadspammer.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS)

threaded-server: utils.c 02_threaded_server.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS)

blocking-listener: utils.c 03_blocking_server.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS)

nonblocking-listener: utils.c 03_nonblocking_server.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS)

select-server: utils.c 03_select_server.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS)

epoll-server: utils.c 03_epoll_server.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS)

uv-timer-sleep-demo: utils.c 04_uv_timer_sleep_demo.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS) $(LDLIBUV)

uv-timer-work-demo: utils.c 04_uv_timer_work_demo.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS) $(LDLIBUV)

uv-server: utils.c 04_uv_server.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS) $(LDLIBUV)

uv-isprime-server: utils.c 04_uv_isprime_server.c
	$(CC) $(CCFLAGS) $^ -o $@ $(LDFLAGS) $(LDLIBUV)


.PHONY: clean format

clean:
	rm -f $(EXECUTABLES) *.o

format:
	clang-format -style=file -i *.c *.h