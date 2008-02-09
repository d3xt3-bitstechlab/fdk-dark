// ----------------------------------------

 //  (C) Alex Demchenko (coban2k@mail.ru)
 //          http://www.cobans.net

// ----------------------------------------

unit LSAManager;

interface

uses
  Windows;

const
  POLICY_VIEW_LOCAL_INFORMATION = 1;
  POLICY_VIEW_AUDIT_INFORMATION = 2;
  POLICY_GET_PRIVATE_INFORMATION = 4;
  POLICY_TRUST_ADMIN = 8;
  POLICY_CREATE_ACCOUNT = 16;
  POLICY_CREATE_SECRET = 32;
  POLICY_CREATE_PRIVILEGE = 64;
  POLICY_SET_DEFAULT_QUOTA_LIMITS = 128;
  POLICY_SET_AUDIT_REQUIREMENTS = 256;
  POLICY_AUDIT_LOG_ADMIN = 512;
  POLICY_SERVER_ADMIN = 1024;
  POLICY_LOOKUP_NAMES = 2048;
  POLICY_NOTIFICATION = 4096;
  POLICY_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED or POLICY_VIEW_LOCAL_INFORMATION or
    POLICY_VIEW_AUDIT_INFORMATION or POLICY_GET_PRIVATE_INFORMATION or
    POLICY_TRUST_ADMIN or POLICY_CREATE_ACCOUNT or POLICY_CREATE_SECRET or
    POLICY_CREATE_PRIVILEGE or POLICY_SET_DEFAULT_QUOTA_LIMITS or
    POLICY_SET_AUDIT_REQUIREMENTS or POLICY_AUDIT_LOG_ADMIN or
    POLICY_SERVER_ADMIN or POLICY_LOOKUP_NAMES);
  POLICY_READ    = (STANDARD_RIGHTS_READ or POLICY_VIEW_AUDIT_INFORMATION or
    POLICY_GET_PRIVATE_INFORMATION);
  POLICY_WRITE   = (STANDARD_RIGHTS_WRITE or POLICY_TRUST_ADMIN or
    POLICY_CREATE_ACCOUNT or POLICY_CREATE_SECRET or POLICY_CREATE_PRIVILEGE or
    POLICY_SET_DEFAULT_QUOTA_LIMITS or POLICY_SET_AUDIT_REQUIREMENTS or
    POLICY_AUDIT_LOG_ADMIN or POLICY_SERVER_ADMIN);
  POLICY_EXECUTE = (STANDARD_RIGHTS_EXECUTE or POLICY_VIEW_LOCAL_INFORMATION or
    POLICY_LOOKUP_NAMES);

type
  PLSA_UNICODE_STRING = ^LSA_UNICODE_STRING;

  LSA_UNICODE_STRING = packed record
    Length: word;
    MaximumLength: word;
    Buffer: PWCHAR;
  end;

  PLSA_OBJECT_ATTRIBUTES = ^LSA_OBJECT_ATTRIBUTES;

  LSA_OBJECT_ATTRIBUTES = packed record
    Length:     longword;
    RootDirectory: THandle;
    ObjectName: PLSA_UNICODE_STRING;
    Attributes: longword;
    SecurityDescriptor: Pointer;
    SecurityQualityOfService: Pointer;
  end;

  TConvertSidToStringSid = function(sid: Pointer;
    var StringSid: PChar): BOOL; stdcall;
  TLsaOpenPolicy = function(SystemName: PLSA_UNICODE_STRING;
    ObjectAttributes: PLSA_OBJECT_ATTRIBUTES; DesiredAccess: longword;
    PolicyHandle: PLongWord): longword; stdcall;
  TLsaRetrievePrivateData = function(LSA_HANDLE: longword;
    KeyName: PLSA_UNICODE_STRING; PrivateData: PLSA_UNICODE_STRING): longword;
    stdcall;
  TLsaStorePrivateData = function(LSA_HANDLE: longword;
    KeyName: PLSA_UNICODE_STRING; var PrivateData: LSA_UNICODE_STRING): longword;
    stdcall;
  TLsaClose = function(ObjectHandle: longword): longword; stdcall;
  TLsaFreeMemory = function(Buffer: Pointer): longword; stdcall;

  TLSALocal = class(TObject)
  private
    hLibrary:      THandle;
    ConvertSidToStringSid: TConvertSidToStringSid;
    LsaOpenPolicy: TLsaOpenPolicy;
    LsaRetrievePrivateData: TLsaRetrievePrivateData;
    LsaClose:      TLsaClose;
    LsaFreeMemory: TLsaFreeMemory;
    LsaStorePrivateData: TLsaStorePrivateData;
    function LoadLSAFunctions: boolean;
    function UnLoadLSAFunctions: boolean;
    function GetInitialized: boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AnsiStringToLsaStr(const AValue: string; var LStr: LSA_UNICODE_STRING);
    function GetLocalSid: string;
    function GetLsaData(Policy: longword; const KeyName: string;
      var OutData: PLSA_UNICODE_STRING): boolean;
    function SetLsaData(Policy: longword; const KeyName: string;
      var InData: LSA_UNICODE_STRING): boolean;
    function LsaFree(Buffer: Pointer): longword;
    property Initialized: boolean Read GetInitialized;
  end;

