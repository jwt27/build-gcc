# This file is intentionally not executable
set -e

find download/*/* ! -wholename '*/.git/*' -delete || :
cd download
for DIR in */; do
  DIR=${DIR%/}
  tar -c -f $DIR-git.tar $DIR
done
rm -rf */
