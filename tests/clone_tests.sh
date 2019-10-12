#!/usr/bin/env bash

export RUN_MAIN=false
. ../clone
unset RUN_MAIN

testParseRepo() {
  assertEquals foo "$(parseRepo http://gitlab.com/Another/foo.git)"
  assertEquals foo "$(parseRepo https://gitlab.com/Another/foo.git)"
  assertEquals foo "$(parseRepo git@gitlab.com:Another/foo.git)"
  assertEquals foo "$(parseRepo git://gitlab.com/Another/foo.git)"
  assertEquals foo "$(parseRepo ssh://git@gitlab.com/Another/foo.git)"
}

doTestBuildUrl() {
  local input=$1
  local expected=$2
  assertEquals "$expected" "$(buildUrl "$input" github.com Default ssh git)"
  assertEquals "$expected" "$(USER=Default; buildUrlWithDefaults "$input")"
}

testBuildUrl() {
  doTestBuildUrl http://gitlab.com/Another/foo.git    http://gitlab.com/Another/foo.git
  doTestBuildUrl https://gitlab.com/Another/foo.git   https://gitlab.com/Another/foo.git
  doTestBuildUrl git@gitlab.com:Another/foo.git       git@gitlab.com:Another/foo.git
  doTestBuildUrl git://gitlab.com/Another/foo.git     git://gitlab.com/Another/foo.git
  doTestBuildUrl ssh://git@gitlab.com/Another/foo.git ssh://git@gitlab.com/Another/foo.git
  doTestBuildUrl gitlab.com/Another/foo               ssh://git@gitlab.com/Another/foo.git
  doTestBuildUrl Another/foo                          ssh://git@github.com/Another/foo.git
  doTestBuildUrl foo                                  ssh://git@github.com/Default/foo.git
}

. ../shunit2/shunit2