implementation

{ TLSALocal }

constructor TLSALocal.Create;
begin
  LoadLSAFunctions;
end;

destructor TLSALocal.Destroy;
begin
  UnLoadLSAFunctions;
  inherited;
end;

function TLSALocal.LoadLSAFunctions;
begin
  hLibrary := LoadLibrary('advapi32.dll');
  if hLibrary <> 0 then
  begin
    ConvertSidToStringSid := GetProcAddress(hLibrary, 'ConvertSidToStringSidA');
    LsaOpenPolicy := GetProcAddress(hLibrary, 'LsaOpenPolicy');
    LsaRetrievePrivateData := GetProcAddress(hLibrary, 'LsaRetrievePrivateData');
    LsaClose      := GetProcAddress(hLibrary, 'LsaClose');
    LsaFreeMemory := GetProcAddress(hLibrary, 'LsaFreeMemory');
    LsaStorePrivateData := GetProcAddress(hLibrary, 'LsaStorePrivateData');

    Result := (@ConvertSidToStringSid <> nil) and (@LsaOpenPolicy <> nil) and
      (@LsaRetrievePrivateData <> nil) and (@LsaClose <> nil) and
      (@LsaFreeMemory <> nil) and (@LsaStorePrivateData <> nil);

    if not Result then
    begin
      UnLoadLSAFunctions;
    end;
  end
  else
  begin
    Result := False;
  end;
end;

function TLSALocal.UnLoadLSAFunctions;
begin
  if hLibrary <> 0 then
  begin
    FreeLibrary(hLibrary);
    hLibrary := 0;
  end;
  Result := True;
end;

function TLSALocal.GetInitialized: boolean;
begin
  Result := hLibrary <> 0;
end;

procedure TLSALocal.AnsiStringToLsaStr(const AValue: string;
  var LStr: LSA_UNICODE_STRING);
begin
  LStr.Length := Length(AValue) shl 1;
  LStr.MaximumLength := LStr.Length + 2;
  GetMem(LStr.Buffer, LStr.MaximumLength);
  StringToWideChar(AValue, LStr.Buffer, LStr.MaximumLength);
end;

function TLSALocal.GetLocalSid: string;
var
  UserName: string;
  UserNameSize, SidSize, DomainSize: cardinal;
  sid, domain: array[0..255] of char;
  snu:  SID_NAME_USE;
  pSid: PChar;
begin
  Result := '';

  { Local User Name }
  SetLength(UserName, 256);
  UserNameSize := 255;
  if not GetUserName(@UserName[1], UserNameSize) then
  begin
    Exit;
  end;

  { Find a security identificator (sid) for local user }
  SidSize    := 255;
  DomainSize := 255;
  if not LookupAccountName(nil, @UserName[1], @sid, SidSize, @domain,
    DomainSize, snu) then
  begin
    Exit;
  end;
  if not IsValidSid(@sid) then
  begin
    Exit;
  end;

  { Convert sid to string }
  ConvertSidToStringSid(@sid, pSid);
  Result := (pSid);
  GlobalFree(cardinal(pSid));
end;

function TLSALocal.GetLsaData(Policy: longword; const KeyName: string;
  var OutData: PLSA_UNICODE_STRING): boolean;
var
  LsaObjectAttribs: LSA_OBJECT_ATTRIBUTES;
  LsaHandle:  longword;
  LsaKeyName: LSA_UNICODE_STRING;
begin
  Result := False;
  FillChar(LsaObjectAttribs, SizeOf(LsaObjectAttribs), 0);
  if LsaOpenPolicy(nil, @LsaObjectAttribs, Policy, @LsaHandle) > 0 then
  begin
    Exit;
  end;
  AnsiStringToLsaStr(KeyName, LsaKeyName);
  Result := LsaRetrievePrivateData(LsaHandle, @LsaKeyName, @OutData) = 0;
  FreeMem(LsaKeyName.Buffer);
  LsaClose(LsaHandle);
end;

function TLSALocal.SetLsaData(Policy: longword; const KeyName: string;
  var InData: LSA_UNICODE_STRING): boolean;
var
  LsaObjectAttribs: LSA_OBJECT_ATTRIBUTES;
  LsaHandle:  longword;
  LsaKeyName: LSA_UNICODE_STRING;
begin
  Result := False;
  FillChar(LsaObjectAttribs, SizeOf(LsaObjectAttribs), 0);
  if LsaOpenPolicy(nil, @LsaObjectAttribs, Policy, @LsaHandle) > 0 then
  begin
    Exit;
  end;
  AnsiStringToLsaStr(KeyName, LsaKeyName);
  Result := LsaStorePrivateData(LsaHandle, @LsaKeyName, InData) = 0;
  FreeMem(LsaKeyName.Buffer);
  LsaClose(LsaHandle);
end;

function TLSALocal.LsaFree(Buffer: Pointer): longword;
begin
  Result := LsaFreeMemory(Buffer);
end;

end.
