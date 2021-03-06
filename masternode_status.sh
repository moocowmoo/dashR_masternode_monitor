#!/bin/bash
clear
# -----
MNIP=`wget -qO- http://ipecho.net/plain`;
export GREP_OPTIONS=--color=always
# -----
function wait_clear() {
    PROMPT="
press enter or wait $1 seconds to continue "
    read -p "$PROMPT" -t $1 NOOP;
    clear;
}
# ----------------------------------------------------------------
cat << EOF


DASH MASTERNODE LIVE STREAM


EOF
echo "-"
echo "-"
echo "----->  PRESS [CTRL-c]"
echo "---->    AT ANY TIME"
echo "--->       TO EXIT"
echo "-->      LIVE STREAM."
# ----------------------------
echo "-"
echo "-"
wait_clear 10;
cat << EOF

***   START DASH MASTERNODE : LIVE STREAM

EOF
# ----------------------------
echo "-"
echo "-"
date
wait_clear 1;
echo "-"
echo "-"
echo "         SPORK INFO"
dash-cli spork active
echo "-"
echo "         SOLO-MINING INFO"
dash-cli getmininginfo
echo "-"
date
echo "-"
echo "-"
wait_clear 10;
cat << EOF

'PLEASE WAIT WHILE ADDITIONAL INFORMATION IS BEING GATHERED...'
EOF
sleep 1
cat << EOF


***YOUR DASH MASTERNODE 'IP' SHOULD = ENABLED


EOF
dash-cli masternode list full | grep $MNIP
echo " "
echo " "
echo "        MASTERNODE STATUS"
dash-cli masternode status
echo " "
echo " "
date
echo " "
echo " "

# ----------------------------
wait_clear 10;

cat << EOF

***GET-INFO FOR 'DASH'

`dash-cli getinfo`
EOF
echo " "
echo " "
date
# ----------------------------
wait_clear 8;
echo " "
date
echo " "
# -----

C_RED="\e[31m";
C_YELLOW="\e[33m";
C_GREEN="\e[32m";
C_NORM="\e[0m";

# -----

DASH_CLI=''
if   [ -e ./dash-cli ];          then DASH_CLI='./dash-cli';
elif [ -e ~/.dash/dash-cli ] ;   then DASH_CLI="$HOME/.dash/dash-cli";
elif [ ! -z `which dash-cli` ] ; then DASH_CLI=`which dash-cli`;
fi
if [ -z $DASH_CLI ]; then
    echo "cannot find dash-cli in current directory, ~/.dash, or \$PATH";
    exit;
fi

echo -en "${C_YELLOW}......COLLECTING EVEN MORE INFORMATION...PLEASE WAIT... ";

# -----

DASH_RUNNING=`ps --no-header \`cat ~/.dash/dashd.pid\` | wc -l`;
DASH_LISTENING=`netstat -nat | grep LIST | grep 9999 | wc -l`;
DASH_CONNECTIONS=`netstat -nat | grep ESTA | grep 9999 | wc -l`;
DASH_CURRENT_BLOCK=`$DASH_CLI getblockcount`;
DASH_GETINFO=`$DASH_CLI getinfo`;

# -----

WEB_MNIP=`wget -qO- http://ipecho.net/plain`;
WEB_BLOCK_COUNT=`wget -qO- https://chainz.cryptoid.info/dash/api.dws?q=getblockcount`;

# -----

DASH_MN_STARTED=`$DASH_CLI masternode debug | grep 'successfully started' | wc -l`
DASH_MN_VISIBLE=`$DASH_CLI masternode list full | grep $WEB_MNIP | wc -l`
DASH_MN_LIST=`$DASH_CLI masternode list full `
DASH_MN_POSE=0 #`$DASH_CLI masternode list pose | grep $WEB_MNIP | awk '{print $3}' | sed 's/[^0-9]//g'`
DASH_MN_VOTES=0 #`$DASH_CLI masternode list votes`

# -----

DASH_CURRENT=0
if [ $(($WEB_BLOCK_COUNT - 2)) -lt $DASH_CURRENT_BLOCK ]; then
    DASH_CURRENT=1
fi

if [ $DASH_MN_POSE -lt 2 ]; then
    DASH_MN_HEALTHY=1
fi

