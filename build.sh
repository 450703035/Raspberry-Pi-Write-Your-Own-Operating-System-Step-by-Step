mkdir build
aarch64-unknown-linux-gnu-gcc -c src/boot.s -o build/boot.o
aarch64-unknown-linux-gnu-gcc -std=c99 -ffreestanding -mgeneral-regs-only -c src/main.c -o build/main.o
aarch64-unknown-linux-gnu-ld -nostdlib -T link.lds -o my-os.elf build/boot.o build/main.o
aarch64-unknown-linux-gnu-objcopy -O binary my-os.elf my-os.img