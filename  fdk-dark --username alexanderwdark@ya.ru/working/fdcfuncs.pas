 {Freeware system tuner & cleaner}
 {(C) 2003-2005 Dark}
unit fdcfuncs;

interface

uses SysUtils, Windows, darkregistry, Classes, tlhelp32,
  wininet, inifiles, ComCtrls, delcat, shlobj, strutils, Dialogs;

procedure RunAndWait(cmdline: string);
procedure RebuildIconCache;
procedure ReMixTweaks(i1, i2: integer);
function TweakByname(s: string): integer;
procedure SortTweaks;
procedure loadruns(f: string);
procedure SaveRuns(f: string);
function BoolToStr(b: boolean): string;
function getharddrives: string;
function inputdir(Handle: HWND; var FolderName: string; Caption: string;
  netdir: boolean): boolean;
procedure SetAutoRun(str: string);
procedure findautorun;
procedure FindCheats;
procedure ChSF;
procedure GetShellFolders;
function WinVerNum: string;
function GetTIF: string;
function GetHistory: string;
function GetCookie: string;
function GetAppData: string;
function BoolToStrYN(b: boolean): string;
procedure DelInstalled;
procedure GetInstalled;
procedure DelWMP;
function GetHistoryOff: boolean;
function WinVer: string;
function WinProduct: string;
function WinPlus: string;
function WinKey: string;
function WinID: string;
function WinSysDir: string;
function BinPersent: integer;
function BinEnabled: boolean;
function IsActiveDeskTopOn: boolean;
procedure IEcache;
procedure ReadReg;
procedure EnvList;
procedure WriteComs;
procedure ListProc;
procedure WriteRun;
function DiskNum(Drive: char): byte;
function GetWallpaper: string;
procedure SetWallpaper(s: string);
procedure ParametersInfo;
procedure BIOSInfo;
procedure BIOSInfoNT;
procedure NonHardwareInfo;
procedure MemoryInfo;
procedure VideoInfo;
procedure OSInfo;
function GetCPUSpeed: double;
function TempDir: string;
function windir: string;
function OnCD: bool;
function isRODir: boolean;
function GetDefaultPrn: ansistring;
function WinSP: string;
function GetSP: string;
function isWin9xSafe: boolean;
procedure DelHistory;
procedure DelPref;
procedure XDir(Dir: string);
procedure Add(what: string); stdcall;
procedure Add2(what: TStrings); stdcall;
function Pad(Text: string; Spaces: integer): string;
function Pad2DOS(Text: string; Spaces: integer): string;
function toansi(s: string): string;
function tooem(s: string): string;
function DeleteFileAdv(s: string): boolean;

var
  NT: boolean = False;
  windowsdir: string = '';

type
  tvt  = (dtNONE, dtINT, dtSTR, dtBIN);
  TRaw = array of byte;

var
  numtweak: integer = 0;

type
  TTWREC = record
    TweakType: (ttreg, ttini, ttcfg);
    Value_type: tVT;
    Root_Key: (HKLM, HKCU, HKU, HKCC, HKCR, ERR);
    Os:      (wany, w9x, wnt);
    Path:    string;
    Val_On:  variant;
    Val_ON_MDV: boolean;
    Val_ON_MDK: boolean;
    Val_Off: variant;
    Val_Off_MDV: boolean;
    Val_Off_MDK: boolean;
    Default: variant;
    Default_MDV: boolean;
    Default_MDK: boolean;
    Value_Name: string;
    Section: string;
    User:    boolean;
    Desc:    string;
    size:    integer;
  end;

var
  Tweaks: array of TTWREC;

var
  strbuf: TStrings;

var
  strdest: (norm, buf);




procedure FreePIDL(PIDL: PItemIDList); stdcall;

implementation

uses mainunit;

function DeleteFileAdv(s: string): boolean;
begin
  if not fileexists(s) then
    begin
    Result := True;
    exit;
    end;
  Result := FileSetReadOnly(s, False);
  if Result then
    begin
    Result := DeleteFile(PChar(s));
    end
  else
    begin
    end;
end;



procedure RunAndWait(cmdline: string);
var
  si: STARTUPINFO;
  pi: PROCESS_INFORMATION;
begin
  ZeroMemory(@si, sizeof(si));
  si.cb := SizeOf(si);
  if not CreateProcess(nil, // No module name (use command line).
    PChar(cmdline),  // Command line.
    nil,             // Process handle not inheritable.
    nil,             // Thread handle not inheritable.
    False,           // Set handle inheritance to FALSE.
    0,               // No creation flags.
    nil,             // Use parent's environment block.
    nil,             // Use parent's starting directory.
    si,              // Pointer to STARTUPINFO structure.
    pi)              // Pointer to PROCESS_INFORMATION structure.
  then
    begin
    ShowMessage('CreateProcess failed.');
    Exit;
    end;
  WaitForSingleObject(pi.hProcess, INFINITE);
  CloseHandle(pi.hProcess);
  CloseHandle(pi.hThread);
end;


procedure FreePIDL; external 'shell32.dll' index 155;


//   {$I 'Icons.inc'}



function tooem(s: string): string;
begin
  Result := stringofchar(' ', length(s) + 1);
  chartooem(PChar(s), PChar(Result));
end;

function toansi(s: string): string;
begin
  Result := stringofchar(' ', length(s));
  oemtochar(PChar(s), PChar(Result));
end;


function Pad(Text: string; Spaces: integer): string;
begin
  Result := Text;
  if Length(Result) > spaces then
    setlength(Result, spaces)
  else
    Result := Result + StringOfChar(' ', spaces - length(Result));
end;

function Pad2DOS(Text: string; Spaces: integer): string;
begin
  Result := Text;
  Result := tooem(Result) + StringOfChar(' ', spaces - length(Result));
end;


procedure Add(what: string); stdcall;
begin
  if strdest <> buf then
    Fdcmain.otc.Lines.add(what)
  else
    begin
    strbuf.add(what);
    end;
end;

procedure Add2(what: TStrings); stdcall;
var
  i: integer;
begin
  if strdest <> buf then
    begin
    for i := 0 to what.Count - 1 do
      Fdcmain.otc.Lines.add(what[i]);
    end
  else
    begin
    strbuf.AddStrings(what);
    end;
end;


function Pos(substr, str: string): integer;
begin
  Result := AnsiPos(UpperCase(substr), UpperCase(str));
end;


{function IsNetWork: boolean;
begin
  Result := (GetSystemMetrics(SM_NETWORK) and 1) <> 0;
end;}

function GetDefaultPrn: ansistring;
var
  ini: TiniFile;
begin
  ini    := tinifile.Create(windowsdir + 'win.ini');
  Result := ini.ReadString('Windows', 'Device', '');
  ini.Free;
end;


function WinDir: string;
var
  PRes: string;
  L:    integer;
begin
  PRes := StringOfChar(' ', 256);
  l    := GetWindowsDirectory(PChar(PRes), 255);
  SetLength(PRes, l);
  Result := PRes;
  if Result <> '' then
    if Result[length(Result)] <> '\' then
      Result := Result + '\';
end;

function WinSysDir: string;
var
  PRes: string;
  l:    integer;
begin
  PRes := StringOfChar(' ', 256);
  L    := GetSystemDirectory(PChar(PRes), 255);
  SetLength(Pres, l);
  Result := PRes;
  if Result <> '' then
    if Result[length(Result)] <> '\' then
      Result := Result + '\';

end;

{function GetCPUSpeed: double;
const
  DelayTime = 500;
var
  TimerHi, TimerLo: DWORD;
  PriorityClass, Priority: integer;
begin
  PriorityClass := GetPriorityClass(GetCurrentProcess);
  Priority      := GetThreadPriority(GetCurrentThread);
  SetPriorityClass(GetCurrentProcess, REALTIME_PRIORITY_CLASS);
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_TIME_CRITICAL);
  Sleep(10);
  asm
    rdtsc
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  Sleep(DelayTime);
  asm
    rdtsc
    sub eax, TimerLo
    sbb edx, TimerHi
    mov TimerLo, eax
    mov TimerHi, edx
  end;
  SetThreadPriority(GetCurrentThread, Priority);
  SetPriorityClass(GetCurrentProcess, PriorityClass);
  Result := TimerLo / (1000.0 * DelayTime);
end;}

function getcpuspeed: double;

  function RdTsc: int64;
  asm
    //   dw 310Fh
    rdtsc
  end;
var
  C1, T1, C2, T2, F: int64;
  Tc: DWORD;
begin
    {$O-}
  C1 := RdTsc;
  QueryPerformanceCounter(T1);
  Tc := GetTickCount;
  while GetTickCount - Tc < 5 do
  ;
  C2 := Rdtsc;
  QueryPerformanceCounter(T2);
  QueryPerformanceFrequency(F);
    {$O+}
  Result := (C2 - C1) / ((T2 - T1) / F) / 1E6;
end;


function TempDir: string;
var
  Buffer: array[0..MAX_PATH + 1] of char;
begin
  GetTempPath(MAX_PATH + 1, Buffer);
  TempDir := StrPas(Buffer);
end;

