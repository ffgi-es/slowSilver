# slowSilver

![](https://github.com/ffgi-es/slowSilver/workflows/Tests/badge.svg)
[![codecov](https://codecov.io/gh/ffgi-es/slowSilver/branch/master/graph/badge.svg)](https://codecov.io/gh/ffgi-es/slowSilver)

The start of an attempt to make a simple compiled language.

## Prerequisites

- A linux OS (tested on [ArchLinux](https://www.archlinux.org))
- [ruby](https://www.ruby-lang.org/): compiler language
- [nasm](https://www.nasm.us/): assembler language

This compiler is currently only written for Linux on x86.
There are currently no plans to expand on this.

## Installation

Given the compiler currently only requires standard library ruby, it should be possible to run the compiler
without any further steps assuming you have successfully installed ruby and nasm.

### Running the Tests

The tests require some ruby gems to be installed, which can be most easy acheived
using [bundler](https://bundler.io/) and the following command in the root directory
```sh
$> bundle install
```
Once this has installed the required gems, it should be possible to run
the tests with
```sh
$> rspec
```

## Running the Compiler

To run the compiler with some code in a file,
use the compiler command `./slwslvr` on the command line
```sh
$> ./slwslvr your_file.sag
```
output executeable is will be called `a.out` which can
be executed in a similar way:
```sh
$> ./a.out
```

## Language Documentation

Further documentation can be found on the [wiki](https://github.com/ffgi-es/slowSilver/wiki)
