aarch64-linux-gnu-gcc -mcpu=cortex-a57 -ggdb -g -O0 -Wall -Werror -fomit-frame-pointer -fno-common -nostdlib -c main.s -o main.o
aarch64-linux-gnu-ld -T linker.lds main.o -o main
aarch64-linux-gnu-objcopy --dump-section .boot=boot.bin main
