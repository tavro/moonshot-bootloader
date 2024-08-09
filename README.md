# moonshot-bootloader

instructions on how to create the boot image

create a blank disk image
```bash
dd if=/dev/zero of=boot.img bs=512 count=1
```

write the bootloader binary to the disk image
```bash
dd if=bootloader.bin of=boot.img bs=512 count=1 conv=notrunc
```

run it with QEMU
```bash
qemu-system-x86_64 -drive format=raw,file=boot.img
```