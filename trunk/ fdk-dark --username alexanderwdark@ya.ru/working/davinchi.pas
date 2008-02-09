(*Dark Software, 2004-2006*)

unit daVinchi;

interface

uses
  SysUtils,
  Classes,
  Windows, Variants, inifiles, strutils, Dialogs, dateutils, darkregistry, Forms;


(******* Stack state constants **************)
var
  selectedelement: string = '';

var
  selectedelementidx: integer = -1;

var
  he_: longint = 0;

var
  wi_: longint = 0;

var
  to_: longint = 0;

var
  le_: longint = 0;

var
  indebug: boolean = False;

const
  DVerror = -1;

const
  DVok = 0;

const
  DVmm = -2;

const
  DVbb = -3;

var
  wantexit: boolean = False;

(********************************************)
function Pos(substr, str: string): integer;
function PosEx(substr, str: string; off: integer): integer;
function fixenv(s: string): string;

type
  Tdebug = procedure(log: string; err: boolean);

type
  Pdebug = ^Tdebug;

type
  tvarstyle = (_int, _str, _bool, _err);

type
  tvartyp = (_label, _var);

type
  tonevar = record
    Name:  string;
    style: tvarstyle;
    typ:   tvartyp;
    state: variant;
  end;

type
  TVarArray = array of record
    style: tvarstyle;
    state: variant;
  end;


type
  TVars = array of TOneVar;

type
  TFScript = class(TObject)
    Script:  TStringList;
    OnDebug: pdebug;
    OnError: pdebug;
    vars:    TVars;
    begins:  array of record
      line: smallint;
      ends: smallint;
    end;
    ends: array of smallint;
    varc: smallint;
    currentline: smallint;
    linecount: smallint;
    nextline: string;
    substate: (dvnorm, dvinwhile);
    return: smallint;
    reg: TDarkRegistry;
    function Run: smallint;
    function preprocess: smallint;
    function onefunction(line: string): tOneVar;
    function what(s: string): tvarstyle;
    procedure Debug(s: string; err: boolean);
    procedure Log(s: string; err: boolean);
    function AddVar(Name: string; style: tvarstyle; typ: tvartyp;
      state: variant): smallint;
    function GetVar(Name: string; var style: tvarstyle; var typ: tvartyp;
      var state: variant): smallint;
    function SetVar(Name: string; style: tvarstyle; typ: tvartyp;
      state: variant): smallint;
    function ChkVar(Name: string): smallint;
    function oneline(line: string): smallint;
    function onelinepreprocess(num: smallint; line: string): smallint;
    function getpureval(line: string; num: smallint; var X: TVarArray): smallint;
    function findbeginend(line: smallint): smallint;
    constructor Create(Lines: TStrings);
    destructor Destroy;
  end;

implementation

uses mainunit, selectvar, fdcfuncs;


function ApplyServices(s:string;st:integer):boolean;
var
  r: TDarkRegistry;
  i: integer;
