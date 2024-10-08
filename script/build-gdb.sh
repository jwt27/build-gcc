cd ${BASE}/build

if [ ! -z ${GDB_VERSION} ]; then
  if [ ! -e gdb-${GDB_VERSION}/gdb-unpacked ]; then
    echo "Unpacking gdb..."
    untar ${GDB_ARCHIVE} || exit 1

    cd gdb-${GDB_VERSION}/ || exit 1
    cat ${BASE}/patch/gdb-${GDB_VERSION}/* | patch -p1 -u || exit 1
    touch gdb-unpacked
    cd ..
  fi
  mkdir -p gdb-${GDB_VERSION}/build-${TARGET}
  cd gdb-${GDB_VERSION}/build-${TARGET} || exit 1

  echo "Building gdb"

  GDB_CONFIGURE_OPTIONS+=" --target=${TARGET} --prefix=${PREFIX} ${HOST_FLAG} ${BUILD_FLAG} ${WITH_LIBS}"
  strip_whitespace GDB_CONFIGURE_OPTIONS

  if [ ! -e configure-prefix ] || [ ! "`cat configure-prefix`" = "${GDB_CONFIGURE_OPTIONS}" ]; then
    rm -rf *
    ../configure ${GDB_CONFIGURE_OPTIONS} || exit 1
    echo ${GDB_CONFIGURE_OPTIONS} > configure-prefix
  else
    echo "Note: gdb already configured. To force a rebuild, use: rm -rf $(pwd)"
    [ -z ${BUILD_BATCH} ] && sleep 5
  fi
  ${MAKE_J} || exit 1
  [ ! -z $MAKE_CHECK ] && ${MAKE_J} -s check | tee ${BASE}/tests/gdb.log
  echo "Installing gdb"
  ${SUDO} ${MAKE_J} install || exit 1

  set_version gdb
fi
