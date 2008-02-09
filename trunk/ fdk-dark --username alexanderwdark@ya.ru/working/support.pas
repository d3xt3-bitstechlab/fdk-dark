{Freeware system tuner & cleaner}
unit support;

interface

uses Windows, ShlObj, SysUtils, Forms;

const
  {SHObjectProperties Flags}
  OPF_PRINTERNAME = $01;
  OPF_PATHNAME    = $02;

function SHObjectProperties(Owner: HWND; Flags: UINT;
  ObjectName: Pointer; InitialTabName: Pointer): longbool; stdcall;

type
  TShellObjectType  = (sdPathObject, sdPrinterObject);
  TShellObjectTypes = set of TShellObjectType;

{MAIN FUNCTION}
function ShowObjectPropertiesDialog(ObjectName: string; ObjectType: TShellObjectType;
  InitialTab: string): boolean;

function ShellObjectTypeEnumToConst(ShellObjectType: TShellObjectType): UINT;
function ShellObjectTypeConstToEnum(ShellObjectType: UINT): TShellObjectType;

implementation



const
  Shell32 = 'shell32.dll';
  SHObjectProperties_Index = 178;

var
  ShellDLL: HMODULE;

function SHObjectProperties; external Shell32 index
  SHObjectProperties_Index;

function ShowObjectPropertiesDialog(ObjectName: string; ObjectType: TShellObjectType;
  InitialTab: string): boolean;

var
  ObjectNameBuffer: Pointer;
  TabNameBuffer:    Pointer;
begin
  {Allocate a buffer to hold the object name, long enough for UNICODE if need be.}
  GetMem(ObjectNameBuffer, (Length(ObjectName) + 1) * SizeOf(widechar));
  try {..finally}

    {If WinNT, convert object name string to UNICODE. Otherwise, just copy to buffer.}
    if (SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT) then
    begin
      StringToWideChar(ObjectName, PWideChar(ObjectNameBuffer),
        (Length(ObjectName) + 1));
    end {if}
    else
    begin
      StrPCopy(PChar(ObjectNameBuffer), ObjectName);
    end; {else}

    {Allocate a buffer to hold the initial tab name, long enough for UNICODE if need be.}
    GetMem(TabNameBuffer, (Length(InitialTab) + 1) * SizeOf(widechar));
    try {..finally}

      {If WinNT, convert initial tab name string to UNICODE. Otherwise, just copy to buffer.}
      if (SysUtils.Win32Platform = VER_PLATFORM_WIN32_NT) then
      begin
        StringToWideChar(InitialTab, PWideChar(TabNameBuffer),
          (Length(InitialTab) + 1));
      end {if}
      else
      begin
        StrPCopy(PChar(TabNameBuffer), InitialTab);
      end; {else}

      {Execute the dialog and translate the result to the return value.}
      Result := SHObjectProperties(Application.Handle, ShellObjectTypeEnumToConst(
        ObjectType), ObjectNameBuffer, TabNameBuffer);

      {Ensure tab name buffer is freed.}
    finally
      FreeMem(TabNameBuffer);
    end; {try..finally}

    {Ensure object name buffer is freed.}
  finally
    FreeMem(ObjectNameBuffer);
  end; {try..finally}
end;


function ShellObjectTypeEnumToConst(ShellObjectType: TShellObjectType): UINT;
begin
  case (ShellObjectType) of
    sdPathObject: Result    := OPF_PATHNAME;
    sdPrinterObject: Result := OPF_PRINTERNAME;
    else
      Result := 0;
  end; {case}
end;

function ShellObjectTypeConstToEnum(ShellObjectType: UINT): TShellObjectType;
begin
  case (ShellObjectType) of
    OPF_PATHNAME: Result    := sdPathObject;
    OPF_PRINTERNAME: Result := sdPrinterObject;
    else
      Result := sdPathObject;
  end;
end;

initialization
  ShellDLL := LoadLibrary(PChar(Shell32));

finalization
  FreeLibrary(ShellDLL);
end.
