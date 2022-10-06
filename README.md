# Raspberry-Pi-Write-Your-Own-Operating-System-Step-by-Step
Raspberry Pi: Write Your Own Operating System Step by Step

# MAC os 
toolchians: https://thinkski.github.io/osx-arm-linux-toolchains/
$ brew install qemu

## 编译
$ make all
or
$ ./build.sh

## 调试
$ make debug

stop qemu
ctrl+a  x

$ lldb
$ file my-os.elf
$ gdb-remote 1234
$ l KMain

# windows


