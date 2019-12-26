#!/usr/bin/env bash
pub get
pub run test_coverage
coveralls-lcov --repo-token $COVERALLS_TOKEN coverage/lcov.info