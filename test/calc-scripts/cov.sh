#! bin/bash

lineCount="$(find lib -name '*.dart' -exec cat {} \; | sed '/^\s*$/d' | wc -l``)"
coveredFileList="lib/src/firebase/dBRefs.dart lib/src/model/*.dart lib/src/state/*.dart lib/src/constants.dart lib/src/store.dart"
coveredFileLineCount="$(find ${coveredFileList}  -exec cat {} \; | sed '/^\s*$/d' | wc -l``)"

echo "TOTAL LINE COUNT: ${lineCount}"
echo "COVERED LINE COUNT: ${coveredFileLineCount}"

# echo "Please enter number of covered lines:"

# read coveredLines

echo  print $coveredFileLineCount / $lineCount | perl