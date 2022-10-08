# Raspberry-Pi-Write-Your-Own-Operating-System-Step-by-Step
Raspberry Pi: Write Your Own Operating System Step by Step

# QEMU

有两种安装方式;

## 第一种源码编译安装
### DOWNLOAD
https://gitlab.com/philmd/qemu-renamed-as-gitlab-cant-associate-with-upstream/-/tree/raspi4_wip
```
$ git clone https://gitlab.com/philmd/qemu-renamed-as-gitlab-cant-associate-with-upstream.git
$ git checkout raspi4_wip
```

### 编译
ubuntu20.04:
```
$ mkdir build
$ cd build

$ ../configure --target-list=arm-softmmu,arm-linux-user,aarch64-linux-user,aarch64-softmmu --enable-sdl
$ sudo apt install libglib2.0-dev
$ sudo apt install libpixman-1-dev
$ sudo apt-get install libsdl2-dev
$ make
$ make install
```
mac:
```
mkdir build
cd build

../configure --target-list=arm-softmmu,aarch64-softmmu --enable-cocoa

make
make install
```
qemu build failed: syscall.c:8526: undefined reference to `stime'
```
--- a/linux-user/syscall.c
+++ b/linux-user/syscall.c
@@ -7651,10 +7651,12 @@ static abi_long do_syscall1(void *cpu_en
 #ifdef TARGET_NR_stime /* not on alpha */
     case TARGET_NR_stime:
         {
-            time_t host_time;
-            if (get_user_sal(host_time, arg1))
+            struct timespec ts;
+            ts.tv_nsec = 0;
+            if (get_user_sal(ts.tv_sec, arg1)) {
                 return -TARGET_EFAULT;
-            return get_errno(stime(&host_time));
+            }
+            return get_errno(clock_settime(CLOCK_REALTIME, &ts));
         }
 #endif
 #ifdef TARGET_NR_alarm /* not on alpha */
```

### 第二种 命令行安装
ubuntu20.04
```
$ apt-get install qemu qemu-system qemu-user
```
mac
```
$ brew install qemu
```

# toolchians
ubunut20.04
```
$ sudo apt-get install gcc-10-aarch64-linux-gnu
# 为方便使用可以软连接或者重命名aarch64-linux-gnu-gcc-10
$ mv  /usr/bin/aarch64-linux-gnu-gcc-10  /usr/bin/aarch64-linux-gnu-gcc
```

mac
toolchians: https://thinkski.github.io/osx-arm-linux-toolchains/


# 编译


```
$ make
or
$ ./build.sh
```
# 调试
```
$ make debug
```
stop qemu
ctrl+a  x

ubuntu20.04
```
$ gdb-multiarch
$ target remote localhost:1234
```

mac
```
$ lldb
$ file my-os.elf
$ gdb-remote 1234
$ l KMain
```


