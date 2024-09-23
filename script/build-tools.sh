TMPINST="${BASE}/build/tmpinst"
mkdir -p "$TMPINST"
export PATH="${TMPINST}/bin:$PATH"

cd "${BASE}/build/" || exit 1

# build GNU sed if needed.
if [ ! -z "${SED_VERSION}" ]; then
  if [ ! "$(cat ${TMPINST}/sed-version 2> /dev/null)" == "${SED_VERSION}" ]; then
    echo "Building sed"
    untar "$SED_ARCHIVE" || exit 1
    cd "sed-${SED_VERSION}/"
    TEMP_CFLAGS="$CFLAGS"
    export CFLAGS="${CFLAGS//-w}"   # configure fails if warnings are disabled.
    ./configure --prefix="$TMPINST" || exit 1
    ${MAKE_J} || exit 1
    ${MAKE_J} DESTDIR= install || exit 1
    CFLAGS="$TEMP_CFLAGS"
    echo ${SED_VERSION} > "${TMPINST}/sed-version"
  fi
fi

WITH_LIBS=""

build_lib()
{
  local name="$1"
  shift
  local display_name="${name^^}"
  local archive_var="${name^^}_ARCHIVE"
  local version_var="${name^^}_VERSION"
  local archive="${!archive_var}"
  local version="${!version_var}"
  if [ ! -z "$version" ]; then
    if [ "$(cat ${TMPINST}/${name}-version 2> /dev/null)" != "$version" ]; then
      echo "Building $display_name $version"
      cd ${BASE}/build || exit 1
      untar "$archive" || exit 1
      cd "${name}-${version}/" || exit 1
      ./configure --prefix="$TMPINST" --disable-shared "$@" || exit 1
      ${MAKE_J} || exit 1
      ${MAKE_J} DESTDIR= install || exit 1
      echo $version > "${TMPINST}/${name}-version"
    fi

    WITH_LIBS+=" --with-${name}=$TMPINST"
  fi
}

build_lib gmp
build_lib mpfr --with-gmp="$TMPINST"
build_lib mpc --with-gmp="$TMPINST" --with-mpfr="$TMPINST"
build_lib isl --with-gmp=system --with-gmp-prefix="$TMPINST"
