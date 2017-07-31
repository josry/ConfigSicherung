#!/bin/bash

if [ $# -ne 3  ]; then
    echo " [mass] [tan(beta)] [Seed]" 
	exit 1
fi


./no_remote_2HDMgenerate_Mass_tanB_Particle_PureOrInteference_BosonType_pdg-A.sh $1 $2 t pure A /home/josmet/CMSSW_7_4_14/ /home/josmet/CMSSW_8_0_25/ /home/josmet/CMSSW_7_4_7 $3 &

./no_remote_2HDMgenerate_Mass_tanB_Particle_PureOrInteference_BosonType_pdg-A.sh $1 $2 b pure A /home/josmet/CMSSW_7_4_14/ /home/josmet/CMSSW_8_0_25/ /home/josmet/CMSSW_7_4_7 $3 &

./no_remote_2HDMgenerate_Mass_tanB_Particle_PureOrInteference_BosonType_pdg-A.sh $1 $2 tb interference A /home/josmet/CMSSW_7_4_14/ /home/josmet/CMSSW_8_0_25/ /home/josmet/CMSSW_7_4_7 $3 &

./no_remote_2HDMgenerate_Mass_tanB_Particle_PureOrInteference_BosonType_pdg-A.sh $1 $2 t interference A /home/josmet/CMSSW_7_4_14/ /home/josmet/CMSSW_8_0_25/ /home/josmet/CMSSW_7_4_7 $3 &

./no_remote_2HDMgenerate_Mass_tanB_Particle_PureOrInteference_BosonType_pdg-A.sh $1 $2 b interference A /home/josmet/CMSSW_7_4_14/ /home/josmet/CMSSW_8_0_25/ /home/josmet/CMSSW_7_4_7 $3;

echo "Done"