{procedure XDir(Dir: string);
var
  S: TSHFileOpStruct;
begin
  if (Dir <> '') and (Dir[length(Dir)] <> '\') then
    Dir := Dir + '\';
  FillChar(S, sizeof(S), 0);
  S.wFunc  := FO_DELETE;
  S.pFrom  := pchar(Dir + '*.*');
  S.fFlags := 0;//FOF_NOCONFIRMATION or FOF_SILENT or FOF_SIMPLEPROGRESS;
  if messagebox(0, pchar('Будут удалены файлы каталога '+'''' + s.pFrom + ''''),
    pchar('Подтверждение'), mb_OKCancel + mb_IconWarning) = idOk then
    ShFileOperation(S);
end;}

procedure XDir(Dir: string);
begin
{  if messagebox(0, pchar('Будут удалены файлы каталога ' + '''' + Dir + ''''),
    pchar('Подтверждение'), mb_OKCancel + mb_IconWarning) = idOk then}
  if DarkKillDir(Dir) then
    CreateDir(Dir);
end;


procedure ParametersInfo;
var
  Bl: bool;
  KeyboardDelay: longint;
  KeyboardSpeed: longint;
  ScreenSaveTimeOut: longint;

begin

  // Разрешен ли PC Speaker
  SystemParametersInfo(SPI_GETBEEP, 0, @Bl, 0);
  Add('Гудок динамика включен: ' + booltostr(bl));

  // Активен ли хранитель экрана
  SystemParametersInfo(SPI_GETSCREENSAVEACTIVE, 0, @Bl, 0);
  Add('Хранитель экрана включен: ' + booltostr(bl));

  // Интервал вызова хранителя экрана
  SystemParametersInfo(SPI_GETSCREENSAVETIMEOUT, 0, @ScreenSaveTimeOut, 0);
  SystemParametersInfo(SPI_GETKEYBOARDDELAY, 0, @KeyboardDelay, 0);
  SystemParametersInfo(SPI_GETKEYBOARDSPEED, 0, @KeyboardSpeed, 0);
  Add('Задержка клавиатуры: ' + IntToStr(KeyboardDelay));
  Add('Скорость клавиатуры: ' + IntToStr(KeyboardSpeed));
  Add(Format('Интервал хранителя экрана, минут: %d', [ScreenSaveTimeOut div 60]));
end;

// Информация о дате создания BIOS-а.
procedure BIOSInfo;
var
  sMainBoardBiosCopyright, sMainBoardBiosDate, sMainBoardBiosName,
  sMainBoardBiosSerialNo: string;

begin
  try
    sMainBoardBiosName      := string(PChar(Ptr($FE061))); // Имя
    sMainBoardBiosCopyright := string(PChar(Ptr($FE091))); // Права
    sMainBoardBiosDate      := string(PChar(Ptr($FFFF5))); //  Дата
    sMainBoardBiosSerialNo  := string(PChar(Ptr($FEC71)));  // Номер
  except
    sMainBoardBiosName      := '';
    sMainBoardBiosCopyright := '';
    sMainBoardBiosDate      := '';
    sMainBoardBiosSerialNo  := '';
    end;
  Add('Наименование БИОС : ' + sMainBoardBiosName);
  Add('Производитель БИОС : ' + sMainBoardBiosCopyRight);
  Add('Дата выпуска БИОС : ' + sMainBoardBiosDate);
  Add('Серийный номер (версия) БИОС : ' + sMainBoardBiosSerialNo);
end;


procedure BiosInfoNT;
var
  Registryv: TDarkRegistry;
  RegPath: string;
  str: PChar;
begin

  RegPath   := '\HARDWARE\DESCRIPTION\System';
  registryv := TDarkRegistry.Create;
  registryv.rootkey := HKEY_LOCAL_MACHINE;
  try
    registryv.Openkey(RegPath);
    Add('Дата БИОС: ' + RegistryV.ReadString('SystemBiosDate'));
    Str := StrAlloc(255);
    RegistryV.ReadBinaryData('SystemBiosVersion', str^, 100);
    Add('Версия БИОС: ' + str);
    StrPCopy(str, StringOfChar(' ', 255));
    Add('Дата видео БИОС: ' + RegistryV.ReadString('VideoBiosDate'));
    RegistryV.ReadBinaryData('VideoBiosVersion', str^, 119);
    Add('Версия видео БИОС: ' + str);
    StrDispose(str);
  except
    end;
  Registryv.Free;
end;


procedure NonHardwareInfo;
var
  PRes: ansistring;
  BRes: boolean;
  Size: cardinal;
begin
  Size := MAX_COMPUTERNAME_LENGTH + 1;
  Pres := StringOfChar(' ', Size);
  BRes := GetComputerName(PChar(PRes), Size);
  if BRes then
    Add('Имя компьютера : ' + PRes);
  Pres := StringOfChar(' ', Size);
  BRes := GetUserName(PChar(PRes), Size);
  if BRes then
    Add('Имя пользователя: ' + PRes);
end;

procedure MemoryInfo;
var
  lpMemoryStatus: TMemoryStatus;
begin
  lpMemoryStatus.dwLength := SizeOf(lpMemoryStatus);
  GlobalMemoryStatus(lpMemoryStatus);
  with lpMemoryStatus do
    begin
    Add('Загрузка памяти на: ' + IntToStr(dwMemoryLoad) + '%');
    Add('Всего ОЗУ: ' + Format('%0.0f Мбайт', [dwTotalPhys div 1024 / 1024]));
    Add('Свободно ОЗУ: ' + Format('%0.3f Мбайт', [dwAvailPhys div 1024 / 1024]));
    Add('Файл подкачки: ' + Format('%0.0f Мбайт',
      [dwTotalPageFile div 1024 / 1024]));
    Add('Доступно в подкачке: ' + Format('%0.0f Мбайт',
      [dwAvailPageFile div 1024 / 1024]));
    end;
end;

procedure VideoInfo;
var
  DC: hDC;
  c:  string;
begin
  DC := CreateDC('DISPLAY', nil, nil, nil);
  Add('Ширина экрана (пикс.): ' + IntToStr(GetDeviceCaps(DC, HORZRES)));
  Add('Высота экрана (пикс.): ' + IntToStr(GetDeviceCaps(DC, VERTRES)));
  Add('Ширина экрана (мм.): ' + IntToStr(GetDeviceCaps(DC, HORZSIZE)));
  Add('Высота экрана (мм.): ' + IntToStr(GetDeviceCaps(DC, VERTSIZE)));
  Add('Битов на пиксель :' + IntToStr(GetDeviceCaps(DC, BITSPIXEL)));
  case GetDeviceCaps(DC, BITSPIXEL) of
    8:
      c := '256 цветов';
    15:
      c := 'Hi-Color / 32768 цветов';
    16:
      c := 'Hi-Color / 65536 цветов';
    24:
      c := 'True-Color / 16 млн цветов';
    32:
      c := 'True-Color / 32 бит';
    end;
  Add('Цветов: ' + c);
  DeleteDC(DC);
end;

procedure OSInfo;
var
  NT:   boolean;
  BRes: boolean;
  lpVersionInformation: TOSVersionInfo;
  c:    string;
begin
  NT := False;
  Add('Каталог Windows: ' + WindowsDir);
  Add('Системный каталог: ' + WinSysDir);
  // Имя ОС
  lpVersionInformation.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  BRes := GetVersionEx(lpVersionInformation);
  if BRes then
    with lpVersionInformation do
      case dwPlatformId of
        VER_PLATFORM_WIN32_WINDOWS:
          begin
          if dwMinorVersion = 0 then
            c := 'Windows 95'
          else
            c := 'Windows 98';
          if (dwMinorVersion = 90) then
            c := 'Windows Me';
          c := c + ' ' + IntToStr(dwMajorVersion) + '.' + IntToStr(dwMinorVersion);
          end;
        VER_PLATFORM_WIN32_NT:
          begin
          nt := True;
          c  := 'Windows NT';
          if dwMajorVersion = 3 then
            c := 'Windows NT 3.51'
          else
          if dwMajorVersion = 4 then
            c := 'Windows NT 4.0'
          else
          if (dwMajorVersion = 5) and (dwMinorVersion = 0) then
            c := 'Windows 2000'
          else
          if (dwMajorVersion = 5) and (dwMinorVersion = 1) then
            c := 'Windows XP';
          c := c + ' ' + IntToStr(dwMajorVersion) + '.' + IntToStr(dwMinorVersion);
          end;
        VER_PLATFORM_WIN32s:
          begin
          c := 'Win 3.1 c поддержкой Win32s';
          c := c + ' ' + IntToStr(dwMajorVersion) + '.' + IntToStr(dwMinorVersion);
          end;

        end;
  Add('Версия ОС: ' + c);
  if not NT then
    Add('Тип ОС: Win9x')
  else
    Add('Тип ОС: WinNT');

end;


function GetWallpaper: string;
var
  reg: TDarkRegistry;
begin
  reg := TDarkRegistry.Create;
  reg.RootKey := HKey_Current_User;
  reg.OpenKey('Control Panel\Desktop');
  Result := reg.ReadString('Wallpaper');
  reg.CloseKey;
  reg.Free;
end;

procedure SetWallpaper(s: string);
var
  reg: TDarkRegistry;
begin
  reg := TDarkRegistry.Create;
  reg.RootKey := HKey_Current_User;
  reg.OpenKey('Control Panel\Desktop');
  reg.WriteString('Wallpaper', s);
  reg.CloseKey;
  reg.Free;
end;


procedure WriteComs;
var
  reg: TDarkRegistry;
  ts:  TStrings;
  i:   integer;
begin
  reg := TDarkRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey('hardware\devicemap\serialcomm');
  ts := TStringList.Create;
  reg.GetValueNames(ts);
  Add('Найденные COM порты');
  for i := 0 to ts.Count - 1 do
    Add(reg.ReadString(ts.Strings[i]));
  ts.Free;
  reg.CloseKey;
  reg.Free;
end;

function DiskNum(Drive: char): byte;
begin
  Drive   := UpCase(Drive);
  DiskNum := Ord(Drive) - Ord('A') + 1;
end;

function DriveExists(Drive: byte): boolean;
var
  Drives: set of 0..25;
begin
  integer(Drives) := GetLogicalDrives;
  Result := Drive in Drives;
end;


function CheckDriveType(Drive: byte): string;
var
  DriveLetter: char;
  DriveType:   UInt;
begin
  DriveLetter := Chr(Drive + $41);
  DriveType   := GetDriveType(PChar(DriveLetter + ':\'));
  case DriveType of
    0:
      Result := '?';
    1:
      Result := 'Path does not exists';
    DRIVE_REMOVABLE:
      Result := 'Removable';
    DRIVE_FIXED:
      Result := 'Fixed';
    DRIVE_REMOTE:
      Result := 'Remote';
    DRIVE_CDROM:
      Result := 'CD_ROM';
    DRIVE_RAMDISK:
      Result := 'RAMDISK'
    else
      Result := 'Unknown'
    end;
end;


{function GetWaveVolume: DWord;
var
  Woc:    TWaveOutCaps;
  Volume: DWord;
begin
  Result := 0;
  if WaveOutGetDevCaps(WAVE_MAPPER, @Woc, sizeof(Woc)) = MMSYSERR_NOERROR then
  begin
    if Woc.dwSupport and WAVECAPS_VOLUME = WAVECAPS_VOLUME then
    begin
      WaveOutGetVolume(WAVE_MAPPER, @Volume);
      Result := Volume;
    end;
  end;
end;}

{
procedure SetWaveVolume(const AVolume: DWord);
var
  Woc: TWaveOutCaps;
begin
  if WaveOutGetDevCaps(WAVE_MAPPER, @Woc, sizeof(Woc)) = MMSYSERR_NOERROR then
  begin
    if Woc.dwSupport and WAVECAPS_VOLUME = WAVECAPS_VOLUME then
      WaveOutSetVolume(WAVE_MAPPER, AVolume);
  end;
end;}

procedure WriteRun;
var
  reg: TDarkRegistry;
  ts:  TStrings;
  i:   integer;
begin
  reg := TDarkRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run');
  ts := TStringList.Create;
  reg.GetValueNames(ts);
  Add('[ Run ]');
  for i := 0 to ts.Count - 1 do
    Add(ts.Strings[i] + ' = ' + reg.ReadString(ts.Strings[i]));
  reg.CloseKey;
  reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce');
  ts := TStringList.Create;
  reg.GetValueNames(ts);
  Add('[ RunOnce ]');
  for i := 0 to ts.Count - 1 do
    Add(ts.Strings[i] + ' = ' + reg.ReadString(ts.Strings[i]));
  reg.CloseKey;
  reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices');
  ts := TStringList.Create;
  reg.GetValueNames(ts);
  Add('[ RunServices ]');
  for i := 0 to ts.Count - 1 do
    Add(ts.Strings[i] + ' = ' + reg.ReadString(ts.Strings[i]));
  reg.CloseKey;
  reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServicesOnce');
  ts := TStringList.Create;
  reg.GetValueNames(ts);
  Add('[ RunServicesOnce ]');
  for i := 0 to ts.Count - 1 do
    Add(ts.Strings[i] + ' = ' + reg.ReadString(ts.Strings[i]));
  reg.CloseKey;
  reg.RootKey := HKEY_CURRENT_USER;
  reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run');
  ts := TStringList.Create;
  reg.GetValueNames(ts);
  Add('[ User Run ]');
  for i := 0 to ts.Count - 1 do
    Add(ts.Strings[i] + ' = ' + reg.ReadString(ts.Strings[i]));
  reg.CloseKey;
  reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce');
  ts := TStringList.Create;
  reg.GetValueNames(ts);
  Add('[ User RunOnce ]');
  for i := 0 to ts.Count - 1 do
    Add(ts.Strings[i] + ' = ' + reg.ReadString(ts.Strings[i]));
  reg.CloseKey;
  reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices');
  ts := TStringList.Create;
  reg.GetValueNames(ts);
  Add('[ User RunServices ]');
  for i := 0 to ts.Count - 1 do
    Add(ts.Strings[i] + ' = ' + reg.ReadString(ts.Strings[i]));
  reg.CloseKey;
  reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServicesOnce');
  ts := TStringList.Create;
  reg.GetValueNames(ts);
  Add('[ User RunServicesOnce ]');
  for i := 0 to ts.Count - 1 do
    Add(ts.Strings[i] + ' = ' + reg.ReadString(ts.Strings[i]));
  reg.CloseKey;

  ts.Free;
  reg.Free;
end;

function isWin9x: Bool; {True=Win9x}{False=NT}
asm
  xor eax, eax
  mov ecx, cs
  xor cl, cl
  jecxz @@quit
  inc eax
  @@quit:
end;

procedure ListProc;
var
  cp, cm: cardinal;
  pe:     TProcessEntry32;
  me:     moduleentry32;
  x:      integer;
begin
  pe.dwSize := sizeof(TProcessEntry32);
  me.dwSize := sizeof(moduleentry32);
  Add('Информация о процессах системы:');
  X  := 0;
  cp := CreateToolHelp32Snapshot(TH32CS_SnapProcess, 0);
  try
    if Process32First(cp, pe) then
      repeat
        Inc(x);
        Add(Format('%-4d: %-32s [%-4d потоков]',
          [x, extractfilename(pe.szExeFile), pe.cntThreads]));
        cm := CreateToolHelp32Snapshot(TH32CS_SnapModule, pe.th32ProcessID);
        if module32first(cm, me) then
          begin
          Add(extractfilename(pe.szExeFile) + ' использует модули:');
          repeat
            Add(Format('%s', [extractfilename(me.szModule)]));
          until not module32next(cm, me);
          end;
        closehandle(cm);
      until not Process32Next(cp, pe);

    Add('Всего запущенных процессов: ' + IntToStr(x));
  finally
    CloseHandle(cp);
    end;
end;

procedure SysGetEnvironmentList(List: TStrings; NamesOnly: boolean);

var
  s:     string;
  i, l:  longint;
  hp, p: PChar;

begin
  p  := GetEnvironmentStrings;
  hp := p;
  while hp^ <> #0 do
    begin
    s := hp;
    l := Length(s);
    if NamesOnly then
      begin
      I := pos('=', s);
      if (I > 0) then
        S := Copy(S, 1, I - 1);
      end;
    List.Add(S);
    hp := hp + l + 1;
    end;
  FreeEnvironmentStrings(p);
end;

procedure EnvList;
var
  temp: TStrings;
  i:    integer;
begin
  temp := TStringList.Create;
  SysGetEnvironmentList(temp, False);
  if temp.Count > 0 then
    for i := 0 to temp.Count - 1 do
      temp[i] := toansi(temp[i]);
  Add2(temp);
  temp.Free;
end;

procedure IEcache;
var
  lpEntryInfo: PInternetCacheEntryInfo;
  hCacheDir:   longword;
  dwEntrySize: longword;
  dwLastError: longword;
begin
  dwEntrySize := 0;
  FindFirstUrlCacheEntry(nil, TInternetCacheEntryInfo(nil^), dwEntrySize);
  GetMem(lpEntryInfo, dwEntrySize);
  hCacheDir := FindFirstUrlCacheEntry(nil, lpEntryInfo^, dwEntrySize);
  if (hCacheDir <> 0) then
    DeleteUrlCacheEntry(lpEntryInfo^.lpszSourceUrlName);
  FreeMem(lpEntryInfo, dwEntrySize);
  repeat
    dwEntrySize := 0;
    FindNextUrlCacheEntry(hCacheDir, TInternetCacheEntryInfo(nil^), dwEntrySize);
    dwLastError := GetLastError();
    if (GetLastError = ERROR_INSUFFICIENT_BUFFER) then
      begin
      GetMem(lpEntryInfo, dwEntrySize);
      if (FindNextUrlCacheEntry(hCacheDir, lpEntryInfo^, dwEntrySize)) then
        DeleteUrlCacheEntry(lpEntryInfo^.lpszSourceUrlName);
      FreeMem(lpEntryInfo, dwEntrySize);
      end;
  until (dwLastError = ERROR_NO_MORE_ITEMS) or (dwEntrySize = 0);
end;

function IsActiveDeskTopOn: boolean;
var
  h: longword;
begin
  h      := FindWindow('Progman', nil);
  h      := FindWindowEx(h, 0, 'SHELLDLL_DefView', nil);
  h      := FindWindowEx(h, 0, 'Internet Explorer_Server', nil);
  Result := h <> 0;
end;

function BoolToStr(b: boolean): string;
begin
  if b then
    Result := 'Да'
  else
    Result := 'Нет';
end;

function BoolToStrYN(b: boolean): string;
begin
  if b then
    Result := 'Yes'
  else
    Result := 'No';
end;

procedure ReadReg;
var
  R: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  R.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion');
  if R.ValueExists('CommonFilesDir') then
    add('Папка Common Files: ' + r.ReadString('CommonFilesDir'))
  else
    add('Папка Common Files: не найден путь');
  if R.ValueExists('ProgramFilesDir') then
    add('Папка Program Files: ' + r.ReadString('ProgramFilesDir'))
  else
    add('Папка Program Files: не найден путь');
  r.CloseKey;
  r.Free;
  Add('Каталог Cookies: ' + GetCookie);
  Add('Каталог Appication Data: ' + GetAppData);
  Add('Каталог History: ' + GetHistory);
  Add('Каталог Temporary Internet Files: ' + GetTiF);
  Add('Временный каталог: ' + tempdir);
end;


function GetRB: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CLASSES_ROOT;
  r.OpenKey('\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}');
  if R.ValueExists('') then
    Result := r.ReadString('')
  else
    Result := 'По-умолчанию';
  r.CloseKey;
  r.Free;
end;

procedure SetRB(nam: string);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CLASSES_ROOT;
  r.OpenKey('\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}');
  r.WriteString('', nam);
  r.CloseKey;
  r.Free;
end;

function BinEnabled: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\BitBucket');
  if R.ValueExists('NukeOnDelete') then
    Result := r.ReadInteger('NukeOnDelete') = 0
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

function BinPersent: integer;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\BitBucket');
  if R.ValueExists('Percent') then
    Result := r.ReadInteger('Percent')
  else
    Result := 0;
  r.CloseKey;
  r.Free;
end;

function WinVer: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  case nt of
    False:
      begin
      r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion');
      if R.ValueExists('Version') then
        Result := r.ReadString('Version')
      else
        Result := 'не установлена';
      end;
    True:
      begin
      r.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion');
      if R.ValueExists('CurrentVersion') then
        Result := r.ReadString('CurrentVersion')
      else
        Result := 'не установлена';
      end;

    end;
  r.CloseKey;
  r.Free;
end;

function WinVerNum: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion');
  if R.ValueExists('VersionNumber') then
    Result := r.ReadString('VersionNumber')
  else
    Result := 'не установлена';
  r.CloseKey;
  r.Free;
end;

function WinSP: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion');
  if R.ValueExists('BuildLab') then
    Result := r.ReadString('BuildLab')
  else
    Result := 'не установлена';
  r.CloseKey;
  r.Free;
end;


function WinProduct: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  case nt of
    False:
      r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion');
    True:
      r.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion');
    end;
  if R.ValueExists('ProductName') then
    Result := r.ReadString('ProductName')
  else
    Result := 'не установлен';
  r.CloseKey;
  r.Free;
end;

function WinPlus: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion');
  if R.ValueExists('Plus! VersionNumber') then
    Result := r.ReadString('Plus! VersionNumber')
  else
    Result := 'не установлен';
  r.CloseKey;
  r.Free;
end;

function WinID: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  case nt of
    False:
      r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion');
    True:
      r.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion');
    end;
  if R.ValueExists('ProductID') then
    Result := r.ReadString('ProductID')
  else
    Result := 'не установлен';
  r.CloseKey;
  r.Free;
end;

function WinKey: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion');
  if R.ValueExists('ProductKey') then
    Result := r.ReadString('ProductKey')
  else
    Result := 'не установлен';
  r.CloseKey;
  r.Free;
end;

function GetHistoryOff: boolean;
var
  r:   TDarkRegistry;
  buf: Dword;
begin
  buf := 0;
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoRecentDocsHistory') then
    begin
    if not NT then
      r.ReadBinaryData('NoRecentDocsHistory', buf, sizeof(DWord))
    else
      buf := r.ReadInteger('NoRecentDocsHistory');
    Result := boolean(buf);
    end
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetHistoryOff(x: boolean);
var
  r:   TDarkRegistry;
  buf: Dword;
begin
  buf := Ord(x);
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if not NT then
    r.WriteBinaryData('NoRecentDocsHistory', buf, sizeof(DWord))
  else
    r.WriteInteger('NoRecentDocsHistory', buf);
  r.CloseKey;
  r.Free;
end;

procedure DummyMSDos;
var
  T:     Text;
  i:     integer;
  msdos: TiniFile;
begin
  if not FileExists('c:\msdos.sys') then
    begin
    assignfile(T, 'c:\msdos.sys');
    rewrite(T);
    writeln(T, ';This lines we use because of filesize must be >1024 bytes');
    writeln(T, ';(c) 2003 DarkSoft (tm)');
    for i := 0 to 21 do
      writeln(T, ';xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    closefile(T);
    msdos := TIniFile.Create('c:\msdos.sys');
    msdos.WriteString('Paths', 'WinDir', ExcludeTrailingPathDelimiter(WindowsDir));
    msdos.WriteString('Paths', 'WinBoot', ExcludeTrailingPathDelimiter(WindowsDir));
    if not nt then
      msdos.WriteString('Options', 'WinVer', WinVerNum);
    if Length(Windowsdir) > 4 then
      msdos.WriteString('Paths', 'HostWinBootDrv', WindowsDir[1]);
    msdos.Free;
    end;
end;

function GetHistoryDel: boolean;
var
  r:   TDarkRegistry;
  buf: Dword;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoRecentDocsMenu') then
    begin
    if not NT then
      r.ReadBinaryData('NoRecentDocsMenu', buf, sizeof(DWord))
    else
      buf := r.ReadInteger('NoRecentDocsMenu');

    Result := boolean(buf);
    end
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetHistoryDel(x: boolean);
var
  r:   TDarkRegistry;
  buf: Dword;
begin
  buf := Ord(x);
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if not NT then
    r.WriteBinaryData('NoRecentDocsMenu', buf, sizeof(DWord))
  else
    r.WriteInteger('NoRecentDocsMenu', buf);
  r.CloseKey;
  r.Free;
end;

function GetFavDel: boolean;
var
  r:   TDarkRegistry;
  buf: Dword;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoFavoritesMenu') then
    begin
    if not NT then
      r.ReadBinaryData('NoFavoritesMenu', buf, sizeof(DWord))
    else
      buf := r.ReadInteger('NoFavoritesMenu');
    Result := boolean(buf);
    end
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetFavDel(x: boolean);
var
  r:    TDarkRegistry;
  buf:  Dword;
  ibuf: integer;
begin
  buf  := byte(x);
  ibuf := byte(not x);
  r    := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if not NT then
    r.WriteBinaryData('NoFavoritesMenu', buf, sizeof(DWord))
  else
    r.WriteInteger('NoFavoritesMenu', buf);
  r.CloseKey;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced');
  r.WriteInteger('StartMenuFavorites', ibuf);
  r.CloseKey;
  r.Free;
end;

function GetRecycle: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\Desktop\NameSpace');
  Result := R.KeyExists('{645FF040-5081-101B-9F08-00AA002F954E}');
  r.CloseKey;
  r.Free;
end;

procedure SetRecycle(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace');
  if R.KeyExists('{645FF040-5081-101B-9F08-00AA002F954E}') then
    begin
    if not x then
      r.DeleteKey('{645FF040-5081-101B-9F08-00AA002F954E}');
    end
  else
  if x then
    r.CreateKey('{645FF040-5081-101B-9F08-00AA002F954E}');
  r.CloseKey;
  r.Free;
end;

function GetNet: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\explorer\Desktop\NameSpace');
  Result := R.KeyExists('{1f4de370-d627-11d1-ba4f-00a0c91eedba}');
  r.CloseKey;
  r.Free;
end;

procedure SetNet(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace');
  if R.KeyExists('{1f4de370-d627-11d1-ba4f-00a0c91eedba}') then
    begin
    if not x then
      r.DeleteKey('{1f4de370-d627-11d1-ba4f-00a0c91eedba}');
    end
  else
  if x then
    r.CreateKey('{1f4de370-d627-11d1-ba4f-00a0c91eedba}');
  r.CloseKey;
  r.Free;
end;

procedure setdll(val: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AlwaysUnloadDLL');
  r.WriteString('', IntToStr(byte(val)));
  r.CloseKey;
  r.Free;
end;

function GetDll: boolean;
var
  a: string;
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AlwaysUnloadDLL');
  if r.ValueExists('') then
    a := r.ReadString('');
  Result := Trim(a) = '1';
  r.CloseKey;
  r.Free;
end;

function GetIcons: integer;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer');
  if R.ValueExists('Max Cached Icons') then
    Result := StrToIntDef(r.ReadString('Max Cached Icons'), 512)
  else
    Result := 512;
  r.CloseKey;
  r.Free;
end;

procedure SetIcons(s: integer);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer');
  r.WriteString('Max Cached Icons', IntToStr(s));
  r.CloseKey;
  r.Free;
end;

procedure SetCertain(x: boolean);
var
  r:   TDarkRegistry;
  buf: integer;
begin
  buf := Ord(x);
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('EnforceShellExtensionSecurity', buf);
  r.CloseKey;
  r.Free;
end;

function GetCertain: boolean;
var
  r:   TDarkRegistry;
  buf: integer;
begin

  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if r.ValueExists('EnforceShellExtensionSecurity') then
    buf := r.ReadInteger('EnforceShellExtensionSecurity')
  else
    Buf := 0;
  r.CloseKey;
  r.Free;
  Result := boolean(Buf);
end;

procedure SetADesk(x: boolean);
var
  r:   TDarkRegistry;
  buf: DWord;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  buf := Ord(x);
  if nt then
    r.Writeinteger('NoActiveDesktop', buf)
  else
    r.WriteBinaryData('NoActiveDesktop', buf, SizeOF(DWord));
  r.CloseKey;
  r.Free;
end;

function GetADesk: boolean;
var
  r:   TDarkRegistry;
  buf: DWord;
begin
  Buf := 0;
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if r.ValueExists('NoActiveDesktop') then
    if nt then
      buf := r.ReadInteger('NoActiveDesktop')
    else
      r.ReadBinaryData('NoActiveDesktop', buf, SizeOF(DWord));
  Result := boolean(Buf);
  r.CloseKey;
  r.Free;
end;

procedure SetZav(x: boolean);
var
  r:   TDarkRegistry;
  buf: DWord;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  buf := byte(x);
  if nt then
    r.WriteInteger('NoLogOff', byte(x))
  else
    r.WriteBinaryData('NoLogOff', buf, SizeOF(DWord));
  r.WriteInteger('StartMenuLogoff', Ord(x));
  r.CloseKey;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced');
  r.WriteInteger('StartMenuLogoff', Ord(x));
  r.CloseKey;
  r.Free;
end;

function GetZav: boolean;
var
  r:   TDarkRegistry;
  buf: DWord;
begin
  Buf := 0;
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if r.ValueExists('NoLogOff') then
    if nt then
      Buf := r.ReadInteger('NoLogOff')
    else
      r.ReadBinaryData('NoLogOff', buf, SizeOF(DWord));
  Result := boolean(Buf);
  r.CloseKey;
  r.Free;
end;

procedure SetAC(x: boolean);
var
  r:   TDarkRegistry;
  buf: DWord;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  buf := Ord(x);
  if nt then
    r.WriteInteger('ClearRecentDocsOnExit', buf)
  else
    r.WriteBinaryData('ClearRecentDocsOnExit', buf, SizeOF(DWord));
  r.CloseKey;
  r.Free;
end;

function GetAC: boolean;
var
  r:   TDarkRegistry;
  buf: DWord;
begin
  Buf := 0;
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if r.ValueExists('ClearRecentDocsOnExit') then
    if nt then
      buf := r.ReadInteger('ClearRecentDocsOnExit')
    else
      r.ReadBinaryData('ClearRecentDocsOnExit', buf, SizeOF(DWord));
  Result := boolean(Buf);
  r.CloseKey;
  r.Free;
end;


procedure SetLD(x: boolean);
var
  r:   TDarkRegistry;
  buf: DWORD;
begin
  Buf := $FFFFFFFF;
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('System\CurrentControlSet\Control\FileSystem');
  if x then
    r.WriteBinaryData('DisableLowDiskSpaceBroadcast', buf, SizeOF(DWord))
  else
    r.DeleteValue('DisableLowDiskSpaceBroadcast');
  r.CloseKey;
  r.Free;
end;

function GetLD: boolean;
var
  r:   TDarkRegistry;
  buf: DWord;
begin
  Buf := 0;
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('System\CurrentControlSet\Control\FileSystem');
  if r.ValueExists('DisableLowDiskSpaceBroadcast') then
    begin
    r.ReadBinaryData('DisableLowDiskSpaceBroadcast', buf, SizeOF(DWord));
    Result := Buf = $FFFFFFFF;
    end
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetScan(x: boolean);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'autoscan', Ord(not x));
  msdos.UpdateFile;
  msdos.Free;
end;

function GetScan: boolean;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := not boolean(msdos.ReadInteger('options', 'autoscan', 1));
  msdos.UpdateFile;
  msdos.Free;
end;

procedure SetLogo(x: boolean);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'Logo', Ord(not x));
  msdos.UpdateFile;
  msdos.Free;
end;

function GetLogo: boolean;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := not boolean(msdos.ReadInteger('options', 'Logo', 1));
  msdos.UpdateFile;
  msdos.Free;
end;

procedure SetLog(x: boolean);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'DisableLog', Ord(x));
  msdos.UpdateFile;
  msdos.Free;
end;

function GetLog: boolean;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := boolean(msdos.ReadInteger('options', 'DisableLog', 1));
  msdos.UpdateFile;
  msdos.Free;
end;

procedure SetGUI(x: boolean);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'BootGUI', Ord(not x));
  msdos.UpdateFile;
  msdos.Free;
end;

function GetGUI: boolean;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := not boolean(msdos.ReadInteger('options', 'BootGUI', 1));
  msdos.UpdateFile;
  msdos.Free;
end;


procedure SetWarn(x: boolean);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'BootWarn', Ord(not x));
  msdos.UpdateFile;
  msdos.Free;
end;

function GetWarn: boolean;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := not boolean(msdos.ReadInteger('options', 'BootWarn', 1));
  msdos.UpdateFile;
  msdos.Free;
end;

procedure SetMenu(x: boolean);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'BootMenu', Ord(x));
  msdos.UpdateFile;
  msdos.Free;
end;

function GetMenu: boolean;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := boolean(msdos.ReadInteger('options', 'BootMenu', 0));
  msdos.UpdateFile;
  msdos.Free;
end;

procedure SetSpace(x: boolean);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'DrvSpace', Ord(not x));
  msdos.WriteInteger('options', 'DblSpace', Ord(not x));
  msdos.UpdateFile;
  msdos.Free;
end;

function GetSpace: boolean;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := (not boolean(msdos.ReadInteger('options', 'DrvSpace', 0))) and
    (not boolean(msdos.ReadInteger('options', 'DblSpace', 0)));
  msdos.UpdateFile;
  msdos.Free;
end;

procedure SetTop(x: boolean);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'LoadTop', Ord(x));
  msdos.UpdateFile;
  msdos.Free;
end;

function GetTop: boolean;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := boolean(msdos.ReadInteger('options', 'LoadTop', 1));
  msdos.UpdateFile;
  msdos.Free;
end;

function GetHung: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Desktop');
  if R.ValueExists('HungAppTimeout') then
    Result := (r.ReadString('HungAppTimeout'))
  else
    Result := '20000';
  r.CloseKey;
  r.Free;
end;

procedure SetHung(s: string);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Desktop');
  r.WriteString('HungAppTimeout', IntToStr(StrToIntDef(s, 20000)));
  r.CloseKey;
  r.Free;
end;

function GetKill: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Desktop');
  if R.ValueExists('WaitToKillAppTimeout') then
    Result := (r.ReadString('WaitToKillAppTimeout'))
  else
    Result := '20000';
  r.CloseKey;
  r.Free;
end;

procedure SetKill(s: string);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Desktop');
  r.WriteString('WaitToKillAppTimeout', IntToStr(StrToIntDef(s, 20000)));
  r.CloseKey;
  r.Free;
end;

procedure SetAZWin98(x: boolean);
var
  r:      TDarkRegistry;
  buf_on: DWORD;
  buf_off: DWORD;
begin
  buf_on := $000000BD;
  buf_off := $00000095;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if x then
    r.WriteBinaryData('NoDriveTypeAutoRun', buf_on, SizeOF(DWord))
  else
    r.WriteBinaryData('NoDriveTypeAutoRun', buf_off, SizeOF(DWord));
  r.CloseKey;
  r.Free;
end;

function GetAZWin98: boolean;
var
  r:   TDarkRegistry;
  buf: DWord;
begin
  buf := 0;
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if r.ValueExists('NoDriveTypeAutoRun') then
    begin
    r.ReadBinaryData('NoDriveTypeAutoRun', buf, SizeOF(DWord));
    Result := Buf = $000000BD;
    end
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetAZWinNT(x: boolean);
var
  r: TDarkRegistry;
const
  buf_on: DWORD  = $000000BD;
  buf_off: DWORD = $00000095;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');

  if x then
    r.WriteInteger('NoDriveTypeAutoRun', buf_on)
  else
    r.WriteInteger('NoDriveTypeAutoRun', buf_off);
  r.CloseKey;
  r.Free;
end;

function GetAZWinNT: boolean;
var
  r:   TDarkRegistry;
  buf: DWord;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if r.ValueExists('NoDriveTypeAutoRun') then
    begin
    Buf    := r.ReadInteger('NoDriveTypeAutoRun');
    Result := Buf = $000000BD;
    end
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

function GetNepr: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('System\CurrentControlSet\Control\FileSystem');
  if R.ValueExists('ContigFileAllocSize') then
    Result := r.ReadInteger('ContigFileAllocSize') = 800
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetNepr(b: bool);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('System\CurrentControlSet\Control\FileSystem');
  if b then
    r.WriteInteger('ContigFileAllocSize', 800)
  else
    r.WriteInteger('ContigFileAllocSize', 512);
  r.CloseKey;
  r.Free;
end;

function GetZas: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Defrag\Settings\DisableScreenSaver');
  if R.ValueExists('') then
    Result := UpperCase(r.ReadString('')) = 'YES'
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetZas(b: bool);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Applets\Defrag\Settings\DisableScreenSaver');
  if b then
    r.WriteString('', 'YES')
  else
    r.WriteString('', 'NO');
  r.CloseKey;
  r.Free;
end;

function GetUser: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\MS Setup (ACME)\User Info');
  if R.ValueExists('DefName') then
    Result := (r.ReadString('DefName'))
  else
    Result := '';
  r.CloseKey;
  r.Free;
end;

procedure SetUser(s: string);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\MS Setup (ACME)\User Info');
  r.WriteString('DefName', s);
  r.CloseKey;
  r.Free;
end;

function GetCompany: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\MS Setup (ACME)\User Info');
  if R.ValueExists('DefCompany') then
    Result := (r.ReadString('DefCompany'))
  else
    Result := '';
  r.CloseKey;
  r.Free;
end;

procedure SetCompany(s: string);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\MS Setup (ACME)\User Info');
  r.WriteString('DefCompany', s);
  r.CloseKey;
  r.Free;
end;

function GetWinUser: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion');
  if R.ValueExists('RegisteredOwner') then
    Result := (r.ReadString('RegisteredOwner'))
  else
    Result := '';
  r.CloseKey;
  r.Free;
end;

procedure SetWinUser(s: string);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion');
  r.WriteString('RegisteredOwner', s);
  r.CloseKey;
  r.Free;
end;


function GetWinFirm: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion');
  if R.ValueExists('RegisteredOrganization') then
    Result := (r.ReadString('RegisteredOrganization'))
  else
    Result := '';
  r.CloseKey;
  r.Free;
end;

procedure SetWinFirm(s: string);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion');
  r.WriteString('RegisteredOrganization', s);
  r.CloseKey;
  r.Free;
end;


function GetRunDel: boolean;
var
  r:   TDarkRegistry;
  buf: Dword;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoRun') then
    begin
    if nt then
      buf := r.ReadInteger('NoRun')
    else
      r.ReadBinaryData('NoRun', buf, sizeof(DWord));
    Result := boolean(buf);
    end
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetRunDel(x: boolean);
var
  r:    TDarkRegistry;
  buf:  Dword;
  ibuf: integer;
begin
  buf  := Ord(x);
  ibuf := Ord(not x);
  r    := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if nt then
    r.WriteInteger('NoRun', buf)
  else
    r.WriteBinaryData('NoRun', buf, sizeof(DWord));
  r.CloseKey;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced');
  r.WriteInteger('StartMenuRun', ibuf);
  r.CloseKey;
  r.Free;
end;

procedure SortStart;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer');
  if r.KeyExists('MenuOrder') then
    r.DeleteKey('MenuOrder');
  r.CloseKey;
  r.Free;
end;

procedure DelWMP;
var
  r:     TDarkRegistry;
  mpdir: string;
begin
  mpdir := GetAppData + '\Media Player';
  if (mpdir <> '') and DirectoryExists(mpdir) then
    XDir(mpdir);
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\MediaPlayer\Player');
  if r.KeyExists('RecentFileList') then
    r.DeleteKey('RecentFileList');
  if r.KeyExists('RecentURLList') then
    r.DeleteKey('RecentURLList');
  r.CloseKey;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer');
  if r.KeyExists('RunMRU') then
    r.DeleteKey('RunMRU');
  r.CloseKey;
  r.OpenKey('\SOFTWARE\Microsoft\Internet Explorer');
  if r.KeyExists('TypedURLs') then
    r.DeleteKey('TypedURLs');
  r.CloseKey;
  r.OpenKey('\SOFTWARE\Microsoft\MediaPlayer\Player\Settings');
  r.WriteString('OpenDir', '');
  r.CloseKey;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer');
  if r.KeyExists('ComDlg32') then
    r.DeleteKey('ComDlg32');
  r.CloseKey;
  r.Free;
end;

procedure DelHistory;
var
  cookdir, history, tif: string;
begin
  cookdir := GetCookie;
  if (cookdir <> '') and DirectoryExists(cookdir) then
    XDir(GetCookie);
  history := GetHistory;
  if (history <> '') and DirectoryExists(history) then
    Xdir(GetHistory);
  tif := GetTIF;
  if (tif <> '') and DirectoryExists(tif) then
    Xdir(tif);
end;

procedure DelPref;
var
  prefdir: string;
begin
  prefdir := WindowsDir;
  if PrefDir <> '' then
    if PrefDir[Length(Prefdir)] <> '\' then
      PrefDir := PrefDir + '\';
  prefdir := Prefdir + 'Prefetch';
  if DirectoryExists(prefdir) then
    XDir(Prefdir);
end;

procedure GetInstalled;
var
  r: TDarkRegistry;
  S: TStrings;
  i: integer;
  n: string;
  ListItem: TListItem;
begin
  FdcMain.installed.Items.BeginUpdate;
  s := TStringList.Create;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall');
  r.GetKeyNames(s);
  for i := 0 to s.Count - 1 do
    begin
    r.CloseKey;
    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\' + s[i]);
    n := r.ReadString('DisplayName');
    if (Trim(N) = '') then
      n := s[i];
    with FdcMain.installed do
      begin
      ListItem := Items.Add;
      ListItem.Caption := N;
      ListItem.SubItems.Add(s[I]);
      ListItem.SubItems.Add(r.ReadString('Uninstallstring'));
      end;

    end;
  r.CloseKey;
  r.Free;
  s.Free;
  FdcMain.installed.Items.EndUpdate;
end;

procedure DelInstalled;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  if r.DeleteKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\' +
    FdcMain.installed.Items[FdcMain.installed.ItemIndex].SubItems[0]) then
    FdcMain.installed.Items[FdcMain.installed.ItemIndex].Caption := 'УДАЛЕН';
  r.Free;
