create a new project:
pebble new-project --simple projectname

build:
cd projectname
pebble build

run:
pebble install --emulator aplite

run baremetal ufw:
qemu-pebble -machine pebble-bb2 -cpu cortex-m3 -s -pflash ./fw.qemu_flash.bin
