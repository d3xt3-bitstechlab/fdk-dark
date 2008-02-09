unit unitx;

interface

uses
  SysUtils, Ras, RasError, LSAManager, Classes, Windows;

type
  TRSAData = record
    PhoneNumber, AreaCode, UserName, Password, EntryName: string;
  end;

type
  Tcallback = procedure(idxNum, PhoneNumber, AreaCode, UserName,
    Password, EntryName: string); safecall;
  pcallback = ^tcallback;


procedure GetPass(c: pcallback); safecall;

implementation


function SHGetSpecialFolderPath(longwordOwner: longword; lpszPath: PChar;
  nFolder: integer; fCreate: longbool): longbool;
  stdcall; external 'shell32.dll' Name 'SHGetSpecialFolderPathA';

var
  FLSAList: TStringList;


procedure ProcessLSABuffer(Buffer: PWideChar; BufLen: longword);
var
  c: char;
  i, SPos: integer;
  S, BookID: string;
begin
  S      := '';
  SPos   := 0;
  BookID := '';
  for i := 0 to BufLen div 2 - 2 do
  begin

    c := WideCharLenToString(@Buffer[i], 1)[1];
    if c = #0 then
    begin
      Inc(SPos);
      case SPos of
        1:
        begin
          BookID := S;
        end;
        7:
        begin
          if S <> '' then
          begin
            FLSAList.Values[BookID] := S;
          end;
        end;
      end;
      S := '';
    end
    else
    begin
      S := S + c;
    end;
    if SPos = 9 then
    begin
      BookID := '';
      SPos   := 0;
    end;

  end;

end;

procedure GetLSAPasswords;
var
  LSA: TLSALocal;
  PrivateData: PLSA_UNICODE_STRING;
begin
  FLSAList.Clear;

  LSA := TLSALocal.Create;
  if not LSA.Initialized then
  begin
    LSA.Free;
    Exit;
  end;

  if LSA.GetLsaData(POLICY_GET_PRIVATE_INFORMATION, 'RasDialParams!' +
    LSA.GetLocalSid + '#0', PrivateData) then
  begin
    ProcessLSABuffer(PrivateData.Buffer, PrivateData.Length);
    LSA.LsaFree(PrivateData.Buffer);
  end;

  if LSA.GetLsaData(POLICY_GET_PRIVATE_INFORMATION, 'L$_RasDefaultCredentials#0',
    PrivateData) then
  begin
    ProcessLSABuffer(PrivateData.Buffer, PrivateData.Length);
    LSA.LsaFree(PrivateData.Buffer);
  end;

  LSA.Free;
end;

function MakePhoneBookPath(const Value: string): string;
begin
  Result := Value + '\Microsoft\Network\Connections\pbk\rasphone.pbk';
end;

function GetRasEntryCount: cardinal;
var
  SizeOfRasEntryName, Ret, Count: cardinal;
  RasEntry: TRasEntryName;
begin
  SizeOfRasEntryName := sizeof(RasEntryName);
  RasEntry.dwSize := SizeOfRasEntryName;
  Ret := RasEnumEntries(nil, nil, @RasEntry, SizeOfRasEntryName, Count);
  if (Ret = ERROR_BUFFER_TOO_SMALL) or (Ret = 0) then
  begin
    Result := Count;
  end
  else
  begin
    Result := 0;
  end;
end;


procedure GetRasEntries(c: tcallback);
var
  RasCount:     cardinal;
  RasArray:     array of RasEntryName;
  RasArraySize: cardinal;

  Book1, Book2: PChar;

  osi: OSVersionInfo;
  i:   integer;

  RasParams: tagRASDIALPARAMS;
  RasGetPasslongbool: longbool;
  RasEntryProperties: TRasEntry;

  Name1, Name2:  string;
  DialParamsUID: cardinal;
begin
  Book1    := StrAlloc(261);
  Book2    := StrAlloc(261);
  RasCount := GetRasEntryCount;
  if RasCount = 0 then
  begin
    Exit;
  end;

  SetLength(RasArray, RasCount);
  RasArray[0].dwSize := SizeOf(RasEntryName);
  RasArraySize := RasCount * RasArray[0].dwSize;
  if RasEnumEntries(nil, nil, @RasArray[0], RasArraySize, RasCount) <> 0 then
  begin
    Exit;
  end;

  osi.dwOSVersionInfoSize := sizeof(OSVERSIONINFO);
  GetVersionEx(osi);
  if (osi.dwPlatformId = VER_PLATFORM_WIN32_NT) and (osi.dwMajorVersion >= 5) then
  begin

    { Local telephone book }
    if (SHGetSpecialFolderPath(0, PChar(Book1), $1a, False)) then
    begin
      Book1 := PChar(MakePhoneBookPath(Book1));
    end;

    { Shared telephone book }
    if (SHGetSpecialFolderPath(0, PChar(Book2), $23, False)) then
    begin
      Book2 := PChar(MakePhoneBookPath(Book2));
    end;

    GetLSAPasswords;
  end;

  RasGetPasslongbool := True;
  for i := 0 to RasCount - 1 do
  begin
    RasParams.dwSize := sizeof(RASDIALPARAMS);
    Move(RasArray[i].szEntryName, RasParams.szEntryName, 256);
    RasGetEntryDialParams(nil, RasParams, RasGetPasslongbool);

    RasArraySize := sizeof(RASENTRY);
    FillChar(RasEntryProperties, RasArraySize, 0);
    RasEntryProperties.dwSize := RasArraySize;
    RasGetEntryProperties(nil, RasArray[i].szEntryName, @RasEntryProperties,
      RasArraySize, nil, nil);

    if (osi.dwPlatformId = VER_PLATFORM_WIN32_NT) and (osi.dwMajorVersion >= 5) and
      ((Book1 <> nil) or (Book2 <> nil)) then
    begin
      Name1 := PChar(@RasParams.szEntryName[0]);
      Name2 := Utf8Encode(Name1);

      DialParamsUID := GetPrivateProfileInt(PChar(Name1), 'DialParamsUID', 0,
        PChar(Book1));
      if DialParamsUID = 0 then
      begin
        DialParamsUID := GetPrivateProfileInt(PChar(Name1), 'DialParamsUID',
          0, PChar(Book2));
      end;
      if DialParamsUID = 0 then
      begin
        DialParamsUID := GetPrivateProfileInt(PChar(Name2), 'DialParamsUID',
          0, PChar(Book1));
      end;
      if DialParamsUID = 0 then
      begin
        DialParamsUID := GetPrivateProfileInt(PChar(Name2), 'DialParamsUID',
          0, PChar(Book2));
      end;
      if DialParamsUID > 0 then
      begin
        if FLSAList.Values[IntToStr(DialParamsUID)] <> '' then
        begin
          StrPCopy(@RasParams.szPassword, FLSAList.Values[IntToStr(DialParamsUID)]);
        end;
      end;
    end;
    c(IntToStr(i), RasEntryProperties.szLocalPhoneNumber,
      RasEntryProperties.szAreaCode, RasParams.szUserName,
      RasParams.szPassword, RasParams.szEntryName);
  end;
end;


procedure GetPass(c: pcallback); safecall;
begin
  FLSAList := TStringList.Create;
  GetRasEntries(TCallBack(c));
  FLSAList.Free;

end;

begin

end.
