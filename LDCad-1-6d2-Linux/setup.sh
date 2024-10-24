#!/bin/sh

# ======================================================================================================================
# This script will copy the LDCad files into suitable central, current user independent, locations.
# It will then try to register the LDraw mime types so LDCad can be used to handle opening of models etc.
# And last it will try to add LDCad to your application menu.
#
# NOTE 1: This might not work for all distributions, feel free to adjust the below script to make it work yourself.
#         If so, please consider sending me your modifications so I might be able to improve the script for all.
# NOTE 2: You need root/sudo rights to run the script as the /usr folders are usually read-only for normal users.
# NOTE 3: Use '--help' as the only parameter to get info about what will/was copied etc.
# ======================================================================================================================


#Destination locations
# The <foo> strings are variables LDCad will process, see http://www.melkert.net/LDCad/tech/config for detaults.
basedir="/usr"
appdir="$basedir/bin"
datadir="$basedir/share/LDCad"
cfgdir="/etc"
cfgfn="$cfgdir/LDCad.cfg"
userdir="<userAppDataDir>/LDCad"
scdir="$basedir/share/applications"
scfn="$basedir/share/applications/LDCad.desktop"
mimebasedir="$basedir/share/mime"
mimedir="$mimebasedir/packages"
mimefn="$mimedir/ldraw.xml"

#show info/help
if [ "$1" = "--help" ]
then
	echo "This setup.sh script will copy/generate the followeling files based on the LDCad linux archive contents of the current folder."
	echo 
	echo "Main executable: $appdir/LDCad"
	echo "Shared (static) data: $datadir"
	echo "Main config file: $cfgfn"
	echo "Desktop entry file: $scfn"
	echo "Mime type info (only if it doesn't exist yet): $mimefn"
	echo 
	echo "Currently there is no automatic removal as deleting things as sudo is somewhat dangerous, but feel free to do a manual remove." 
	echo "Don't forget to run \"update-mime-database\" if you remove the mime file."
	echo "Don't forget to run \"update-desktop-database\" if you remove the desktop entry file."
	exit
fi

if [ `whoami` != "root" ]
then
  echo "This setup.sh needs 'sudo' rights to copy files to otherwise read-only locations."
  exit
fi

#choose the 32 or 64 bit executable
if [ -e "LDCad" ]
then
 appSrcExe="LDCad"
else
 if [ `getconf LONG_BIT` = "64" ]
 then
  appSrcExe="LDCad64"
 else
  appSrcExe="LDCad32"
 fi
fi

#Copy the main (and only) executable.
echo "Copying executable to: $appdir"
cp -v $appSrcExe $appdir/LDCad


#Copy the central (static) program data
echo "Copying data files to: $datadir"
mkdir -p $datadir/seeds
cp -v seeds/*.sf $datadir/seeds
cp -vr docs $datadir
cp -vr resources $datadir


#Create the main config file which instructs the main executable about where to find its stuff.
echo "Creating config file: $cfgfn"
echo "[paths]" > $cfgfn
echo "resourcesDir=$datadir/resources" >> $cfgfn
echo "seedsDir=$datadir/seeds" >> $cfgfn
echo "logDir=$userdir/logs" >> $cfgfn
echo "cfgDir=$userdir/config" >> $cfgfn
echo "guiDir=$userdir/gui" >> $cfgfn
echo "colorBinDir=$userdir/colorBin" >> $cfgfn
echo "partBinDir=$userdir/partBin" >> $cfgfn
echo "examplesDir=$userdir/examples" >> $cfgfn
echo "templatesDir=$userdir/templates" >> $cfgfn
echo "donorsDir=$userdir/donors" >> $cfgfn
echo "shadowDir=$userdir/shadow" >> $cfgfn
echo "scriptsDir=$userdir/scripts" >> $cfgfn
echo "povCfgDir=$userdir/povray" >> $cfgfn


#Register ldraw mime type
if [ -e "$mimefn" ]
then
  echo "Skipping mime type stuff, file \"$mimefn\" already exists."
else
  echo "Creating ldraw mime type file: $mimefn"
  
  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $mimefn
  echo "<mime-info xmlns=\"http://www.freedesktop.org/standards/shared-mime-info\">" >> $mimefn
  echo "   <mime-type type=\"application/x-ldraw\">" >> $mimefn
  echo "     <comment>LDraw Model</comment>" >> $mimefn
  echo "     <glob pattern=\"*.ldr\"/>" >> $mimefn
  echo "     <glob pattern=\"*.LDR\"/>" >> $mimefn
  echo "   </mime-type>" >> $mimefn
  echo "   <mime-type type=\"application/x-multipart-ldraw\">" >> $mimefn
  echo "     <comment>LDraw Model</comment>" >> $mimefn
  echo "     <glob pattern=\"*.mpd\"/>" >> $mimefn
  echo "     <glob pattern=\"*.MPD\"/>" >> $mimefn
  echo "   </mime-type>" >> $mimefn  
  echo "</mime-info>" >> $mimefn

  echo "Updating mime database."
  update-mime-database $mimebasedir
fi


#Create desktop entry file.
./genDskEntry.sh "$appdir" "$datadir" "$scfn"


#Update desktop database.
echo "Updating desktop database."
update-desktop-database


#Done
echo "All done."
