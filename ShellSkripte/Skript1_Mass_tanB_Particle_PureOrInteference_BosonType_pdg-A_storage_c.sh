#!/bin/bash

export START=$(pwd)

cd $6/src
eval `scramv1 runtime -sh`
export PATH=$PATH:/cvmfs/cms.cern.ch/slc6_amd64_gcc491/external/lhapdf/6.1.5-koleij/bin/:/cvmfs/cms.cern.ch/slc6_amd64_gcc491/external/fastjet/3.1.0-odfocd/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CMSSW_BASE}/src/chaplinLib/lib
./${CMSSW_BASE}/src/POWHEG-BOX-V2/gg_H_2HDM/generate.sh $1 $2 $3 $4 $5 $START

cd ${CMSSW_BASE}/src/POWHEG-BOX-V2/gg_H_2HDM/Juli_2017_testrun-lhc-${5}-m${5}${1}_tb${2}_${3}_${4}
../pwhg_main
cmsRun /home/josmet/forGeneration/fromLHE2EDM.py input=${CMSSW_BASE}/src/POWHEG-BOX-V2/gg_H_2HDM/Juli_2017_testrun-lhc-${5}-m${5}${1}_tb${2}_${3}_${4}/pwgevents.lhe output=./josmet/2HDM-Simulations/lhe2edm-Files/lhe2edm-${5}-m${5}${1}_tb${2}_${3}_${4}.root
cd /home/josmet/forGeneration/
cmsRun fromEDM2GEN.py input=./josmet/2HDM-Simulations/lhe2edm-Files/lhe2edm-${5}-m${5}${1}_tb${2}_${3}_${4}.root output=./josmet/2HDM-Simulations/edm2gen-Files/edm2gen-${5}-m${5}${1}_tb${2}_${3}_${4}.root jobnum=0 totaljobs=1
cd $7/src
eval `scramv1 runtime -sh`
cmsRun /home/josmet/forGeneration/gen_skim_cfg.py input=file:./josmet/2HDM-Simulations/edm2gen-Files/edm2gen-${5}-m${5}${1}_tb${2}_${3}_${4}.root output=./josmet/2HDM-Simulations/gen2kappa-Files/gen2kappa-${5}-m${5}${1}_tb${2}_${3}_${4}.root
cd $8/src
eval `scramv1 runtime -sh`
HiggsToTauTauAnalysis.py -c GenMSSM/baseConfig_pdg-A.json -p GenMSSM/gen_pdg-A.json -i ./josmet/2HDM-Simulations/gen2kappa-Files/gen2kappa-${5}-m${5}${1}_tb${2}_${3}_${4}.root -o ./kappa2artus.root
