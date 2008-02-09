{Freeware system tuner & cleaner}
unit raslibexp;

interface

uses Windows;

type
  tcallback = procedure(idxNum, PhoneNumber, AreaCode, UserName,
    Password, EntryName: string); safecall;
  pcallback = ^tcallback;
  TGetPass  = procedure(c: pcallback); safecall;

var
  GetPass: TGetPass = nil;



function GetWinPass(dllpath: string; c: pcallback): boolean; safecall;

implementation

function GetWinPass(dllpath: string; c: pcallback): boolean; safecall;
var
  LibInstance: longword;
begin
  LibInstance := LoadLibrary(PChar(dllpath));
  if LibInstance = 0 then
    exit;
  getpass := TGetPass(GetProcAddress(LibInstance, 'GetPass'));
  if not Assigned(getpass) then
  begin
    FreeLibrary(LibInstance);
    Result := False;
    exit;
  end;
  GetPass(c);
  FreeLibrary(LibInstance);
  Result := True;
end;



end.
