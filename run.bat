@echo off
where cl.exe > nul 2>&1
if %errorlevel% neq 0 (call setup.bat)
odin run main.odin -file 
