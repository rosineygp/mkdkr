#!/bin/bash

testCreateJobInstance() {
    source .mkdkr
    export JOB_NAME="testCreateJobInstance"
    ... job alpine
    # assertNotNull "$JOB_NAME"
}

# Load shUnit2.
. ./shunit2
