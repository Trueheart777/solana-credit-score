#!/usr/bin/env bash

set -e

BINS=(
  solana-credit-score
)
REPO=https://github.com/mvines/solana-credit-score
DEFAULT_TO_MASTER=1

case "$(uname)" in
Linux)
  TARGET=x86_64-unknown-linux-gnu
  ;;
Darwin)
  TARGET=x86_64-apple-darwin
  ;;
*)
  echo "machine architecture is currently unsupported"
  exit 1
  ;;
esac

for BIN in ${BINS[@]}; do
  BIN_TARGET=$BIN-$TARGET

  if [[ ( -z $1 && -n $DEFAULT_TO_MASTER ) || $1 = master ]]; then
    URL=$REPO/raw/master-bin/$BIN_TARGET
  elif [[ -n $1 ]]; then
    URL=$REPO/releases/download/$1/$BIN_TARGET
  else
    URL=$REPO/releases/latest/download/$BIN_TARGET
  fi

  (
    set -x
    curl -fL $URL -o $BIN
    chmod +x $BIN
    ls -l $BIN
    ./$BIN --version
  )
done
