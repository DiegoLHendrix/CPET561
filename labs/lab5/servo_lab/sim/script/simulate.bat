@REM *****************************************************************************
@REM   This file do some cleanup of the simulation directory and call the
@REM   ModelSim simulator. 
@REM *****************************************************************************

@echo off
if exist work (
    rmdir /s /q work 
) 

if exist transcript (
    del /f /q transcript 
) 

if exist transcript (
    del /f /q vsim.wlf 
) 

echo on

vsim -do sim.do

@echo off

rmdir work   /s /q
del transcript
del vsim.wlf