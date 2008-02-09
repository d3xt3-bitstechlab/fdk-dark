 {Freeware system tuner & cleaner}
 // 2003,2004,2005 Dark

unit SrchUnit;

interface

uses
  Classes, ComCtrls, SysUtils;

var
  TotalSize, foundsize, delsize: int64;
  Count: longint = 0;
  FillCount: longint = 0;
  fillpos: longint;
  fillmode: boolean = False;
  max:  integer;
  auto: boolean;

type
  TSearchThread = class(TThread)
  private
    attrsum: integer;
    zerofile: boolean;
    LV: TListView;
    FileName: string;
    FilePath: string;
    procedure AddToList(APath: string; FindFile: TSearchRec);
    procedure FixControls;
    procedure FindFiles(APath: string);
    procedure FillList;
    procedure BU;
    procedure EU;
  protected
    procedure Execute; override;
  public
    constructor Create(AFileName, AFilePath: string; attr: integer;
      zero: boolean; continue: boolean);
    destructor Destroy; override;
  end;

var
  reslist: array of record
    nam: string;
    time, size: longint;
  end;

implementation

uses fndedit, mainunit;
/////////////////

///////////
procedure fsplit(path: string; var dir: string; var Name: string; var ext: string);
var
  dotpos, p1, i: longint;
