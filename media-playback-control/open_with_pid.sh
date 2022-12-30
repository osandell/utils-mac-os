#!/bin/bash

ps -ax | grep $1 | sed -n '1p' |  sed 's/[^\/]*//' | sed 's/.*/"&"/' | xargs open -a
