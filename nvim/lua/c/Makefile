CFLAGS=-Wall -shared -fPIC
INCLUDE=-I/usr/include/lua5.1
LIBS=-llua5.1

all: ratio.so

ratio.so: ratio.c
	gcc ${CFLAGS} ${INCLUDE} ${LIBS} -o ../$@ $<

.PHONY: all