end;



procedure ChSF;
var
  r: TDarkRegistry;
  s: string;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  if FdcMain.sysf.ItemIndex >= 0 then
    begin
    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
    s := '';
    if inputdir(0, s, 'Укажите путь к ' + fdcmain.SysF.Items.Item[
      fdcmain.SysF.ItemIndex].Caption, True) then
      if messagedlg('Действительно изменить путь к ' +
        fdcmain.SysF.Items.Item[fdcmain.SysF.ItemIndex].Caption +
        #13#10 + ' с ' + r.ReadString(
        fdcmain.SysF.Items.Item[fdcmain.SysF.ItemIndex].Caption) + #13#10 +
        ' на ' + s + '?', mtConfirmation, mbOkCancel, 0) = idOk then
        r.WriteString(fdcmain.SysF.Items.Item[fdcmain.SysF.ItemIndex].Caption, s);
    r.CloseKey;
    end;
  FdcMain.SFR.Click;
  r.Free;
end;

procedure GetShellFolders;
var
  r: TDarkRegistry;
  S: TStrings;
  i: integer;
  ListItem: TListItem;
begin
  FdcMain.SysF.Items.BeginUpdate;
  s := TStringList.Create;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
  r.GetValueNames(s);
  for i := 0 to s.Count - 1 do
    with FdcMain.SysF do
      begin
      ListItem := Items.Add;
      ListItem.Caption := s[i];
      ListItem.SubItems.Add(r.ReadString(s[i]));
      end;
  r.CloseKey;
  r.Free;
  s.Free;
  FdcMain.SysF.Items.EndUpdate;
