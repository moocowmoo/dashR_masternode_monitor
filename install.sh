#!/bin/bash

echo 'export PATH=~/.dash:$PATH' >> ~/.bashrc

REPODIR=`pwd`

cd ~/.dash

if [ ! -e masternode_status.sh ]; then
    ln -s $REPODIR/masternode_status.sh .
fi

