#!/bin/bash

if [ $# -ne 8 ]; then
    echo "sh MSSM_generation.sh [CMSSW_7_4_14_Path] [CMSSW_7_4_7_Path] [CMSSW_8_0_25_Path] [htype] [tan(beta)] [mass] [tb,t,b] [interference, pure]"
    exit 1
fi
CMSSW_7_4_14_Path=$1
CMSSW_7_4_7_Path=$2
CMSSW_8_0_25_Path=$3
htype=$4
tb=$5
mass=$6
particle=$7
isInterference=$8

pushd ../../scales/scales
	source /cvmfs/cms.cern.ch/cmsset_default.sh
	SCRAM_ARCH=slc6_amd64_gcc491
	eval `scramv1 runtime -sh`
	if [ "$isInterference" = "interference" ]; then
	    HFACT=$(python plotscale.py -p $htype -m $mass -t $tb |grep "Qtb ="|awk '{print $3}')
	fi
	if [ "$isInterference" = "pure" ]; then
		HFACT=$(python plotscale.py -p $htype -m $mass -t $tb |grep "Q${particle} ="|awk '{print $3}')
	fi
popd

echo "mass = $mass"
echo "tan(beta) = $tb"
echo "particle to be considered = $particle"
echo "isInterference = $isInterference"
echo "higgstype = $htype"
echo "HFACT = $HFACT"


dir=Juli_2017_testrun-lhc-${htype}-m${htype}${mass}_tb${tb}_${particle}_${isInterference}

if [ "$particle" = "tb" ]; then
    echo "You choose tb"
elif [ "$particle" = "t" ]; then
    echo "You choose t"
elif [ "$particle" = "b" ]; then
    echo "You choose b"
else
    echo "Not valid option ... choose from [tb, t, b]"
    exit 1
fi

if [ "$htype" = "A" ]; then
    echo "You choose pseudo-scalar A"
elif [ "$htype" = "H" ]; then
    echo "You choose heavy Higgs H"
else
    echo "Not valid option ... choose from [H,A]"
    exit 1
fi

if [ "$isInterference" = "interference" ]; then
    echo "You choose interference"
else
    echo "You choose pure process"
    if [ "$particle" = "tb" ]; then
	echo "You don't need to choose this process for pure term"
	exit 1
    fi
fi

if [ -d ${dir} ]; then
    echo "directory already exist ... avoid !"
    exit 1
else
    echo "create directory : $dir"
    mkdir $dir
fi


cp ${CMSSW_BASE}/src/POWHEG-BOX-V2/gg_H_MSSM/testrun-lhc-A/powheg.input $dir
cp ${CMSSW_BASE}/src/POWHEG-BOX-V2/gg_H_MSSM/testrun-lhc-A/TB${tb}MA${mass}/powheg-fh.in $dir

if [ "$particle" = "tb" ]; then
    echo ""
elif [ "$particle" = "t" ]; then
    echo "nobot 1" >> $dir/powheg.input
    echo ""
elif [ "$particle" = "b" ]; then
    echo "notop 1" >> $dir/powheg.input
    echo ""
fi

sed -i -e "s/!hfact    %hfact/hfact    ${HFACT}d0/" $dir/powheg.input

cd $1/src
eval `scramv1 runtime -sh`
export PATH=$PATH:/cvmfs/cms.cern.ch/slc6_amd64_gcc491/external/lhapdf/6.1.5-koleij/bin/:/cvmfs/cms.cern.ch/slc6_amd64_gcc491/external/fastjet/3.1.0-odfocd/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CMSSW_BASE}/src/chaplinLib/lib:/home/josmet/CMSSW_7_4_14/src/FeynHiggs-2.9.5/x86_64-Linux/lib64
cd ${CMSSW_BASE}/src/POWHEG-BOX-V2/gg_H_MSSM



#sed -i -e "s/TB  15/TB  ${tb}/" $dir/powheg-fh.in
#sed -i -e "s/MA0 500/MA0 ${mass}/" $dir/powheg-fh.in 
#was ist mit htype ????

cd $dir
../pwhg_main
cd /home/josmet/forGeneration/
cmsRun fromLHE2EDM.py input=${CMSSW_BASE}/src/POWHEG-BOX-V2/gg_H_MSSM/$dir/pwgevents.lhe output=/storage/c/josmet/MSSM-Simulations/lhe2edm-Files/lhe2edm-${htype}-m${htype}${mass}_tb${tb}_${7}_${8}.root

cmsRun /home/josmet/forGeneration/fromEDM2GEN.py input=/storage/c/josmet/MSSM-Simulations/lhe2edm-Files/lhe2edm-${htype}-m${htype}${mass}_tb${tb}_${7}_${8}.root output=/storage/c/josmet/MSSM-Simulations/edm2gen-Files/edm2gen-${htype}-m${htype}${mass}_tb${tb}_${7}_${8}.root jobnum=0 totaljobs=1

cd $3/src
eval `scramv1 runtime -sh`
cmsRun /home/josmet/forGeneration/gen_skim_cfg.py input=file:/storage/c/josmet/MSSM-Simulations/edm2gen-Files/edm2gen-${htype}-m${htype}${mass}_tb${tb}_${7}_${8}.root output=/storage/c/josmet/MSSM-Simulations/gen2kappa-Files/gen2kappa-${htype}-m${htype}${mass}_tb${tb}_${7}_${8}.root

cd $2/src
eval `scramv1 runtime -sh`
HiggsToTauTauAnalysis.py -c GenMSSM/baseConfig_pdg-A.json -p GenMSSM/gen_pdg-A.json -i /storage/c/josmet/MSSM-Simulations/gen2kappa-Files/gen2kappa-${htype}-m${htype}${mass}_tb${tb}_${7}_${8}.root -o /storage/c/josmet/MSSM-Simulations/kappa2artus-Files/kappa2artus-${htype}-m${htype}${mass}_tb${tb}_${7}_${8}.root


