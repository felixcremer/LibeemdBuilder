# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "libeemd"
version = v"1.4.0"

# Collection of sources required to build libeemdBuilder
sources = [
    "https://bitbucket.org/luukko/libeemd.git" =>
    "385e1cf063f28efef5b5bbdb2b6696d4e288ca14",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd libeemd/
make
PREFIX=$prefix make install
exit

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libeemd", Symbol(""))
]

# Dependencies that must be installed before this package can be built
dependencies = [
    "https://github.com/giordano/GSLBuilder.jl/releases/download/v2.5/build_GSL.v2.5.0.jl"
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

