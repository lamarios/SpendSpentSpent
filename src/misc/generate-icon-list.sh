#!/bin/sh

 cat $1 |  grep 'icon.*{' | sed 's/\./ALL.add("/g' | sed 's/ {/");/g'
