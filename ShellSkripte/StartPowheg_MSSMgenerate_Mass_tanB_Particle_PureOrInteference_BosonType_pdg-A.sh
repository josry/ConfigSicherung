#!/bin/bash

if [ $# -ne 8 ]; then
    echo "sh generate.sh [mass] [tan(beta)] [tb,t,b] [interference, pure] [htype] [CMSSW_7_4_14_Path] [CMSSW_7_4_7_Path] [CMSSW_8_0_25_Path] [Seed]" 
    exit 1
fi


mass=$1
tb=$2
particle_isinterference=$3
htype=$4

Path1=$5
Path2=$6
Path3=$7

seed=$8

particle=${particle_isinterference%_*}
isinterference=${particle_isinterference#*_}
echo "$PWD"

cd $5/src
source /cvmfs/cms.cern.ch/cmsset_default.sh
eval `scramv1 runtime -sh`
export PATH=$PATH:/cvmfs/cms.cern.ch/slc6_amd64_gcc491/external/lhapdf/6.1.5-koleij/bin/:/cvmfs/cms.cern.ch/slc6_amd64_gcc491/external/fastjet/3.1.0-odfocd/bin/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${CMSSW_BASE}/src/chaplinLib/lib
cd -

pushd ${CMSSW_BASE}/src/scales/scales
ls
pwd
	source /cvmfs/cms.cern.ch/cmsset_default.sh
	SCRAM_ARCH=slc6_amd64_gcc491
	eval `scramv1 runtime -sh`
	if [ "${isinterference}" = "interference" ]; then

	    HFACT=$(python plotscale.py -p $htype -m $mass -t $tb |grep "Qtb ="|awk '{print $3}')
	fi
	if [ "${isinterference}" = "pure" ]; then
		HFACT=$(python plotscale.py -p $htype -m $mass -t $tb |grep "Q${particle} ="|awk '{print $3}')
	fi
popd

echo "mass = $mass"
echo "tan(beta) = $tb"
echo "particle to be considered = ${particle}"
echo "isInterference = ${isinterference}"
echo "higgstype = $htype"
echo "HFACT = $HFACT"


dir=./MSSM_2017_run-lhc-${htype}-m${htype}${mass}_tb${tb}_${particle_isinterference}

if [ "${particle}" = "tb" ]; then
    echo "You choose tb"
elif [ "${particle}" = "t" ]; then
    echo "You choose t"
elif [ "${particle}" = "b" ]; then
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

if [ "${isinterference}" = "interference" ]; then
    echo "You choose interference"
else
    echo "You choose pure process"
    if [ "${particle}" = "tb" ]; then
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


cp powheg.input $dir
cp powheg-fh.in $dir

#
sed -i -e "s/iseed    55555/iseed    ${seed}/" $dir/powheg.input

sed -i -e "s/MA0          500/MA0    ${mass}/" $dir/powheg-fh.in

sed -i -e "s/TB           15/TB    ${tb}/" $dir/powheg-fh.in
#

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

sed -i -e "s/!hfact    %hfact/hfact    ${HFACT}d0/" $dir/powheg.input
echo "Done !"


cd $dir


/portal/ekpbms1/home/josmet/CMSSW_7_4_14/src/POWHEG-BOX-V2/gg_H_MSSM/pwhg_main

tail -n 100 pwgevents.lhe

cd -
cmsRun fromLHE2EDM.py input=$dir/pwgevents.lhe output=./lhe2edm-${4}-m${4}${1}_tb${2}_${3}.root

tar -cf MSSM_packed-${4}-m${4}${1}_tb${2}_${3}.tar.gz ${dir}
echo "done"
