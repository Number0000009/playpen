# Apple //e + Mockingboard VIA timers stuff

## How to use cc65 with linapple

### Compile a program
```
ca65 mb.s
ld65 -o mb.bin -C ./cc65/cfg/apple2-asm.cfg mb.o
```
### Disk Image
AppleCommander console version.

Create a new disk image:
```
java -jar AppleCommander.jar -dos140 new.dsk
```
Copy the binary file onto the image:
```
java -jar AppleCommander.jar -p new.dsk MB B < mb.bin
```

## Emulator
LinApple emulator.
```
linapple --d1 res/Master.dsk --d2 new.dsk
[Ctrl+F2]
```
Once you see the prompt `]`
```
BRUN MB,D2,A$800
```
Program will start executing and then will hang for reasons unclear yet to me
(something with Language Card switches I presume...), so you have to:
1. break by using Ctrl-F10
2. go into the monitor by CALL-151
3. manually poke $C083 switch by just
```
*C083 C083
```

After that you'll see symbol starts changing in the top left screen corner -
that's the ISR for Mockingboard timer IRQs.

Enjoy.
