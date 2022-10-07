mkdir build

board=rpi3
if [ $board == rpi3 ]; then
    COPS=-DCONFIG_BOARD_PI3B
    echo "rpi3"
elif [ $board == rpi4 ]; then
    COPS=-DCONFIG_BOARD_PI4B
    echo "rpi4"
else
    echo "other"
fi 
echo $COPS

aarch64-unknown-linux-gnu-gcc -c -Iinclude src/boot.s $COPS -o build/boot.o
aarch64-unknown-linux-gnu-gcc -c -Iinclude src/lib.s $COPS -o build/lib.o
aarch64-unknown-linux-gnu-gcc -std=c99 -ffreestanding -mgeneral-regs-only -Iinclude $COPS -c src/main.c -o build/main.o
aarch64-unknown-linux-gnu-gcc -std=c99 -ffreestanding -mgeneral-regs-only -Iinclude $COPS -c src/uart.c -o build/uart.o
aarch64-unknown-linux-gnu-ld -Map my-os.map -nostdlib -T link.lds -o my-os.elf build/boot.o build/lib.o build/main.o build/uart.o
aarch64-unknown-linux-gnu-objcopy -O binary my-os.elf my-os.img