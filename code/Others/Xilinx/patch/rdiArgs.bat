rem #
rem # COPYRIGHT NOTICE
rem # Copyright 1986-1999, 2001-2012 Xilinx, Inc. All Rights Reserved.
rem #

if not defined RDI_ARGS_FUNCTION (
  goto SETUP
) else (
  goto %RDI_ARGS_FUNCTION%
)

:SETUP
  rem #
  rem # Default to OS platform options
  rem #
  rem #if [%RDI_OS_ARCH%] == [64] (
  rem #  set RDI_PLATFORM=win64
  rem #) else (
    set RDI_PLATFORM=win32
  rem #)

  set RDI_ARGS=
  :parseArgs
    if [%1] == [] (
      goto argsParsed
    ) else (
    if [%1] == [-m32] (
      set RDI_PLATFORM=win32
    ) else (
    if [%1] == [-m64] (
      if [%RDI_OS_ARCH%] == [64] (
        set RDI_PLATFORM=win32
      ) else (
        echo WARNING: 64bit architecture not detected. Defaulting to 32bit.
      )
    ) else (
    if [%1] == [-exec] (
      set RDI_PROG=%2
      shift
    ) else (
    if [%1] == [-mode] (
      set RDI_ARGS=%RDI_ARGS% %1
      if [%2] == [batch] (
        set RDI_BATCH_MODE=True
        set RDI_ARGS=!RDI_ARGS! %2
        shift
      )
    ) else (
      set RDI_ARGS=%RDI_ARGS% %1
    )))))
    shift
    goto parseArgs
  :argsParsed

  set RDI_VERBOSE=False

  set RDI_DATADIR=%RDI_APPROOT%/data
  set TEMP_PATCHROOT=!RDI_PATCHROOT!
  :TOKEN_LOOP_DATADIR
  for /F "delims=;" %%d in ("!TEMP_PATCHROOT!") do (
    if exist "%%d/data" (
      set RDI_DATADIR=%%d/data;!RDI_DATADIR!
    )
  )
  :CHARPOP_DATADIR
  set CHARPOP=!TEMP_PATCHROOT:~0,1!
  set TEMP_PATCHROOT=!TEMP_PATCHROOT:~1!
  if "!TEMP_PATCHROOT!" EQU "" goto END_TOKEN_LOOP_DATADIR
  if "!CHARPOP!" NEQ ";" goto CHARPOP_DATADIR
  goto TOKEN_LOOP_DATADIR
  :END_TOKEN_LOOP_DATADIR

  set RDI_JAVAROOT=%RDI_APPROOT%/tps/%RDI_PLATFORM%/jre

  rem #
  rem # Strip /planAhead off %RDI_APPROOT% to discovery the
  rem # common ISE installation.
  rem #
  if not [%XIL_PA_NO_XILINX_OVERRIDE%] == [1] (
    if exist "%RDI_BASEROOT%/ISE" (
      set XILINX=%RDI_BASEROOT%/ISE
    )
  )

  if not [%XIL_PA_NO_XILINX_EDK_OVERRIDE%] == [1] (
    if exist "%RDI_BASEROOT%/EDK" (
      set XILINX_EDK=%RDI_BASEROOT%/EDK
    )
  )

  if exist "%RDI_BASEROOT%/common" (
      set XILINX_COMMON_TOOLS=%RDI_BASEROOT%/common
  )
  if not defined RDI_ARGS_FUNCTION (
    set RDI_ARGS_FUNCTION=RDI_EXEC_DEFAULT
  )

  goto :EOF

:RDI_EXEC_DEFAULT
  "%RDI_PROG%" %RDI_ARGS%
  goto :EOF


