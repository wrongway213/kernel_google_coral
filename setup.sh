#
# Environment setup metascript for arm64 Android kernel builds with Clang
# Copyright (C) 2019 Danny Lin <danny@kdrag0n.dev>
#
# This script must be *sourced* from a Bourne-compatible shell in order to
# function. Nothing will happen if you execute it.
#

BUILD_DIR="/home/wrongway/data"

# Path to executables in Clang toolchain
clang_bin="$BUILD_DIR/android/linux-x86/clang-r399163b/bin/"

# 64-bit GCC toolchain prefix
gcc_prefix64="$BUILD_DIR/android/aarch64-linux-android-4.9/bin/aarch64-linux-android-"

# 32-bit GCC toolchain prefix
gcc_prefix32="$BUILD_DIR/android/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-"

# Number of parallel jobs to run
# Do not remove; set to 1 for no parallelism.
jobs=$(nproc)

# Do not edit below this point
# ----------------------------

# Load the shared helpers
source helpers.sh

_ksetup_old_ld_path="$LD_LIBRARY_PATH"
_ksetup_old_path="$PATH"
export LD_LIBRARY_PATH="$clang_bin/../lib:$clang_bin/../lib64:$LD_LIBRARY_PATH"
export PATH="$clang_bin:$PATH"

# Index of variables for cleanup in unsetup
_ksetup_vars+=(
	clang_bin
	gcc_prefix64
	gcc_prefix32
	jobs
	kmake_flags
)

kmake_flags+=(
	CC="clang"
	AR="llvm-ar"
	NM="llvm-nm"
	LD="ld.lld"
	OBJCOPY="llvm-objcopy"
	OBJDUMP="llvm-objdump"
	STRIP="llvm-strip"

	CROSS_COMPILE="$gcc_prefix64"
	CROSS_COMPILE_ARM32="$gcc_prefix32"
	CLANG_TRIPLE="aarch64-linux-gnu-"

	KBUILD_COMPILER_STRING="$(get_clang_version clang)"
)


