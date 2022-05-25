#!/usr/bin/env bash
DIR=$1
shift
GCC=$1
shift
exec ${GCC} -B${DIR}/lib/ -isystem ${DIR}/watt/inc/ -isystem ${DIR}/sys-include/ -isystem ${DIR}/include/ -DWATT32_NO_OLDIES "$@"
