#!/bin/bash

cd logs && for d in `ls`; do 
  cp /dev/null $d;
done
