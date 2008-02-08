{Freeware system tuner & cleaner}
unit DarkRegistry;

{$R-,T-,H+,X+}

interface

uses Windows, Classes, SysUtils;

type

  TRegKeyInfo = record
    NumSubKeys:   integer;
    MaxSubKeyLen: integer;
    NumValues:    integer;
    MaxValueLen:  integer;
    MaxDataLen:   integer;
    FileTime:     TFileTime;
  end;

  TRegDataType = (rdUnknown, rdString, rdExpandString, rdInteger, rdBinary);

  TRegDataInfo = record
    RegData:  TRegDataType;
    DataSize: integer;
  end;

  TDarkRegistry = class(TObject)
  private
    FCurrentKey: HKEY;
    FRootKey: HKEY;
    FLazyWrite: boolean;
    FCurrentPath: string;
    FCloseRootKey: boolean;
    FAccess: longword;
    procedure SetRootKey(Value: HKEY);
  protected
    procedure ChangeKey(Value: HKey; const Path: string);
    function GetBaseKey(Relative: boolean): HKey;
    function GetData(const Name: string; Buffer: Pointer; BufSize: integer;
      var RegData: TRegDataType): integer;
    function GetKey(const Key: string): HKEY;
    procedure PutData(const Name: string; Buffer: Pointer; BufSize: integer;
      RegData: TRegDataType);
    procedure SetCurrentKey(Value: HKEY);
  public
    constructor Create; overload;
    destructor Destroy; override;
    procedure CloseKey;
    function CreateKey(const Key: string): boolean;
    function DeleteKey(const Key: string): boolean;
    function DeleteValue(const Name: string): boolean;
    function GetDataInfo(const ValueName: string; var Value: TRegDataInfo): boolean;
    function GetDataSize(const ValueName: string): integer;
    function GetDataType(const ValueName: string): TRegDataType;
    function GetKeyInfo(var Value: TRegKeyInfo): boolean;
    procedure GetKeyNames(Strings: TStrings);
    procedure GetValueNames(Strings: TStrings);
    function HasSubKeys: boolean;
    function KeyExists(const Key: string): boolean;
    function OpenKey(const Key: string): boolean;
    function ReadCurrency(const Name: string): currency;
    function ReadBinaryData(const Name: string; var Buffer;
      BufSize: integer): integer;
    function ReadBool(const Name: string): boolean;
    function ReadDate(const Name: string): TDateTime;
    function ReadDateTime(const Name: string): TDateTime;
    function ReadFloat(const Name: string): double;
    function ReadInteger(const Name: string): integer;
    function ReadString(const Name: string): string;
    function ReadTime(const Name: string): TDateTime;
    function ValueExists(const Name: string): boolean;
    procedure WriteCurrency(const Name: string; Value: currency);
    procedure WriteBinaryData(const Name: string; var Buffer; BufSize: integer);
    procedure WriteBool(const Name: string; Value: boolean);
    procedure WriteDate(const Name: string; Value: TDateTime);
    procedure WriteDateTime(const Name: string; Value: TDateTime);
    procedure WriteFloat(const Name: string; Value: double);
    procedure WriteInteger(const Name: string; Value: integer);
    procedure WriteString(const Name, Value: string);
    procedure WriteExpandString(const Name, Value: string);
    procedure WriteTime(const Name: string; Value: TDateTime);
    property CurrentKey: HKEY Read FCurrentKey;
    property CurrentPath: string Read FCurrentPath;
    property RootKey: HKEY Read FRootKey Write SetRootKey;
    property Access: longword Read FAccess Write FAccess;
  end;


implementation

uses RTLConsts;