DASH_MN_ENABLED=$(echo "$DASH_MN_LIST" | grep -c ENABLED)
DASH_MN_UNHEALTHY=$(echo "$DASH_MN_LIST" | grep -c POS_ERROR)
DASH_MN_EXPIRED=$(echo "$DASH_MN_LIST" | grep -c EXPIRED)
DASH_MN_TOTAL=$(( $DASH_MN_ENABLED + $DASH_MN_UNHEALTHY ))

DASH_VERSION="v"$(echo "$DASH_GETINFO" | grep '"version' | sed -e 's/[^0-9]//g' | sed -e 's/\(..\)/\1\./g' | sed -e 's/\.$//')

echo -e "${C_GREEN}DONE${C_NORM}"

# -----

TEXT_RUNNING="${C_RED}NOT-RUNNING${C_NORM}";
TEXT_LISTENING="${C_RED}NOT-LISTENING${C_NORM}";
TEXT_CURRENT="${C_RED}NOT-SYNCED${C_NORM}";
TEXT_ENABLED="${C_RED}NOT-STARTED${C_NORM}";
TEXT_VISIBLE="${C_RED}NOT-VISIBLE${C_NORM}";
#TEXT_HEALTHY="${C_RED}NOT-HEALTHY${C_NORM}";

if [ $DASH_RUNNING   -gt 0 ]; then TEXT_RUNNING="${C_GREEN}RUNNING${C_NORM}"; fi
if [ $DASH_LISTENING -gt 0 ]; then TEXT_LISTENING="${C_GREEN}LISTENING${C_NORM}"; fi
if [ $DASH_CURRENT   -gt 0 ]; then TEXT_CURRENT="${C_GREEN}CURRENT${C_NORM}"; fi

if [ $DASH_MN_STARTED -gt 0 ]; then TEXT_ENABLED="${C_GREEN}STARTED${C_NORM}"; fi
if [ $DASH_MN_VISIBLE -gt 0 ]; then TEXT_VISIBLE="${C_GREEN}VISIBLE${C_NORM}"; fi
#if [ $DASH_MN_HEALTHY -gt 0 ]; then TEXT_HEALTHY="${C_GREEN}HEALTHY${C_NORM}"; fi

# -----

echo -e "\n ----"

echo -e "                         DASHD STATUS     :   $TEXT_RUNNING   $TEXT_LISTENING   $TEXT_CURRENT"
echo -e "                         MASTERNODE STATUS:   $TEXT_ENABLED   $TEXT_VISIBLE     $TEXT_HEALTHY"

echo -e " ----"

echo "   INSTANCE INFORMATION"
echo "                          IP ADDRESS         $WEB_MNIP"
echo "                          DASH VERSION       $DASH_VERSION"
echo "                          CONNECTIONS        $DASH_CONNECTIONS"
#echo "                          POS SERVICE SCORE  $DASH_MN_POSE"
echo "                          LAST LOCAL BLOCK   $DASH_CURRENT_BLOCK"
echo "                          LAST CHAINZ BLOCK  $WEB_BLOCK_COUNT"
echo "                          TOTAL MASTERNODE   $DASH_MN_TOTAL"
#echo "                          MASTERNODE HEALTH  $DASH_MN_ENABLED"

echo -e " ----"

#echo "    CURRENT VOTE COUNTS"
#echo "                          YEA:       $(echo "$DASH_MN_VOTES" | grep -c YEA)"
#echo "                          NAY:       $(echo "$DASH_MN_VOTES" | grep -c NAY)"
#echo "                          ABSTAIN:   $(echo "$DASH_MN_VOTES" | grep -c ABSTAIN)"
#echo "                          YOUR VOTE: $(echo "$DASH_MN_VOTES" | grep $WEB_MNIP | awk '{print $3}' | sed -e 's/[",]//g')"

# -----
date

wait_clear 10;
cat << EOF

***   CHECKING YOUR DASH MASTERNODE IP CONNECTION(S) ON PORT: 9999

`netstat -an | grep 9999 | more`


***   CHECKING YOUR DASH 'LISTENING' ABILITY : LISTENING, ON PORT : 9999

`netstat -an | grep LISTEN | grep 9999`
EOF
echo " "
echo " "
date
# ----------------------------
wait_clear 8;

cat << EOF

            MASTERNODE WINNERS
EOF
dash-cli masternode winners
echo " "
echo " "
date
wait_clear 10;
exec $0
