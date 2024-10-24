#!/bin/sh

# ======================================================================================================================
# This script will generate a desktop entry file for this standalone version of LDCad.
# Separate generation of this file is needed to ensure the correct absolute paths.
# You can use the resulting .desktop file wherever you need it (e.g. on your task bar or desktop) by dragging it there.
#
# NOTE: If you want to fully integrate LDCad into your (multi user) linux/xwindows environment run setup.sh instead.
#
# params (used only for calls from install.sh)
#   genDskEntry.sh bindir datadir outfile
# ======================================================================================================================


#Base dirs from the parameters
bin=$1
data=$2
fn=$3
loc=`pwd`

#Names
exe="LDCad"
dsk="LDCad.desktop"
ico="LDCad-128x128.png"

#force base dirs (uses = instead of == so we won't need bash)
if [ "$bin" = "" ]
then
  bin=$loc
fi

if [ "$data" = "" ]
then
  data=$loc
fi

if [ "$fn" = "" ]
then
  fn="$loc/$dsk"
fi

#Write file
# Only show 'pre' info info if called from setup.sh
if [ "$1" != "" ]
then
  echo "Creating desktop entry file: $fn"
fi

echo "#!/usr/bin/env xdg-open" > $fn
echo "[Desktop Entry]" >> $fn
echo "Type=Application" >> $fn
echo "Version=1.0" >> $fn
echo "Name=LDCad" >> $fn
echo "GenericName=LDraw model editor" >> $fn
echo "Comment=LDCad can be used to edit all kinds of LDraw (virtual LEGO(r)) models." >> $fn
echo "Icon=$data/resources/$ico" >> $fn
echo "Exec=$bin/$exe" >> $fn
echo "Terminal=false" >> $fn
echo "MimeType=application/x-ldraw;application/x-multipart-ldraw" >> $fn
echo "Categories=Graphics" >> $fn

#Done, onnly show 'post' info if not called from setup.sh
if [ "$1" = "" ]
then
  echo $fn has been written.
fi
