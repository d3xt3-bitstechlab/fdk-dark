unit ShellAdd;

interface

uses Windows;

{type
  TSHQueryRBInfo = packed record
    cbSize: DWORD;
    i64Size,
    i64NumItems: TLargeInteger; //LargeUInt; //DWORDLONG;
  end;

  PSHQueryRBInfo = ^TSHQueryRBInfo;}

const
  SHERB_NOCONFIRMATION = $1;
  SHERB_NOPROGRESSUI = $2;
  SHERB_NOSOUND = $4;

function SHEmptyRecycleBin(Wnd: HWND; pszRootPath: PChar;
  dwFlags: DWORD): HRESULT; stdcall;
{function SHEmptyRecycleBinA(Wnd: HWND; pszRootPath: PANSIChar;
  dwFlags: DWORD): HRESULT; stdcall;
function SHEmptyRecycleBinW(Wnd: HWND; pszRootPath: PWideChar;
  dwFlags: DWORD): HRESULT; stdcall;
{function SHQueryRecycleBinA(pszRootPath: PANSIChar;
  var SHQueryRBInfo: TSHQueryRBInfo): HRESULT; stdcall;
function SHQueryRecycleBinW(pszRootPath: PWideChar;
  var SHQueryRBInfo: TSHQueryRBInfo): HRESULT; stdcall;
function SHQueryRecycleBin(pszRootPath: pchar;
  var SHQueryRBInfo: TSHQueryRBInfo): HRESULT; stdcall;}

implementation

const
  Shell32 = 'Shell32.dll';

function SHEmptyRecycleBin; external Shell32 Name 'SHEmptyRecycleBinA';

{function SHEmptyRecycleBinA; external Shell32 name 'SHEmptyRecycleBinA';
function SHEmptyRecycleBinW; external Shell32 name 'SHEmptyRecycleBinW';
function SHQueryRecycleBinA; external shell32 name 'SHQueryRecycleBinA';
function SHQueryRecycleBinW; external shell32 name 'SHQueryRecycleBinW';
function SHQueryRecycleBin; external shell32 name 'SHQueryRecycleBinA';}

end.