function IsRelative(const Value: string): boolean;
begin
  if (Value <> '') then
    Result := not ((Value <> '') and (Value[1] = '\'));
end;

function RegDataToDataType(Value: TRegDataType): integer;
begin
  case Value of
    rdString:
      Result := REG_SZ;
    rdExpandString:
      Result := REG_EXPAND_SZ;
    rdInteger:
      Result := REG_DWORD;
    rdBinary:
      Result := REG_BINARY;
    else
      Result := REG_NONE;
  end;
end;

function DataTypeToRegData(Value: integer): TRegDataType;
begin
  case Value of
    REG_SZ:
      Result := rdString;
    REG_EXPAND_SZ:
      Result := rdExpandString;
    REG_DWORD:
      Result := rdInteger;
    REG_BINARY:
      Result := rdBinary;
    else
      Result := rdUnknown;
  end;
end;

constructor TDarkRegistry.Create;
begin
  RootKey := HKEY_CURRENT_USER;
  FAccess := KEY_ALL_ACCESS;
end;


destructor TDarkRegistry.Destroy;
begin
  CloseKey;
  inherited;
end;

procedure TDarkRegistry.CloseKey;
begin
  if CurrentKey <> 0 then
  begin
    RegCloseKey(CurrentKey);
    FCurrentKey  := 0;
    FCurrentPath := '';
  end;
end;

procedure TDarkRegistry.SetRootKey(Value: HKEY);
begin
  if RootKey <> Value then
  begin
    if FCloseRootKey then
    begin
      RegCloseKey(RootKey);
      FCloseRootKey := False;
    end;
    FRootKey := Value;
    CloseKey;
  end;
end;

procedure TDarkRegistry.ChangeKey(Value: HKey; const Path: string);
begin
  CloseKey;
  FCurrentKey  := Value;
  FCurrentPath := Path;
end;

function TDarkRegistry.GetBaseKey(Relative: boolean): HKey;
begin
  if (CurrentKey = 0) or not Relative then
    Result := RootKey
  else
    Result := CurrentKey;
end;

procedure TDarkRegistry.SetCurrentKey(Value: HKEY);
begin
  FCurrentKey := Value;
end;

function TDarkRegistry.CreateKey(const Key: string): boolean;
var
  TempKey: HKey;
  S: string;
  Disposition: integer;
  Relative: boolean;
begin
  TempKey := 0;
  S := Key;
  Relative := IsRelative(S);
  if not Relative then
    Delete(S, 1, 1);
  Result := RegCreateKeyEx(GetBaseKey(Relative), PChar(S), 0, nil,
    REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, nil, TempKey, @Disposition) = ERROR_SUCCESS;
  if Result then
    RegCloseKey(TempKey);
end;

function TDarkRegistry.OpenKey(const Key: string): boolean;
var
  TempKey: HKey;
  S: string;
  Disposition: integer;
  Relative: boolean;
begin
  S := Key;
  Relative := IsRelative(S);

  if not Relative then
    Delete(S, 1, 1);
  TempKey := 0;
  Result  := RegCreateKeyEx(GetBaseKey(Relative), PChar(S), 0, nil,
    REG_OPTION_NON_VOLATILE, FAccess, nil, TempKey, @Disposition) = ERROR_SUCCESS;
  if Result then
  begin
    if (CurrentKey <> 0) and Relative then
      S := CurrentPath + '\' + S;
    ChangeKey(TempKey, S);
  end;
end;


function TDarkRegistry.DeleteKey(const Key: string): boolean;
var
  Len:  DWORD;
  I:    integer;
  Relative: boolean;
  S, KeyName: string;
  OldKey, DeleteKey: HKEY;
  Info: TRegKeyInfo;
begin
  S := Key;
  Relative := IsRelative(S);
  if not Relative then
    Delete(S, 1, 1);
  OldKey    := CurrentKey;
  DeleteKey := GetKey(Key);
  if DeleteKey <> 0 then
    try
      SetCurrentKey(DeleteKey);
      if GetKeyInfo(Info) then
      begin
        SetString(KeyName, nil, Info.MaxSubKeyLen + 1);
        for I := Info.NumSubKeys - 1 downto 0 do
        begin
          Len := Info.MaxSubKeyLen + 1;
          if RegEnumKeyEx(DeleteKey, DWORD(I), PChar(KeyName), Len,
            nil, nil, nil, nil) = ERROR_SUCCESS then
            Self.DeleteKey(PChar(KeyName));
        end;
      end;
    finally
      SetCurrentKey(OldKey);
      RegCloseKey(DeleteKey);
    end;
  Result := RegDeleteKey(GetBaseKey(Relative), PChar(S)) = ERROR_SUCCESS;
end;

function TDarkRegistry.DeleteValue(const Name: string): boolean;
begin
  Result := RegDeleteValue(CurrentKey, PChar(Name)) = ERROR_SUCCESS;
end;

function TDarkRegistry.GetKeyInfo(var Value: TRegKeyInfo): boolean;
begin
  FillChar(Value, SizeOf(TRegKeyInfo), 0);
  Result := RegQueryInfoKey(CurrentKey, nil, nil, nil, @Value.NumSubKeys,
    @Value.MaxSubKeyLen, nil, @Value.NumValues, @Value.MaxValueLen,
    @Value.MaxDataLen, nil, @Value.FileTime) = ERROR_SUCCESS;
  if SysLocale.FarEast and (Win32Platform = VER_PLATFORM_WIN32_NT) then
    with Value do
    begin
      Inc(MaxSubKeyLen, MaxSubKeyLen);
      Inc(MaxValueLen, MaxValueLen);
    end;
end;

procedure TDarkRegistry.GetKeyNames(Strings: TStrings);
var
  Len:  DWORD;
  I:    integer;
  Info: TRegKeyInfo;
  S:    string;
begin
  Strings.Clear;
  if GetKeyInfo(Info) then
  begin
    SetString(S, nil, Info.MaxSubKeyLen + 1);
    for I := 0 to Info.NumSubKeys - 1 do
    begin
      Len := Info.MaxSubKeyLen + 1;
      RegEnumKeyEx(CurrentKey, I, PChar(S), Len, nil, nil, nil, nil);
      Strings.Add(PChar(S));
    end;
  end;
end;

procedure TDarkRegistry.GetValueNames(Strings: TStrings);
var
  Len:  DWORD;
  I:    integer;
  Info: TRegKeyInfo;
  S:    string;
begin
  Strings.Clear;
  if GetKeyInfo(Info) then
  begin
    SetString(S, nil, Info.MaxValueLen + 1);
    for I := 0 to Info.NumValues - 1 do
    begin
      Len := Info.MaxValueLen + 1;
      RegEnumValue(CurrentKey, I, PChar(S), Len, nil, nil, nil, nil);
      Strings.Add(PChar(S));
    end;
  end;
end;

function TDarkRegistry.GetDataInfo(const ValueName: string;
  var Value: TRegDataInfo): boolean;
var
  DataType: integer;
begin
  FillChar(Value, SizeOf(TRegDataInfo), 0);
  Result := RegQueryValueEx(CurrentKey, PChar(ValueName), nil, @DataType,
    nil, @Value.DataSize) = ERROR_SUCCESS;
  Value.RegData := DataTypeToRegData(DataType);
end;

function TDarkRegistry.GetDataSize(const ValueName: string): integer;
var
  Info: TRegDataInfo;
begin
  if GetDataInfo(ValueName, Info) then
    Result := Info.DataSize
  else
    Result := -1;
end;

function TDarkRegistry.GetDataType(const ValueName: string): TRegDataType;
var
  Info: TRegDataInfo;
begin
  if GetDataInfo(ValueName, Info) then
    Result := Info.RegData
  else
    Result := rdUnknown;
end;

procedure TDarkRegistry.WriteString(const Name, Value: string);
begin
  PutData(Name, PChar(Value), Length(Value) + 1, rdString);
end;

procedure TDarkRegistry.WriteExpandString(const Name, Value: string);
begin
  PutData(Name, PChar(Value), Length(Value) + 1, rdExpandString);
end;

function TDarkRegistry.ReadString(const Name: string): string;
var
  Len:     integer;
  RegData: TRegDataType;
begin
  Result := '';
  if not ValueExists(Name) then
    Exit;
  Len := GetDataSize(Name);
  if Len > 0 then
  begin
    SetString(Result, nil, Len);
    GetData(Name, PChar(Result), Len, RegData);
    if (RegData = rdString) or (RegData = rdExpandString) then
      SetLength(Result, StrLen(PChar(Result)));
  end;

end;

procedure TDarkRegistry.WriteInteger(const Name: string; Value: integer);
begin
  PutData(Name, @Value, SizeOf(integer), rdInteger);
end;

function TDarkRegistry.ReadInteger(const Name: string): integer;
var
  RegData: TRegDataType;
begin
  Result := -1;
  if not ValueExists(Name) then
    exit;
  GetData(Name, @Result, SizeOf(integer), RegData);
end;

procedure TDarkRegistry.WriteBool(const Name: string; Value: boolean);
begin
  WriteInteger(Name, Ord(Value));
end;

function TDarkRegistry.ReadBool(const Name: string): boolean;
begin
  Result := False;
  if not ValueExists(Name) then
    exit;
  Result := ReadInteger(Name) <> 0;
end;

procedure TDarkRegistry.WriteFloat(const Name: string; Value: double);
begin
  PutData(Name, @Value, SizeOf(double), rdBinary);
end;

function TDarkRegistry.ReadFloat(const Name: string): double;
var
  Len:     integer;
  RegData: TRegDataType;
begin
  Result := -1;
  if not valueexists(Name) then
    exit;
  Len := GetData(Name, @Result, SizeOf(double), RegData);
end;

procedure TDarkRegistry.WriteCurrency(const Name: string; Value: currency);
begin
  PutData(Name, @Value, SizeOf(currency), rdBinary);
end;

function TDarkRegistry.ReadCurrency(const Name: string): currency;
var
  RegData: TRegDataType;
  Len:     DWord;
begin
  Result := -1;
  if not ValueExists(Name) then
    exit;
  GetData(Name, @Result, SizeOf(currency), RegData);
  if (RegData <> rdBinary) or (Len <> SizeOf(currency)) then
    Result := 0;
end;

procedure TDarkRegistry.WriteDateTime(const Name: string; Value: TDateTime);
begin
  PutData(Name, @Value, SizeOf(TDateTime), rdBinary);
end;

function TDarkRegistry.ReadDateTime(const Name: string): TDateTime;
var
  RegData: TRegDataType;
begin
  Result := 0;
  if not ValueExists(Name) then
    exit;
  GetData(Name, @Result, SizeOf(TDateTime), RegData);
end;

procedure TDarkRegistry.WriteDate(const Name: string; Value: TDateTime);
begin
  WriteDateTime(Name, Value);
end;

function TDarkRegistry.ReadDate(const Name: string): TDateTime;
begin
  Result := 0;
  if not ValueExists(Name) then
    exit;
  Result := ReadDateTime(Name);
end;

procedure TDarkRegistry.WriteTime(const Name: string; Value: TDateTime);
begin
  WriteDateTime(Name, Value);
end;

function TDarkRegistry.ReadTime(const Name: string): TDateTime;
begin
  Result := 0;
  if not ValueExists(Name) then
    exit;
  Result := ReadDateTime(Name);
end;

procedure TDarkRegistry.WriteBinaryData(const Name: string; var Buffer;
  BufSize: integer);
begin
  PutData(Name, @Buffer, BufSize, rdBinary);
end;

function TDarkRegistry.ReadBinaryData(const Name: string; var Buffer;
  BufSize: integer): integer;
var
  RegData: TRegDataType;
  Info:    TRegDataInfo;
begin
  FillChar(Buffer, BufSize, #0);
  if not valueexists(Name) then
    exit;
  if GetDataInfo(Name, Info) then
  begin
    Result  := Info.DataSize;
    RegData := Info.RegData;
    if ((RegData = rdBinary) or (RegData = rdUnknown)) and (Result <= BufSize) then
      GetData(Name, @Buffer, Result, RegData);
  end
  else
    Result := 0;
end;

procedure TDarkRegistry.PutData(const Name: string; Buffer: Pointer;
  BufSize: integer; RegData: TRegDataType);
var
  DataType: integer;
begin
  if valueexists(Name) then
    if (Name <> '') then
      if not DeleteValue(Name) then
        exit;
  DataType := RegDataToDataType(RegData);
  RegSetValueEx(CurrentKey, PChar(Name), 0, DataType, Buffer, BufSize);
end;

function TDarkRegistry.GetData(const Name: string; Buffer: Pointer;
  BufSize: integer; var RegData: TRegDataType): integer;
var
  DataType: integer;
begin
{  if not valueexists(Name) then begin FillChar(Buffer^,BufSize,0);
  Exit;
  end;}
  DataType := REG_NONE;
  RegQueryValueEx(CurrentKey, PChar(Name), nil, @DataType, PByte(Buffer), @BufSize);
  Result  := BufSize;
  RegData := DataTypeToRegData(DataType);
end;

function TDarkRegistry.HasSubKeys: boolean;
var
  Info: TRegKeyInfo;
begin
  Result := GetKeyInfo(Info) and (Info.NumSubKeys > 0);
end;

function TDarkRegistry.ValueExists(const Name: string): boolean;
var
  Info: TRegDataInfo;
begin
  Result := GetDataInfo(Name, Info);
end;

function TDarkRegistry.GetKey(const Key: string): HKEY;
var
  S: string;
  Relative: boolean;
begin
  S := Key;
  Relative := IsRelative(S);
  if not Relative then
    Delete(S, 1, 1);
  Result := 0;
  RegOpenKeyEx(GetBaseKey(Relative), PChar(S), 0, FAccess, Result);
end;


function TDarkRegistry.KeyExists(const Key: string): boolean;
var
  TempKey:   HKEY;
  OldAccess: longword;
begin
  OldAccess := FAccess;
  try
    FAccess := STANDARD_RIGHTS_READ or KEY_QUERY_VALUE or KEY_ENUMERATE_SUB_KEYS;
    TempKey := GetKey(Key);
    if TempKey <> 0 then
      RegCloseKey(TempKey);
    Result := TempKey <> 0;
  finally
    FAccess := OldAccess;
  end;
end;

end.
