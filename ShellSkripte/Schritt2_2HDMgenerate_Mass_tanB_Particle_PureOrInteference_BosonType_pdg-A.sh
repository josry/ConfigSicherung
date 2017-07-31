#!/bin/bash

mass=$1
tb=$2
particle_isinterference=$3
htype=$4


jobnum=$5
printenv

source /cvmfs/cms.cern.ch/cmsset_default.sh

#srmcp srm://dcache-se-cms.desy.de:8443/srm/managerv2?SFN=/pnfs/desy.de/cms/tier2/store/user/jmetwall/lhe2edm-Files/lhe2edm-${4}-m${4}${1}_tb${2}_${3}.root file:///$PWD/lhe2edm-${4}-m${4}${1}_tb${2}_${3}.root

scramv1 project CMSSW CMSSW_7_4_14
pushd CMSSW_7_4_14/src
eval `scramv1 runtime -sh`
popd

cmsRun fromEDM2GEN.py input=/storage/c/josmet/EtpFreiburgDesyEtp/2HDM-Files/lhe2edm-Files/lhe2edm-${4}-m${4}${1}_tb${2}_${3}.root output=./edm2gen-${4}-m${4}${1}_tb${2}_${3}.root jobnum=${5}


scramv1 project CMSSW CMSSW_8_0_25
pushd CMSSW_8_0_25/src
tar -xf ../../KappaInput.tar
tar -xf ../../VertexRefit.tar
eval `scramv1 runtime -sh`
scram b
popd

cmsRun gen_skim_cfg.py input=file:./edm2gen-${4}-m${4}${1}_tb${2}_${3}_${5}.root output=./gen2kappa-${4}-m${4}${1}_tb${2}_${3}_${5}.root
