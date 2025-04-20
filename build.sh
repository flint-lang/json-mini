#!/usr/bin/env sh

clang ./test/test.cpp -o testing -Iinclude -lstdc++ -std=c++17 \
    -g \
    -O0 \
    -Wall \
    -Wextra \
    -Wno-unused-parameter \
    -Wno-unused-variable \
    -Wno-deprecated-declarations \
    -fno-omit-frame-pointer \
    -funwind-tables \
    -D_GNU_SOURCE \
    -D__STDC_CONSTANT_MACROS \
    -D__STDC_FORMAT_MACROS \
    -D__STDC_LIMIT_MACROS
