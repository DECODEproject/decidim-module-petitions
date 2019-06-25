#!/bin/bash

DIR=`dirname $0`

while getopts p:e: option
do
  case "${option}"
    in
    p) HASH=${OPTARG}
             RUN=0;;
    e) COMMAND=${OPTARG}
             RUN=1;;
  esac
done

if [ "$RUN" = "1" ]; then
  echo "$COMMAND"
fi

if [ "$RUN" = "0" ]; then
  echo $HASH | $DIR/zenroom-static 2> /dev/null
fi

