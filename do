#!/bin/bash

action=$1; shift

projects=( java-coding-standards lidalia-parent lidalia-test lidalia-lang lidalia-slf4j-ext slf4j-test lidalia-test-dependencies sysout-over-slf4j  lidalia-net lidalia-http lidalia-http-impl )

function inDirectory() {
    local project=$1
    local command="$2"
    (cd $project; $command)
}

function topLevel() {
    local project=$1
    local newpattern=$2
    local command=`eval echo $newpattern`
    ($command)
}

function forAllProjects() {
  local exit_code=0
  local function=$1
  local description=$2
  local command=$3
  for project in "${projects[@]}"
  do
    echo "$description $project"
    $function $project "$command"
    exit_code=`expr $exit_code + $?`
  done

  if [ $exit_code -eq 0 ]
    then echo "********* $description SUCCESSFUL *********"
    else echo "!!!!!!!!! $description FAILED !!!!!!!!!"
  fi
}

case $action in
    "build")
      forAllProjects inDirectory 'Building' 'mvn clean install'
    ;;
    "update")
      forAllProjects inDirectory 'Updating' 'git pull'
    ;;
    "clone")
      forAllProjects topLevel 'Cloning' 'git clone https://github.com/Mahoney/$project.git'
    ;;
    *)
      echo "Sorry chief, no idea what you mean by '$action'"
      echo "Usage:"
      echo "$0 build | update | clone"
    ;;
esac

