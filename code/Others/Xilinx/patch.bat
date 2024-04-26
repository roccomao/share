@echo off
fc /b patch\nt\libPortability.dll 14.7\ISE_DS\.xinstall\bin\nt\libPortability.dll > nul
if errorlevel 1 (
    copy 14.7\ISE_DS\.xinstall\bin\nt64\libPortability.dll 14.7\ISE_DS\.xinstall\bin\nt64\libPortability.dll.bak
    copy 14.7\ISE_DS\EDK\lib\nt64\libPortability.dll 14.7\ISE_DS\EDK\lib\nt64\libPortability.dll.bak
    copy 14.7\ISE_DS\EDK\lib\nt64\sdk\libPortability.dll 14.7\ISE_DS\EDK\lib\nt64\sdk\libPortability.dll.bak
    copy 14.7\ISE_DS\ISE\lib\nt64\libPortability.dll 14.7\ISE_DS\ISE\lib\nt64\libPortability.dll.bak
    copy 14.7\ISE_DS\ISE\lib\nt64\libPortabilityNOSH.dll 14.7\ISE_DS\ISE\lib\nt64\libPortabilityNOSH.dll.bak
    copy 14.7\ISE_DS\ISE\sysgen\bin\nt64\libPortability.dll 14.7\ISE_DS\ISE\sysgen\bin\nt64\libPortability.dll.bak
    copy 14.7\ISE_DS\common\lib\nt64\libPortability.dll 14.7\ISE_DS\common\lib\nt64\libPortability.dll.bak
    copy patch\nt64\libPortability.dll 14.7\ISE_DS\.xinstall\bin\nt64\libPortability.dll
    copy patch\nt64\libPortability.dll 14.7\ISE_DS\EDK\lib\nt64\libPortability.dll
    copy patch\nt64\libPortability.dll 14.7\ISE_DS\EDK\lib\nt64\sdk\libPortability.dll
    copy patch\nt64\libPortability.dll 14.7\ISE_DS\ISE\lib\nt64\libPortability.dll
    copy patch\nt64\libPortability.dll 14.7\ISE_DS\ISE\lib\nt64\libPortabilityNOSH.dll
    copy patch\nt64\libPortability.dll 14.7\ISE_DS\ISE\sysgen\bin\nt64\libPortability.dll
    copy patch\nt64\libPortability.dll 14.7\ISE_DS\common\lib\nt64\libPortability.dll

    copy 14.7\ISE_DS\.xinstall\bin\nt\libPortability.dll 14.7\ISE_DS\.xinstall\bin\nt\libPortability.dll.bak
    copy 14.7\ISE_DS\EDK\lib\nt\libPortability.dll 14.7\ISE_DS\EDK\lib\nt\libPortability.dll.bak
    copy 14.7\ISE_DS\ISE\lib\nt\libPortability.dll 14.7\ISE_DS\ISE\lib\nt\libPortability.dll.bak
    copy 14.7\ISE_DS\ISE\lib\nt\libPortabilityNOSH.dll 14.7\ISE_DS\ISE\lib\nt\libPortabilityNOSH.dll.bak
    copy 14.7\ISE_DS\ISE\sysgen\bin\nt\libPortability.dll 14.7\ISE_DS\ISE\sysgen\bin\nt\libPortability.dll.bak
    copy 14.7\ISE_DS\common\lib\nt\libPortability.dll 14.7\ISE_DS\common\lib\nt\libPortability.dll.bak
    copy patch\nt\libPortability.dll 14.7\ISE_DS\.xinstall\bin\nt\libPortability.dll
    copy patch\nt\libPortability.dll 14.7\ISE_DS\EDK\lib\nt\libPortability.dll
    copy patch\nt\libPortability.dll 14.7\ISE_DS\ISE\lib\nt\libPortability.dll
    copy patch\nt\libPortability.dll 14.7\ISE_DS\ISE\lib\nt\libPortabilityNOSH.dll
    copy patch\nt\libPortability.dll 14.7\ISE_DS\ISE\sysgen\bin\nt\libPortability.dll
    copy patch\nt\libPortability.dll 14.7\ISE_DS\common\lib\nt\libPortability.dll

    copy 14.7\ISE_DS\PlanAhead\bin\rdiArgs.bat 14.7\ISE_DS\PlanAhead\bin\rdiArgs.bat.bak
    copy patch\rdiArgs.bat 14.7\ISE_DS\PlanAhead\bin\rdiArgs.bat
)
