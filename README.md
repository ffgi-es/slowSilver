# slowSilver

![](https://github.com/ffgi-es/slowSilver/workflows/Tests/badge.svg)
[![codecov](https://codecov.io/gh/ffgi-es/slowSilver/branch/master/graph/badge.svg)](https://codecov.io/gh/ffgi-es/slowSilver)

The start of an attempt to make a simple compiled language.

## Prerequisites

- [ruby](https://www.ruby-lang.org/): compiler language
- [nasm](https://www.nasm.us/): assembler language

This compiler is currently only written for Linux on x86.
There are currently no plans to expand on this.

## Running

To run the compiler with some code in a file, eg:
```
INT main => 2.
```
use the compiler command `./slwslvr` on the command line
```
$> ./slwslvr your_file.sag
```
output executeable is will be called `a.out` which can
be executed in a similar way:
```
$> ./a.out
```

## Language Documentation

Not much to document at the moment. It can currently only return
a single integer value... a postive integer value.
