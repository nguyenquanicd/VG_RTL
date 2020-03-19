#! /bin/sh

export RISCV=/usr/local
export PATH=$RISCV/bin:$PATH

#git clone https://github.com/riscv/riscv-tests
#cd riscv-tests
#git submodule update --init --recursive
autoconf
./configure --prefix=$RISCV/riscv32-unknown-elf --with-xlen=32
#./configure --prefix=$RISCV/riscv64-unknown-elf --with-xlen=64
make isa
#make
