CROSS_COMPILE ?= aarch64-linux-gnu-

CC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)ld

SRC := main.S init.S mmu.S ../../common/io.S ../../common/vectors.S

OUTPUT := main

INCLUDE := -I./ -I../../include

CFLAGS := \
	-Wall \
	-Werror \
	-fomit-frame-pointer \
	-fno-common \
	-nostdlib

LDFLAGS := -T linker.lds

all:
	$(CC) $(CFLAGS) $(INCLUDE) $(SRC) -c
	$(LD) $(LDFLAGS) main.o init.o mmu.o io.o vectors.o -o $(OUTPUT)

clean:
	rm $(OUTPUT) main.o init.o mmu.o io.o vectors.o
