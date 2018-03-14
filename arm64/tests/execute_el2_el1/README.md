# A minimal baremetal test that executes some code in an EL1 [Redacted].

## Plan
Initialise a minimal set of pages that is sufficient for entering and executing some code in an EL1 [Redacted].
1) Initialise EL2 MMU tables to be 1 to 1 mappings, VTTBR0_EL2, initialise EL1 MMU tables, including UART0 for printing out log;
2) Initialise pages for [Redacted], [Redacted], [Redacted] and [Redacted] Code;
3) Copy some code into [Redacted];
4) Enter [Redacted] (prints out `"Hello from EL1!!"`);
5) Go back to [Redacted] via undefined instruction abort (prints `"All done."`)

## How to build
`make`

## How to run
`./run.sh [fast model binary name]`

## Expected result
 ```
  ____________________
<   [Redacted] test   >
  --------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
Currently in EL3
Initialising...
Going to EL2...
Currently in EL2
Setup MMU...

[Redacted] test cases:
Executing in an EL1 [Redacted]
Hello from [Redacted]!!
All done.
```

If something went wrong and fast model GUI window is enabled - all red LEDs will show, all green and yellow otherwise.

## Known limitations
- Pages (blocks) are 2MB.
