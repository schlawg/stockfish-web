#!/usr/bin/env -S bash -e

cd "$(dirname "${BASH_SOURCE:-$0}")/.."

NNUE=$(grep -E -o -m 1 'nn-[0-9a-f]{12}.nnue' src/evaluate.h)

if [ "$1" == "--fetch" ]; then
  curl -s -L https://tests.stockfishchess.org/api/nn/$NNUE -o $NNUE
  echo "Downloaded $NNUE"
elif [ "$1" == "--js" ]; then
  echo "Module.recommendedNnue = '$NNUE';"
else
  echo $NNUE
fi