end;

function GetFindDel: boolean;
var
  r:   TDarkRegistry;
  buf: Dword;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoFind') then
    begin
    r.ReadBinaryData('NoFind', buf, sizeof(DWord));
    Result := boolean(buf);
    end
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetFindDel(x: boolean);
var
  r:   TDarkRegistry;
  buf: Dword;
begin
  buf := Ord(x);
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteBinaryData('NoFind', buf, sizeof(DWord));
  r.CloseKey;
  r.Free;
end;

function GetNetConnect: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoNetConnectDisconnect') then
    Result := boolean(r.ReadInteger('NoNetConnectDisconnect'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetNetConnect(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('NoNetConnectDisconnect', Ord(X));
  r.CloseKey;
  r.Free;
end;

function GetHelp: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoSMHelp') then
    Result := boolean(r.ReadInteger('NoSMHelp'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetHelp(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('NoSMHelp', Ord(X));
  r.CloseKey;
  r.Free;
end;

function GetExit: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Desktop');
  if R.ValueExists('AutoEndTasks') then
    Result := r.ReadString('AutoEndTasks') = '1'
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetExit(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Desktop');
  r.WriteString('AutoEndTasks', IntToStr(Ord(X)));
  r.CloseKey;
  r.Free;
end;

function GetSound: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Sound');
  if R.ValueExists('Beep') then
    Result := not (UpperCase(r.ReadString('Beep')) = 'YES')
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetSound(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Sound');
  r.WriteString('Beep', BoolToStrYN(not X));
  r.CloseKey;
  r.Free;
end;

{ HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\explorer\Shell Icons
0 Default Icon
1 Default Document
2 MS-DOS Application
3 Closed Folder
4 Open Folder
5 Floppy Drive (5.25)
6 Floppy Drive (3.5)
7 Removable Drive
8 Hard Drive
9 Network Drive (connected)
10  Network Drive (offline)
11 CD-ROM Drive
12 RAM Drive
13 NetWork
15 Computer
18 Workgroup
19 Programs
20 Documents
21 Settings
22 Find
23 Help
24 Run
27 Shut Down
28 Sharing Overlay
29 Shortcut Overlay
34 Desktop
35 Settings - Control Panel
36 Program Group
37 Settings - Printers
40 Audio CD
43 Favorites
44  Log Off }
function Cor(x: string): string;
var
  s, s2: string;
  i:     integer;
begin
  s  := Trim(X);
  s2 := '';
  for i := 1 to length(s) do
    if (s[i] <> '"') then
      s2 := s2 + s[i];
  Result := LowerCase(S2);
end;

{procedure SetShellIcons(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11,
  s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24,
  s25, s26, s27, s28, s29, s30, s31, s32: string);
var
  R: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKey_Local_Machine;
  r.OpenKey('Software\Microsoft\Windows\CurrentVersion\explorer\Shell Icons');
  if s1 <> '' then
    r.WriteString('0', Cor(s1));  //   Иконка по-умолчанию
  if s2 <> '' then
    r.WriteString('1', Cor(s2));  //  Док-т
  if s3 <> '' then
    r.WriteString('2', Cor(s3));  //  МСДОС
  if s4 <> '' then
    r.WriteString('3', Cor(s4));  //  Закрпапка
  if s5 <> '' then
    r.WriteString('4', Cor(s5));  //  открпапка
  if s6 <> '' then
    r.WriteString('5', Cor(s6));  //  флоппи5
  if s7 <> '' then
    r.WriteString('6', Cor(s7));  //  флоппи3.5
  if s8 <> '' then
    r.WriteString('7', Cor(s8));  //  сменндиск
  if s9 <> '' then
    r.WriteString('8', Cor(s9));  //  винт
  if s10 <> '' then
    r.WriteString('9', Cor(s10)); //  сетьсоед
  if s11 <> '' then
    r.WriteString('10', Cor(s11));//  сетьнесоед
  if s12 <> '' then
    r.WriteString('11', Cor(s12));//  сидиром
  if s13 <> '' then
    r.WriteString('12', Cor(s13));//  рамдиск
  if s14 <> '' then
    r.WriteString('13', Cor(s14));//  сетьокр
  if s15 <> '' then
    r.WriteString('15', Cor(s15));//  пэка
  if s16 <> '' then
    r.WriteString('18', Cor(s16));//  рабгрупа
  if s17 <> '' then
    r.WriteString('19', Cor(s17));//  проги
  if s18 <> '' then
    r.WriteString('20', Cor(s18));//  документы
  if s19 <> '' then
    r.WriteString('21', Cor(s19));//  настройки
  if s20 <> '' then
    r.WriteString('22', Cor(s20)); // поиск
  if s21 <> '' then
    r.WriteString('23', Cor(s21));//  хелп
  if s22 <> '' then
    r.WriteString('24', Cor(s22));//  ран
  if s23 <> '' then
    r.WriteString('27', Cor(s23));//  выключить
  if s24 <> '' then
    r.WriteString('28', Cor(s24));//  сетьоверл
  if s25 <> '' then
    r.WriteString('29', Cor(s25));//  ярловерл
  if s26 <> '' then
    r.WriteString('34', Cor(s26));//  рабстол
  if s27 <> '' then
    r.WriteString('35', Cor(s27));//  настройки
  if s28 <> '' then
    r.WriteString('36', Cor(s28));//  групппрог
  if s29 <> '' then
    r.WriteString('37', Cor(s29));//  принт
  if s30 <> '' then
    r.WriteString('40', Cor(s30));//  аудиокд
  if s31 <> '' then
    r.WriteString('43', Cor(s31));//  избран
  if s32 <> '' then
    r.WriteString('44', Cor(s32));//  логофф
  r.CloseKey;
  r.Free;
end;}

function isRODir: boolean;
var
  F: file;
begin
{$I-}
  Assign(F, mypath + 'delete_me.$$$');
  Rewrite(F);
  Result := IOResult <> 0;
  Close(F);
  deletefile(PChar(mypath + 'delete_me.$$$'));
{$I+}
end;

function OnCD: bool;
begin
  Result := SysUtils.FileCreate(extractfilepath(ParamStr(0)) + 'dummy.tmp') <= 0;
end;

function GetOV: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_Local_Machine;
  r.OpenKey('\Software\CLASSES\lnkfile');
  Result := not (R.ValueExists('IsShortcut'));
  r.CloseKey;
  r.Free;
end;

procedure SetOV(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_Local_Machine;
  r.OpenKey('\SOFTWARE\CLASSES\lnkfile');
  if X then
    r.DeleteValue('IsShortcut')
  else
    r.WriteString('IsShortcut', '');
  r.CloseKey;
  r.OpenKey('\SOFTWARE\CLASSES\piffile');
  if X then
    r.DeleteValue('IsShortcut')
  else
    r.WriteString('IsShortcut', '');
  r.CloseKey;
  r.Free;
end;

function GetNetWork: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoNetHood') then
    Result := boolean(r.ReadInteger('NoNetHood'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetNetWork(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('NoNetHood', Ord(X));
  r.CloseKey;
  r.Free;
end;

function GetUpdate: boolean;
var
  r:   TDarkRegistry;
  buf: dword;
begin
  buf := 0;
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoWindowsUpdate') then
    begin
    if nt then
      buf := r.ReadInteger('NoWindowsUpdate')
    else
      r.ReadBinaryData('NoWindowsUpdate', buf, sizeof(DWord));
    Result := boolean(buf);
    end
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetUpdate(x: boolean);
var
  r:   TDarkRegistry;
  buf: dword;
begin
  buf := byte(x);
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if nt then
    r.WriteInteger('NoWindowsUpdate', Ord(X))
  else
    r.WriteBinaryData('NoWindowsUpdate', buf, SizeOf(DWord));
  r.CloseKey;
  r.Free;
end;

function GetSetF: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoFolderOptions') then
    Result := boolean(r.ReadInteger('NoFolderOptions'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetSetF(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('NoFolderOptions', Ord(X));
  r.CloseKey;
  r.Free;
end;

function GetPZ: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoSetTaskBar') then
    Result := boolean(r.ReadInteger('NoSetTaskBar'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetPZ(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('NoSetTaskBar', Ord(X));
  r.CloseKey;
  r.Free;
end;

function GetARS: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoSetActiveDesktop') then
    Result := boolean(r.ReadInteger('NoSetActiveDesktop'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetARS(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('NoSetActiveDesktop', Ord(X));
  r.CloseKey;
  r.Free;
end;

function GetClose: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoClose') then
    Result := boolean(r.ReadInteger('NoClose'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetClose(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('NoClose', Ord(X));
  r.CloseKey;
  r.Free;
end;

procedure RebuildIconCache;
var
  win: string;
begin
  FDCMAIN.Enabled := False;
  Win := WindowsDir;
  if FileExists(Win + 'ShellIconCache') then
    DeleteFile(PChar(Win + 'ShellIconCache'));
  FDCMAIN.Enabled := True;
end;

function GetRS: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoDeskTop') then
    Result := boolean(r.ReadInteger('NoDeskTop'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetRS(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('NoDeskTop', Ord(X));
  r.CloseKey;
  r.Free;
end;

function GetTCM: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoTrayContextMenu') then
    Result := boolean(r.ReadInteger('NoTrayContextMenu'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetTCM(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('NoTrayContextMenu', Ord(X));
  r.CloseKey;
  r.Free;
end;

function GetStC: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoChangeStartMenu') then
    Result := boolean(r.ReadInteger('NoChangeStartMenu'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetStC(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('NoChangeStartMenu', Ord(X));
  r.CloseKey;
  if nt then
    begin
    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced');
    r.WriteInteger('StartMenuChange', Ord(not x));
    r.CloseKey;
    end;
  r.Free;
end;

function GetMS: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Desktop');
  if R.ValueExists('MenuShowDelay') then
    Result := r.ReadString('MenuShowDelay') = '65534'
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetMS(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Desktop');
  if x then
    r.WriteString('MenuShowDelay', '65534')
  else
    r.WriteString('MenuShowDelay', '400');
  r.CloseKey;
  r.Free;
end;

function GetMMC: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Desktop');
  if R.ValueExists('MinMaxClose') then
    Result := r.ReadString('MinMaxClose') = '1'
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetMMC(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Desktop');
  r.WriteString('MinMaxClose', IntToStr(Ord(X)));
  r.CloseKey;
  r.Free;
end;

function GetCPDel: boolean;
var
  r:   TDarkRegistry;
  buf: Dword;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoSetFolders') then
    begin
    if nt then
      buf := r.ReadInteger('NoSetFolders')
    else
      r.ReadBinaryData('NoSetFolders', buf, sizeof(DWord));
    Result := boolean(buf);
    end
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetCPDel(x: boolean);
var
  r:   TDarkRegistry;
  buf: Dword;
begin
  buf := Ord(x);
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if nt then
    r.WriteInteger('NoSetFolders', buf)
  else
    r.WriteBinaryData('NoSetFolders', buf, sizeof(DWord));
  r.CloseKey;
  r.Free;
end;

function GetCookie: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  ;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
  if R.ValueExists('Cookies') then
    Result := Trim(r.ReadString('Cookies'))
  else
    Result := '';
  r.CloseKey;
  r.Free;
end;

function GetAppData: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
  if R.ValueExists('AppData') then
    Result := Trim(r.ReadString('AppData'))
  else
    Result := '';
  r.CloseKey;
  r.Free;
end;

function GetHistory: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
  if R.ValueExists('History') then
    Result := Trim(r.ReadString('History'))
  else
    Result := '';
  r.CloseKey;
  r.Free;
end;

function GetTIF: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders');
  if R.ValueExists('Cache') then
    Result := Trim(r.ReadString('Cache'))
  else
    Result := '';
  r.CloseKey;
  r.Free;
end;

function GetRT: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System');
  if R.ValueExists('DisableRegistryTools') then
    Result := boolean(r.ReadInteger('DisableRegistryTools'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetRT(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System');
  r.WriteInteger('DisableRegistryTools', Ord(X));
  r.CloseKey;
  r.Free;
end;

function GetControl: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('nocontrolpanel') then
    Result := boolean(r.ReadInteger('nocontrolpanel'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetControl(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('nocontrolpanel', Ord(X));
  r.CloseKey;
  r.Free;
end;

function GetPrinter: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('noaddprinter') then
    Result := boolean(r.ReadInteger('noaddprinter'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetPrinter(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('noaddprinter', Ord(X));
  r.CloseKey;
  r.Free;
end;

procedure SetDBufer(x: boolean);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'DoubleBuffer', Ord(x));
  msdos.UpdateFile;
  msdos.Free;
end;

function GetDBufer: boolean;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := (boolean(msdos.ReadInteger('options', 'DoubleBuffer', 1)));
  msdos.UpdateFile;
  msdos.Free;
end;

procedure Setbmd(x: integer);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'BootMenuDelay', x);
  msdos.UpdateFile;
  msdos.Free;
end;

function Getbmd: integer;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := msdos.ReadInteger('options', 'BootMenuDelay', 4);
  msdos.UpdateFile;
  msdos.Free;
end;

procedure SetMulti(x: boolean);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'BootMulti', Ord(x));
  msdos.UpdateFile;
  msdos.Free;
end;

function GetMulti: boolean;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := (boolean(msdos.ReadInteger('options', 'BootMulti', 1)));
  msdos.UpdateFile;
  msdos.Free;
end;

procedure NotSetReg(x: boolean);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'SystemReg', (Ord(not x)));
  msdos.UpdateFile;
  msdos.Free;
end;

function NotGetReg: boolean;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := (not boolean(msdos.ReadInteger('options', 'SystemReg', 1)));
  msdos.UpdateFile;
  msdos.Free;
end;

procedure NotSetKeys(x: boolean);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'BootKeys', (Ord(not x)));
  msdos.UpdateFile;
  msdos.Free;
end;

function NotGetKeys: boolean;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := (not boolean(msdos.ReadInteger('options', 'BootKeys', 1)));
  msdos.UpdateFile;
  msdos.Free;
end;

function GetSmoothing: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Desktop');
  if R.ValueExists('FontSmoothing') then
    Result := r.ReadString('FontSmoothing') = '0'
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetSmoothing(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Desktop');
  r.WriteString('FontSmoothing', IntToStr(Ord(not X)));
  r.CloseKey;
  r.Free;
end;

procedure SetMDEF(x: integer);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'BootMenuDefault', x);
  msdos.UpdateFile;
  msdos.Free;
end;

function GetMDEF: integer;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := msdos.ReadInteger('options', 'BootMenuDefault', 1);
  msdos.UpdateFile;
  msdos.Free;
end;

procedure SetBD(x: integer);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'BootDelay', x);
  msdos.UpdateFile;
  msdos.Free;
end;

function GetBD: integer;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := msdos.ReadInteger('options', 'BootDelay', 2);
  msdos.UpdateFile;
  msdos.Free;
end;

procedure NotSetWB(x: boolean);
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos := TIniFile.Create('c:\msdos.sys');
  msdos.WriteInteger('options', 'BootWin', (Ord(not x)));
  msdos.UpdateFile;
  msdos.Free;
end;

function NotGetWB: boolean;
var
  msdos: TiniFile;
begin
  DummyMSDos;
  FileSetReadOnly('c:\msdos.sys', False);
  msdos  := TIniFile.Create('c:\msdos.sys');
  Result := (not boolean(msdos.ReadInteger('options', 'BootWin', 1)));
  msdos.UpdateFile;
  msdos.Free;
end;

function GetSP: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup');
  if R.ValueExists('SourcePath') then
    Result := r.ReadString('SourcePath')
  else
    Result := 'не установлена';
  r.CloseKey;
  r.Free;
end;

procedure SetSP(var s: string);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Setup');
  r.WriteString('SourcePath', s);
  r.CloseKey;
  r.Free;
end;

function GetVSZ: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  if Nt then
    r.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinLogOn')
  else
    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\WinLogOn');
  if R.ValueExists('LegalNoticeCaption') then
    Result := r.ReadString('LegalNoticeCaption');
  r.CloseKey;
  r.Free;
end;

function GetVST: string;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  if Nt then
    r.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinLogOn')
  else
    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\WinLogOn');
  if R.ValueExists('LegalNoticeText') then
    Result := r.ReadString('LegalNoticeText');
  r.CloseKey;
  r.Free;
end;

procedure SetVSZ(s: string);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  if Nt then
    r.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinLogOn')
  else
    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\WinLogOn');
  r.WriteString('LegalNoticeCaption', s);
  r.CloseKey;
  r.Free;
end;

procedure SetVST(s: string);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  if Nt then
    r.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\WinLogOn')
  else
    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\WinLogOn');
  r.WriteString('LegalNoticeText', s);
  r.CloseKey;
  r.Free;
end;

function NTGetAssist: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState');
  if R.ValueExists('Use Search Asst') then
    Result := UpperCase(r.ReadString('Use Search Asst')) = 'YES'
  else
    Result := True;
  r.CloseKey;
  r.Free;
end;

procedure NTSetAssist(s: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CabinetState');
  if s then
    r.WriteString('Use Search Asst', 'yes')
  else
    r.WriteString('Use Search Asst', 'no');
  r.CloseKey;
  r.Free;
end;

function MeGetFH: integer;
var
  I: TiniFile;
begin
  i      := Tinifile.Create(windowsdir + 'system.ini');
  Result := i.ReadInteger('386Enh', 'PerVMFiles', 30);
  i.Free;
end;

procedure MeSetFH(val: integer);
var
  I: TiniFile;
begin
  i := Tinifile.Create(windowsdir + 'system.ini');
  i.WriteInteger('386Enh', 'PerVMFiles', val);
  i.Free;
end;


function NTGetTaskMan: boolean;
var
  r: TDarkRegistry;
begin
  if not nt then
    begin
    Result := True;
    exit;
    end;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System');
  if R.ValueExists('DisableTaskMgr') then
    Result := not boolean(r.ReadInteger('DisableTaskMgr'))
  else
    Result := True;
  r.CloseKey;
  r.Free;
end;

procedure NTSetTaskMan(s: boolean);
var
  r: TDarkRegistry;
begin
  if not nt then
    exit;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System');
  r.WriteInteger('DisableTaskMgr', Ord(not s));
  r.CloseKey;
  r.Free;
end;


function GetLocalLH: boolean;
var
  I: TiniFile;
begin
  i      := Tinifile.Create(windowsdir + 'system.ini');
  Result := boolean(i.ReadInteger('386Enh', 'LocalLoadHigh', 1));
  i.Free;
end;

procedure SetLocalLH(val: boolean);
var
  I: TiniFile;
begin
  i := Tinifile.Create(windowsdir + 'system.ini');
  i.WriteInteger('386Enh', 'LocalLoadHigh', Ord(val));
  i.Free;
end;


function GetStack: integer;
var
  I: TiniFile;
begin
  i      := Tinifile.Create(windowsdir + 'system.ini');
  Result := i.ReadInteger('386Enh', 'minsps', 8);
  i.Free;
end;

procedure SetStack(val: integer);
var
  I: TiniFile;
begin
  i := Tinifile.Create(windowsdir + 'system.ini');
  i.WriteInteger('386Enh', 'minsps', val);
  i.Free;
end;

function GetQR: boolean;
var
  I: TiniFile;
begin
  i      := Tinifile.Create(windowsdir + 'system.ini');
  Result := UpperCase(i.ReadString('386Enh', 'KybdReboot', 'False')) = 'True';
  i.UpdateFile;
  i.Free;
end;

procedure SetQR(val: boolean);
var
  I: TiniFile;
begin
  i := Tinifile.Create(windowsdir + 'system.ini');
  if val then
    i.WriteString('386Enh', 'KybdReboot', 'True')
  else
    i.DeleteKey('386Enh', 'KybdReboot');
  i.UpdateFile;
  i.Free;
end;

function GetLR: boolean;
var
  I: TiniFile;
begin
  i      := Tinifile.Create(windowsdir + 'system.ini');
  Result := UpperCase(i.ReadString('386Enh', 'LocalReboot', 'OFF')) = 'ON';
  i.Free;
end;

procedure SetLR(val: boolean);
var
  I: TiniFile;
begin
  i := Tinifile.Create(windowsdir + 'system.ini');
  if val then
    i.WriteString('386Enh', 'LocalReboot', 'On')
  else
    i.DeleteKey('386Enh', 'LocalReboot');
  i.Free;
end;


function GetLargeCache: boolean;
var
  r: TDarkRegistry;
begin
  if not nt then
    begin
    Result := False;
    exit;
    end;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management');
  if R.ValueExists('LargeSystemCache') then
    Result := boolean(r.ReadInteger('LargeSystemCache'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetLargeCache(x: boolean);
var
  r: TDarkRegistry;
begin
  if not nt then
    exit;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management');
  r.WriteInteger('LargeSystemCache', Ord(X));
  r.CloseKey;
  r.Free;
end;

function GetSysPerf: boolean;
var
  r: TDarkRegistry;
begin
  if not nt then
    begin
    Result := False;
    exit;
    end;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management');
  if R.ValueExists('DisablePagingExecutive') then
    Result := boolean(r.ReadInteger('DisablePagingExecutive'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetSysPerf(x: boolean);
var
  r: TDarkRegistry;
begin
  if not nt then
    exit;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management');
  r.WriteInteger('DisablePagingExecutive', Ord(X));
  r.CloseKey;
  r.Free;
end;


function NTGetDetails: boolean;
var
  r: TDarkRegistry;
begin
  if not nt then
    exit;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment');
  if R.ValueExists('DEVMGR_SHOW_DETAILS') then
    Result := r.ReadString('DEVMGR_SHOW_DETAILS') = '1'
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure NTSetDetails(x: boolean);
var
  r: TDarkRegistry;
begin
  if not nt then
    exit;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment');
  r.WriteString('DEVMGR_SHOW_DETAILS', IntToStr(Ord(X)));
  r.CloseKey;
  r.Free;
end;

function isWin9xSafe: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment');
  if R.ValueExists('OS') then
    Result := r.ReadString('OS') <> 'Windows_NT'
  else
    Result := isWin9x;
  r.CloseKey;
  r.Free;
end;

function NTGetCPF: boolean;
var
  r: TDarkRegistry;
begin
  if not nt then
    begin
    Result := False;
    exit;
    end;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management');
  if R.ValueExists('ClearPageFileAtShutdown') then
    Result := boolean(r.ReadInteger('ClearPageFileAtShutdown'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure NTSetCPF(x: boolean);
var
  r: TDarkRegistry;
begin
  if not nt then
    exit;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management');
  r.WriteInteger('ClearPageFileAtShutdown', Ord(X));
  r.CloseKey;
  r.Free;
end;

function NTGetPref: boolean;
var
  r: TDarkRegistry;
begin
  if not nt then
    begin
    Result := False;
    exit;
    end;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters');
  if R.ValueExists('EnablePrefetcher') then
    Result := r.ReadInteger('EnablePrefetcher') = 3
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure NTSetPref(x: boolean);
var
  r: TDarkRegistry;
begin
  if not nt then
    exit;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters');
  if X then
    r.WriteInteger('EnablePrefetcher', 3)
  else
    r.WriteInteger('EnablePrefetcher', 0);
  r.CloseKey;
  r.Free;
end;


function GetNoU: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoDevMgrUpdate') then
    Result := boolean(r.ReadInteger('NoDevMgrUpdate'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetNoU(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('NoDevMgrUpdate', Ord(X));
  r.CloseKey;
  r.Free;
end;


function GetIconDepth: integer;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Desktop\WindowMetrics');
  if R.ValueExists('Shell Icon BPP') then
    Result := StrTointDef(r.ReadString('Shell Icon BPP'), 16)
  else
    Result := 16;
  r.CloseKey;
  r.Free;
end;

procedure SetIconDepth(x: integer);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('Control Panel\Desktop\WindowMetrics');
  r.WriteString('Shell Icon BPP', IntToStr(X));
  r.CloseKey;
  r.Free;
end;


function GetClassicD: boolean;
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('ClassicShell') then
    Result := boolean(r.ReadInteger('ClassicShell'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetClassicD(x: boolean);
var
  r: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('ClassicShell', Ord(X));
  r.CloseKey;
  r.Free;
end;

function GetNoWell: boolean;
var
  r: TDarkRegistry;
begin
  Result := False;
  if not nt then
    exit;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  if R.ValueExists('NoWelcomeScreen') then
    Result := boolean(r.ReadInteger('NoWelcomeScreen'))
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetNoWell(x: boolean);
var
  r: TDarkRegistry;
begin
  if not nt then
    exit;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CURRENT_USER;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer');
  r.WriteInteger('NoWelcomeScreen', Ord(X));
  r.CloseKey;
  r.Free;
end;


function GetClassicL: boolean;
var
  r: TDarkRegistry;
begin
  Result := False;
  if not nt then
    exit;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon');
  if R.ValueExists('LogonType') then
    Result := r.ReadInteger('LogonType') = 0
  else
    Result := False;
  r.CloseKey;
  r.Free;
end;

procedure SetClassicL(x: boolean);
var
  r: TDarkRegistry;
begin
  if not nt then
    exit;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_LOCAL_MACHINE;
  r.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon');
  r.WriteInteger('LogonType', Ord(not X));
  r.CloseKey;
  r.Free;
end;


function fixenv(s: string): string;
var
  i, j:   integer;
  new, v: string;
begin
  repeat
    i := pos('%', s);
    if i = 0 then
      continue;
    j := posex('%', s, i + 1);
    if j = 0 then
      continue;
    v   := copy(s, i + 1, j - 1 - i);
    new := SysUtils.GetEnvironmentVariable(v);
    s   := ansireplacestr(s, copy(s, i, j - i + 1), new);
  until i = 0;
  Result := s;
end;


procedure parseoneline(s: string);
var
  Data: string;

  function ParseAsRawData(Data: string): TRaw;
  var
    i, c: integer;
  begin
    if Data = '' then
      exit;
    c := 0;
    i := 1;
    SetLength(Result, tweaks[numtweak - 1].size);
    repeat
      Result[c] := strtointdef('$' + copy(Data, i, 2), 0);
      Inc(c);
      Inc(i, 2);
    until i > length(Data);
  end;

begin
  s := fixenv(s);
  if pos('SECTION>', s) > 0 then
    Tweaks[numtweak - 1].Section :=
      UpperCase(Trim(Copy(S, pos('SECTION>', s) + 8, length(s))));

  if pos('TYPE>', s) > 0 then
    begin
    Data := UpperCase(Trim(Copy(S, pos('TYPE>', s) + 5, length(s))));

    if Data = 'REG' then
      Tweaks[numtweak - 1].TweakType := ttreg
    else
    if Data = 'INI' then
      Tweaks[numtweak - 1].TweakType := ttini
    else
    if Data = 'CFG' then
      Tweaks[numtweak - 1].TweakType := ttcfg;

    end;


  if pos('OS>', s) > 0 then
    begin
    Data := UpperCase(Trim(Copy(S, pos('OS>', s) + 3, length(s))));
    if Data = '9X' then
      Tweaks[numtweak - 1].Os := w9x
    else
    if Data = 'NT' then
      Tweaks[numtweak - 1].Os := wnt;
    end
  else
  if Pos('VALUETYPE>', s) > 0 then
    begin
    Data := UpperCase(Trim(Copy(S, pos('VALUETYPE>', s) + 10, length(s))));
    Tweaks[numtweak - 1].Value_type := dtNONE;
    if Data = 'DWORD' then
      Tweaks[numtweak - 1].Value_type := dtINT
    else
    if Data = 'STRING' then
      Tweaks[numtweak - 1].Value_type := dtSTR
    else
    if Data = 'BIN' then
      Tweaks[numtweak - 1].Value_type := dtBIN;
    end
  else
  if Pos('VALUENAME>', s) > 0 then
    begin
    Data := (Trim(Copy(S, pos('VALUENAME>', s) + 10, length(s))));
    Tweaks[numtweak - 1].Value_Name := Data;
    end
  else
  if Pos('TWEAKNAME>', s) > 0 then
    begin
    Data := (Trim(Copy(S, pos('TWEAKNAME>', s) + 10, length(s))));
    Tweaks[numtweak - 1].Desc := Data;
    end
  else
  if Pos('ROOTKEY>', s) > 0 then
    begin
    Data := UpperCase(Trim(Copy(S, pos('ROOTKEY>', s) + 8, length(s))));
    Tweaks[numtweak - 1].Root_Key := ERR;
    if Data = 'HKLM' then
      Tweaks[numtweak - 1].Root_Key := HKLM;
    if Data = 'HKCU' then
      Tweaks[numtweak - 1].Root_Key := HKCU;
    if Data = 'HKU' then
      Tweaks[numtweak - 1].Root_Key := HKU;
    if Data = 'HKCR' then
      Tweaks[numtweak - 1].Root_Key := HKCR;
    end
  else
  if Pos('PATH>', s) > 0 then
    begin
    Data := (Trim(Copy(S, pos('PATH>', s) + 5, length(s))));
    Tweaks[numtweak - 1].Path := Data;
    end
  else
  if Pos('NOTBOOL>', s) > 0 then
    begin
    Data := UpperCase(Trim(Copy(S, pos('NOTBOOL>', s) + 8, length(s))));
    Tweaks[numtweak - 1].User := False;
    Tweaks[numtweak - 1].User := Data = '1';
    end;
  if Pos('VALUEOFF>', s) > 0 then
    begin
    Data := (Trim(Copy(S, pos('VALUEOFF>', s) + 9, length(s))));
    if UpperCase(Data) = '#SYSDELKEY' then
      begin
      Tweaks[numtweak - 1].Val_OFF_MDK := True;
      case Tweaks[numtweak - 1].Value_type of
        dtINT:
          Tweaks[numtweak - 1].Val_Off := 0;
        dtSTR:
          Tweaks[numtweak - 1].Val_Off := '';
        dtBin:
          Tweaks[numtweak - 1].Val_Off := TRaw(ParseAsRawData('00000000'));
        end;

      end
    else
    if UpperCase(Data) = '#SYSDELVAL' then
      begin
      Tweaks[numtweak - 1].Val_OFF_MDV := True;
      case Tweaks[numtweak - 1].Value_type of
        dtINT:
          Tweaks[numtweak - 1].Val_Off := 0;
        dtSTR:
          Tweaks[numtweak - 1].Val_Off := '';
        dtBin:
          Tweaks[numtweak - 1].Val_Off := TRaw(ParseAsRawData('00000000'));
        end;

      end
    else
      case Tweaks[numtweak - 1].Value_type of
        dtINT:
          Tweaks[numtweak - 1].Val_Off := StrToIntDef(Data, 0);
        dtSTR:
          Tweaks[numtweak - 1].Val_Off := Data;
        dtBin:
          Tweaks[numtweak - 1].Val_Off := TRaw(ParseAsRawData(Data));
        end;
    end
  else
  if Pos('VALUEON>', s) > 0 then
    begin
    Data := (Trim(Copy(S, pos('VALUEON>', s) + 8, length(s))));
    if UpperCase(Data) = '#SYSDELKEY' then
      begin
      Tweaks[numtweak - 1].Val_ON_MDK := True;
      case Tweaks[numtweak - 1].Value_type of
        dtINT:
          Tweaks[numtweak - 1].Val_On := 0;
        dtSTR:
          Tweaks[numtweak - 1].Val_On := '';
        dtBin:
          Tweaks[numtweak - 1].Val_On := TRaw(ParseAsRawData('00000000'));
        end;

      end
    else
    if UpperCase(Data) = '#SYSDELVAL' then
      begin
      Tweaks[numtweak - 1].Val_ON_MDV := True;
      case Tweaks[numtweak - 1].Value_type of
        dtINT:
          Tweaks[numtweak - 1].Val_On := 0;
        dtSTR:
          Tweaks[numtweak - 1].Val_On := '';
        dtBin:
          Tweaks[numtweak - 1].Val_On := TRaw(ParseAsRawData('00000000'));
        end;

      end
    else
      case Tweaks[numtweak - 1].Value_type of
        dtINT:
          Tweaks[numtweak - 1].Val_On := StrToIntDef(Data, 0);
        dtSTR:
          Tweaks[numtweak - 1].Val_On := Data;
        dtBin:
          Tweaks[numtweak - 1].Val_On := TRaw(ParseAsRawData(Data));
        end;

    end
  else
  if Pos('DEFAULT>', s) > 0 then
    begin
    Data := (Trim(Copy(S, pos('DEFAULT>', s) + 8, length(s))));
    if UpperCase(Data) = '#SYSDELKEY' then
      begin
      Tweaks[numtweak - 1].Default_MDK := True;
      case Tweaks[numtweak - 1].Value_type of
        dtINT:
          Tweaks[numtweak - 1].default := 0;
        dtSTR:
          Tweaks[numtweak - 1].default := '';
        dtBin:
          Tweaks[numtweak - 1].default := TRaw(ParseAsRawData('00000000'));
        end;

      end
    else
    if UpperCase(Data) = '#SYSDELVAL' then
      begin
      Tweaks[numtweak - 1].Default_MDV := True;
      case Tweaks[numtweak - 1].Value_type of
        dtINT:
          Tweaks[numtweak - 1].default := 0;
        dtSTR:
          Tweaks[numtweak - 1].default := '';
        dtBin:
          Tweaks[numtweak - 1].default := TRaw(ParseAsRawData('00000000'));
        end;

      end
    else
      case Tweaks[numtweak - 1].Value_type of
        dtINT:
          Tweaks[numtweak - 1].Default := StrToIntDef(Data, 0);
        dtSTR:
          Tweaks[numtweak - 1].Default := Data;
        dtBin:
          Tweaks[numtweak - 1].Default := TRaw(ParseAsRawData(Data));
        end;
    end
  else
  if Pos('SIZE>', s) > 0 then
    begin
    Data := (Trim(Copy(S, pos('SIZE>', s) + 5, length(s))));
    Tweaks[numtweak - 1].Size := StrToIntDef(Data, 0);
    end;

end;


procedure parsecheat(s: string);
var
  Fi:   Text;
  line: string;
  ShortDescr: string;
begin
  Inc(Numtweak);
  SetLength(Tweaks, NumTweak);
  Tweaks[numtweak - 1].size := 0;
  AssignFile(Fi, S);
  Reset(Fi);
  repeat
    readln(Fi, line);
    if pos('//', line) > 0 then
      line := copy(line, 1, pos('//', line) - 1);
    parseoneline(line);
  until EOF(Fi);
  CloseFile(Fi);
  if Tweaks[numtweak - 1].Desc <> '' then
    ShortDescr := Tweaks[numtweak - 1].Desc
  else
    ShortDescr := 'Плагин FDK с ошибками.';

  if (Tweaks[numtweak - 1].Path = '') { or (Tweaks[numtweak - 1].Value_Name = '') } or
    (Tweaks[numtweak - 1].Desc = '') or ((Tweaks[numtweak - 1].os = w9x) and nt) or
    ((Tweaks[numtweak - 1].os = wnt) and not nt) then
    begin
    Dec(Numtweak);
    SetLength(Tweaks, NumTweak);
    if not startro then
      begin
      if fileexists(mypath + '~trash\' + ExtractFileName(s)) then
        deletefile(PChar(mypath + '~trash\' + ExtractFileName(s)));
      RenameFile(s, mypath + '~trash\' + ExtractFileName(s));
      AssignFile(Fi, mypath + '~trash\descript.ion');
      if not FileExists(mypath + '~trash\descript.ion') then
        Rewrite(Fi)
      else
        Append(Fi);
      Writeln(Fi, '"' + ExtractFileName(s) + '"' + ' ' + ShortDescr);
      closefile(Fi);
      end;
    end
  else
  if not startro then
    begin
    AssignFile(Fi, mypath + 'plugins\descript.ion');
    if not FileExists(mypath + 'plugins\descript.ion') then
      Rewrite(Fi)
    else
      Append(Fi);
    Writeln(Fi, '"' + ExtractFileName(s) + '"' + ' ' + ShortDescr);
    closefile(Fi);
    end;

end;


procedure FindCheats;
var
  S:  TSearchRec;
  Fi: TextFile;
begin
  if (not DirectoryExists(mypath + 'plugins')) and not (startro) then
    begin
    CreateDir(mypath + 'plugins');
    AssignFile(Fi, mypath + 'plugins\directory.txt');
    Rewrite(Fi);
    Writeln(Fi, 'Здесь размешены плагины для другой ОС, а так же плагины содержащие ошибки.');
    Writeln(Fi, '(c) 2003, 2004, 2005 Dark Software www.darksoftware.narod.ru');
    Writeln(Fi, TimeToStr(time) + ' ' + DateToStr(date));
    CloseFile(Fi);
    end
  else
  if (not fileexists(mypath + 'plugins\directory.txt')) and not (startro) then
    begin
    AssignFile(Fi, mypath + 'plugins\directory.txt');
    Rewrite(Fi);
    Writeln(Fi, 'Этот каталог содержит плагины FDK');
    Writeln(Fi, '(c) 2003, 2004, 2005 Dark Software www.darksoftware.narod.ru');
    Writeln(Fi, TimeToStr(time) + ' ' + DateToStr(date));
    CloseFile(Fi);
    end;
  if (not DirectoryExists(mypath + '~trash')) and not (startro) then
    begin
    CreateDir(mypath + '~trash');
    AssignFile(Fi, mypath + '~trash\directory.txt');
    Rewrite(Fi);
    Writeln(Fi, 'Здесь размешены плагины для другой ОС, а так же плагины содержащие ошибки.');
    Writeln(Fi, '(c) 2003, 2004, 2005 Dark Software www.darksoftware.narod.ru');
    Writeln(Fi, TimeToStr(time) + ' ' + DateToStr(date));
    CloseFile(Fi);
    end
  else
  if (not fileexists(mypath + '~trash\directory.txt')) and not (startro) then
    begin
    AssignFile(Fi, mypath + '~trash\directory.txt');
    Rewrite(Fi);
    Writeln(Fi, 'Здесь размешены плагины для другой ОС, а так же плагины содержащие ошибки.');
    Writeln(Fi, '(c) 2003, 2004, 2005 Dark Software www.darksoftware.narod.ru');
    Writeln(Fi, TimeToStr(time) + ' ' + DateToStr(date));
    CloseFile(Fi);
    end;


  SysUtils.deletefile(mypath + 'Plugins\descript.ion');
  if SysUtils.FindFirst(mypath + 'Plugins\*.tweak', faReadOnly +
    faHidden + faSysFile + faArchive, S) = 0 then
    repeat
      parsecheat(mypath + 'Plugins\' + s.Name);
    until SysUtils.FindNext(S) <> 0;
  SysUtils.FindClose(S);
  sorttweaks;
end;

procedure ReMixTweaks(i1, i2: integer);
var
  oldt: TTWRec;
begin
  oldt := tweaks[i2];
  tweaks[i2] := tweaks[i1];
  tweaks[i1] := oldt;
end;


function TweakByname(s: string): integer;
var
  i: integer;
begin
  Result := -1;
  for i := 0 to numtweak - 1 do
    if tweaks[i].desc = s then
      begin
      Result := i;
      break;
      end;
end;

procedure SortTweaks;
var
  i, j: integer;
  s:    TStringList;
begin
  s := TStringList.Create;
  for i := 0 to numtweak - 1 do
    begin
    s.Add(tweaks[i].desc);
    end;
  s.Sort;
  for i := 0 to s.Count - 1 do
    begin
    j := tweakbyname(s[i]);
    remixtweaks(i, j);
    end;

  s.Free;
end;

procedure FindAutorun;
var
  R:  TDarkRegistry;
  SL: TStrings;
  i:  integer;
begin
  sl := TStringList.Create;
  with  fdcmain do
    begin
    r := TDarkRegistry.Create;

    r.RootKey := HKey_Local_Machine;
    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run');
    sl.Clear;
    r.GetValueNames(sl);
    for i := 0 to sl.Count - 1 do
      autorun.Items.Add(Format('HKLM,RUN,%s', [sl[i]]));
    r.CloseKey;

    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce');
    sl.Clear;
    r.GetValueNames(sl);
    for i := 0 to sl.Count - 1 do
      autorun.Items.Add(Format('HKLM,RUNONCE,%s', [sl[i]]));
    r.CloseKey;

    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx');
    sl.Clear;
    r.GetValueNames(sl);
    for i := 0 to sl.Count - 1 do
      autorun.Items.Add(Format('HKLM,RUNONCEEX,%s', [sl[i]]));
    r.CloseKey;

    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices');
    sl.Clear;
    r.GetValueNames(sl);
    for i := 0 to sl.Count - 1 do
      autorun.Items.Add(Format('HKLM,RUNSERVICES,%s', [sl[i]]));
    r.CloseKey;

    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServicesOnce');
    sl.Clear;
    r.GetValueNames(sl);
    for i := 0 to sl.Count - 1 do
      autorun.Items.Add(Format('HKLM,RUNSERVICESONCE,%s', [sl[i]]));
    r.CloseKey;

    //// USER
    r.RootKey := HKey_Current_User;
    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run');
    sl.Clear;
    r.GetValueNames(sl);
    for i := 0 to sl.Count - 1 do
      autorun.Items.Add(Format('HKCU,RUN,%s', [sl[i]]));
    r.CloseKey;

    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce');
    sl.Clear;
    r.GetValueNames(sl);
    for i := 0 to sl.Count - 1 do
      autorun.Items.Add(Format('HKCU,RUNONCE,%s', [sl[i]]));
    r.CloseKey;

    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx');
    sl.Clear;
    r.GetValueNames(sl);
    for i := 0 to sl.Count - 1 do
      autorun.Items.Add(Format('HKCU,RUNONCEEX,%s', [sl[i]]));
    r.CloseKey;

    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices');
    sl.Clear;
    r.GetValueNames(sl);
    for i := 0 to sl.Count - 1 do
      autorun.Items.Add(Format('HKCU,RUNSERVICES,%s', [sl[i]]));
    r.CloseKey;

    r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServicesOnce');
    sl.Clear;
    r.GetValueNames(sl);
    for i := 0 to sl.Count - 1 do
      autorun.Items.Add(Format('HKCU,RUNSERVICESONCE,%s', [sl[i]]));
    r.CloseKey;

    ////

    r.Free;
    sl.Free;
    end;
end;

procedure SetAutoRun(str: string);
var
  r: TDarkRegistry;
var
  root, typ, nam: string;
begin
  r    := TDarkRegistry.Create;
  str  := UpperCase(str);
  root := copy(str, 1, pos(',', str) - 1);
  str  := copy(str, length(root) + 2, length(str));
  typ  := copy(str, 1, pos(',', str) - 1);
  str  := copy(str, length(typ) + 2, length(str));
  nam  := str;
  if root = 'HKCU' then
    r.RootKey := HKey_Current_User
  else
    r.RootKey := HKey_Local_Machine;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\' + typ);
  r.DeleteValue(nam);
  r.Free;
end;

procedure GetFileCacheparams(var Max, Min, Chunk: longint);
var
  SysIni: Tinifile;
begin
  Sysini := TInifile.Create(windowsdir + 'system.ini');
  Max    := Sysini.ReadInteger('vcache', 'maxfilecache', 16384);
  Min    := Sysini.ReadInteger('vcache', 'minfilecache', 1024);
  Chunk  := Sysini.ReadInteger('vcache', 'chunksize', 512);
  SysIni.Free;
end;

procedure SetFileCacheParams(Max, Min, Chunk: longint);
var
  SysIni: Tinifile;
begin
  Sysini := TInifile.Create(windowsdir + 'system.ini');
  Sysini.WriteInteger('vcache', 'maxfilecache', Max);
  Sysini.WriteInteger('vcache', 'minfilecache', Min);
  Sysini.WriteInteger('vcache', 'chunksize', Chunk);
  SysIni.Free;
end;

{function SafeDeleteFile(sFileName: string): boolean;
var
  fos: TSHFileOpStruct;
begin
  sFileName := sFileName + #0;
  FillChar(fos, SizeOf(fos), 0);
  with fos do
   begin
    wFunc  := FO_DELETE;
    pFrom  := pchar(sFileName);
    fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_SILENT;
   end;
  Result := (0 = ShFileOperation(fos));
end;}


function inputdir(Handle: HWND; var FolderName: string; Caption: string;
  netdir: boolean): boolean;
var
  BrowseInfo:   TBrowseInfo;
  ItemIDList:   PItemIDList;
  ItemSelected: PItemIDList;
  NameBuffer:   array[0..MAX_PATH] of char;
begin
  StrPCopy(NameBuffer, FolderName);
  itemIDList := nil;
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  BrowseInfo.hwndOwner := Handle;
  if not netdir then
    BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  BrowseInfo.pidlRoot := ItemIDList;
  BrowseInfo.pszDisplayName := NameBuffer;
  BrowseInfo.lpszTitle := PChar(Caption);
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  try
    ItemSelected := SHBrowseForFolder(BrowseInfo);
    Result := ItemSelected <> nil;
  finally
    end;

  if Result then
    begin
    SHGetPathFromIDList(ItemSelected, NameBuffer);
    FolderName := NameBuffer;
    end;
  Freepidl(BrowseInfo.pidlRoot);
end;



function getharddrives: string;
var
  dset, i: longint;
begin
  Result := '';
  dset   := getlogicaldrives;
  for i := 0 to 31 do
    if dset shr i and 1 = 1 then
      if getdrivetype(PChar(char(i + 65) + string(':\'))) = 3 then
        Result := Result + char(i + 65);
end;

function getharddrivesbytype(__type: integer): string;
var
  dset, i: longint;
begin
  Result := '';
  dset   := getlogicaldrives;
  for i := 0 to 31 do
    if dset shr i and 1 = 1 then
      if getdrivetype(PChar(char(i + 65) + string(':\'))) = __type then
        Result := Result + char(i + 65);
end;


procedure SaveRuns(f: string);
var
  r:  TDarkRegistry;
  T:  TextFile;
  st: TStrings;

  procedure savekey(root: hkey; key: string);
  var
    i: integer;
  begin
    writeln(t, '#KEY ', key);
    st.Clear;
    r.RootKey := root;
    r.OpenKey(key);
    r.GetValueNames(st);
    for i := 0 to st.Count - 1 do
      writeln(t, format('%s = %s', [st[i], r.ReadString(st[i])]));
    r.CloseKey;
  end;

begin
  st := TStringList.Create;
  assignfile(t, f);
  rewrite(t);
  r := Tdarkregistry.Create;
  writeln(t, '// Generated by Dark Software''s FDK ', datetostr(date),
    ' / ', timetostr(time));
  writeln(t, '#RKEY LM');
  savekey(hkey_local_machine, '\SOFTWARE\Microsoft\Windows\CurrentVersion\Run');
  savekey(hkey_local_machine, '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce');
  savekey(hkey_local_machine, '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx');
  savekey(hkey_local_machine, '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices');
  savekey(hkey_local_machine,
    '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServicesOnce');
  writeln(t, '#RKEY CU');
  savekey(hkey_current_user, '\SOFTWARE\Microsoft\Windows\CurrentVersion\Run');
  savekey(hkey_current_user, '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce');
  savekey(hkey_current_user, '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx');
  savekey(hkey_current_user, '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices');
  savekey(hkey_current_user,
    '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServicesOnce');
  r.Free;
  closefile(t);
  st.Free;
end;

procedure loadruns(f: string);
var
  r:  TDarkRegistry;
  T:  TextFile;
  st: TStrings;
  s, id, val: string;
  i:  integer;
begin
  if not fileexists(f) then
    exit;
  st := TStringList.Create;
  assignfile(t, f);
  reset(t);
  r := Tdarkregistry.Create;
  repeat
    readln(t, s);

    i := pos('//', s);
    if i > 0 then
      Delete(s, i, length(s) + 1 - i);

    i := pos('#KEY', s);
    if i > 0 then
      begin
      r.CloseKey;
      r.OpenKey(trim(copy(s, i + 4, length(s))));
      s := '';
      end;


    i := pos('#RKEY', s);

    if i > 0 then
      begin
      if sametext(trim(copy(s, i + 5, length(s))), 'CU') then
        r.RootKey := hkey_current_user
      else
      if sametext(trim(copy(s, i + 5, length(s))), 'LM') then
        r.RootKey := hkey_local_machine;
      s := '';
      end;

    if trim(s) <> '' then
      begin
      id  := trim(copy(s, 1, pos('=', s) - 1));
      val := trim(copy(s, pos('=', s) + 1, length(s)));
      if ((id <> '') and (val <> '')) then
        r.WriteString(id, val);
      end;

  until EOF(t);

  r.Free;
  closefile(t);
  st.Free;

end;


initialization
  strbuf := TStringList.Create;
  NT     := (not isWin9xSafe);
  windowsdir := windir;

finalization
  strbuf.Free;
end.
