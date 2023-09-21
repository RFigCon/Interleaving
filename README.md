Writing an interleaving algorithm in 7 different languages, compiling the code with different compilers and flags, and comparing the times.

Tests are being ran in a Windows 10 machine, with a Ryzen 5 2600 and 16GB of RAM.

| Language | Best Time | Compiler and flags |
| -------- | --------- | -------------------- |
| Python | 4889 us | (python3) |
| Zig | 142 us | (zig build-exe) |
| Kotlin | 77 us | (kotlinc) |
| D | 53 us | (dmd) |
| C | 44 us | (gcc) |
| Java | 26 us | (javac) |
| D | 9 us | (ldc2 -release -O3) |
| C | 7 us | (gcc -Ofast) |
| Zig | 6 us | (zig build-exe -O ReleaseFast) |

*Kotlin is 2x slower than Java because I only implemented Kotlin using a StringBuilder. When also using a StringBuilder, Java's best time was 67 us.

Top 3 **WITH** explicit compiler optimizations:

    3. D    - 9 us
    2. C    - 7 us
    1. Zig  - 6 us

Top 3 **WITHOUT** explicit compiler optimizations:

    3. Java - 69 us
    2. D    - 53 us
    1. C    - 44 us

## D times (_with GC_)

    Base  ~~> uses allocator!string, allocating on every call to interleave and deinterleave
    Fast  ~~> uses char[], allocating on every call to interleave and deinterleave
    Optm  ~~> uses char[], allocs only once

| COMMAND     |        TYPE     |   TIME (MICRO) |
| ----------- | --------------- | ------------ |
| ldc2        |       (Base)    |   343 us |
| dmd         |       (Base)    |   315 us |
| dmd  -release -O  | (Base)    |   228 us |
| ldc2        |       (Fast)    |   67 us |
| ldc2        |       (Optm)    |   62 us |
| dmd         |       (Fast)    |   53 us |
| dmd         |       (Optm)    |   53 us |
| ldc2 -release -O3 | (Base)    |   48 us |
| dmd  -release -O  | (Fast)    |   24 us |
| ldc2 -release -O3 | (Fast)    |   13 us |
| dmd  -release -O  | (Optm)    |   13 us |
| ldc2 -release -O3 | (Optm)    |   9 us |


## Java times

    Base  ~~> uses String, creating new one on every call to interleave and deinterleave
    Fast  ~~> uses StringBuilder, allocating on every call to interleave and deinterleave
    Optm  ~~> uses char[], allocs only once

| COMMAND     |        TYPE     |   TIME (MICRO) |
| ----------- | --------------- | ------------ |
| javac       |       (Base)    |   4888 us |
| javac       |       (Fast)    |   67 us |
| javac       |       (Optm)    |   26 us |


## C times

    Base  ~~> uses char* and allocs (to heap) on every call to interleave and deinterleave
    Fast  ~~> uses char* and allocs (to heap) only once
    Optm  ~~> uses char[] and allocs (to stack) only once

| COMMAND     |        TYPE     |   TIME (MICRO) |
| ----------- | --------------- | ------------ |
| zig cc      |       (Base)    |   88 us |
| zig cc      |       (Fast)    |   87 us |
| zig cc      |       (Optm)    |   86 us |
| gcc         |       (Base)    |   44 us |
| gcc         |       (Fast)    |   44 us |
| gcc         |       (Optm)    |   44 us |
| zig cc -Ofast   |   (Fast)    |   10 us |
| zig cc -Ofast   |   (Optm)    |   10 us |
| zig cc -Ofast   |   (Base)    |   9 us |
| gcc -Ofast    |     (Base)    |   8 us |
| gcc -Ofast    |     (Optm)    |   8 us |
| gcc -Ofast    |     (Fast)    |   7 us |
