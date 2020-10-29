#!/bin/bash
# Mambo's interactive resolution changing script
# Thu Sep 24 2020
ECHO="echo -e"
NECHO=echo
EXITM="exit 0"
EXITMSGA="echo Saved, exiting..."
# The following 2 lines list XRandr for a list of displays
# LISTDISPS="echo "LIST OF DISPLAYS" && xrandr -q | grep " connected""
# $LISTDISPS
$ECHO "  Enter "q" to exit at any time\n"
$ECHO "  Display to change?"
read disp
if [ $disp = q ]
then
   $EXITM
fi
$NECHO "  Changing display $disp."
$ECHO "  Resolution?"
read res
if [ $res = q ]
then
   $EXITM
fi
$NECHO "  Set resolution to $res."
$ECHO "  Rate?"
read refrate
if [ $refrate = q ]
then
    $EXITM
fi
$NECHO "  Set rate to $refrate Hz."
$ECHO "  Setting..."
DISPS="xrandr --output $disp --mode $res --rate $refrate"
$DISPS # Set resolution
$ECHO "  Set."
CONFFILE="$HOME/.res-$res-$refrate-hz-$disp.sh"
CONFFILEWH=".res-$res-$refrate-$disp.sh"
$ECHO "  Saving to $CONFFILE..."
$NECHO $DISPS > "$CONFFILE" # Output DISPS var to logfile to load later
$NECHO "  Making executable..."
chmod +x $CONFFILE # Makes DISPS executable as a script
$NECHO "  Run ./$CONFFILEWH while inside $HOME to load the resolution saved by this session"
$NECHO "Saved, exiting..."
