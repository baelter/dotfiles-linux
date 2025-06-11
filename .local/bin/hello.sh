#!/bin/bash

sign-ssh-key
cd ~/84codes || exit
mr update -j 8
find . -name Gemfile -type f -execdir bundle ';'
