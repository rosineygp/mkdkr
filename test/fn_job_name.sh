#!/bin/bash

testJobNameNotNull() {
    source .mkdkr
    NAME="testJobNameNotNull"
    .... "$NAME" > /dev/null
    assertNotNull "$JOB_NAME"
}

testJobKeepSessionName() {
    source .mkdkr
    _JOB_NAME="$JOB_NAME"           # get testJobNameNotNull JOB_NAME
    NAME="testJobKeepSessionName"
    .... "$NAME" > /dev/null        # try replace
    assertEquals "$JOB_NAME" "$_JOB_NAME"
}

testJobNameContains() {
    source .mkdkr
    unset JOB_NAME
    NAME="testJobNameContains"
    .... "$NAME" > /dev/null
    assertContains "$JOB_NAME" "$NAME"
}

testJobNameOutput() {
    source .mkdkr
    unset JOB_NAME
    NAME="testJobNameOutput"
    OUT_NAME=$(.... "$NAME")
    assertNotNull "$OUT_NAME"
}

testJobNameDateTime() {
    source .mkdkr
    unset JOB_NAME
    NAME="testJobNameDateTime"
    .... "$NAME" > /dev/null
    assertEquals "$(echo $JOB_NAME | cut -d'_' -f2 | wc -m)" "15"
}

# Load shUnit2.
. ./shunit2
