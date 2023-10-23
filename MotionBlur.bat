@echo off
title MotionBlur
ffprobe -v error -select_streams v:0 -show_entries stream=r_frame_rate -i %1 -of csv=p=0 > %temp%\fps.txt
set /p infps=<%temp%\fps.txt
if exist "%temp%\fps.txt" (del "%temp%\fps.txt")
set /a infps=%infps%
set /p "bluramt=What is the desired blur amount: "
set /p "intnum=What do you want to interpolate to: "
set /p "outfps=What is the desired output fps:"
set tmixframes=((%infps%*%bluramt%)/%outfps%)
cls
echo Adding MotionBlur...
ffmpeg -hide_banner -loglevel error -stats -i %1 -vf "minterpolate=fps=%intnum%" -vf tmix=frames=%tmixframes%:weights="1",fps=%outfps% -qp 15 -c:a copy "%~dpn1 (%intnum%, %bluramt%)%~x1"
cls
echo Added Motionblur!
echo.
echo Press any key to exit...
pause > nul