begin
  { allow slash as backslash }
  for i := 1 to length(path) do
    if path[i] = '/' then
      path[i] := '\';
  { get drive name }
  p1 := pos(':', path);
  if p1 > 0 then
  begin
    dir := path[1] + ':';
    Delete(path, 1, p1);
  end
  else
    dir := '';
  { split the path and the name, there are no more path informtions }
  { if path contains no backslashes                                 }
  while True do
  begin
    p1 := pos('\', path);
    if p1 = 0 then
      break;
    dir := dir + copy(path, 1, p1);
    Delete(path, 1, p1);
  end;
  { try to find out a extension }
  Ext    := '';
  i      := Length(Path);
  DotPos := 256;
  while (i > 0) do
  begin
    if (Path[i] = '.') then
    begin
      DotPos := i;
      break;
    end;
    Dec(i);
  end;
  Ext  := Copy(Path, DotPos, 255);
  Name := Copy(Path, 1, DotPos - 1);
end;

//////////




function MatchesMask(What, Mask: string): boolean;


  function CmpStr(const hstr1, hstr2: string): boolean;
  var
    found:  boolean;
    i1, i2: longint;
  begin
    i1    := 0;
    i2    := 0;
    found := True;
    while found and (i1 < length(hstr1)) and (i2 < length(hstr2)) do
    begin
      Inc(i2);
      Inc(i1);
      case hstr1[i1] of
        '?':
          found := True;
        '*':
        begin
          found := True;
          if (i1 = length(hstr1)) then
            i2 := length(hstr2)
          else if (i1 < length(hstr1)) and (hstr1[i1 + 1] <> hstr2[i2]) then
          begin
            if i2 < length(hstr2) then
              Dec(i1);
          end
          else if i2 > 1 then
            Dec(i2);
        end;
        else
          found := (hstr1[i1] = hstr2[i2]) or (hstr2[i2] = '?');
      end;
    end;
    if found then
    begin
      { allow 'p*' matching 'p' }
      if (i1 < length(hstr1)) then
        if (hstr1[i1 + 1] = '*') then
          Inc(i1);
      found := (i1 >= length(hstr1)) and (i2 >= length(hstr2));
    end;
    CmpStr := found;
  end;

var
  D1, D2: string;
  N1, N2: string;
  E1, E2: string;
begin
  FSplit(UpperCase(What), D1, N1, E1);
  FSplit(UpperCase(Mask), D2, N2, E2);

  MatchesMask := CmpStr(N2, N1) and CmpStr(E2, E1);
end;

type
  PMaskItem = ^TMaskItem;

  TMaskItem = record
    Mask: string;
    Next: PMaskItem;
  end;

var
  masklist: pmaskitem;

procedure AddMask(s: string);
var
  maskitem: PMaskItem;
  i: longint;
begin
  repeat
    i := pos(' ', s);
    if i = 0 then
      i := length(s) + 1;
    New(maskitem);
    fillchar(maskitem^, sizeof(tmaskitem), 0);
    maskitem^.mask := Copy(s, 1, i - 1);
    maskitem^.Next := masklist;
    masklist := maskitem;
    Delete(s, 1, i);
  until s = '';
end;

////////////////



constructor TSearchThread.Create(AFileName, AFilePath: string;
  attr: integer; zero: boolean; continue: boolean);
begin
  setlength(reslist, 1024);
  attrsum  := attr;
  zerofile := zero;
  FreeOnTerminate := True;
  FileName := Trim(AFileName);
  FilePath := Trim(AFilePath);
  if (FilePath <> '') then
    if FilePath[Length(FilePath)] = '\' then
      FilePath := Copy(FilePath, 1, Length(Filepath) - 1);
  if not continue then
    Count := 0;
  if not continue then
    FoundSize := 0;

  fillcount := 0;
  inherited Create(False);
end;

destructor TSearchThread.Destroy;
var
  i: integer;
begin
  FillList;
  for i := 0 to high(reslist) do
    reslist[i].nam := '';
  setlength(reslist, 0);
  Synchronize(FixControls);

  inherited Destroy;
end;

procedure TSearchThread.Execute;
begin
  LV := view.ListViewf;
  Priority := TThreadPriority(tpr);
  FindFiles(FilePath);
end;

procedure TSearchThread.FixControls;
begin
  FdcMain.EnableSearchControls(True);
end;


procedure TSearchThread.FindFiles(APath: string);
var
  S: TSearchRec;

begin
  if Terminated then
    exit;
  if FindFirst(Apath + '\*.*', faHidden + faSysFile + faDirectory +
    faReadOnly + faArchive, S) = 0 then
    repeat
      if (S.Attr and faDirectory <> 0) then
      begin
        if (s.Name <> '..') and (s.Name <> '.') then
          FindFiles(Apath + '\' + S.Name);
      end
      else
      begin
        AddToList(Apath + '\', S);
        Inc(TotalSize, S.Size);
      end;
    until (FindNext(S) <> 0) or (Terminated);
  FindClose(S);
end;

function checkmask(Filename: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 1 to max do
    if matchesmask(FileName, rec[i]) then
    begin
      Result := True;
      exit;
    end;
end;

procedure TSearchThread.AddToList(APath: string; FindFile: TSearchRec);
var
  Prefix: string;
begin
  curr := APath;

  if ((checkmask(findfile.Name)) or ((findfile.size = 0) and zerofile)) then
    if ((findfile.Attr and attrsum = 0) or (attrsum = -1)) then

    begin
      if auto then
      begin
        if not DeleteFile(APath + FindFile.Name) then
        begin
          if fillcount = high(reslist) then
            setlength(reslist, high(reslist) + 2048);
          reslist[fillcount].nam  := Prefix + LowerCase(APath + FindFile.Name);
          reslist[fillcount].time := findfile.Time;
          reslist[fillcount].size := findfile.Size;
          Inc(FillCount);
        end;
      end
      else
      begin
        if fillcount = high(reslist) then
          setlength(reslist, high(reslist) + 2048);
        reslist[fillcount].nam  := Prefix + LowerCase(APath + FindFile.Name);
        reslist[fillcount].time := findfile.Time;
        reslist[fillcount].size := findfile.Size;
        Inc(FillCount);

      end;
      Inc(Count);
      Inc(foundsize, findfile.Size);
    end;

end;


procedure TSearchThread.FillList;
var
  i: integer;
var
  ListItem: TListItem;
begin
  if fillcount = 0 then
    exit;
  synchronize(BU);
  fillmode   := True;
  fdcmain.allfiles.MaxValue := fillcount - 1;
  lv.AllocBy := (lv.Items.Count + fillcount) + 1;
  if fillcount > 0 then
    for i := 0 to fillcount - 1 do
      with LV do
      begin
        ListItem := Items.Add;
        ListItem.Caption := reslist[i].nam;
        ListItem.SubItems.Add(IntToStr(reslist[i].size));
        ListItem.SubItems.Add(Datetostr(FileDateToDateTime(reslist[i].time)));
        fillpos := i;
        if terminated then
          break;
      end;
  synchronize(EU);
  fillmode := False;
end;

procedure TSearchThread.BU;
begin
  view.beginupdatelv;
end;

procedure TSearchThread.EU;
begin
  view.endupdatelv;
end;


end.
