#!/usr/bin/env bash

source ".functions"

function testLowerCase() {
  local test_string="ABC_abc_ÖÄÜ_öäü_!\"§";
  local test_result=$(lc $test_string);
  local test_expected="abc_abc_öäü_öäü_!\"§";

  assertEquals $test_expected $test_result
}

function testUpperCase() {
  local test_string="ABC_abc_ÖÄÜ_öäü_!\"§";
  local test_result=$(uc $test_string);
  local test_expected="ABC_ABC_ÖÄÜ_ÖÄÜ_!\"§";

  assertEquals $test_expected $test_result
}

# run tests

if [ -n "${ZSH_VERSION:-}" ]; then
  setopt shwordsplit

  SHUNIT_PARENT=$0
fi

. shunit2
