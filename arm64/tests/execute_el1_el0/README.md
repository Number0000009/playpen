# A minimal baremetal test that executes some code in [Redacted].

## Plan
Initialise a minimal set of pages that is sufficient for entering and executing some code in [redacted].
1) Initialise MMU tables to be 1 to 1 mappings. Map UART0 to EL0 [Redacted] for printing out log;
2) Initialise pages for [redacted] and [redacted];
3) Copy some code into [redacted];
4) Enter EL0 [Redacted] (prints out `"Hello from [redacted]!!"`);
5) Go back to [redacted] via [redacted] (eret) (prints `"All done."`)

## How to build
`$ make`

## How to run
`./run.sh [fast model binary name]`

## Expected result
 ```
  ____________________
 <  [Redacted] test   >
  --------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
Currently in EL3
Initialising...
Going to EL1...
Currently in EL1
Setup MMU...

[Redacted] test cases:
Executing in a [Redacted]
Hello from [Redacted]!!
All done.
```

If something went wrong and fast model GUI window is enabled - all red LEDs will show, all green and yellow otherwise.

## Known limitations
- Map addresses are the same as destination addresses when in [Redacted];
- Pages (blocks) are 2MB.
