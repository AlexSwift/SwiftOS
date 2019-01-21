@ echo off
:build:
C:\cygwin64\bin\bash --login -c "cd /cygdrive/d/SwiftOS/2018; ./premake5 gmake; make -C project/"
pause
goto build