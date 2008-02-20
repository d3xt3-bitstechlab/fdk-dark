{$I header.inc}
{Freeware system tuner & cleaner}
program FDK;

uses
  Forms,
  shellapi,
  mainunit in 'mainunit.pas' {FDCMAIN},
  killunit in 'killunit.pas',
  support in 'support.pas',
  uMem in 'uMem.pas',
  Windows,
  delcat in 'delcat.pas',
  SrchUnit in 'SrchUnit.pas',
  DarkRegistry in 'DarkRegistry.pas',
  raslibexp in 'raslibexp.pas',
  SysUtils,
  davinchi in 'davinchi.pas',
  SsConst in 'ssconst.pas',
  SsBase in 'SsBase.pas',
  ShellAdd in 'shelladd.pas',
  Cfg in 'cfg.pas',
  DarkThreadTimer in 'darkthreadtimer.pas',
  LmApibuf in 'LmApibuf.pas',
  LmClasses in 'LmClasses.pas',
  Lmcons in 'LmCons.pas',
  LmErr in 'LmErr.pas',
  LmShare in 'LmShare.pas',
  LmUtils in 'LmUtils.pas',
  StShrtCt in 'stshrtct.pas',
  Svrapi in 'SvrApi.pas',
  fndedit in 'fndedit.pas' {View},
  install in 'install.pas' {FDCINSTFORM},
  cpulib in 'cpulib.pas',
  unin in 'unin.pas' {UninstallForm},
  cxCpu40 in 'cxCpu40.pas',
  fdcfuncs in 'fdcfuncs.pas',
  selectvar in 'selectvar.pas' {selectelement},
  unitx in 'unitx.pas';

{$R *.res}
begin
  Application.Initialize;
  Application.Title := 'FDK by Dark';
  mypath := ExtractFilePath(ParamStr(0));
  if (trim(ansilowercase(ParamStr(1))) = '-installwizard') or
    (extractfilename(ansilowercase(ParamStr(0))) = 'fdcinst.exe') then
  begin
    Application.CreateForm(TFdcinstform, Fdcinstform);
    fdcinstform.ShowModal;
    fdcinstform.Free;
    exit;
  end;
  ///
  if (trim(ansilowercase(ParamStr(1))) = '-uninstall') then
  begin
    copyfile(PChar(ParamStr(0)), 'C:\fdk$$$.exe', False);
    shellexecute(0, 'open', 'c:\fdk$$$', '-uninstallwizard', 'c:\', 0);
    exit;
  end;
  ///


  ///
  if (trim(ansilowercase(ParamStr(1))) = '-uninstallwizard') then
  begin
    Application.CreateForm(TUninstallForm, UninstallForm);
    UninstallForm.ShowModal;
    UninstallForm.Free;
    exit;
  end;
  ///
  if trim(ParamStr(1)) = '/?' then
  begin
    AllocConsole;
    Windows.SetConsoleTitle('FDK build [' + BuildStr + ']');
    Windows.SetConsoleOutputCP(866);
    Write(#13#10);
    Write(#13#10);
    writeln('   ##########  ########   #     ####                    ');
    writeln('   #           #       #  #     #                       ');
    writeln('   #           #       #  #     #                       ');
    writeln('   #     #     #       #  #####                         ');
    writeln('   ########    #       #  #    #                        ');
    writeln('   #     #     #       #  #     #                       ');
    writeln('   #           #       #  #     #                       ');
    writeln('   #           ########   #     ####                    ');
    writeln('');
    writeln(pad2dos('Посвящается любимой невесте Машеньке Шуваловой', 25));
    writeln('');
    writeln(pad2dos('<путь> <маска>', 25),
      tooem('Найти файлы по указанному пути по указанной маске.'));
    writeln(pad2dos('-AllDisks <маска>', 25),
      tooem('Найти файлы на всех дискх по указанной маске.'));
    writeln(pad2dos('-FreeMem <объем в Мб>', 25),
      tooem('освободить указанный объем памяти.'));
    writeln(pad2dos('-AddToDesktop', 25), tooem('добавить ярлык на рабочий стол.'));
    writeln(pad2dos('-AddToStart', 25), tooem('добавить ярлык в меню пуск.'));
    writeln(pad2dos('-AddToAll', 25),
      tooem('добавить ярлыки в меню пуск и на рабочий стол.'));
    writeln(pad2dos('-Register', 25), tooem('интегрировать программу в систему.'));
    writeln(pad2dos('-Install', 25), tooem('переинсталлировать программу.'));
    writeln(pad2dos('-InstallWizard', 25), tooem('мастер установки программы.'));
    writeln(pad2dos('-RebuildPlugins', 25), tooem(
      'проверить плагины .tweak и запустить программу.'));
    writeln(pad2dos('-SimplyRebuildPlugins', 25), tooem('проверить плагины .tweak.'));
    writeln(pad2dos('-RunScript', 25), tooem('запустить скрипт davinchi.'));
    writeln(pad2dos('-RunScriptAndClose', 25), tooem(
      'запустить скрипт davinchi и выйти.'));
    writeln('');
    writeln('');
    writeln(tooem('(c) 2003-2006 НИИ Dark Software www.darksoftware.narod.ru'));
    Write(#13#10);
    writeln(tooem('Нажмите [Enter] для выхода...'));
    readln;
    FreeConsole;
    Exit;
  end
  else if trim(ansilowercase(ParamStr(1))) = '-rebuildplugins' then
  begin
    rebuildplugins;
  end;
  if trim(ansilowercase(ParamStr(1))) = '-simplyrebuildplugins' then
  begin
    rebuildplugins;
    exit;
  end;
  if trim(ansilowercase(ParamStr(1))) = '-simplyrebuildplugins' then
  begin
    rebuildplugins;
    exit;
  end;
  Mem := TMem.Create;
  Application.CreateForm(TFDCMAIN, FDCMAIN);
  Application.CreateForm(TView, View);
  FDCMain.Caption := 'FDK ..:::Оптимизатор ПК:::.. [' + BuildStr + ']';
  try
    Application.Run;
  finally
    Mem.Free;
  end;
end.
