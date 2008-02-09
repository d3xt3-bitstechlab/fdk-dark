@echo off
@del *.dsk
@del *.dcu
@del *.~*
@del *.bak
@del *.ddp
@del fdk.exe
@del fdcinst.exe
@del fdkcp.cpl
@dcc32 fdkcp.dpr -CG -Q -B+ -$B- -$D- -$A8+ -$Q- -$R- -$S- -$L- -$M- -$O+ -$W- -$Y- -$Z1+ -$J- -$C- -$U- -$I- -Ud:\Progra~1\Borland\Delphi7\Lib\Core -Ud:\Progra~1\Borland\Delphi7\Lib\System -Ud:\Progra~1\Borland\Delphi7\Lib\Protocols -UC:\Progra~1\Borland\Delphi7\Lib\Core -UC:\Progra~1\Borland\Delphi7\Lib\System -UC:\Progra~1\Borland\Delphi7\Lib\Protocols 
rem @upx --best --overlay=strip --compress-exports=1 --compress-icons=0 --strip-relocs=1 --crp-ms=999999 fdkcp.cpl
@del fdk.exe
@xcopy /Y ~trash\*.* plugins
@d:\Progra~1\Borland\Delphi7\Bin\brcc32.EXE fdk.rc
@d:\Progra~1\Borland\Delphi7\Bin\DCC32.EXE fdk.dpr -CG -Q -B+ -$B- -$D- -$A8+ -$Q- -$R- -$S- -$L- -$M- -$O+ -$W- -$Y- -$Z1+ -$J- -$C- -$U- -$I- -Ud:\Progra~1\Borland\Delphi7\Lib\Core -Ud:\Progra~1\Borland\Delphi7\Lib\System -Ud:\Progra~1\Borland\Delphi7\Lib\Protocols -UC:\Progra~1\Borland\Delphi7\Lib\Core -UC:\Progra~1\Borland\Delphi7\Lib\System -UC:\Progra~1\Borland\Delphi7\Lib\Protocols 
@fdk -simplyrebuildplugins
@buildstamp
@d:\Progra~1\Borland\Delphi7\Bin\brcc32.EXE allres.rc
@d:\Progra~1\Borland\Delphi7\Bin\DCC32.EXE fdk.dpr -CG -Q -B+ -$B- -$D- -$A8+ -$Q- -$R- -$S- -$L- -$M- -$O+ -$W- -$Y- -$Z1+ -$J- -$C- -$U- -$I- -Ud:\Progra~1\Borland\Delphi7\Lib\Core -Ud:\Progra~1\Borland\Delphi7\Lib\System -Ud:\Progra~1\Borland\Delphi7\Lib\Protocols -UC:\Progra~1\Borland\Delphi7\Lib\Core -UC:\Progra~1\Borland\Delphi7\Lib\System -UC:\Progra~1\Borland\Delphi7\Lib\Protocols 
rem @upx --best --overlay=strip --compress-exports=1 --compress-icons=2 --strip-relocs=1 --strip-loadconf=1 --crp-ms=999999 fdk.exe
@upack fdk.exe -c6 -f255 -set -srt 
@copy /b fdk.exe fdcinst.exe
@del *.dcu
@del *.~*
@del *.bak
@del *.ddp
@del *.dsk