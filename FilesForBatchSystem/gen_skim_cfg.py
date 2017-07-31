import os
import FWCore.ParameterSet.Config as cms
import Kappa.Skimming.datasetsHelper2015 as datasetsHelper
import Kappa.Skimming.tools as tools
from FWCore.ParameterSet.VarParsing import VarParsing

options = VarParsing('python')
options.register('mA','',VarParsing.multiplicity.singleton,VarParsing.varType.string,"mA parameter")
options.register('tanB','',VarParsing.multiplicity.singleton,VarParsing.varType.string,"tanB parameter")
options.register('scale','',VarParsing.multiplicity.singleton,VarParsing.varType.string,"scale parameter")
options.register('quark','',VarParsing.multiplicity.singleton,VarParsing.varType.string,"quark parameter")
options.register('type','',VarParsing.multiplicity.singleton,VarParsing.varType.string,"type parameter")
options.register('output','',VarParsing.multiplicity.singleton,VarParsing.varType.string,"type parameter")
options.register('input','',VarParsing.multiplicity.singleton,VarParsing.varType.string,"type parameter")
options.parseArguments()

cmssw_version_number = tools.get_cmssw_version_number()
		

process = cms.Process("KAPPA")

process.source = cms.Source("PoolSource",
	fileNames = cms.untracked.vstring()
)
#process.source.fileNames = cms.untracked.vstring(["file:///storage/a/rcaspart/MSSM_reweighting_ggH/GEN_testrun-lhc-A-mA500_tb15_b_interference.root"])
process.source.fileNames = cms.untracked.vstring([options.input])


#process.maxEvents = cms.untracked.PSet( input = cms.untracked.int32(10000) )
process.maxEvents = cms.untracked.PSet( input = cms.untracked.int32(-1) ) #-1
process.load("Kappa.Producers.KTuple_cff")
process.kappaTuple = cms.EDAnalyzer('KTuple',
    process.kappaTupleDefaultsBlock,
    outputFile = cms.string(options.output),
    #outputFile = cms.string('testskim1.root'),
    )

    

process.kappaTuple.active = cms.vstring()
process.kappaOut = cms.Sequence(process.kappaTuple)
process.p = cms.Path ( )

process.kappaTuple.verbose = cms.int32(0)

process.kappaTuple.Info.l1Source = cms.InputTag("")
process.kappaTuple.Info.hltSource = cms.InputTag("")
process.kappaTuple.Info.hlTrigger = cms.InputTag("")
process.kappaTuple.Info.noiseHCAL = cms.InputTag("")

process.kappaTuple.active = cms.vstring('GenInfo') # produce Metadata for MC,


#process.kappaTuple.active+= cms.vstring('GenInfo')           # produce Metadata for MC,
process.kappaTuple.active+= cms.vstring('GenParticles') # save GenParticles,
process.kappaTuple.active+= cms.vstring('GenTaus')           # save GenParticles,


process.p *= ( process.kappaOut )
