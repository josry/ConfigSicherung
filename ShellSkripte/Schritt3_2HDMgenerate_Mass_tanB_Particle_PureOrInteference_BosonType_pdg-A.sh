#!/bin/bash

mass=$1
tb=$2
particle_isinterference=$3
htype=$4
Path=$5


source /cvmfs/cms.cern.ch/cmsset_default.sh

cd $5/src
eval `scramv1 runtime -sh`
source ${CMSSW_BASE}/src/HiggsAnalysis/KITHiggsToTauTau/scripts/ini_KITHiggsToTauTauAnalysis.sh
cd -

HiggsToTauTauAnalysis.py -c baseConfig_pdg-A.json -p gen_pdg-A.json -i /storage/c/josmet/EtpFreiburgDesyEtp/2HDM-Files/gen2kappa-Files/gen2kappa-${4}-m${4}${1}_tb${2}_${3}_*.root -o ./kappa2artus-${4}-m${4}${1}_tb${2}_${3}.root
