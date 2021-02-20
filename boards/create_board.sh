#!/bin/bash
SRC=$1
DST=$2
lsrc=`echo $SRC | tr '[:upper:]' '[:lower:]'`
ldst=`echo $DST | tr '[:upper:]' '[:lower:]'`

if [ $# != 2 ]
then
	echo "Creates a new board folder from an existing one. Has to be run in the 'boards' directory"
	echo "Usage: $0 ExistingBoardName NewBoardName"
	exit -1
fi


if [ ! -d "$SRC" ]
then
	echo "Source Directory \"$SRC\" does not exist"
	exit 1
fi

if [ -d "$DST" ]
then
	echo "Destionation Directory \"$DST\" exists"
	exit 2
fi

mkdir -p "$DST" && \
cp -r "$SRC"/* "$DST" && \
for sdir in db build incremental_db simulation greybox_tmp
do
	rm -rf "$DST"/$sdir
done && \
cd "$DST" && \
sed -i "s/$SRC/$DST/"  `grep -i "$SRC" -lr *.*` && \
sed -i "s/$lsrc/$ldst/"  `grep -i "$lsrc" -lr *.*` && \
for f in *.*; do mv "$f" "$(echo "$f" | sed s/$SRC/$DST/)"; done && \
for f in *.*; do mv "$f" "$(echo "$f" | sed s/$lsrc/$ldst/)"; done && \
ls -l 

