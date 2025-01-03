@echo off
where cl.exe > nul 2>&1
if %errorlevel% neq 0 (call setup.bat)
odin build main.odin -file 2>&1 > tmp
type tmp
del tmp
