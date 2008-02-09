{Freeware system tuner & cleaner}
unit killunit;

interface

uses SysUtils, Forms, Classes, ComCtrls;

var
  Checked:   integer = 0;
  foundlist: TList;

type
  TESC      = procedure(a: boolean);
  ESCP      = ^TEsc;
  PListView = ^TListView;

type
  TKillThread = class(TThread)
  private
    procedure FixControls;
  protected
    procedure Execute; override;
  public
    LV:  PListView;
    esc: escp;
    constructor Create(l: Plistview; e: escp);
    destructor Destroy; override;
  end;


implementation

uses mainunit;

destructor TKillThread.Destroy;
begin
  Synchronize(FixControls);
  inherited Destroy;
end;

procedure TKillThread.FixControls;
begin
  TESC(Esc)(True);
end;


procedure TKillThread.Execute;
type
  alpha = array of record
    crc, size: longint;
  end;
var
  i, j, max: longint;
  beta:      alpha;

  function qcrc(s: shortstring): longint;
  var
    z: integer;
{  var
    tmp: array[0..255] of longint;}
  begin
    //    fillchar(tmp[0], 256 * 4, 0);
    Result := Length(s);
 {   for z := 1 to Result do
     begin
      Inc(tmp[byte(s[z])]);
      Result := Result + (byte(s[z]) * z) + tmp[byte(s[z])];
     end;}
    for z := 1 to Result do
    begin
      Result := Result + (byte(s[z]) * z);
    end;

  end;

begin
  foundlist.Clear;
  priority := tpHighest;
  with fdcmain do
  begin
    max := lv^.Items.Count - 1;
    if (max > 1) then
    begin
      SetLength(beta, max + 1);
      for i := 0 to max do
      begin
        beta[i].crc  := qcrc(ExtractFileName(lv^.Items.Item[i].Caption));
        beta[i].size := StrToInt(lv^.Items.Item[i].SubItems[0]);
      end;

      for i := 0 to max - 1 do
      begin
        Checked := i + 1;
        for j := i + 1 to max do
          if beta[i].crc = beta[j].crc then
            if beta[i].size = beta[j].size then
              //   if foundlist.IndexOf(ptr(j)) = -1 then
            begin
              foundlist.Add(ptr(i));
              foundlist.Add(ptr(j));
            end;
        if terminated then
          break;
      end;
      SetLength(beta, 0);
    end;
  end;
end;

constructor TKillThread.Create;
begin
  freeonterminate := True;
  lv      := l;
  esc     := e;
  Checked := 0;
  inherited Create(False);
end;

initialization
  foundlist := TList.Create;

finalization
  foundlist.Clear;
  foundlist.Free;

end.
