#from gcSettings import Settings
#   this import is only needed to execute the script standalone
#   (<GCDIR>/packages needs to be in your PYTHONPATH - or grid-control was properly installed)

import time
import os
import sys
import datetime
print(time.time())

cfg = Settings()
cfg.workflow.task = 'UserTask'
cfg.workflow.backend = 'condor'

cfg.jobs.wall_time = '42:00:00'
cfg.jobs.in_flight = '1000' #war 1000
cfg.jobs.set("memory", "4000")
cfg.condor.set("JDLData", "request_disk=10000000")
cfg.jobs.set("max retry", "4")
cfg.jobs.continuous = True

cfg.usertask.executable = 'ShellSkripte/Schritt2_2HDMgenerate_Mass_tanB_Particle_PureOrInteference_BosonType_pdg-A.sh'
cfg.usertask.set("input files", ["ShellSkripte/Schritt2_2HDMgenerate_Mass_tanB_Particle_PureOrInteference_BosonType_pdg-A.sh", "FilesForBatchSystem/slha.slha", "FilesForBatchSystem/SLHA.SLHA", "FilesForBatchSystem/gen_skim_cfg.py", "FilesForBatchSystem/fromEDM2GEN.py", "KappaInput"] )

executable = 'ShellSkripte/Schritt2_2HDMgenerate_Mass_tanB_Particle_PureOrInteference_BosonType_pdg-A.sh'

cfg.parameters.set("parameters", ["P1", "P2", "P3", "P4", "P5"])
cfg.parameters.set("repeat", 1)
cfg.parameters.set("P1", ["400", "500", "600", "700", "800"])
cfg.parameters.set("P2", ["5", "10", "15", "30"])
cfg.parameters.set("P3", ["t_pure", "b_pure", "tb_interference","t_interference", "b_interference"])
cfg.parameters.set("P4", ["A"])
cfg.parameters.set("P5", ["%s"%x for x in range(10)])

arguments = "@P1@ @P2@ @P3@ @P4@ @P5@"

cfg.usertask.set('arguments', "%s"%arguments)
cfg.storage.set('se path', "srm://dcache-se-cms.desy.de:8443/srm/managerv2?SFN=/pnfs/desy.de/cms/tier2/store/user/jmetwall/2HDM_Generation/")
cfg.storage.set('se output files', [ "edm2gen-@P4@-m@P4@@P1@_tb@P2@_@P3@_@P5@.root", "gen2kappa-@P4@-m@P4@@P1@_tb@P2@_@P3@_@P5@.root"])

cfg.storage.set('se output pattern', "@X@")
getattr(cfg, 'global').set('workdir', "/storage/c/josmet/EtpFreiburgDesyEtp/Schritt2_2HDM/Run_"+datetime.datetime.now().strftime("%Y-%m-%d_%H_%M")+"/workdir/")
print(cfg)
