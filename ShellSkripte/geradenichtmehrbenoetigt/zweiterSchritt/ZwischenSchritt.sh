#!/bin/bash


cd $6/src
source /cvmfs/cms.cern.ch/cmsset_default.sh
eval `scramv1 runtime -sh`


mass=$1
tb=$2
particle=$3
isInterference=$4
htype=$5

Path1=$6
Path2=$7
Path3=$8

echo "Hallo"
cmsRun /home/josmet/forGeneration/fromLHE2EDM.py input=/storage/c/josmet/Freiburg/Juli_2017_testrun-lhc-${5}-m${5}${1}_tb${2}_${3}_${4}/pwgevents.lhe output=/storage/c/josmet/Freiburg/lhe2edm-Files/lhe2edm-${5}-m${5}${1}_tb${2}_${3}_${4}.root


echo "HHHallo"

