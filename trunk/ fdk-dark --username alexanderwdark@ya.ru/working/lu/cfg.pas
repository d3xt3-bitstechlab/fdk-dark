 // SIMPLY BIG INI FILE (>64 KB, not as Microsoft's)
 // Full source code 2004 by DarkSoft
 // Totally Freeware;

{Простой аналог INI Файла без поддержки секций, без ограничения на 64 КБ}

{$DEFINE ALLOWNIL}
unit Cfg;

interface

uses SysUtils, Classes;

type
  TCFG = class(TObject)
  public
    constructor Create(F: string);
    destructor Free;
    function ReadInteger(Value: string; def: longint): longint;
    procedure WriteInteger(Name: string; Value: longint);
    function ReadBool(Value: string; def: boolean): boolean;
    procedure WriteBool(Name: string; Value: boolean);
    function ReadFloat(Value: string; def: extended): extended;
    procedure WriteFloat(Name: string; Value: extended);
    function ReadDateTime(Value: string; def: TDateTime): TDateTime;
    procedure WriteDateTime(Name: string; Value: TDateTime);
    function ReadDate(Value: string; def: TDateTime): TDateTime;
    procedure WriteDate(Name: string; Value: TDateTime);
    function ReadTime(Value: string; def: TDateTime): TDateTime;
    procedure WriteTime(Name: string; Value: TDateTime);
    function ReadString(Value: string; def: string): string;
    procedure WriteString(Name, Value: string);
  protected
    Items:    TStringList;
    FileName: string;
    function ReadValue(Name: string): string;
    procedure WriteValue(Name, Value: string);
  end;

implementation

constructor TCFG.Create(F: string);
begin
  FileName := F;
  Items    := TStringList.Create;
  Items.Sorted := False;
  Items.CaseSensitive := False;
  Items.Clear;
  if FileExists(FileName) then
  begin
    Items.LoadFromFile(FileName);
  end
  else
  begin
    Items.SaveToFile(FileName);
  end;
end;

destructor TCFG.Free;
begin
  if Items.Count > 0 then
  begin
    Items.Sort;
  end;
  Items.SaveToFile(FileName);
  FreeAndNil(Items);
end;

function TCfg.readvalue(Name: string): string;
begin
  Result := Items.Values[Name];
{$IFDEF ALLOWNIL}
  if Result = '/nil' then
  begin
    Result := '';
  end;
{$ENDIF}
end;


procedure TCfg.writevalue(Name, Value: string);
begin
{$IFDEF ALLOWNIL}
  if Value = '' then
  begin
    Value := '/nil';
  end;
{$ENDIF}
  if Items.IndexOfName(Name) <> -1 then
  begin
    Items.values[Name] := Value;
  end
  else
  begin
    Items.Add(Format('%s=%s', [Name, Value]));
  end;
end;

function TCFG.ReadInteger(Value: string; def: longint): longint;
begin
  Result := StrToIntDef(readvalue(Value), def);
end;

procedure TCFG.WriteInteger(Name: string; Value: longint);
begin
  writevalue(Name, IntToStr(Value));
end;

function TCFG.ReadBool(Value: string; def: boolean): boolean;
begin
  Result := boolean(StrToIntDef(ReadValue(Value), Ord(Def)));
end;

procedure TCFG.WriteBool(Name: string; Value: boolean);
begin
  WriteValue(Name, IntToStr(Ord(Value)));
end;

function TCFG.ReadFloat(Value: string; def: extended): extended;
begin
  Result := StrToFloatDef(ReadValue(Value), def);
end;

procedure TCFG.WriteFloat(Name: string; Value: extended);
begin
  WriteValue(Name, FloatToStr(Value));
end;

function TCFG.ReadString(Value: string; def: string): string;
begin
  if Items.IndexOfName(Value) <> -1 then
  begin
    Result := ReadValue(Value);
  end
  else
  begin
    Result := Def;
  end;
end;

procedure TCFG.WriteString(Name, Value: string);
begin
  WriteValue(Name, Value);
end;

function TCFG.ReadDateTime(Value: string; def: TDateTime): TDateTime;
begin
  Result := StrToDateTimeDef(ReadValue(Value), def);
end;

procedure TCFG.WriteDateTime(Name: string; Value: TDateTime);
begin
  WriteValue(Name, DateTimeToStr(Value));
end;

function TCFG.ReadDate(Value: string; def: TDateTime): TDateTime;
begin
  Result := StrToDateDef(ReadValue(Value), def);
end;

procedure TCFG.WriteDate(Name: string; Value: TDateTime);
begin
  WriteValue(Name, DateToStr(Value));
end;

function TCFG.ReadTime(Value: string; def: TDateTime): TDateTime;
begin
  Result := StrToTimeDef(ReadValue(Value), def);
end;

procedure TCFG.WriteTime(Name: string; Value: TDateTime);
begin
  WriteValue(Name, TimeToStr(Value));
end;


end.
