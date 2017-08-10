#!/bin/bash

#if [ $# -ne 9 ]; then
 #   echo "sh generate.sh [mass] [tan(beta)] [tb,t,b] [interference, pure] [htype] [CMSSW_7_4_14_Path] [CMSSW_7_4_7_Path] [CMSSW_8_0_25_Path] [Seed]" 
 #   exit 1
#fi





export START=$(pwd)
echo $START
mass=$1
tb=$2
particle=$3
isInterference=$4
htype=$5

Path1=$6
Path2=$7
Path3=$8

seed=$9
printenv

cd $6/src
source /cvmfs/cms.cern.ch/cmsset_default.sh
eval `scramv1 runtime -sh`
export PATH=$PATH:/cvmfs/cms.cern.ch/slc6_amd64_gcc491/external/lhapdf/6.1.5-koleij/bin/:/cvmfs/cms.cern.ch/slc6_amd64_gcc491/external/fastjet/3.1.0-odfocd/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CMSSW_BASE}/src/chaplinLib/lib

pushd /${CMSSW_BASE}/src/scales/scales
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

cd $START

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
    mkdir $dir -p
fi



cp ${CMSSW_BASE}/src/POWHEG-BOX-V2/gg_H_2HDM/powheg.input $dir
sed -i -e "s/iseed    55555/iseed    ${seed}/" $dir/powheg.input
sed -i -e "s/hmass  500/hmass  ${mass}/" $dir/powheg.input
sed -i -e "s/tanb 50d0/tanb ${tb}d0/" $dir/powheg.input

if [ "$particle" = "tb" ]; then
    echo ""
elif [ "$particle" = "t" ]; then
    echo "nobot 1" >> $dir/powheg.input
    echo ""
elif [ "$particle" = "b" ]; then
    echo "notop 1" >> $dir/powheg.input
    echo ""
fi


if [ "$htype" = "H" ]; then
    sed -i -e "s/higgstype 3/higgstype 2/" $dir/powheg.input
fi

sed -i -e "s/hfact    17d0/hfact    ${HFACT}d0/" $dir/powheg.input
echo "Done !"


cd $dir

/portal/ekpbms1/home/josmet/CMSSW_7_4_14/src/POWHEG-BOX-V2/gg_H_2HDM/pwhg_main
cd $START
echo $PWD


cmsRun /portal/ekpbms1/home/josmet/forGeneration/fromLHE2EDM.py input=$dir/pwgevents.lhe output=./lhe2edm-${5}-m${5}${1}_tb${2}_${3}_${4}.root

cmsRun /portal/ekpbms1/home/josmet/forGeneration/fromEDM2GEN.py input=./lhe2edm-${5}-m${5}${1}_tb${2}_${3}_${4}.root output=./edm2gen-${5}-m${5}${1}_tb${2}_${3}_${4}.root jobnum=0


cd $7/src
echo $PWD
eval `scramv1 runtime -sh`
cd $START
echo "gen2kappa-Step"
ls
cmsRun gen_skim_cfg.py input=file:./edm2gen-${5}-m${5}${1}_tb${2}_${3}_${4}_${10}.root output=gen2kappa-${5}-m${5}${1}_tb${2}_${3}_${4}_${10}.root
ls
echo "gen2kappa-File exist?"
cd $8/src
echo $PWD
eval `scramv1 runtime -sh`
cd $START
echo $PWD
ls
echo "Last Step!"
/portal/ekpbms1/home/josmet/CMSSW_7_4_7/src/HiggsAnalysis/KITHiggsToTauTau/scripts/HiggsToTauTauAnalysis.py -c baseConfig_pdg-A.json -p gen_pdg-A.json -i gen2kappa-${5}-m${5}${1}_tb${2}_${3}_${4}.root -o kappa2artus-${5}-m${5}${1}_tb${2}_${3}_${4}.root
ls
tar cfvz packed-${5}-m${5}${1}_tb${2}_${3}_${4}.tar.gz $dir

##########
#cmsRun /home/josmet/forGeneration/fromLHE2EDM.py input=${CMSSW_BASE}/src/POWHEG-BOX-V2/gg_H_2HDM/Juli_2017_testrun-lhc-${5}-m${5}${1}_tb${2}_${3}_${4}/pwgevents.lhe output=./josmet/2HDM-Simulations/lhe2edm-Files/lhe2edm-${5}-m${5}${1}_tb${2}_${3}_${4}.root
#cd /home/josmet/forGeneration/
#cmsRun /portal/ekpbms1/home/josmet/forGeneration/fromEDM2GEN.py input=./josmet/2HDM-Simulations/lhe2edm-Files/lhe2edm-${5}-m${5}${1}_tb${2}_${3}_${4}.root output=./josmet/2HDM-Simulations/edm2gen-Files/edm2gen-${5}-m${5}${1}_tb${2}_${3}_${4}.root jobnum=0 totaljobs=1
#cmsRun /portal/ekpbms1/home/josmet/forGeneration/gen_skim_cfg.py input=file:./josmet/2HDM-Simulations/edm2gen-Files/edm2gen-${5}-m${5}${1}_tb${2}_${3}_${4}.root output=./josmet/2HDM-Simulations/gen2kappa-Files/gen2kappa-${5}-m${5}${1}_tb${2}_${3}_${4}.root
#HiggsToTauTauAnalysis.py -c GenMSSM/baseConfig_pdg-A.json -p GenMSSM/gen_pdg-A.json -i ./josmet/2HDM-Simulations/gen2kappa-Files/gen2kappa-${5}-m${5}${1}_tb${2}_${3}_${4}.root -o ./kappa2artus.root

