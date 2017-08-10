#!/bin/bash

if [ $# -ne 6 ]; then
    echo " [CMSSW_7_4_14_Path] [CMSSW_7_4_7_Path] [CMSSW_8_0_25_Path] [htype] [tan(beta)] [mass]"
    exit 1
fi
CMSSW_7_4_14_Path=$1
CMSSW_7_4_7_Path=$2
CMSSW_8_0_25_Path=$3
htype=$4
tb=$5
mass=$6
dir=OneSample_Juli_2017_lhc-${htype}-m${htype}${mass}_tb${tb}

cd $1/src
eval `scramv1 runtime -sh`
export PATH=$PATH:/cvmfs/cms.cern.ch/slc6_amd64_gcc491/external/lhapdf/6.1.5-koleij/bin/:/cvmfs/cms.cern.ch/slc6_amd64_gcc491/external/fastjet/3.1.0-odfocd/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CMSSW_BASE}/src/chaplinLib/lib:/home/josmet/CMSSW_7_4_14/src/FeynHiggs-2.9.5/x86_64-Linux/lib64
cd ${CMSSW_BASE}/src/POWHEG-BOX-V2/gg_H_MSSM

if [ -d ${dir} ]; then
    echo "directory already exist ... avoid !"
    exit 1
else
    echo "create directory : $dir"
    mkdir $dir
fi

cp ${CMSSW_BASE}/src/POWHEG-BOX-V2/gg_H_MSSM/testrun-lhc-A/powheg.input $dir
cp ${CMSSW_BASE}/src/POWHEG-BOX-V2/gg_H_MSSM/testrun-lhc-A/TB${tb}MA${mass}/powheg-fh.in $dir

#sed -i -e "s/numevts  100000/numevts  ${numevents}/" $dir/powheg.input
#sed -i -e "s/TB  15/TB  ${tb}/" $dir/powheg-fh.in
#sed -i -e "s/MA0 500/MA0 ${mass}/" $dir/powheg-fh.in
#was ist mit htype ????

cd $dir
../pwhg_main
cd /home/josmet/forGeneration/
cmsRun fromLHE2EDM.py input=${CMSSW_BASE}/src/POWHEG-BOX-V2/gg_H_MSSM/$dir/pwgevents.lhe output=/storage/c/josmet/MSSM-Simulations-OneSample/lhe2edm-Files/lhe2edm-${htype}-m${htype}${mass}_tb${tb}.root

cmsRun /home/josmet/forGeneration/fromEDM2GEN.py input=/storage/c/josmet/MSSM-Simulations-OneSample/lhe2edm-Files/lhe2edm-${htype}-m${htype}${mass}_tb${tb}.root output=/storage/c/josmet/MSSM-Simulations-OneSample/edm2gen-Files/edm2gen-${htype}-m${htype}${mass}_tb${tb}.root jobnum=0 totaljobs=1

cd $3/src
eval `scramv1 runtime -sh`
cmsRun /home/josmet/forGeneration/gen_skim_cfg.py input=file:/storage/c/josmet/MSSM-Simulations-OneSample/edm2gen-Files/edm2gen-${htype}-m${htype}${mass}_tb${tb}.root output=/storage/c/josmet/MSSM-Simulations-OneSample/gen2kappa-Files/gen2kappa-${htype}-m${htype}${mass}_tb${tb}.root

cd $2/src
eval `scramv1 runtime -sh`
HiggsToTauTauAnalysis.py -c GenMSSM/baseConfig_pdg-A.json -p GenMSSM/gen_pdg-A.json -i /storage/c/josmet/MSSM-Simulations-OneSample/gen2kappa-Files/gen2kappa-${htype}-m${htype}${mass}_tb${tb}.root -o /storage/c/josmet/MSSM-Simulations-OneSample/kappa2artus-Files/kappa2artus-${htype}-m${htype}${mass}_tb${tb}.root