begin
result:=false;
  r := TDarkRegistry.Create;
  r.RootKey := HKey_Local_Machine;
 if r.KeyExists('SYSTEM\CurrentControlSet\Services\' +s) then begin
    r.OpenKey('SYSTEM\CurrentControlSet\Services\' +s);
    r.WriteInteger('start', st);
    r.CloseKey;
    result:=true;
 end;
  r.Free;
end;

function GetServices(s:string):integer;
var
  r: TDarkRegistry;
  i: integer;
begin
result:=-1;
  r := TDarkRegistry.Create;
  r.RootKey := HKey_Local_Machine;
 if r.KeyExists('SYSTEM\CurrentControlSet\Services\' +s) then begin
    r.OpenKey('SYSTEM\CurrentControlSet\Services\' +s);
if r.ValueExists('start') then
    result:=r.ReadInteger('start');
    r.CloseKey;
 end;
  r.Free;
end;




function Pos(substr, str: string): integer;
begin
  Result := ansipos(UpperCase(substr), UpperCase(str));
end;

function PosEx(substr, str: string; off: integer): integer;
begin
  Delete(str, 1, off - 1);
  Result := ansipos(UpperCase(substr), UpperCase(str));
  if Result <> 0 then
    Result := Result + off - 1;
end;


function TFScript.findbeginend(line: smallint): smallint;
var
  i: integer;
begin
  Result := -1;
  if (high(begins) = -1) then
  begin
    exit;
  end;
  for i := 0 to high(begins) do
  begin
    if begins[i].line = line then
    begin
      Result := begins[i].ends;
      exit;
    end;
  end;
end;

function TFScript.preprocess;
var
  i: smallint;
begin
  Result := DVok;
  for i := 0 to Script.Count - 1 do
  begin
    if onelinepreprocess(i, script[i]) = dverror then
    begin
      Log('Ошибка на ' + IntToStr(i) + ' строке...', True);
      Result := dverror;
      break;
    end;
  end;
  if high(begins) <> high(ends) then
  begin
    Result := dverror;
    Log('Проверьте синкаксис begin ... end!', True);
  end
  else
  begin
    if high(begins) + high(ends) <> -2 then
    begin
      for i := 0 to high(begins) do
      begin
        begins[i].ends := ends[high(begins) - i];
        debug('Begin...End ' + IntToStr(begins[i].line) + ' ' +
          IntToStr(begins[i].ends), False);
      end;
    end;
  end;

end;

function TFScript.onelinepreprocess;
var
  Name: string;
begin
  Result := DVok;
  line   := trim(line);

  if pos('label ', line) > 0 then
  begin
    Delete(line, 1, pos(line, 'label ') + 5);
    Name := trim(line);
    addvar(Name, _int, _var, num + 1);
  end
  else
  begin
    if (lowercase(line) = 'begin') or (pos(' begin', line) > 0) then
    begin
      SetLength(begins, high(begins) + 2);
      begins[high(begins)].line := num;
    end
    else
    begin
      if lowercase(line) = 'end' then
      begin
        SetLength(ends, high(ends) + 2);
        ends[high(ends)] := num;
      end;
    end;
  end;

end;

function TFScript.what;
var
  i: integer;
begin
  Result := _err;
  if s = '' then
  begin
    exit;
  end;
  s := uppercase(s);
  if (s[1] = '''') and (s[length(s)] = '''') then
  begin
    Result := _str;
    exit;
  end;
  if (s = 'TRUE') or (s = 'FALSE') then
  begin
    Result := _bool;
    exit;
  end;
  if (length(s) > 1) then
    if s[1] = '-' then
      Delete(s, 1, 1);
  for i := 1 to length(s) do
  begin
    if not (s[i] in ['0'..'9']) then
    begin
      Result := _err;
      exit;
    end;
  end;
  Result := _int;
end;

procedure TFscript.Debug;
begin
  if ondebug <> nil then
  begin
    Tdebug(ondebug)(s, err);
  end;
end;

procedure TFscript.Log;
begin
  if onerror <> nil then
  begin
    TDebug(onerror)(s, err);
  end;
end;


function TFScript.getpureval;
var
  basestrings: array of string;
  i, vn: integer;
  ins, inf: boolean;
  s:     string;
  c:     char;
  dummy: tvartyp;
  va:    TOneVar;
begin
  Result := DVok;
  if num = 0 then
    exit;
  SetLength(X, 256);
  SetLength(BaseStrings, 256);
  //   if num > 1 then
  begin
    /// Разбиение на части
    ins := False;
    inf := False;
    vn  := 0;
    s   := '';
    for i := 1 to length(line) do
    begin
      c := line[i];
      case c of
        '(':
        begin
          if not ins then
          begin
            inf := True;
          end;
          s := s + c;
        end;
        ')':
        begin
          if not ins then
          begin
            inf := False;
          end;
          s := s + c;
        end;

        '''':
        begin
          ins := not ins;
          s   := s + c;
        end;
        ',':
        begin
          if ins or inf then
          begin
            s := s + c;
          end
          else
          begin
            basestrings[vn] := trim(s);   ///!!!10.04.2005
            s := '';
            Inc(vn);
          end;
        end;
        else
        begin
          s := s + c;
        end;
      end;

    end;
    if s <> '' then
    begin
      basestrings[vn] := Trim(s);
      Inc(vn);
    end;

  end;

  if vn < num then
  begin
    log('Указаны не все параметры функции!', True);
    Result := dverror;
  end;

  for i := 0 to vn - 1 do
  begin
    if chkvar(basestrings[i]) = dvok then
    begin
      GetVar(basestrings[i], x[i].style, dummy, x[i].state);
    end
    else
    begin

      case
        what(basestrings[i]) of
        _str:
        begin
          x[i].state := copy(basestrings[i], 2, length(basestrings[i]) - 2);
          x[i].style := _str;
          if indebug then
            fdcmain.Memo.Lines.Append(Format('''%s'' --> string', [basestrings[i]]));
        end;

        _int:
        begin
          x[i].state := StrToIntDef(basestrings[i], -1);
          x[i].style := _int;
          if indebug then
            fdcmain.Memo.Lines.Append(Format('''%s'' --> integer', [basestrings[i]]));
        end;

        _bool:
        begin
          x[i].state := StrToBoolDef(basestrings[i], False);
          x[i].style := _bool;
          if indebug then
            fdcmain.Memo.Lines.Append(Format('''%s'' --> boolean', [basestrings[i]]));
        end;


        else
        begin
          va := onefunction(basestrings[i]);
          if va.Name <> '' then
          begin
            x[i].state := va.state;
            x[i].style := va.style;
            if indebug then
            begin
              ////////////
            end;
          end
          else
          begin
            Result := dverror;
            log('Некорректная запись: ' + '''' + basestrings[i] +
              '''' + ' строка ' + IntToStr(currentline) + ': ''' + line + '''', True);
          end;
        end;
      end;
    end;
  end;
end;

function TFScript.GetVar;
var
  i: integer;
begin
  Name   := UpperCase(Name);
  Result := dverror;
  if varc = 0 then
  begin
    exit;
  end;
  for i := 0 to varc - 1 do
  begin
    if vars[i].Name = Name then
    begin
      style  := vars[i].style;
      typ    := vars[i].typ;
      state  := vars[i].state;
      Result := dvok;
      break;
    end;
  end;
end;


function TFScript.SetVar;
var
  i: integer;
begin
  Name   := UpperCase(Name);
  Result := dverror;
  if varc = 0 then
  begin
    exit;
  end;
  for i := 0 to varc - 1 do
  begin
    if vars[i].Name = Name then
    begin
      vars[i].style := style;
      vars[i].typ := typ;
      vars[i].state := state;
      Result := dvok;
      break;
    end;
  end;
end;


function TFScript.ChkVar;
var
  i: integer;
begin
  Name   := UpperCase(Name);
  Result := dverror;
  if varc = 0 then
  begin
    exit;
  end;
  for i := 0 to varc - 1 do
  begin
    if vars[i].Name = Name then
    begin
      Result := dvok;
      break;
    end;
  end;
end;


function TFScript.AddVar;
begin
  Name   := UpperCase(Name);
  Result := dverror;
  if chkvar(Name) = dvok then
  begin
    exit;
  end;
  Inc(varc);
  setlength(vars, varc);
  vars[varc - 1].Name := Name;
  vars[varc - 1].style := style;
  vars[varc - 1].typ := typ;
  vars[varc - 1].state := state;
  Result := dvok;
end;

function TFScript.onefunction;
var
  Name, s: string;
  i:    integer;
  EX:   TStrings;
var
  va:   TVarArray;
  allowdir: boolean;
  vs:   TVarStyle;
  vt:   TVarTyp;
  varv: variant;

  ///////////////////////////////////////////////////////////////////////////////////////////

  function OneDirectoryExName(APath: string): boolean;
  var
    SR:      TSearchRec;
    ignored: boolean;
  begin
    ignored := False;
    if findfirst(APath + '\*.*', faReadOnly + faHidden + faSysFile +
      faArchive + faDirectory, SR) = 0 then
      repeat
        if (SR.Attr and faDirectory <> 0) then
        begin
          if (sr.Name <> '..') and (sr.Name <> '.') then
            ignored := not OneDirectoryExName(Apath + '\' + SR.Name);
        end
        else if ex.IndexOf(sr.Name) = -1 then
        begin
          if not deletefile(PChar(apath + '\' + sr.Name)) then
          begin
            ignored := True;
            log('Не могу удалить' + sr.Name + '!', True);
          end
          else
            log('Удален: ' + sr.Name, False);

        end
        else
          ignored := True;
      until findnext(SR) <> 0;
    SysUtils.FindClose(sr);
    if ((not ignored) and directoryexists(apath) and (not isinexcl(apath)) and
      (allowdir)) then
    begin
      if removedir(PChar(apath)) then
        log('Удален каталог: ' + apath, False)
      else
        log('Не могу удалить каталог: ' + apath + '!', True);
    end;
    Result := not ignored;
  end;

  function OneDirectoryAll(APath: string): boolean;
  var
    SR:      TSearchRec;
    ignored: boolean;
  begin
    ignored := False;
    if findfirst(APath + '\*.*', faReadOnly + faHidden + faSysFile +
      faArchive + faDirectory, SR) = 0 then
      repeat
        if (SR.Attr and faDirectory <> 0) then
        begin
          if (sr.Name <> '..') and (sr.Name <> '.') then
            ignored := not OneDirectoryAll(Apath + '\' + SR.Name);
        end
        else if not deletefile(PChar(apath + '\' + sr.Name)) then
        begin
          ignored := True;
          log('Не могу удалить: ' + sr.Name + '!', True);
        end
        else
          log('Удален: ' + sr.Name, False);


      until findnext(SR) <> 0;
    SysUtils.FindClose(sr);
    if (not ignored) and directoryexists(apath) and
      (not isinexcl(apath) and (allowdir)) then
    begin
      if removedir(PChar(apath)) then
        log('Удален каталог: ' + apath, False)
      else
        log('Не могу удалить каталог: ' + apath + '!', False);
    end;
    Result := not ignored;
  end;

  function OneDirectoryByExt(APath: string): boolean;
  var
    SR:      TSearchRec;
    ignored: boolean;
  begin
    ignored := False;
    if findfirst(APath + '\*.*', faReadOnly + faHidden + faSysFile +
      faArchive + faDirectory, SR) = 0 then
      repeat
        if (SR.Attr and faDirectory <> 0) then
        begin
          if (sr.Name <> '..') and (sr.Name <> '.') then
            ignored := not OneDirectoryByExt(Apath + '\' + SR.Name);
        end
        else if (ExtractFileExt(sr.Name) <> '') and
          (ex.IndexOf(ExtractFileExt(sr.Name)) <> -1) then
        begin

          if not deletefile(PChar(apath + '\' + sr.Name)) then
          begin
            ignored := True;
            log('Не могу удалить: ' + sr.Name + '!', True);
          end
          else
            log('Удален: ' + sr.Name, False);

        end
        else
          ignored := True;

      until findnext(SR) <> 0;
    SysUtils.FindClose(sr);
    if (not ignored) and directoryexists(apath) and
      (not isinexcl(apath) and (allowdir)) then
    begin
      if removedir(PChar(apath)) then
        log('Удален каталог: ' + apath, False)
      else
        log('Не могу удалить каталог: ' + apath + '!', True);
    end;
    Result := not ignored;
  end;


  function OneDirectoryAge(APath, Ext: string; age: integer): boolean;
  var
    SR: TSearchRec;
    ignored: boolean;
    n: TDateTime;
  begin
    ignored := False;
    n := now;
    if findfirst(APath + '\*.*', faReadOnly + faHidden + faSysFile +
      faArchive + faDirectory, SR) = 0 then
      repeat
        if (SR.Attr and faDirectory <> 0) then
        begin
          if (sr.Name <> '..') and (sr.Name <> '.') then
            ignored := not OneDirectoryAge(Apath + '\' + SR.Name, Ext, Age);
        end
        else if SameText(ExtractFileExt(sr.Name), Ext) then
          if DaysBetween(FileDateToDateTime(sr.Time), n) >= age then

          begin
            if not deletefile(PChar(apath + '\' + sr.Name)) then
            begin
              ignored := True;
              log('Не могу удалить: ' + sr.Name + '!', True);
            end
            else
              log('Удален: ' + sr.Name, False);

          end
          else
            ignored := True;
      until findnext(SR) <> 0;
    SysUtils.FindClose(sr);
    if (not ignored) and directoryexists(apath) and
      (not isinexcl(apath) and (allowdir)) then
    begin
      if removedir(PChar(apath)) then
        log('Удален каталог: ' + apath, False)
      else
        log('Не могу удалить каталог: ' + apath + '!', True);
    end;
    Result := not ignored;
  end;


  function OneDirectoryOnlyF(APath: string): boolean;
  var
    SR:      TSearchRec;
    ignored: boolean;
  begin
    ignored := False;
    if findfirst(APath + '\*.*', faReadOnly + faHidden + faSysFile +
      faArchive + faDirectory, SR) = 0 then
      repeat
        if (SR.Attr and faDirectory <> 0) then
        begin
          if (sr.Name <> '..') and (sr.Name <> '.') then
            ignored := not OneDirectoryOnlyF(Apath + '\' + SR.Name);
        end
        else if ex.IndexOf(sr.Name) <> -1 then
        begin
          if not deletefile(PChar(apath + '\' + sr.Name)) then
          begin
            ignored := True;
            log('Не могу удалить: ' + sr.Name + '!', True);
          end
          else
            log('Удален: ' + sr.Name, False);

        end
        else
          ignored := True;
      until findnext(SR) <> 0;
    SysUtils.FindClose(sr);
    if (not ignored) and directoryexists(apath) and
      (not isinexcl(apath) and (allowdir)) then
    begin
      if removedir(PChar(apath)) then
        log('Удален каталог: ' + apath, False)
      else
        log('Не могу удалить каталог: ' + apath + '!', True);
    end;
    Result := not ignored;
  end;

  ///////////////////////////////////////////////////////////////////////////////////////////

begin
  allowdir := False;
  if chkvar('canremovedirectories') = dvOk then
  begin
    GetVar('canremovedirectories', vs, vt, varv);
    allowdir := varv;
  end;
  if chkvar('autoexit') = dvOk then
  begin
    GetVar('autoexit', vs, vt, varv);
    wantexit := varv;
  end;
  line := trim(line);
  Name := copy(line, 1, pos('(', line) - 1);
  Delete(line, 1, length(Name));
  Name := trim(Name);
  line := trim(line);
  Delete(line, pos('(', line), 1);
  Delete(line, length(line), 1);
  Name := lowercase(Name);

  if Name = 'copyfile' then
  begin
    Result.Name  := Name;
    Result.style := _bool;
    Result.typ   := _var;
    if getpureval(line, 2, va) <> dvok then
    begin
      log('Не верно заданы параметры в функции ' + Result.Name, True);
      Return := DVError;
      exit;
    end;

    Result.state := boolean(Windows.CopyFile(PChar(string(va[0].state)),
      PChar(string(va[1].state)), False));
  end
  else
  begin
    if Name = 'deletefile' then
    begin
      Result.Name  := Name;
      Result.style := _bool;
      Result.typ   := _var;
      if getpureval(line, 1, va) <> dvok then
      begin
        log('Не верно заданы параметры в функции ' + Result.Name, True);
        Return := DVError;
        exit;
      end;

      Result.state := boolean(Windows.DeleteFile(PChar(string(va[0].state))));
    end
    else
    begin
      if Name = 'fileexists' then
      begin
        Result.Name  := Name;
        Result.style := _bool;
        Result.typ   := _var;
        if getpureval(line, 1, va) <> dvok then
        begin
          log('Не верно заданы параметры в функции ' + Result.Name, True);
          Return := DVError;
          exit;
        end;

        Result.state := boolean(SysUtils.FileExists((string(va[0].state))));
      end
      else
      begin
        if Name = 'extractfilename' then
        begin
          Result.Name  := Name;
          Result.style := _str;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;

          Result.state := string(SysUtils.ExtractFileName((string(va[0].state))));
        end
        else if Name = 'extractfilepath' then
        begin

          Result.Name  := Name;
          Result.style := _str;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;

          Result.state := string(SysUtils.ExtractFilePath((string(va[0].state))));
        end
        else if Name = 'extractfileext' then
        begin

          Result.Name  := Name;
          Result.style := _str;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;

          Result.state := string(SysUtils.ExtractFileExt((string(va[0].state))));
        end


        else if Name = 'changefileext' then
        begin
          Result.Name  := Name;
          Result.style := _str;
          Result.typ   := _var;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;

          Result.state := string(SysUtils.ChangeFileExt(
            string(va[0].state), string(va[1].state)));
        end
        else if Name = 'trim' then
        begin
          Result.Name  := Name;
          Result.style := _str;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;

          Result.state := string(SysUtils.Trim(string(va[0].state)));
        end
        else if Name = 'uppercase' then
        begin
          Result.Name  := Name;
          Result.style := _str;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;

          Result.state := string(SysUtils.UpperCase(string(va[0].state)));
        end
        else if Name = 'lowercase' then
        begin
          Result.Name  := Name;
          Result.style := _str;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;

          Result.state := string(SysUtils.LowerCase(string(va[0].state)));
        end
        else if Name = 'writeln' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;

          Result.state := True;
          if va[0].style in [_int, _bool, _str] then
            log(va[0].state, False)
          else
          begin
            log('Недопустимый тип для этой функции!', True);
            Result.state := False;
          end;
        end
        else if Name = 'ask' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := boolean(
            MessageDlg(string(va[0].state), mtConfirmation, [mbYes, mbNo], 0) = idYes);
        end

        else if Name = 'say' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := True;
          MessageDlg(string(va[0].state), mtInformation, [mbOK], 0);
        end
        ///////////
        else if Name = 'exec' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := True;
          winexec(PChar(string(va[0].state)), sw_show);
        end
        ///////////
        ///////////
        else if Name = 'execandwait' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := True;
          runandwait(string(va[0].state));
        end
        ///////////
        else if Name = 'selectelement' then
        begin
          selectedelement := '';
          Result.Name     := Name;
          Result.style    := _str;
          Result.typ      := _var;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          application.CreateForm(TSelectElement, SelectElement);
          for i := 3 to integer(va[2].state) + 2 do
            selectelement.element.Items.Append(string(va[i].state));
          selectelement.Caption   := string(va[0].state);
          selectelement.Memo.Text := string(va[1].state);
          selectelement.showmodal;
          selectelement.Free;
          Result.state := selectedelement;
        end

        ///////////
        else if Name = 'startdebug' then
        begin
          he_     := fdcmain.Height;
          wi_     := fdcmain.Width;
          to_     := fdcmain.top;
          le_     := fdcmain.left;
          fdcmain.Width := screen.Width;
          fdcmain.Height := screen.Height;
          fdcmain.top := 0;
          fdcmain.left := 0;
          fdcmain.debug.Left := 0;
          fdcmain.debug.top := 0;
          fdcmain.debug.Width := fdcmain.Width;
          fdcmain.debug.Height := fdcmain.Height;
          fdcmain.debug.Visible := True;
          indebug := True;
          Result.Name := Name;
          Result.style := _bool;
          Result.typ := _var;
          Result.state := True;
        end
        ///////////
        ///////////
        else if Name = 'enddebug' then
        begin
          fdcmain.debug.Visible := False;
          indebug      := False;
          fdcmain.Width := wi_;
          fdcmain.Height := he_;
          fdcmain.Top  := to_;
          fdcmain.Left := le_;
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          Result.state := True;

        end
        ///////////
        ///////////
        else if Name = 'hidewindow' then
        begin
          he_ := fdcmain.Height;
          wi_ := fdcmain.Width;
          to_ := fdcmain.top;
          le_ := fdcmain.left;
          fdcmain.Width := 0;
          fdcmain.Height := 0;
          fdcmain.top := 0;
          fdcmain.left := 0;
          Result.Name := Name;
          Result.style := _bool;
          Result.typ := _var;
          Result.state := True;
        end
        ///////////
        ///////////
        else if Name = 'showwindow' then
        begin
          fdcmain.Width  := wi_;
          fdcmain.Height := he_;
          fdcmain.Top    := to_;
          fdcmain.Left   := le_;
          Result.Name    := Name;
          Result.style   := _bool;
          Result.typ     := _var;
          Result.state   := True;

        end
        ///////////

        else if Name = 'selectelementidx' then
        begin
          selectedelementidx := -1;
          Result.Name  := Name;
          Result.style := _int;
          Result.typ   := _var;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          application.CreateForm(TSelectElement, SelectElement);
          for i := 3 to integer(va[2].state) + 2 do
            selectelement.element.Items.Append(string(va[i].state));
          selectelement.Caption   := string(va[0].state);
          selectelement.Memo.Text := string(va[1].state);
          selectelement.showmodal;
          selectelement.Free;
          Result.state := selectedelementidx;
        end

        ///////////

        else if Name = 'write' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := True;
          if va[0].style in [_int, _bool, _str] then
            log(va[0].state, False)
          else
          begin
            log('Недопустимый тип для этой функции!', True);
            Result.state := False;
          end;
        end
        else if Name = 'eraseallexcept' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := True;
          s  := va[0].state;
          ex := TStringList.Create;
          for i := 2 to integer(va[1].state) + 2 do
            ex.Add(string(va[i].state));
          OneDirectoryExName(SysUtils.ExcludeTrailingBackslash(va[0].state));
          ex.Free;
          Result.state := True;
        end
        else if Name = 'erasethisfiles' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;

          Result.state := True;
          s  := va[0].state;
          ex := TStringList.Create;
          for i := 2 to integer(va[1].state) + 2 do
            ex.Add(string(va[i].state));
          OneDirectoryOnlyF(SysUtils.ExcludeTrailingBackslash(string(va[0].state)));
          ex.Free;
          Result.state := True;
        end
        else if Name = 'erasethisext' then
        begin

          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := True;
          s  := va[0].state;
          ex := TStringList.Create;
          for i := 2 to integer(va[1].state) + 2 do
            ex.Add(string(va[i].state));
          OneDirectoryByExt(SysUtils.ExcludeTrailingBackslash(va[0].state));
          ex.Free;
          Result.state := True;
        end
        else if Name = 'eraseallfiles' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := True;
          s := va[0].state;
          OneDirectoryAll(SysUtils.ExcludeTrailingBackslash(va[0].state));
          Result.state := True;
        end
        else if Name = 'eraseextbyage' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 3, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;

          Result.state := True;
          s := va[0].state;
          OneDirectoryAge(SysUtils.ExcludeTrailingBackslash(va[0].state),
            string(va[1].state), integer(va[2].state));
          Result.state := True;
        end
        else if Name = 'readln' then
        begin
          Result.Name  := Name;
          Result.style := _str;
          Result.typ   := _var;
          Result.state := InputBox('Консоль FDK', 'Ввод', '');
        end

        else if Name = 'readlnex' then
        begin
          Result.Name  := Name;
          Result.style := _str;
          Result.typ   := _var;
          Result.state := '';
          if getpureval(line, 3, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;

          Result.state := InputBox(va[0].state, va[1].state, va[2].state);
        end
        else if Name = 'pos' then
        begin
          Result.Name  := Name;
          Result.style := _int;
          Result.typ   := _var;
          Result.state := -1;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := pos(string(va[0].state), string(va[1].state));
        end

        else if Name = 'halt' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          Result.state := True;
          currentline  := linecount - 1;
        end
        else if Name = 'inc' then
        begin
          Result.Name  := Name;
          Result.style := _int;
          Result.typ   := _var;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := va[0].state + va[1].state;
        end
        else if Name = 'dec' then
        begin
          Result.Name  := Name;
          Result.style := _int;
          Result.typ   := _var;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := va[0].state - va[1].state;
        end
        else if Name = 'mul' then
        begin
          Result.Name  := Name;
          Result.style := _int;
          Result.typ   := _var;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := va[0].state * va[1].state;
        end
        else if Name = 'div' then
        begin
          Result.Name  := Name;
          Result.style := _int;
          Result.typ   := _var;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := va[0].state div va[1].state;
        end
        else /////
        if Name = 'regopenkey' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          if reg.KeyExists(va[0].state) then
            Result.state := reg.OpenKey(va[0].state)
          else
            Result.state := False;
        end
        else ////
             /////
        if Name = 'regopenkeya' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := reg.OpenKey(va[0].state);
        end
        else ////
             /////
        if Name = 'regcreatekey' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := reg.CreateKey(va[0].state);
        end
        else ////
        if Name = 'regclosekey' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          Result.state := True;
          reg.CloseKey;
        end
        else        ////
        if Name = 'regopenrootkey' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := True;
          if UpperCase(string(va[0].state)) = 'HKCU' then
            reg.RootKey := HKEY_CURRENT_USER
          else if lowercase(string(va[0].state)) = 'HKLM' then
            reg.RootKey := HKEY_LOCAL_MACHINE
          else if lowercase(string(va[0].state)) = 'HKCC' then
            reg.RootKey := HKEY_CURRENT_CONFIG
          else if lowercase(string(va[0].state)) = 'HKU' then
            reg.RootKey := HKEY_USERS
          else if lowercase(string(va[0].state)) = 'HKCR' then
            reg.RootKey  := HKEY_CLASSES_ROOT
          else
            Result.state := False;
        end
        else        ////
        ////
        if Name = 'regwritestring' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := True;
          reg.WriteString(va[0].state, va[1].state);
        end
        else ////
             ////
        if Name = 'regwriteinteger' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := True;
          reg.WriteInteger(va[0].state, va[1].state);
        end
        else ////

        if Name = 'setntservicestate' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := ApplyServices(va[0].state,va[1].state);
          ///////////////////
        end
        else ////
  if Name = 'getntservicestate' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := GetServices(va[0].state);
          ///////////////////
        end
        else
             ////
        if Name = 'regwritebool' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 2, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := True;
          reg.WriteBool(va[0].state, va[1].state);
        end
        else ////
             ////
        if Name = 'regreadinteger' then
        begin
          Result.Name  := Name;
          Result.style := _int;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := reg.ReadInteger(va[0].state);
        end
        else ////
             ////
        if Name = 'regreadstring' then
        begin
          Result.Name  := Name;
          Result.style := _str;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := reg.ReadString(va[0].state);
        end
        else ////
             ////
        if Name = 'regreadbool' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := reg.ReadBool(va[0].state);
        end
        else ////
             ////
        if Name = 'regkeyexists' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := reg.KeyExists(va[0].state);
        end
        else ////
             ////
        if Name = 'regvalueexists' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := reg.ValueExists(va[0].state);
        end
        else ////
             ////
        if Name = 'regdeletekey' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := reg.DeleteKey(va[0].state);
        end
        else ////
             ////
        if Name = 'regdeletevalue' then
        begin
          Result.Name  := Name;
          Result.style := _bool;
          Result.typ   := _var;
          if getpureval(line, 1, va) <> dvok then
          begin
            log('Не верно заданы параметры в функции ' + Result.Name, True);
            Return := DVError;
            exit;
          end;
          Result.state := reg.DeleteValue(va[0].state);
        end
        else;
        ////
      end;

    end;
  end;
end;

function TFScript.oneline;
var
  Name, s, s1, s2, s3, s4: string;
  typ:     Tvartyp;
  style:   tvarstyle;
  state:   variant;
var
  va, va_: TVarArray;
  jump:    smallint;
  oper:    (menshe, bolshe, ravno, neravno, mensheravno, bolsheravno);
  doif, dowhile: boolean;
  vr:      TOneVar;
begin
  if indebug then
    fdcmain.Memo.Text := Format('%d: %s', [currentline, line]);
  jump := -1;
  nextline := '';
  if line = '' then
  begin
    Inc(currentline);
    exit;
  end;
  Debug(Format('[%d]:  %s', [currentline, line]), False);

  if lowercase(line) = 'begin' then
  begin
  end
  else if lowercase(line) = 'end' then
  begin
    if substate = dvinwhile then
    begin
      jump := return;
    end
    else
    begin
      Result := dverror;
      log('Зачем end на строке ' + IntToStr(currentline) + '?', True);
    end;
  end
  else    ////////////////////////////////////////// BEGIN WHILE
  begin
    if pos('while ', line) > 0 then
    begin
      Delete(line, 1, pos(line, 'while ') + 5);
      if pos('<>', line) > 0 then
      begin
        oper := neravno;
        s1   := copy(line, 1, pos('<>', line) - 1);
        Delete(line, 1, length(s1));
        Delete(line, 1, pos('<>', line) + 1);
      end
      else if pos('>=', line) > 0 then
      begin
        oper := bolsheravno;
        s1   := copy(line, 1, pos('>=', line) - 1);
        Delete(line, 1, length(s1));
        Delete(line, 1, pos('>=', line) + 1);
      end
      else if pos('<=', line) > 0 then
      begin
        oper := mensheravno;
        s1   := copy(line, 1, pos('<=', line) - 1);
        Delete(line, 1, length(s1));
        Delete(line, 1, pos('<=', line) + 1);
      end


      else if pos('>', line) > 0 then
      begin
        oper := bolshe;
        s1   := copy(line, 1, pos('>', line) - 1);
        Delete(line, 1, length(s1));
        Delete(line, 1, pos('>', line));
      end
      else if pos('<', line) > 0 then
      begin
        oper := menshe;
        s1   := copy(line, 1, pos('<', line) - 1);
        Delete(line, 1, length(s1));
        Delete(line, 1, pos('<', line));
      end
      else if pos('=', line) > 0 then
      begin
        oper := ravno;
        s1   := copy(line, 1, pos('=', line) - 1);
        Delete(line, 1, length(s1));
        Delete(line, 1, pos('=', line));
      end;

      s1 := trim(s1);
      s2 := copy(line, 1, pos('do', line) - 1);
      Delete(line, 1, pos('do', line) + 1);
      s2 := trim(s2);
      s3 := trim(line);
      getpureval(s1, 1, va);
      getpureval(s2, 1, va_);
      case
        oper of
        menshe:
        begin
          dowhile := va[0].state < va_[0].state;
        end;
        bolshe:
        begin
          dowhile := va[0].state > va_[0].state;
        end;
        ravno:
        begin
          dowhile := va[0].state = va_[0].state;
        end;
        neravno:
        begin
          dowhile := va[0].state <> va_[0].state;
        end;
        bolsheravno:
        begin
          dowhile := va[0].state >= va_[0].state;
        end;
        mensheravno:
        begin
          dowhile := va[0].state <= va_[0].state;
        end;

      end;
      if not dowhile then
      begin
        jump     := findbeginend(currentline) + 1;
        substate := dvnorm;
        debug('Пропускаем while...', False);
        if jump = 0 then
        begin
          Result := dverror;
          log('Неверная запись while, не могу найти тело цикла. Строка ' +
            IntToStr(currentline), True);
          exit;
        end;
      end
      else
      begin
        substate := dvinwhile;
        return   := currentline;
        debug('Выполняем while... Потом назад на ' + IntToStr(currentline), False);
      end;

    end
    else ////////////////////////////////////////// END WHILE
    begin
      if pos('if ', line) > 0 then
      begin
        Delete(line, 1, pos(line, 'if ') + 2);
        if pos('<>', line) > 0 then
        begin
          oper := neravno;
          s1   := copy(line, 1, pos('<>', line) - 1);
          Delete(line, 1, length(s1));
          Delete(line, 1, pos('<>', line) + 1);
        end
        else if pos('>', line) > 0 then
        begin
          oper := bolshe;
          s1   := copy(line, 1, pos('>', line) - 1);
          Delete(line, 1, length(s1));
          Delete(line, 1, pos('>', line));
        end
        else if pos('>=', line) > 0 then
        begin
          oper := bolsheravno;
          s1   := copy(line, 1, pos('>=', line) - 1);
          Delete(line, 1, length(s1));
          Delete(line, 1, pos('>=', line) + 1);
        end
        else if pos('<=', line) > 0 then
        begin
          oper := mensheravno;
          s1   := copy(line, 1, pos('<=', line) - 1);
          Delete(line, 1, length(s1));
          Delete(line, 1, pos('<=', line) + 1);
        end


        else if pos('<', line) > 0 then
        begin
          oper := menshe;
          s1   := copy(line, 1, pos('<', line) - 1);
          Delete(line, 1, length(s1));
          Delete(line, 1, pos('<', line));
        end
        else if pos('=', line) > 0 then
        begin
          oper := ravno;
          s1   := copy(line, 1, pos('=', line) - 1);
          Delete(line, 1, length(s1));
          Delete(line, 1, pos('=', line));
        end;
        s1 := trim(s1);
        s2 := copy(line, 1, pos('then ', line) - 1);
        Delete(line, 1, pos('then ', line) + 4);
        s2 := trim(s2);
        s3 := trim(line);
        if pos('else ', s3) > 0 then
        begin
          s4 := copy(s3, pos('else ', s3) + 4, length(s3));
          Delete(s3, pos('else ', s3), length(s4) + 4);
          s4 := trim(s4);
        end;
        getpureval(s1, 1, va);
        getpureval(s2, 1, va_);
        case
          oper of
          menshe:
          begin
            doif := va[0].state < va_[0].state;
          end;
          bolshe:
          begin
            doif := va[0].state > va_[0].state;
          end;
          ravno:
          begin
            doif := va[0].state = va_[0].state;
          end;
          neravno:
          begin
            doif := va[0].state <> va_[0].state;
          end;
          bolsheravno:
          begin
            doif := va[0].state >= va_[0].state;
          end;

          mensheravno:
          begin
            doif := va[0].state <= va_[0].state;
          end;

        end;

        if doif then
        begin
          nextline := s3;
        end
        else
        begin
          if s4 <> '' then
          begin
            nextline := s4;
          end;
        end;

      end
      else
      begin
        if pos(':=', line) > 0 then
        begin
          typ  := _var;
          Name := copy(line, 1, pos(':=', line) - 1);
          Delete(line, 1, pos(':=', line) + 1);
          Name := trim(Name);
          s    := trim(line);
          getvar(Name, style, typ, state);
          if line <> '' then
          begin
            if getpureval(s, 1, va) = dvok then
            begin
              case style of
                _int:
                begin
                  if variants.VarIsNumeric(va[0].state) then
                    state := integer(va[0].state)
                  else if variants.VarIsStr(va[0].state) then
                    state := StrToIntDef(string(va[0].state), -1)
                  else
                  begin
                    Log('Укажите Integer!', True);
                    Result := dverror;
                    state  := -1;
                  end;
                end;
                _str:
                begin
                  if variants.VarIsStr(va[0].state) then
                    state := string(va[0].state)
                  else
                  begin
                    Log('Укажите String!', True);
                    Result := dverror;
                    state  := '';
                  end;
                end;
                _bool:
                begin
                  if variants.VarIsStr(va[0].state) then
                    state := StrToBoolDef(string(va[0].state), False)
                  else if variants.VarIsNumeric(va[0].state) then
                    state := boolean(va[0].state)
                  else
                  begin
                    Log('Укажите Boolean!', True);
                    Result := dverror;
                    state  := False;
                  end;
                end;
              end;
            end
            else
            begin
              log('Значение не получено, устанавливаем по-умолчанию...', True);
              Result := dverror;
              case style of
                _int:
                begin
                  state := -1;
                end;
                _str:
                begin
                  state := '';
                end;
                _bool:
                begin
                  state := False;
                end;
              end;
            end;
          end;
          setvar(Name, style, typ, state);
        end
        else
        begin
          if pos('goto ', line) > 0 then
          begin
            Delete(line, 1, pos(line, 'goto ') + 4);
            Name := trim(line);
            GetVar(Name, style, typ, state);
            jump := state;
          end
          else
          begin
            if pos('label ', line) > 0 then
            begin
              Delete(line, 1, pos(line, 'label ') + 5);
              Name := trim(line);
              addvar(Name, _int, _var, currentline + 1);
            end
            else
            begin
              if pos('var ', line) > 0 then
              begin
                typ := _var;
                Delete(line, 1, pos(line, 'var ') + 3);
                Name := copy(line, 1, pos(':', line) - 1);
                Delete(line, 1, length(Name) + 1);
                Name := trim(Name);
                if pos('=', line) > 0 then
                begin
                  s := copy(line, 1, pos('=', line) - 1);
                end
                else
                begin
                  s := line;
                end;
                Delete(line, 1, length(s) + 1);
                line := trim(line);
                s    := uppercase(trim(s));
                if s = 'INTEGER' then
                begin
                  style := _int;
                end
                else if s = 'STRING' then
                begin
                  style := _str;
                end
                else if s = 'BOOLEAN' then
                begin
                  style := _bool;
                end
                else
                begin
                  style  := _err;
                  Result := dverror;
                  Log('Что значит ' + s + '?', True);
                end;
                if line <> '' then
                begin
                  if getpureval(line, 1, va) = dvok then
                  begin
                    case style of
                      _int:
                      begin
                        state := integer(va[0].state);
                      end;
                      _str:
                      begin
                        state := string(va[0].state);
                      end;
                      _bool:
                      begin
                        state := boolean(va[0].state);
                      end;
                    end;
                  end
                  else
                  begin
                    case style of
                      _int:
                      begin
                        state := -1;
                      end;
                      _str:
                      begin
                        state := '';
                      end;
                      _bool:
                      begin
                        state := False;
                      end;
                    end;
                  end;
                end;

                addvar(Name, style, typ, state);
              end
              else
              begin
                vr := onefunction(line);
                if vr.Name <> '' then
                begin
                  debug('Фукция ''' + vr.Name + ''' вернула ''' +
                    string(vr.state) + '''', False);
                end
                else
                begin
                  Result := dverror;
                  Log('Проверьте синтаксис на строке ' +
                    IntToStr(currentline) + ': ''' + line + '''', True);
                end;
              end;
            end;
          end;
        end;
      end;
    end;
  end;


  if jump <> -1 then
  begin
    currentline := jump;
  end
  else
  begin
    if nextline = '' then
    begin
      Inc(currentline);
    end;
  end;
  Result := dvok;
end;


destructor TFscript.Destroy;
begin
  Script.Free;
  SetLength(vars, 0);
  OnDebug := nil;
  Onerror := nil;
  reg.Free;
  inherited;
end;

constructor TFscript.Create;
begin
  Script := TStringList.Create;
  Script.AddStrings(Lines);
  varc     := 0;
  substate := dvnorm;
  return   := -1;
  Setlength(vars, 0);
  reg := Tdarkregistry.Create;
  addvar('_ntserviceauto',_int,_var,2);
  addvar('_ntservicemanual',_int,_var,3);
  addvar('_ntservicedisabled',_int,_var,4);
  inherited Create;
end;

function TFScript.Run;
begin
  if preprocess = dvok then
  begin
    currentline := 0;
    Result      := dvok;
    linecount   := script.Count;

    while currentline < linecount do

    begin

      if nextline = '' then
      begin
        nextline := FixEnv(Trim(script[currentline]));
      end;
      Return := DvOK;
      if (oneline(nextline) = dverror) or (Return = DvError) then
      begin
        currentline := linecount;
        Result      := dverror;
      end;

    end;
    log('Код выполнен.', False);
  end
  else
  begin
    Result := dverror;
    log('Ошибка в коде. Подготовка провалена!', True);
  end;
end;

function fixenv(s: string): string;
var
  i, j:   integer;
  new, v: string;
begin
  i := pos('//', s);
  if i > 0 then
    Delete(s, i, 1024);
  s      := trim(s);
  Result := s;
  repeat
    i := pos('%', s);
    if i = 0 then
      continue;
    j := posex('%', s, i + 1);
    if j = 0 then
      continue;
    v := lowercase(copy(s, i + 1, j - 1 - i));
    if v <> 'fdcdir' then
      new := SysUtils.GetEnvironmentVariable(v)
    else
      new := extractfiledir(mypath);
    s := ansireplacestr(s, copy(s, i, j - i + 1), new);
  until i = 0;
  Result := s;
end;


end.
