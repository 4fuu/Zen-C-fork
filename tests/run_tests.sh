#!/bin/bash

# Zen-C Test Suite Runner
# Usage: ./tests/run_tests.sh [zc options]
#
# Examples:
#   ./tests/run_tests.sh                    # Test with default compiler (gcc)
#   ./tests/run_tests.sh --cc clang         # Test with clang
#   ./tests/run_tests.sh --cc zig           # Test with zig cc
#   ./tests/run_tests.sh --cc tcc           # Test with tcc

# Configuration
ZC="./zc"
TEST_DIR="tests"
PASSED=0
FAILED=0
FAILED_TESTS=""

# Display which compiler is being used
CC_NAME="gcc (default)"
for arg in "$@"; do
    if [ "$prev_arg" = "--cc" ]; then
        CC_NAME="$arg"
        break
    fi
    prev_arg="$arg"
done

echo "** Running Zen C test suite (compiler: $CC_NAME) **"

if [ ! -f "$ZC" ]; then
    echo "Error: zc binary not found. Please build it first."
    exit 1
fi

for test_file in "$TEST_DIR"/*.zc; do
    [ -e "$test_file" ] || continue

    echo -n "Testing $(basename "$test_file")... "
    
    output=$($ZC run "$test_file" "$@" 2>&1)
    exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        echo "PASS"
        ((PASSED++))
    else
        echo "FAIL"
        ((FAILED++))
        FAILED_TESTS="$FAILED_TESTS\n- $(basename "$test_file")"
    fi
done

echo "----------------------------------------"
echo "Summary:"
echo "-> Passed: $PASSED"
echo "-> Failed: $FAILED"
echo "----------------------------------------"

if [ $FAILED -ne 0 ]; then
    echo -e "Failed tests:$FAILED_TESTS"
    rm -f a.out out.c
    exit 1
else
    echo "All tests passed!"
    rm -f a.out out.c
    exit 0
fi
