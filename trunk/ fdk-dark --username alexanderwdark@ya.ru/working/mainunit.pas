{Freeware system tuner & cleaner}
unit mainunit;

{$R *.dfm}
{$R allres.res}
interface

uses
  Windows, SysUtils, Forms, SrchUnit, DarkRegistry,
  IniFiles, masks, KillUnit,
  ExtCtrls, unitx, Controls, Mask, Buttons, Classes,
  fdcfuncs, shlobj, shelladd, Menus, ExtDlgs, Dialogs,
  Gauges, StdCtrls, ComCtrls, StShrtCt, ssBase, Graphics,
  winsvc, support, CheckLst, IdBaseComponent, IdComponent, IdTCPServer,
  IdCustomHTTPServer, IdHTTPServer, idStack, FileCtrl, syncobjs, idglobal,
  IdServerIOHandler, IdServerIOHandlerSocket, ToolWin, ShellApi,
  DarkThreadTimer, IdContext, IdGlobalProtocols, davinchi, cfg,
  strutils, LmClasses, svrapi, cpulib, IdCustomTCPServer, Spin;

var
  Excl: TStringList;
  installmode: boolean = False;

type
  TFDCMAIN = class (TForm)
    Panel1:  TPanel;
    curpath: TStaticText;
    PC:      TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    Label3:  TLabel;
    TabSheet5: TTabSheet;
    SpeedButton1: TButton;
    deltempl: TButton;
    spreset: TListBox;
    TabSheet6: TTabSheet;
    total:   TStaticText;
    found:   TStaticText;
    cool:    TDarkThreadTimer;
    TabSheet9: TTabSheet;
    Clear:   TButton;
    refr:    TDarkThreadTimer;
    proc:    TStaticText;
    barfree: TProgressBar;
    TabSheet10: TTabSheet;
    obn:     TButton;
    SaveDialog: TSaveDialog;
    savenow: TButton;
    TabSheet11: TTabSheet;
    memav:   TLabel;
    upd:     TLabel;
    assoc:   TComboBox;
    pc3:     TPageControl;
    TabSheet16: TTabSheet;
    installed: TListView;
    DelSoft: TButton;
    RunSoft: TButton;
    RefSoft: TButton;
    Bevel2:  TBevel;
    sbtn:    TButton;
    res:     TButton;
    sus:     TButton;
    stp:     TButton;
    TabSheet23: TTabSheet;
    oemlogo: TImage;
    proiz:   TEdit;
    model:   TEdit;
    local:   TEdit;
    site:    TEdit;
    sinfo:   TMemo;
    apply:   TButton;
    reset:   TButton;
    opd:     TOpenPictureDialog;
    change:  TButton;
    TabSheet25: TTabSheet;
    Bevel8:  TBevel;
    SysF:    TListView;
    SFR:     TButton;
    SFC:     TButton;
    OpenDialog: TOpenDialog;
    autodel: TCheckBox;
    Bevel3:  TBevel;
    sld:     TScrollBar;
    Bevel10: TBevel;
    slider:  TScrollBar;
    track:   TScrollBar;
    Label19: TLabel;
    allfiles: TGauge;
    PopupMenu1: TPopupMenu;
    N1:      TMenuItem;
    TabSheet28: TTabSheet;
    saveplug: TButton;
    refrplug: TButton;
    Value:   TEdit;
    defval:  TEdit;
    Label60: TLabel;
    TabSheet29: TTabSheet;
    arref:   TButton;
    Button3: TButton;
    autorun: TListBox;
    smask:   TEdit;
    chtempl: TButton;
    TabSheet4: TTabSheet;
    Clr:     TButton;
    Button4: TButton;
    Button5: TButton;
    TabSheet8: TTabSheet;
    SFresh:  TButton;
    slist:   TListBox;
    srun:    TRadioGroup;
    SApply:  TButton;
    servpopup: TPopupMenu;
    sstart:  TMenuItem;
    sstop:   TMenuItem;
    spause:  TMenuItem;
    sresume: TMenuItem;
    radio:   TRadioGroup;
    alldisks: TCheckBox;
    where:   TComboBox;
    browse:  TButton;
    spec:    TButton;
    pust:    TCheckBox;
    tn:      TCheckBox;
    hid:     TCheckBox;
    ro:      TCheckBox;
    arc:     TCheckBox;
    sys:     TCheckBox;
    Bevel1:  TBevel;
    ClearOpt: TCheckListBox;
    TabSheet2: TTabSheet;
    Serv9x:  TListBox;
    update9xserv: TButton;
    del9xserv: TButton;
    TabSheet7: TTabSheet;
    HTTPServer: TIdHTTPServer;
    acActivate: TCheckBox;
    edPort:  TEdit;
    TabSheet12: TTabSheet;
    bid:     TMemo;
    ToolBar1: TToolBar;
    sbi:     TToolButton;
    lbi:     TToolButton;
    dlbi:    TToolButton;
    defbi:   TToolButton;
    TabSheet13: TTabSheet;
    gosite:  TLabel;
    TabSheet14: TTabSheet;
    TabSheet15: TTabSheet;
    TabSheet17: TTabSheet;
    ToolBar2: TToolBar;
    tb:      TToolButton;
    ToolButton2: TToolButton;
    abat:    TMemo;
    ToolBar3: TToolBar;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    cos:     TMemo;
    ToolBar4: TToolBar;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    msd:     TMemo;
    cspreset: TComboBox;
    abpreset: TComboBox;
    msdpreset: TComboBox;
    autoab:  TToolButton;
    csauto:  TToolButton;
    msdauto: TToolButton;
    N6:      TMenuItem;
    TabSheet18: TTabSheet;
    typesref: TButton;
    stypes:  TListBox;
    Button6: TButton;
    aropt:   TButton;
    addar:   TButton;
    setyp:   TButton;
    armenu:  TPopupMenu;
    N7:      TMenuItem;
    N8:      TMenuItem;
    N9:      TMenuItem;
    Label2:  TLabel;
    Label4:  TLabel;
    Label25: TLabel;
    TabSheet19: TTabSheet;
    oper:    TComboBox;
    loadoper: TButton;
    operpc:  TPageControl;
    TabSheet20: TTabSheet;
    TabSheet21: TTabSheet;
    operdebug: TRichEdit;
    operlog: TRichEdit;
    TabSheet22: TTabSheet;
    opercode: TRichEdit;
    otc:     TMemo;
    Button2: TButton;
    alltypes: TCheckBox;
    TabSheet24: TTabSheet;
    shared:  TComboBox;
    rshared: TButton;
    dshared: TButton;
    nfo:     TListBox;
    sworks:  TButton;
    spopup:  TPopupMenu;
    N11:     TMenuItem;
    N14:     TMenuItem;
    N15:     TMenuItem;
    Panel2:  TPanel;
    Button7: TButton;
    sacc:    TRadioGroup;
    shidd:   TCheckBox;
    sreadp:  TEdit;
    sfullp:  TEdit;
    Label5:  TLabel;
    Label6:  TLabel;
    spers:   TCheckBox;
    TabSheet26: TTabSheet;
    layouts: TListBox;
    lrefr:   TButton;
    ldelete: TButton;
    TabSheet27: TTabSheet;
    times:   TListBox;
    trefr:   TButton;
    tdelete: TButton;
    TabSheet30: TTabSheet;
    TabSheet31: TTabSheet;
    ToolBar5: TToolBar;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    abntpreset: TComboBox;
    abnt:    TMemo;
    ToolBar6: TToolBar;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton11: TToolButton;
    csntpreset: TComboBox;
    csnt:    TMemo;
    preset:  TComboBox;
    TabSheet32: TTabSheet;
    Software: TListBox;
    refs:    TButton;
    dels:    TButton;
    opc:     TPageControl;
    TabSheet33: TTabSheet;
    TabSheet34: TTabSheet;
    options: TCheckListBox;
    qchk:    TComboBox;
    Label7:  TLabel;
    safe:    TComboBox;
    safea:   TButton;
    safed:   TButton;
    safen:   TComboBox;
    addpr:   TButton;
    debug:   TPanel;
    Memo:    TMemo;
    TabSheet35: TTabSheet;
    Button1: TButton;
    setw:    TButton;
    TabSheet36: TTabSheet;
    chk:     TRichEdit;
    check:   TButton;
    fixfonts: TButton;
    gobox:   TComboBox;
    cheats:  TListBox;
    up:      TSpinButton;
    Bevel4:  TBevel;
    Bevel5:  TBevel;
    Label8:  TLabel;
    Label9:  TLabel;
    GroupBox1: TGroupBox;
    Label1:  TLabel;
    Label10: TLabel;
    procedure ldeleteClick(Sender: TObject);
    procedure lrefrClick(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N15Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure alltypesClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure operSelect(Sender: TObject);
    procedure loadoperClick(Sender: TObject);
    procedure MemDeAllocMemory(Sender: TObject; AQuantity: integer);
    procedure MemAllocMemory(Sender: TObject; AQuantity: integer);
    procedure gotosearch(Sender: TObject);
    procedure TrackChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure gotostop(Sender: TObject);
    procedure EnableSearchControls(Value: boolean);
    procedure EDIT1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Pause(Sender: TObject);
    procedure resume(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tnClick(Sender: TObject);
    procedure Freshpreset(Sender: TObject);
    procedure spresetKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure GetXRun;
    procedure mxFlaTButton1Click(Sender: TObject);
    procedure PCChange(Sender: TObject);
    procedure listviewClick(Sender: TObject);
    procedure ClrClick(Sender: TObject);
    procedure coolTimer(Sender: TObject);
    procedure clearClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SliderChange(Sender: TObject);
    procedure makereport;
    procedure Saveit(Sender: TObject);
    procedure sldChange(Sender: TObject);
    procedure assocChange(Sender: TObject);
    procedure DelSoftClick(Sender: TObject);
    procedure RefSoftClick(Sender: TObject);
    procedure RunSoftClick(Sender: TObject);
    procedure smClick(Sender: TObject);
    procedure dsClick(Sender: TObject);
    procedure SFRClick(Sender: TObject);
    procedure changeClick(Sender: TObject);
    procedure applyClick(Sender: TObject);
    procedure resetClick(Sender: TObject);
    procedure SFCClick(Sender: TObject);
    procedure pc3Change(Sender: TObject);
    procedure SysFDblClick(Sender: TObject);
    procedure refMouseEnter(Sender: TObject);
    procedure refMouseLeave(Sender: TObject);
    procedure alldisksClick(Sender: TObject);
    procedure roClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure refrplugClick(Sender: TObject);
    procedure saveplugClick(Sender: TObject);
    procedure cheatsSelect(Sender: TObject);
    procedure radioClick(Sender: TObject);
    procedure arrefClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure freshtemplates;
    procedure chtemplClick(Sender: TObject);
    procedure deltemplClick(Sender: TObject);
    procedure nextdisk(Sender: TObject);
    procedure browseClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SFreshClick(Sender: TObject);
    procedure slistDblClick(Sender: TObject);
    procedure slistClick(Sender: TObject);
    procedure srunClick(Sender: TObject);
    procedure SApplyClick(Sender: TObject);
    procedure sstopClick(Sender: TObject);
    procedure sstartClick(Sender: TObject);
    procedure spauseClick(Sender: TObject);
    procedure sresumeClick(Sender: TObject);
    procedure servpopupPopup(Sender: TObject);
    procedure ClearOptClickCheck(Sender: TObject);
    procedure optionsClickCheck(Sender: TObject);
    procedure update9xservClick(Sender: TObject);
    procedure Serv9xClick(Sender: TObject);
    procedure del9xservClick(Sender: TObject);
    procedure acActivateExecute(Sender: TObject);
    procedure edPortChange(Sender: TObject);
    procedure edPortKeyPress(Sender: TObject; var Key: char);
    procedure edPortExit(Sender: TObject);
    function GetMIMEType(sFile: TFileName): string;
    procedure obnClick(Sender: TObject);
    procedure sbiClick(Sender: TObject);
    procedure lbiClick(Sender: TObject);
    procedure dlbiClick(Sender: TObject);
    procedure defbiClick(Sender: TObject);
    procedure gettClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure sendmailClick(Sender: TObject);
    procedure k(Sender: TObject);
    procedure tbClick(Sender: TObject);
    procedure ToolButton6Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton9Click(Sender: TObject);
    procedure abpresetSelect(Sender: TObject);
    procedure cspresetSelect(Sender: TObject);
    procedure msdpresetSelect(Sender: TObject);
    procedure autoabClick(Sender: TObject);
    procedure csautoClick(Sender: TObject);
    procedure msdautoClick(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure gettypesClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure stypesClick(Sender: TObject);
    procedure aroptClick(Sender: TObject);
    procedure addarClick(Sender: TObject);
    procedure setypClick(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure Label2MouseEnter(Sender: TObject);
    procedure Label2MouseLeave(Sender: TObject);
    procedure Label25MouseEnter(Sender: TObject);
    procedure Label25MouseLeave(Sender: TObject);
    procedure HTTPServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure rsharedClick(Sender: TObject);
    procedure sworksClick(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure trefrClick(Sender: TObject);
    procedure tdeleteClick(Sender: TObject);
    procedure autorunClick(Sender: TObject);
    procedure sharedSelect(Sender: TObject);
    procedure saccClick(Sender: TObject);
    procedure dsharedClick(Sender: TObject);
    procedure abntpresetSelect(Sender: TObject);
    procedure csntpresetSelect(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure specClick(Sender: TObject);
    procedure presetSelect(Sender: TObject);
    procedure smaskChange(Sender: TObject);
    procedure refsClick(Sender: TObject);
    procedure delsClick(Sender: TObject);
    procedure safedClick(Sender: TObject);
    procedure safeaClick(Sender: TObject);
    procedure addprClick(Sender: TObject);
    procedure sbtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure setwClick(Sender: TObject);
    procedure checkClick(Sender: TObject);
    procedure fixfontsClick(Sender: TObject);
    procedure goboxSelect(Sender: TObject);
    procedure upUpClick(Sender: TObject);
    procedure upDownClick(Sender: TObject);

  private

  public
    procedure StrToSList(Value: string; var StrList: TStringList);
    procedure Fill9xServices;
    procedure FillOper;
    procedure NilServices;
    procedure FilterRuns;
    procedure Regit;
    procedure RunScript(s: string);
    procedure BuildNetShareList;
    procedure NextTaskStep(FlistIfFirstTime: string = '');
    procedure WriteEnv;
    procedure ExtractInstall;
    function CheckSafe(s: string): boolean;
  end;


procedure CreateNilFile(s: string);
procedure rebuildplugins;
procedure ExtractRes(ResType, ResName, ResNewName: string);

var
  MIMEMap: TIdMIMETable;

var
  BadAr: TStringList;

function isinexcl(s: string): boolean;
function servicestatusid(sn: string): cardinal;
function servicestatus(sn: string): string;

{$I build.inc}
var
  Obj: array[1..7000] of record
    ext, des: string;
  end;
  z:     integer;
  tpr:   integer;
  s:     TsearchThread;
  killt: TKillThread;
  clonemode: boolean = False;
  work:  boolean;
  rec:   array[1..255] of string[255];
  drivesize: longint;
  curr:  string;

  current_drive: integer = 1;
  harddrives: string;
  Cur:     longint;
  FDCMAIN: TFDCMAIN;
  oe:      string;
  prepare: boolean;
  passwasrun: boolean = False;
  mypath:  string;
  templ:   TStrings;
  exiting: boolean = False;
  maxservices: integer = 0;
  services: array of record
    Name, key, desc: string;
    start: integer;
  end;


var
  options_name: string = 'fdc_config.ini';
  s_temp_fn: string = 'fdc_search.fds';
  usrdir: string = 'usr';

type
  TIdx = class (TObject)
    id: smallint;
  end;


var
  ServList: array of record
    Name:    string;
    path:    string;
    regpath: string;
    vxd:     boolean;
  end;
  numserv: integer = 0;

var
  startro: boolean = False;

var
  enablelog: boolean = True;


implementation

uses uMem, fndedit, install;

var
  temptimer: TTimer;

var
  Tasks: TStringList = nil;

var
  tasknum: integer = 0;

var
  waitfordk: boolean = False;




procedure lasterror;
begin
  messagebox(fdcmain.Handle, PChar(syserrormessage(getlasterror)), 'Сообщение', mb_Ok);
end;

function ExtractRealName(s: string): string;
begin
  Result := Trim(S);
  exit;
end;


procedure EW(t: string);
begin
  if messagedlg(t + #13#10 + 'Продолжить работу?', mtError, [mbYes, mbNo], 0) = 7 then
    Halt(0);
end;



procedure AddPass(idxNum, PhoneNumber, AreaCode, UserName, Password, EntryName: string);
  safecall;
begin
  if not passwasrun then
    begin
    add('--------- Пароли ------------');
    passwasrun := True;
    end;
  add(Format('[%s] %s код: %s тел. %s логин: %s пароль: %s',
    [idxNum, EntryName, AreaCode, PhoneNumber, UserName, Password]));
end;

procedure TFDCMain.nextdisk(Sender: TObject);
begin
  temptimer.Enabled := False;
  temptimer.OnTimer := nil;
  temptimer.Free;
  curpath.Caption := 'Старт поиска...';
  if (current_drive < length(harddrives)) then
    begin
    Inc(current_drive);
    where.Text := HardDrives[current_drive] + ':\';
    sbtn.Click;
    end
  else
    begin
    alldisks.Checked := False;
    current_drive    := 1;
    curpath.Caption  := 'Поиск успешно завершен...';
    if Count > 0 then
      if not view.Visible then
        view.Show;
    end;
end;

procedure SearchDone;
begin
  FdcMain.cool.Enabled    := False;
  FdcMain.smask.Enabled   := True;
  FdcMain.where.Enabled   := True;
  FdcMain.tn.Enabled      := True;
  FdcMain.pust.Enabled    := True;
  FdcMain.spreset.Enabled := True;
  FdcMain.AllFiles.Progress := FdcMain.AllFiles.MaxValue;
  FdcMain.total.Caption   := Format('Найдено %d файлов', [Count]);
  FdcMain.found.Caption   := format('%f Мб', [foundsize / 1024 / 1024]);
  FdcMain.curpath.Caption := 'Поиск завершен';
  if FDCMain.alldisks.Checked then
    begin
    FdcMain.curpath.Caption := 'Следующий диск...';
    temptimer := TTimer.Create(nil);
    temptimer.Interval := 500;
    temptimer.OnTimer := fdcmain.nextdisk;
    temptimer.Enabled := True;
    end
  else
    begin
    if Count > 0 then
      if view.Visible = False then
        view.Show;
    end;
  if waitfordk then
    begin
    waitfordk := False;
    fdcmain.NextTaskStep;
    end;
end;

procedure SearchBegin;
begin
  FdcMain.smask.Enabled   := False;
  FdcMain.where.Enabled   := False;
  FdcMain.tn.Enabled      := False;
  FdcMain.pust.Enabled    := False;
  FdcMain.spreset.Enabled := False;
  FdcMain.curpath.Caption := 'Начало поиска';
end;

procedure TFDCMAIN.EnableSearchControls(Value: boolean);
begin
  Work := not Value;
  preset.Enabled := Value;
  safen.Enabled := Value;
  if work then
    view.Hide;
  spec.Enabled   := Value;
  browse.Enabled := Value;
  if exiting then
    exit;
  Stp.Enabled  := not Value;
  Sbtn.Enabled := Value;
  sus.Enabled  := not Value;
  if work then
    SearchBegin
  else
    SearchDone;
end;

procedure GetParam(s: string);
var
  c:      char;
  i:      integer;
  s2, s3: string;
begin
  if Length(Trim(s)) > 0 then
    begin
    srchunit.max := 1;
    s2 := Trim(s);
    s3 := '';
    for i := 1 to length(s2) do
      begin
      c := s2[i];
      if (c = ';') or (i = length(s2)) then
        begin
        if c <> ';' then
          rec[srchunit.max] := s3 + c
        else
          rec[srchunit.max] := s3;
        s3 := '';
        srchunit.max := srchunit.max + 1;
        end
      else
        s3 := s3 + c;
      end;
    srchunit.max := srchunit.max - 1;
    end;
end;

function diskready(d: string): boolean;
var
  S: string;
  A: longint;
begin
  Result := False;
  s      := ExtractFileDrive(d);
  if (d <> '') then
    if D[1] in ['A', 'B'] then
      Exit;
  A := FileCreate(D + 'delete_me_now.tmp');
  if (A <> -1) then
    begin
    FileClose(A);
    Result := True;
    deletefileadv(D + 'delete_me_now.tmp');
    Exit;
    end;
end;

procedure TFDCMAIN.gotosearch(Sender: TObject);
var
  ready:  boolean;
  attrib: integer;
begin
  attrib := 0;
  if not tn.Checked then
    attrib := -1
  else
    begin
    if not hid.Checked then
      attrib := attrib + fahidden;
    if not sys.Checked then
      attrib := attrib + fasysfile;
    if not ro.Checked then
      attrib := attrib + fareadonly;
    if not arc.Checked then
      attrib := attrib + faarchive;
    end;

  ready := DiskReady(Trim(where.Text));
  if (Trim(where.Text) <> '') and (trim(smask.Text) <> '') and (ready) then
    begin
    drivesize := disksize(DiskNum(UpCase(where.Text[1]))) div 1024 div
      1024 - DiskFree(DiskNum(UpCase(where.Text[1]))) div 1024 div 1024;
    allfiles.MaxValue := drivesize;
    delsize   := 0;
    totalsize := 0;
    auto      := autodel.Checked;
    AllFiles.Progress := 0;
    curpath.Caption := '';
    total.Caption := '';
    found.Caption := '';
    if Trim(smask.Text) > '' then
      GetParam(smask.Text);
    if (rec[1] <> '') then
      begin
      if not alldisks.Checked then
        view.listviewf.Clear;
      EnableSearchControls(False);
{      if Assigned(S) then
      begin
        terminatethread(s.ThreadID, 0);
      end;}

      s := TSearchThread.Create('*.*', where.Text, attrib, pust.Checked,
        alldisks.Checked);
      cool.Enabled := True;
      end;

    end
  else
  if ready then
    begin
    curpath.Caption := 'Укажите маску файлов для поиска';
    end
  else
    begin
    curpath.Caption  := 'Укажите устройство для поиска';
    alldisks.Checked := False;
    end;
end;

procedure TFDCMAIN.TrackChange(Sender: TObject);
begin
  tpr := track.position;
  if work then
    s.Priority := TThreadPriority(tpr);
end;

procedure TFDCMAIN.MemAllocMemory(Sender: TObject; AQuantity: integer);
begin
  BarFree.Position := AQuantity;
end;

procedure GetAss;
var
  Reg: TDarkRegistry;
  SL:  TStringList;
  I:   integer;
  FileExtension: string;
  ClassID: string;
  ClassDescription: string;
begin
  z   := 0;
  SL  := TStringList.Create;
  Reg := TDarkRegistry.Create;
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Reg.OpenKey('');
    Reg.GetKeyNames(SL);
    SL.Sort;
    if (SL.Count > 0) then
      for I := 0 to Pred(SL.Count) do
        if (SL.Strings[I] <> '') and (SL.Strings[I][1] = '.') then
          begin
          FileExtension := '*' + SL[I];
          if Reg.OpenKey('\' + SL[I]) then
            begin
            ClassID := Reg.ReadString('');
            if Reg.OpenKey('\' + ClassID) then
              begin
              ClassDescription := Reg.ReadString('');
              if ClassDescription <> '' then
                begin
                Inc(z, 1);
                Obj[z].ext := FileExtension;
                Obj[z].Des := ClassDescription;
                end;
              end;
            end;
          end;
  finally
    reg.CloseKey;
    Reg.Free;
    SL.Free;
    end;
  for i := 1 to z do
    FdcMain.assoc.Items.Add(obj[i].ext + ' - ' + obj[i].des);
end;

procedure TFDCMain.freshtemplates;
var
  i: integer;
begin
  spreset.Clear;
  smask.Clear;
  for i := 0 to templ.Count - 1 do
    spreset.Items.Append(templ.Names[i]);
  preset.Items.Assign(spreset.Items);
  safen.Items.Assign(spreset.Items);
  preset.Items.Add('[Пользовательский]');
end;

procedure TFDCMAIN.MemDeallocMemory(Sender: TObject; AQuantity: integer);
begin
  BarFree.Position := (BarFree.Position + AQuantity);
end;

procedure TFDCMAIN.FormCreate(Sender: TObject);
var
  ini: TiniFile;
  i:   integer;
  Fi:  TextFile;
begin
  tasks   := TStringList.Create;
  badar   := TStringList.Create;
  excl    := TStringList.Create;
  MIMEMap := TIdMIMETable.Create(True);
  startro := isrodir;
  harddrives := getharddrives;
  for i := 1 to length(harddrives) do
    where.Items.Add(harddrives[i] + ':\');
  FindCheats;
  if numtweak > 0 then
    for i := 0 to numtweak - 1 do
      cheats.Items.Add(tweaks[i].Desc);
  GetAss;
  mem.OnAllocMemory := MemAllocMemory;
  mem.OnDeAllocMemory := MemDeAllocMemory;
  Slider.Max      := Mem.GetMemoryStatus.TotalPhys;
  Slider.Position := Slider.Max div 2;
  BarFree.Position := 1;
  BarFree.Min     := 1;
  BarFree.Max     := Slider.Max;
  AllFiles.Progress := 0;
  if fileexists(windowsdir + 'errors') then
    deletefileadv(windowsdir + 'errors');
  prepare := True;
  FdcMain.smask.Text := '';
  ini     := TiniFile.Create(windowsdir + options_name);
  acactivate.Checked := ini.ReadBool('main_application_options', 'web_control', False);
  usrdir  := ini.ReadString('main_application_options', 'usr_directory_override', 'usr');
  tpr     := ini.ReadInteger('main_application_options', 'search_thread_priority', 2);
  options.Checked[2] := ini.ReadBool('main_application_options',
    'save_state', options.Checked[2]);
  options.Checked[6] := ini.ReadBool('main_application_options', 'safe_masks', True);
  pust.Checked := ini.ReadBool('main_application_options', 'add_zero-size_files',
    pust.Checked);
  refr.Interval := ini.ReadInteger('main_application_options',
    'memory_data_refresh', 1000);
  sld.Position := refr.Interval div 10;
  sldchange(self);
  pc.ActivePageIndex     := 0;
  pc3.ActivePageIndex    := 0;
  operpc.ActivePageIndex := 0;
  pc.ActivePageIndex     := 0;
  if tpr <= track.Max then
    track.position := tpr
  else
    begin
    tpr := 2;
    track.position := 2;
    end;
  templ := TStringList.Create;
  if FileExists(mypath + s_temp_fn) and not FileExists(windowsdir + s_temp_fn) then
    copyfile(PChar(mypath + s_temp_fn), PChar(windowsdir + s_temp_fn), False);
  if FileExists(windowsdir + s_temp_fn) then
    templ.LoadFromFile(windowsdir + s_temp_fn);
  freshtemplates;
  /////
  if options.Checked[2] then
    begin
    FdcMain.Position := poDesigned;
    FdcMain.Top      := ini.ReadInteger('main_application_options',
      'top_position', FdcMain.Top);
    FdcMain.left     := ini.ReadInteger('main_application_options',
      'left_position', FdcMain.Left);
    pc.ActivePageIndex := ini.ReadInteger('main_application_options',
      'main_book_index', 0);
    opc.ActivePageIndex := ini.ReadInteger('main_application_options',
      'options_book_index', 0);

    pc3.ActivePageIndex    := ini.ReadInteger('main_application_options',
      'system_config_book_index', 0);
    operpc.ActivePageIndex :=
      ini.ReadInteger('main_application_options', 'operations_book_index', 0);
    pcchange(self);
    end;
  /////
  ini.Free;
  where.Text    := 'C:\';
  bid.ReadOnly  := not nt;
  abat.ReadOnly := nt;
  cos.ReadOnly  := nt;
  msd.ReadOnly  := nt;
  if nt then
    if fileexists('c:\boot.ini') then
      bid.Lines.LoadFromFile('c:\boot.ini')
    else
      ShowMessage('Boot.ini не существует!');

  if nt then
    if fileexists(windowsdir + 'system32\autoexec.nt') then
      abnt.Lines.LoadFromFile(windowsdir + 'system32\autoexec.nt')
    else
      ShowMessage('autoexec.nt не существует!');
  if nt then
    if fileexists(windowsdir + 'system32\config.nt') then
      csnt.Lines.LoadFromFile(windowsdir + 'system32\config.nt')
    else
      ShowMessage('config.nt не существует!');


  if not nt then
    if fileexists('c:\autoexec.bat') then
      abat.Lines.LoadFromFile('c:\autoexec.bat')
    else
      ShowMessage('autoexec.bat не существует!');

  if not nt then
    if fileexists('c:\config.sys') then
      cos.Lines.LoadFromFile('c:\config.sys')
    else
      ShowMessage('config.sys не существует!');

  if not nt then
    if fileexists('c:\msdos.sys') then
      msd.Lines.LoadFromFile('c:\msdos.sys')
    else
      ShowMessage('msdos.sys не существует!');
  ///!!!  setw.Enabled := not nt;
  sfresh.Enabled := nt;
  sapply.Enabled := nt;
  update9xserv.Enabled := not nt;
  del9xserv.Enabled := not nt;
  prepare := False;
  if not (directoryexists(mypath + usrdir)) then
    begin
    createdir(mypath + usrdir);
    AssignFile(Fi, mypath + usrdir + '\directory.txt');
    Rewrite(Fi);
    Writeln(Fi, 'Каталог содержит различные изменяемые пользователем данные.');
    Writeln(Fi, '(c) 2003-2006 Dark Software http://www.darksoftware.narod.ru/');
    Writeln(Fi, TimeToStr(time) + ' ' + DateToStr(date));
    CloseFile(Fi);
    end
  else
  if not fileexists(mypath + usrdir + '\directory.txt') then
    begin
    AssignFile(Fi, mypath + usrdir + '\directory.txt');
    Rewrite(Fi);
    Writeln(Fi, 'Каталог содержит различные изменяемые пользователем данные.');
    Writeln(Fi, '(c) 2003-2006 Dark Software http://www.darksoftware.narod.ru/');
    Writeln(Fi, TimeToStr(time) + ' ' + DateToStr(date));
    CloseFile(Fi);
    end;

  if fileexists(mypath + usrdir + '\safemasks.fdp') then
    begin
    safe.Items.LoadFromFile(mypath + usrdir + '\safemasks.fdp');
    safe.Sorted := True;
    safe.Sorted := False;
    end
  else
    createnilfile(mypath + usrdir + '\safemasks.fdp');



  if fileexists(mypath + usrdir + '\exclude.fdp') then
    excl.LoadFromFile(mypath + usrdir + '\exclude.fdp')
  else
    createnilfile(mypath + usrdir + '\exclude.fdp');

  if excl.Count > 0 then
    begin
    for i := 0 to excl.Count - 1 do
      excl[i] := fixenv(excl[i]);
    end;


  if fileexists(mypath + usrdir + '\autorun.fdp') then
    badar.LoadFromFile(mypath + usrdir + '\autorun.fdp')
  else
    createnilfile(mypath + usrdir + '\autorun.fdp');

  if nt then
    begin
    if fileexists(mypath + usrdir + '\autoexecnt.fdp') then
      begin
      abntpreset.Items.LoadFromFile(mypath + usrdir + '\autoexecnt.fdp');
      abntpreset.Sorted := True;
      abntpreset.Sorted := False;
      abntpreset.Items.Add('[Изменить этот список]');
      end
    else
      createnilfile(mypath + usrdir + '\autoexecnt.fdp');
    if fileexists(mypath + usrdir + '\confignt.fdp') then
      begin
      csntpreset.Items.LoadFromFile(mypath + usrdir + '\confignt.fdp');
      csntpreset.Sorted := True;
      csntpreset.Sorted := False;
      csntpreset.Items.Add('[Изменить этот список]');
      end
    else
      createnilfile(mypath + usrdir + '\confignt.fdp');
    end;


  if not nt then
    begin
    if fileexists(mypath + usrdir + '\autoexec.fdp') then
      begin
      abpreset.Items.LoadFromFile(mypath + usrdir + '\autoexec.fdp');
      abpreset.Sorted := True;
      abpreset.Sorted := False;
      abpreset.Items.Add('[Изменить этот список]');
      end
    else
      createnilfile(mypath + usrdir + '\autoexec.fdp');

    if fileexists(mypath + usrdir + '\msdos.fdp') then
      begin
      msdpreset.Items.LoadFromFile(mypath + usrdir + '\msdos.fdp');
      msdpreset.Sorted := True;
      msdpreset.Sorted := False;
      msdpreset.Items.Add('[Изменить этот список]');
      end
    else
      createnilfile(mypath + usrdir + '\msdos.fdp');

    if fileexists(mypath + usrdir + '\config.fdp') then
      begin
      cspreset.Items.LoadFromFile(mypath + usrdir + '\config.fdp');
      cspreset.Sorted := True;
      cspreset.Sorted := False;
      cspreset.Items.Add('[Изменить этот список]');
      end
    else
      createnilfile(mypath + usrdir + '\config.fdp');
    end;
  FillOper;
  toolbar1.Enabled := nt;
  toolbar2.Enabled := not nt;
  toolbar3.Enabled := not nt;
  toolbar4.Enabled := not nt;
  toolbar5.Enabled := nt;
  toolbar6.Enabled := nt;
end;

procedure TFDCMAIN.gotostop(Sender: TObject);
begin
  s.Priority := tpLower;
  s.Terminate;
  cool.Enabled     := False;
  alldisks.Checked := False;
end;

procedure TFDCMAIN.EDIT1Change(Sender: TObject);
begin
  if Length(Trim(smask.Text)) > 0 then
    sbtn.Enabled := True;
end;

procedure TFDCMAIN.SpeedButton1Click(Sender: TObject);
var
  s, m: string;
begin
  s := inputbox('Новая заготовка поиска', 'Имя заготовки', 'Новый');
  m := inputbox('Редактирование заготовки''' + s + '''', 'Список масок', smask.Text);
  templ.values[s] := m;
  freshtemplates;
  spreset.ItemIndex := spreset.Items.IndexOf(s);
  freshpreset(self);
end;


procedure TFDCMAIN.Pause(Sender: TObject);
begin
  stp.Enabled := False;
  res.Enabled := True;
  sus.Enabled := False;
  s.Suspend;
  cool.Enabled := False;
end;

procedure TFDCMAIN.resume(Sender: TObject);
begin
  stp.Enabled := True;
  res.Enabled := False;
  sus.Enabled := True;
  s.Resume;
  cool.Enabled := True;
end;

procedure TFDCMAIN.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  cool.OnTimer := nil;
  cool.Enabled := False;
  exiting      := True;
  if work then
    s.Terminate;
  if clonemode then
    killt.Terminate;
  httpserver.Active := False;
  MIMEMap.Free;
end;



procedure TFDCMAIN.FormClose(Sender: TObject; var Action: TCloseAction);
var
  ini: Tinifile;
  TS:  TStringList;
  i:   integer;
begin
  refr.Enabled := False;
  ini := TiniFile.Create(windowsdir + options_name);
  ini.WriteString('shared', 'fdk_path', mypath);
  ini.WriteString('main_application_options', 'usr_directory_override', usrdir);
  ini.WriteInteger('main_application_options', 'search_thread_priority', tpr);
  ini.WriteInteger('main_application_options', 'memory_data_refresh', refr.Interval);
  ini.WriteBool('main_application_options', 'save_state', options.Checked[2]);
  ini.WriteBool('main_application_options', 'safe_masks', options.Checked[6]);
  ini.WriteBool('main_application_options', 'add_zero-size_files', pust.Checked);
  ini.WriteBool('main_application_options', 'web_control', acactivate.Checked);
  if options.Checked[2] then
    begin
    ini.WriteInteger('main_application_options', 'top_position', FdcMain.Top);
    ini.WriteInteger('main_application_options', 'left_position', FdcMain.Left);
    ini.WriteInteger('main_application_options', 'main_book_index', pc.ActivePageIndex);
    ini.WriteInteger('main_application_options', 'options_book_index',
      opc.ActivePageIndex);
    ini.WriteInteger('main_application_options', 'system_config_book_index',
      pc3.ActivePageIndex);
    ini.WriteInteger('main_application_options',
      'operations_book_index', operpc.ActivePageIndex);

    end;
  ini.UpdateFile;
  ini.Free;
  TS := TStringList.Create;
  for i := 0 to templ.Count - 1 do
    begin
    Ts.Clear;
    ts.Delimiter     := ';';
    ts.DelimitedText := Templ.ValueFromIndex[i];
    ts.Sort;
    templ.ValueFromIndex[i] := ts.DelimitedText;
    end;
  TS.Free;
  if not installmode then
    templ.SaveToFile(windowsdir + s_temp_fn);
  templ.Free;
  nilservices;
  badar.Free;
  excl.Free;
  tasks.Free;
  if (not startro) and (not installmode) then
    begin
    safe.Items.SaveToFile(mypath + usrdir + '\safemasks.fdp');
    end;
  /////////// Закрытие
end;

procedure TFDCMAIN.GetXRun;
var
  s, opt: string;
begin
  s := ExtractRealName(Trim(LowerCase(ParamStr(1))));
  if s = '' then
    exit
  else
  if s[1] = '-' then
    begin
    opt := copy(s, 2, length(s));
    if opt = 'alldisks' then
      begin
      alldisks.Checked := True;
      smask.Text := ExtractRealName(trim(ParamStr(2)));
      //////GS!!!//////
      if options.Checked[6] then
        begin
        if not checksafe(smask.Text) then
          begin
          if messagedlg(
            'Среди файлов, которые могут быть найдены (и удалены) при данном поиске могут быть важные, действительно продолжить?',
            mtConfirmation, mbOkCancel, 0) = idOk then
            gotosearch(self);
          end
        else
          gotosearch(self);

        end
      else
        gotosearch(self);
      /////////

      end
    else
    if opt = 'freemem' then
      begin
      pc.ActivePage := tabsheet9;
      sld.Position  := strtointdef(ExtractRealName(ParamStr(2)),
        Mem.GetMemoryStatus.TotalPhys div 2);
      Clear.Click;
      Close;
      end
    else
    if opt = 'addtostart' then
      smclick(nil)
    else
    if opt = 'addtodesktop' then
      dsclick(nil)
    else
    if opt = 'addtoall' then
      begin
      smclick(nil);
      dsclick(nil);
      end
    else
    if opt = 'register' then
      regit
    else
    if opt = 'install' then
      begin
      installmode := True;
      extractinstall;
      smclick(nil);
      dsclick(nil);
      regit;
      ShowMessage('Программа успешно установлена!');
      Close;
      end
    else
    if opt = 'autorun' then
      begin
      pc.ActivePage  := tabsheet11;
      pc3.ActivePage := tabsheet29;
      if messagedlg('Действительно заменить записи в автозагрузке?',
        mtConfirmation, mbOkCancel, 0) = idOk then
        begin
        loadruns(ExtractRealName(ParamStr(2)));
        end;
      arref.Click;
      end

    ///
    else
    if opt = 'usefilelist' then
      begin
      view.LoadFList(ExtractRealName(ParamStr(2)), False);
      view.Show;
      end
    ///

    else
    if opt = 'usetasklist' then
      begin
      NextTaskStep(ExtractRealName(ParamStr(2)));

      end
    ///

    else
    if opt = 'runscript' then
      begin
      pc.ActivePage := tabsheet19;
      runscript(ExtractRealName(ParamStr(2)));
      if wantexit then
        Close;
      end
    else
    if opt = 'runscriptandclose' then
      begin
      pc.ActivePage := tabsheet19;
      runscript(ExtractRealName(ParamStr(2)));
      Close;
      end;

    end
  else
    begin
    if pos('"', s) = 1 then
      where.Text := Copy(s, 2, length(s) - 2)
    else
      where.Text := s;
    smask.Text := trim(ExtractRealName(ParamStr(2)));
    //////GS!!!//////
    if options.Checked[6] then
      begin
      if not checksafe(smask.Text) then
        begin
        if messagedlg(
          'Среди файлов, которые могут быть найдены (и удалены) при данном поиске могут быть важные, действительно продолжить?',
          mtConfirmation, mbOkCancel, 0) = idOk then
          gotosearch(self);
        end
      else
        gotosearch(self);

      end
    else
      gotosearch(self);
    /////////

    end;
end;



procedure TFDCMAIN.tnClick(Sender: TObject);
var
  al: boolean;
begin
  al := tn.Checked;
  hid.Enabled := al;
  sys.Enabled := al;
  arc.Enabled := al;
  ro.Enabled := al;
end;

procedure TFDCMAIN.Freshpreset(Sender: TObject);
var
  E: TNotifyEvent;
begin
  if spreset.ItemIndex <> -1 then
    begin
    e := smask.OnChange;
    smask.OnChange := nil;
    smask.Text := templ.Values[spreset.Items[spreset.ItemIndex]];
    smask.OnChange := e;
    preset.ItemIndex := preset.Items.IndexOf(spreset.Items[spreset.ItemIndex]);
    end;
  deltempl.Enabled := spreset.ItemIndex <> -1;
  chtempl.Enabled  := spreset.ItemIndex <> -1;
  preset.Hint      := 'Шаблон поиска: ' + spreset.Items[preset.ItemIndex] + #13#10 +
    'Маски файлов: ' + smask.Text;
end;

procedure TFDCMAIN.spresetKeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  FreshPreset(Self);
end;

procedure TFDCMAIN.mxFlaTButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TFDCMAIN.PCChange(Sender: TObject);
begin
  if (pc.ActivePage = tabsheet9) then
    refr.Enabled := True
  else
    refr.Enabled := False;

  if (pc.ActivePage = tabsheet11) then
    pc3change(nil)
  else
  if (pc.ActivePage = tabsheet6) then
    begin
    qchk.Items.BeginUpdate;
    qchk.Items.Clear;
    qchk.Items.Add('[Не использовать этот метод очистки]');
    qchk.Items.AddStrings(spreset.Items);
    qchk.ItemIndex := 0;
    qchk.Items.EndUpdate;
    end;

end;

procedure TFDCMAIN.listviewClick(Sender: TObject);
begin
  if (view.listviewf.Items.Count > 0) and (view.listviewf.ItemIndex >= 0) and
    (view.listviewf.SelCount > 0) then
    view.listviewf.Items[view.listviewf.ItemIndex].Checked :=
      not view.listviewf.Items[view.listviewf.ItemIndex].Checked;
end;

procedure TFDCMAIN.ClrClick(Sender: TObject);
begin
  pc.Enabled  := False;
  clr.Enabled := False;
  if clearopt.Checked[0] then
    SHEmptyRecycleBin(0, nil, SHERB_NOCONFIRMATION or SHERB_NOPROGRESSUI);
  if clearopt.Checked[1] then
    SHAddToRecentDocs(0, nil);
  if clearopt.Checked[2] then
    IECache;
  if clearopt.Checked[3] then
    XDir(Tempdir);
  if clearopt.Checked[4] then
    delhistory;
  if clearopt.Checked[5] then
    delpref;
  if clearopt.Checked[6] then
    delwmp;
  clr.Enabled := True;
  pc.Enabled  := True;
end;

procedure TFDCMAIN.coolTimer(Sender: TObject);
begin
  if not clonemode then
    begin
    if not fillmode then
      begin
      FdcMain.AllFiles.Progress := totalsize div 1024 div 1024;
      FdcMain.Total.Caption     := Format('Найдено %d файлов', [Count]);
      if foundsize > 0 then
        FdcMain.Found.Caption := format('%f Мб', [FoundSize / 1024 / 1024]);
      FdcMain.CurPath.Caption := curr;
      end
    else
      begin
      FdcMain.AllFiles.Progress := fillpos;
      end;

    end
  else
    view.sb.SimpleText := format('Проверено %d из %d', [Checked, Count]);
end;


procedure TFDCMAIN.clearClick(Sender: TObject);
begin
  pc.Enabled    := False;
  Clear.Caption := 'Ждите';
  refr.Enabled  := False;
  Clear.Enabled := False;
  Mem.FreeRAM(Slider.Position);
  refr.Enabled := True;
  Clear.Enabled := True;
  Clear.Caption := 'Очистка';
  barfree.Position := 1;
  pc.Enabled := True;
end;

procedure TFDCMAIN.Timer1Timer(Sender: TObject);
var
  RAMAvailable, RAMTotal: integer;
begin
  RAMAvailable  := Mem.GetMemoryStatus.AvailPhys;
  RAMTotal      := Mem.GetMemoryStatus.TotalPhys;
  MemAv.Caption := Format('Доступно %d МБ из %d МБ', [RAMAvailable, RAMTotal]);
end;

procedure TFDCMAIN.SliderChange(Sender: TObject);
begin
  proc.Caption := Format(' %d МБ', [slider.Position]);
end;

procedure TFDCMAIN.makereport;
begin
  if strdest = norm then
    begin
    pc.Enabled      := False;
    obn.Enabled     := False;
    savenow.Enabled := False;
    Otc.Clear;
    otc.Lines.BeginUpdate;
    end
  else
    strbuf.Clear;
  add('Отчет за: ' + datetostr(date) + ' / ' + timetostr(time));
  add('');
  add('--------- Windows ------------');
  ReadReg;
  OSInfo;
  add('Версия ОС (реестр): ' + WinVer);
  add('Имя продукта (ОС, реестр): ' + WinProduct);
  add('Имя Windows Plus! (ОС, реестр): ' + WinPlus);
  if nt then
    add('Билд Windows: ' + WinSP);
  add('Номер Windows при установке: ' + WinID);
  if not nt then
    add('Ключ Windows при установке: ' + WinKey);
  if BinEnabled then
    begin
    add('Корзина используется');
    add('Выделено диска под корзину: ' + IntToStr(binpersent) + ' %');
    end
  else
    add('Файлы удаляются в обход корзины Windows (tm)');
  passwasrun := False;
  GetPass(@addpass);
  CPUINFO;
  add('--------- Имена ------------');
  NonHardwareInfo;
  add('--------- Принтеры ------------');
  add(Format('Принтер по-умолчанию: %s', [getdefaultprn]));
  add('--------- Память ------------');
  MemoryInfo;
  add('--------- Поддержка национальных языков ---------');
  add('OEM кодовая страница: ' + IntToStr(GetOEMCP));
  add('ANSI кодовая страница: ' + IntToStr(GetACP));
  add('--------- Системные параметры ---------');
  ParametersInfo;
  add('--------- БИОС ----------------');
  if not nt then
    BIOSInfo
  else
    BIOSinfoNT;
  add('--------- Коммуникационные порты -----------------');
  writecoms;
  add('--------- Рабочий стол ----------');
  if IsActiveDeskTopOn then
    add('Активный рабочий стол: Да')
  else
    add('Активный рабочий стол: Нет');
  VideoInfo;
  add('Обои на рабочем столе: ' + GetWallpaper);
  add('--------- Автозапуск -----------');
  writerun;
  add('--------- Процессы ------------');
  listproc;
  add('--------- Переменные окружения ----------');
  envlist;
  add('--------------------------------------');
  if strdest = norm then
    begin
    otc.Lines.EndUpdate;
    obn.Enabled     := True;
    savenow.Enabled := True;
    pc.Enabled      := True;
    end;
end;

procedure TFDCMAIN.Saveit(Sender: TObject);
begin
  pc.Enabled      := False;
  savenow.Enabled := False;
  Otc.Enabled     := False;
  savedialog.Filter := '*.txt|*.txt';
  savedialog.FileName := 'c:\sysinfo_' + FormatDateTime('DD.MMMM.YYYY', now) + '.txt';
  savedialog.InitialDir := 'c:\';
  savedialog.Title := 'Сохранение отчета';
  savedialog.DefaultExt := '.txt';
  if savedialog.Execute then
    otc.Lines.SaveToFile(savedialog.FileName);
  pc.Enabled      := True;
  Otc.Enabled     := True;
  savenow.Enabled := True;
end;

procedure TFDCMAIN.sldChange(Sender: TObject);
begin
  refr.Interval := sld.Position * 10;
  upd.Caption   := 'Обновлять каждые ' + IntToStr(sld.Position * 10) + ' мс';
end;

procedure TFDCMAIN.assocChange(Sender: TObject);
var
  t: string;
begin
  if assoc.ItemIndex <> -1 then
    begin
    t := obj[assoc.ItemIndex + 1].ext;
    if Trim(smask.Text) = '' then
      smask.Text := t
    else
    if pos(t, smask.Text) = 0 then
      smask.Text := smask.Text + ';' + t;
    end;
end;


procedure TFDCMAIN.DelSoftClick(Sender: TObject);
begin
  if FdcMain.installed.ItemIndex <> -1 then
    if messagedlg('Действительно убрать запись ''' +
      FdcMain.installed.Items[FdcMain.installed.ItemIndex].Caption +
      ''' из списка деинсталляции?', mtConfirmation, mbOkCancel, 0) <> idOk then
      exit;
  installed.Enabled := False;
  delsoft.Enabled   := False;
  installed.Items.BeginUpdate;
  delinstalled;
  delsoft.Enabled := True;
  installed.Items.EndUpdate;
  installed.Enabled := True;
end;

procedure TFDCMAIN.RefSoftClick(Sender: TObject);
begin
  RefSoft.Enabled := False;
  installed.Clear;
  installed.Items.BeginUpdate;
  GetInstalled;
  installed.Items.EndUpdate;
  RefSoft.Enabled := True;
end;

procedure TFDCMAIN.RunSoftClick(Sender: TObject);
begin
  if FdcMain.installed.ItemIndex <> -1 then
    if messagedlg('Действительно деинсталлировать ''' +
      FdcMain.installed.Items[FdcMain.installed.ItemIndex].Caption +
      '''?', mtConfirmation, mbOkCancel, 0) <> idOk then
      exit;
  RunSoft.Enabled := False;
  if FdcMain.installed.ItemIndex >= 0 then
    WinExec(PChar(installed.Items[installed.ItemIndex].SubItems[1]), SW_Show);
  RunSoft.Enabled := True;
end;


procedure TFDCMAIN.smClick(Sender: TObject);

  procedure AddSC(F, N, P: string);
  var
    shortcut: TStShortCut;
  begin
    shortcut      := TStShortCut.Create(nil);
    shortcut.SpecialFolder := sfPrograms;
    shortcut.FileName := F;
    shortcut.IconIndex := 0;
    shortcut.SDir := 'НИИ Dark Software\FDK';
    shortcut.Description := N;
    shortcut.IconPath := F;
    shortcut.ShortcutFileName := F + '.lnk';
    shortcut.Parameters := P;
    shortcut.CreateShortcut;
    shortcut.Free;
  end;

begin
  addsc(mypath + 'fdk.exe', 'FDK', '');
  addsc(mypath + 'readme.txt', 'Руководство пользователя', '');
  addsc(mypath + 'news.txt', 'Новости', '');
  addsc(mypath + 'plugins.txt', 'Инструкция по написанию плагинов', '');
  addsc(mypath + 'tasks.txt', 'Инструкция по написанию задач', '');
  addsc(mypath + 'hotcd.url', 'Диски почтой по 50 рублей', '');
  addsc(mypath + 'darksoftware.url', 'Сайт НИИ DarkSoftware', '');
  addsc(mypath + 'scripts', 'Скрипты', '');
  addsc(mypath + 'plugins', 'Плагины', '');
  addsc(mypath + '~trash', 'Отсеяные плагины', '');
  addsc(mypath + 'usr', 'Файлы пользователя', '');
  addsc(mypath + 'fdk.exe', 'Удалить FDK', '-uninstallwizard');
  options.Checked[1] := False;
end;

procedure TFDCMAIN.dsClick(Sender: TObject);
var
  shortcut: TStShortCut;
begin
  shortcut := TStShortCut.Create(nil);
  shortcut.SpecialFolder := sfDeskTop;
  shortcut.FileName := application.ExeName;
  shortcut.IconIndex := 0;
  shortcut.Description := 'FDK';
  shortcut.IconPath := application.ExeName;
  shortcut.ShortcutFileName := 'FDK.Lnk';
  shortcut.CreateShortcut;
  shortcut.Free;
  options.Checked[0] := False;
end;

procedure TFDCMAIN.SFRClick(Sender: TObject);
begin
  Sfr.Enabled := False;
  Sfr.Caption := 'Ждите';
  SysF.Items.BeginUpdate;
  SysF.Clear;
  GetShellFolders;
  SysF.Items.EndUpdate;
  sfr.Enabled := True;
  Sfr.Caption := 'Обновить';
end;

procedure TFDCMAIN.changeClick(Sender: TObject);
var
  BM: TBitmap;
begin
  opd.Filter     := '*.bmp|*.bmp';
  opd.FileName   := 'c:\default.bmp';
  opd.InitialDir := 'c:\';
  opd.Title      := 'Выбор изображения';
  opd.DefaultExt := '.bmp';

  if opd.Execute then
    begin
    bm := TBitmap.Create;
    bm.LoadFromFile(opd.FileName);
    if (bm.Width <= 160) and (bm.Height <= 120) then
      begin
      oemlogo.Picture.LoadFromFile(opd.FileName);
      oe := opd.FileName;
      apply.Enabled := True;
      end
    else
      begin
      ShowMessage('Необходимо изображение в пределах 160x120!');
      apply.Enabled := False;
      end;
    bm.Free;
    end;
end;

procedure TFDCMAIN.applyClick(Sender: TObject);
var
  Oeminfo: Tinifile;
  i: integer;
begin
  if (oe <> '') then
    begin
    reset.Click;
    oeminfo := Tinifile.Create(WinSysDir + 'oeminfo.ini');
    CopyFile(PChar(OE), PChar(WinSysDir + 'oemlogo.bmp'), False);
    oeminfo.WriteString('General', 'Manufacturer', proiz.Text);
    oeminfo.WriteString('General', 'Model', model.Text);
    oeminfo.WriteString('General', 'SupportURL', site.Text);
    oeminfo.WriteString('General', 'LocalFile', local.Text);
    if sinfo.Lines.Count >= 1 then
      for i := 0 to sinfo.Lines.Count do
        if Trim(sinfo.Lines[i]) <> '' then
          oeminfo.WriteString('Support Information', 'Line' + IntToStr(i + 1),
            sinfo.Lines[i]);
    oeminfo.UpdateFile;
    oeminfo.Free;
    end
  else
    ShowMessage('Укажите логотип!');
end;

procedure TFDCMAIN.resetClick(Sender: TObject);
begin
  if messagedlg('Действительно удалить OEM - информацию?', mtConfirmation,
    mbOkCancel, 0) = idOk then
    begin
    deletefileadv((WinSysDir + 'oeminfo.ini'));
    deletefileadv((WinSysDir + 'oemlogo.bmp'));
    end;
end;

procedure TFDCMAIN.SFCClick(Sender: TObject);
begin
  sfc.Enabled := False;
  CHSF;
  sfc.Enabled := True;
end;

procedure TFDCMAIN.pc3Change(Sender: TObject);
begin
  if (pc3.ActivePage = tabsheet27) then
    trefr.Click
  else
  if (pc3.ActivePage = tabsheet26) then
    lrefr.Click
  else
  if (pc3.ActivePage = tabsheet24) then
    rshared.Click
  else
  if (pc3.ActivePage = tabsheet25) then
    SFR.Click
  else
  if (pc3.ActivePage = tabsheet16) then
    refsoft.Click
  else
  if (pc3.ActivePage = tabsheet18) then
    typesref.Click
  else
  if (pc3.ActivePage = tabsheet29) then
    arref.Click
  else
  if (pc3.ActivePage = tabsheet32) then
    refs.Click

  else
  if (pc3.ActivePage = tabsheet8) then
    begin
    if nt then
      SFresh.Click;
    end
  else
  if (pc3.ActivePage = tabsheet2) then
    if not nt then
      update9xservclick(nil);

end;

procedure TFDCMAIN.SysFDblClick(Sender: TObject);
begin
  sfc.Click;
end;

procedure TFDCMAIN.refMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clYellow;
end;

procedure TFDCMAIN.refMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clLime;
end;

procedure TFDCMAIN.alldisksClick(Sender: TObject);
begin
  where.Enabled  := not alldisks.Checked;
  browse.Enabled := not alldisks.Checked;
  current_drive  := 1;
  where.Text     := 'C:\';
end;

procedure TFDCMAIN.roClick(Sender: TObject);
begin
  if byte(hid.Checked) + byte(sys.Checked) + byte(ro.Checked) +
  byte(arc.Checked) in [0, 4] then
    tn.Checked := False;

end;


procedure TFDCMAIN.N1Click(Sender: TObject);
begin
  if (view.listviewf.Items.Count > 0) and (view.listviewf.ItemIndex >= 0) and
    (view.listviewf.SelCount > 0) then
    ShowObjectPropertiesDialog(view.listviewf.Items[view.listviewf.ItemIndex].Caption,
      sdPathObject, '');

end;

procedure TFDCMAIN.PopupMenu1Popup(Sender: TObject);
var
  r:    TDarkRegistry;
  n, l: string;
  ke:   boolean;
begin
  N1.Enabled := (view.listviewf.Items.Count > 0) and
    (view.listviewf.ItemIndex <> -1) and (view.listviewf.SelCount > 0);
  N6.Enabled := (view.listviewf.Items.Count > 0) and
    (view.listviewf.ItemIndex <> -1) and (view.listviewf.SelCount > 0);
  if N1.Enabled then
    begin
    r := TDarkRegistry.Create;
    r.RootKey := HKEY_Classes_Root;
    ///////////
    n := ExtractFileExt(view.listviewf.Items[view.listviewf.ItemIndex].Caption);
    repeat
      ke := r.KeyExists('\' + n);
      if ke then
        begin
        r.OpenKey('\' + n);
        l := n;
        n := Trim(r.ReadString(''));
        if l = n then
          n := '';
        end;
    until (ke = False) or (n = '');
    //////////
    n6.Caption := 'Открыть как ' + n;
    r.CloseKey;
    r.Free;
    end;

end;

procedure TFDCMAIN.refrplugClick(Sender: TObject);
var
  R:      TDarkRegistry;
  vt:     TVT;
  valuex: variant;
  rawdata: traw;
  i:      integer;
  ini:    TIniFile;
  cfg:    TCfg;
  valstate: (ok, nokey, noval);

  function comparearrays(A, B: TRaw; size: integer): boolean;
  var
    i: integer;
  begin
    Result := False;
    for i := 0 to size - 1 do
      if a[i] <> b[i] then
        exit;
    Result := True;
  end;

begin
  if cheats.ItemIndex = -1 then
    exit;
  cheats.Enabled := False;
  radio.Visible  := not tweaks[cheats.ItemIndex].User;
  Value.Visible  := tweaks[cheats.ItemIndex].User;

  if tweaks[cheats.ItemIndex].TweakType = ttreg then
    begin
    ////////////////// REGISTRY

    r := TDarkRegistry.Create;
    case tweaks[cheats.ItemIndex].Root_Key
      of
      hkcu:
        r.RootKey := HKEY_CURRENT_USER;
      hklm:
        r.RootKey := HKEY_LOCAL_MACHINE;
      hkcc:
        r.RootKey := HKEY_CURRENT_CONFIG;
      hku:
        r.RootKey := HKEY_USERS;
      hkcr:
        r.RootKey := HKEY_CLASSES_ROOT;
      end;

    vt := tweaks[cheats.ItemIndex].value_type;

    if not (r.keyexists(tweaks[cheats.ItemIndex].Path)) then
      valstate := nokey
    else
      begin
      r.OpenKey(tweaks[cheats.ItemIndex].Path);
      if r.ValueExists(tweaks[cheats.ItemIndex].Value_Name) then

        case vt
          of
          dtSTR:
            valuex := r.ReadString(tweaks[cheats.ItemIndex].Value_Name);
          dtINT:
            valuex := r.ReadInteger(tweaks[cheats.ItemIndex].Value_Name);
          dtBin:
            begin
            SetLength(rawdata, tweaks[cheats.ItemIndex].size + 1);
            r.ReadBinaryData(tweaks[cheats.ItemIndex].Value_Name, rawdata[0],
              tweaks[cheats.ItemIndex].size);
            valuex := TRaw(rawdata);
            end;

          end
      else
        begin
        valstate := noval;
        if vt <> dtBin then
          valuex := tweaks[cheats.ItemIndex].Default
        else
          valuex := TRaw(tweaks[cheats.ItemIndex].Default);
        end;
      end;
    Value.Text := '';
    if vt <> dtBin then
      Value.Text := valuex
    else
      for i := 0 to tweaks[cheats.ItemIndex].size - 1 do
        Value.Text := Value.Text + inttohex(TRaw(valuex)[i], 2);

    defval.Text := '';
    if vt <> dtBin then
      defval.Text := tweaks[cheats.ItemIndex].Default
    else
      for i := 0 to tweaks[cheats.ItemIndex].size - 1 do
        defval.Text := defval.Text + inttohex(
          Traw(tweaks[cheats.ItemIndex].Default)[i], 2);

    if not tweaks[cheats.ItemIndex].User then
      begin

      if vt <> dtBin then
        if (((valstate = ok) and (valuex = tweaks[cheats.ItemIndex].Val_ON) and
          (not tweaks[cheats.ItemIndex].Val_ON_MDV) and
          (not tweaks[cheats.ItemIndex].Val_ON_MDK)) or
          ((valstate = noval) and (tweaks[cheats.ItemIndex].Val_On_MDV)) or
          ((valstate = nokey) and (tweaks[cheats.ItemIndex].Val_On_MDK))) then
          radio.ItemIndex := 0
        else
          radio.ItemIndex := 1
      else
      if ((comparearrays(TRaw(Valuex), TRaw(tweaks[cheats.ItemIndex].Val_ON),
        tweaks[cheats.ItemIndex].size)) and (valstate = ok) and
        (not tweaks[cheats.ItemIndex].Val_ON_MDV) and
        (not tweaks[cheats.ItemIndex].Val_ON_MDK)) or
        ((valstate = noval) and tweaks[cheats.ItemIndex].Val_On_MDV) or
        ((valstate = nokey) and tweaks[cheats.ItemIndex].Val_On_MDK) then
        radio.ItemIndex := 0
      else
        radio.ItemIndex := 1;
      if vt <> dtBin then
        if (tweaks[cheats.ItemIndex].Default = tweaks[cheats.ItemIndex].Val_On) or
          (tweaks[cheats.ItemIndex].Default_MDV and
          tweaks[cheats.ItemIndex].Val_On_MDV) or
          (tweaks[cheats.ItemIndex].Default_MDK and
          tweaks[cheats.ItemIndex].Val_On_MDK) then
          defval.Text := 'ДА'
        else
          defval.Text := 'НЕТ'
      else
      if comparearrays(TRaw(Valuex), TRaw(tweaks[cheats.ItemIndex].Val_ON),
        tweaks[cheats.ItemIndex].size) or
        (tweaks[cheats.ItemIndex].Default_MDV and
        tweaks[cheats.ItemIndex].Val_On_MDV) or
        (tweaks[cheats.ItemIndex].Default_MDK and
        tweaks[cheats.ItemIndex].Val_On_MDK) then
        defval.Text := 'ДА'
      else
        defval.Text := 'НЕТ';
      end;
    r.CloseKey;
    r.Free;
    end
  else
  if tweaks[cheats.ItemIndex].TweakType = ttini then
    begin
    /////////////END OF REGISTRY

    ////////////////// INIFILE //////////////////////////////////////////////////

    ini := TIniFile.Create(tweaks[cheats.ItemIndex].Path);
    vt  := tweaks[cheats.ItemIndex].value_type;
    if not ini.SectionExists(tweaks[cheats.ItemIndex].Section) then
      valstate := nokey
    else
    if ini.ValueExists(tweaks[cheats.ItemIndex].Section,
      tweaks[cheats.ItemIndex].Value_Name) then
      case vt
        of
        dtSTR:
          valuex := ini.ReadString(tweaks[cheats.ItemIndex].Section,
            tweaks[cheats.ItemIndex].Value_Name, tweaks[cheats.ItemIndex].Default);
        dtINT:
          valuex := ini.ReadInteger(tweaks[cheats.ItemIndex].Section,
            tweaks[cheats.ItemIndex].Value_Name, tweaks[cheats.ItemIndex].Default);
        dtBin: ;

        end
    else
      begin
      valstate := noval;
      if vt <> dtBin then
        valuex := tweaks[cheats.ItemIndex].Default
      else
        valuex := TRaw(tweaks[cheats.ItemIndex].Default);
      end; //SE
    Value.Text := '';
    if vt <> dtBin then
      Value.Text := valuex
    else
      for i := 0 to tweaks[cheats.ItemIndex].size - 1 do
        Value.Text := Value.Text + inttohex(TRaw(valuex)[i], 2);

    defval.Text := '';
    if vt <> dtBin then
      defval.Text := tweaks[cheats.ItemIndex].Default
    else
      for i := 0 to tweaks[cheats.ItemIndex].size - 1 do
        defval.Text := defval.Text + inttohex(
          Traw(tweaks[cheats.ItemIndex].Default)[i], 2);

    if not tweaks[cheats.ItemIndex].User then
      begin

      if vt <> dtBin then
        if (((valstate = ok) and (valuex = tweaks[cheats.ItemIndex].Val_ON) and
          (not tweaks[cheats.ItemIndex].Val_ON_MDV) and
          (not tweaks[cheats.ItemIndex].Val_ON_MDK)) or
          ((valstate = noval) and (tweaks[cheats.ItemIndex].Val_On_MDV)) or
          ((valstate = nokey) and (tweaks[cheats.ItemIndex].Val_On_MDK))) then
          radio.ItemIndex := 0
        else
          radio.ItemIndex := 1
      else
      if ((comparearrays(TRaw(Valuex), TRaw(tweaks[cheats.ItemIndex].Val_ON),
        tweaks[cheats.ItemIndex].size)) and (valstate = ok) and
        (not tweaks[cheats.ItemIndex].Val_ON_MDV) and
        (not tweaks[cheats.ItemIndex].Val_ON_MDK)) or
        ((valstate = noval) and tweaks[cheats.ItemIndex].Val_On_MDV) or
        ((valstate = nokey) and tweaks[cheats.ItemIndex].Val_On_MDK) then
        radio.ItemIndex := 0
      else
        radio.ItemIndex := 1;
      if vt <> dtBin then
        if (tweaks[cheats.ItemIndex].Default = tweaks[cheats.ItemIndex].Val_On) or
          (tweaks[cheats.ItemIndex].Default_MDV and
          tweaks[cheats.ItemIndex].Val_On_MDV) or
          (tweaks[cheats.ItemIndex].Default_MDK and
          tweaks[cheats.ItemIndex].Val_On_MDK) then
          defval.Text := 'ДА'
        else
          defval.Text := 'НЕТ'
      else
      if comparearrays(TRaw(Valuex), TRaw(tweaks[cheats.ItemIndex].Val_ON),
        tweaks[cheats.ItemIndex].size) or
        (tweaks[cheats.ItemIndex].Default_MDV and
        tweaks[cheats.ItemIndex].Val_On_MDV) or
        (tweaks[cheats.ItemIndex].Default_MDK and
        tweaks[cheats.ItemIndex].Val_On_MDK) then
        defval.Text := 'ДА'
      else
        defval.Text := 'НЕТ';
      end;
    ini.Free;

    end
  ///////////// END OF INIFILE /////////////////////////////////////////////
  else
  if tweaks[cheats.ItemIndex].TweakType = ttcfg then
    begin
    cfg := TCFG.Create(tweaks[cheats.ItemIndex].Path);
    vt  := tweaks[cheats.ItemIndex].value_type;
    case vt
      of
      dtSTR:
        valuex := cfg.ReadString(tweaks[cheats.ItemIndex].Value_Name,
          tweaks[cheats.ItemIndex].Default);
      dtINT:
        valuex := cfg.ReadInteger(tweaks[cheats.ItemIndex].Value_Name,
          tweaks[cheats.ItemIndex].Default);
      dtBin: ;

      end;
    Value.Text := '';
    if vt <> dtBin then
      Value.Text := valuex
    else
      for i := 0 to tweaks[cheats.ItemIndex].size - 1 do
        Value.Text := Value.Text + inttohex(TRaw(valuex)[i], 2);

    defval.Text := '';
    if vt <> dtBin then
      defval.Text := tweaks[cheats.ItemIndex].Default
    else
      for i := 0 to tweaks[cheats.ItemIndex].size - 1 do
        defval.Text := defval.Text + inttohex(
          Traw(tweaks[cheats.ItemIndex].Default)[i], 2);

    if not tweaks[cheats.ItemIndex].User then
      begin

      if vt <> dtBin then
        if (((valstate = ok) and (valuex = tweaks[cheats.ItemIndex].Val_ON) and
          (not tweaks[cheats.ItemIndex].Val_ON_MDV) and
          (not tweaks[cheats.ItemIndex].Val_ON_MDK)) or
          ((valstate = noval) and (tweaks[cheats.ItemIndex].Val_On_MDV)) or
          ((valstate = nokey) and (tweaks[cheats.ItemIndex].Val_On_MDK))) then
          radio.ItemIndex := 0
        else
          radio.ItemIndex := 1
      else
      if ((comparearrays(TRaw(Valuex), TRaw(tweaks[cheats.ItemIndex].Val_ON),
        tweaks[cheats.ItemIndex].size)) and (valstate = ok) and
        (not tweaks[cheats.ItemIndex].Val_ON_MDV) and
        (not tweaks[cheats.ItemIndex].Val_ON_MDK)) or
        ((valstate = noval) and tweaks[cheats.ItemIndex].Val_On_MDV) or
        ((valstate = nokey) and tweaks[cheats.ItemIndex].Val_On_MDK) then
        radio.ItemIndex := 0
      else
        radio.ItemIndex := 1;
      if vt <> dtBin then
        if (tweaks[cheats.ItemIndex].Default = tweaks[cheats.ItemIndex].Val_On) or
          (tweaks[cheats.ItemIndex].Default_MDV and
          tweaks[cheats.ItemIndex].Val_On_MDV) or
          (tweaks[cheats.ItemIndex].Default_MDK and
          tweaks[cheats.ItemIndex].Val_On_MDK) then
          defval.Text := 'ДА'
        else
          defval.Text := 'НЕТ'
      else
      if comparearrays(TRaw(Valuex), TRaw(tweaks[cheats.ItemIndex].Val_ON),
        tweaks[cheats.ItemIndex].size) or
        (tweaks[cheats.ItemIndex].Default_MDV and
        tweaks[cheats.ItemIndex].Val_On_MDV) or
        (tweaks[cheats.ItemIndex].Default_MDK and
        tweaks[cheats.ItemIndex].Val_On_MDK) then
        defval.Text := 'ДА'
      else
        defval.Text := 'НЕТ';
      end;
    cfg.Free;

    end;

  cheats.Enabled := True;
end;

procedure TFDCMAIN.saveplugClick(Sender: TObject);
var
  R:      TDarkRegistry;
  valuex: variant;
  vt:     TVT;
  raw:    TRaw;
  ini:    TIniFile;
  cfg:    TCFG;
  operation: (_normal, _delvalue, _delkey);

  function ParseRaw(Data: string; size: integer): boolean;
  var
    i, c: integer;
  begin
    Result := False;
    if length(Data) <> size * 2 then
      exit;
    for i := 1 to length(Data) do
      if not (UpCase(Data[i]) in ['A'..'F', '0'..'9']) then
        exit;
    c := 0;
    i := 1;
    repeat
      raw[c] := strtointdef('$' + copy(Data, i, 2), 0);
      Inc(c);
      Inc(i, 2);
    until i > length(Data);
    Result := True;
  end;

begin
  if cheats.ItemIndex = -1 then
    exit;
  cheats.Enabled := False;
  if tweaks[cheats.ItemIndex].TweakType = ttreg then
    begin
    ////////////////////////////////// REGISTRY
    r := TDarkRegistry.Create;
    case tweaks[cheats.ItemIndex].Root_Key
      of
      hkcu:
        r.RootKey := HKEY_CURRENT_USER;
      hklm:
        r.RootKey := HKEY_LOCAL_MACHINE;
      hkcc:
        r.RootKey := HKEY_CURRENT_CONFIG;
      hku:
        r.RootKey := HKEY_USERS;
      hkcr:
        r.RootKey := HKEY_CLASSES_ROOT;

      end;
    vt := tweaks[cheats.ItemIndex].value_type;

    if not tweaks[cheats.ItemIndex].User then
      case
        radio.ItemIndex of
        0:
          if tweaks[cheats.ItemIndex].Val_ON_MDV then
            operation := _delvalue
          else
          if tweaks[cheats.ItemIndex].Val_ON_MDK then
            operation := _delkey
          else
          if vt <> dtBin then
            valuex := tweaks[cheats.ItemIndex].Val_ON
          else
            raw    := TRaw(tweaks[cheats.ItemIndex].Val_ON);
        1:
          if tweaks[cheats.ItemIndex].Val_OFF_MDV then
            operation := _delvalue
          else
          if tweaks[cheats.ItemIndex].Val_OFF_MDK then
            operation := _delkey
          else
          if vt <> dtBin then
            valuex := tweaks[cheats.ItemIndex].Val_OFF
          else
            raw    := TRaw(tweaks[cheats.ItemIndex].Val_OFF);
        end
    else
    if vt <> dtBin then
      valuex := Value.Text
    else
      begin
      SetLength(Raw, tweaks[cheats.ItemIndex].size);
      if not parseraw(Value.Text, tweaks[cheats.ItemIndex].size) then
        raw := TRaw(tweaks[cheats.ItemIndex].Default);

      end;

    if operation = _delvalue then
      begin
      r.OpenKey(tweaks[cheats.ItemIndex].Path);
      r.DeleteValue(tweaks[cheats.ItemIndex].Value_Name);
      end
    else
    if operation = _delkey then
      r.DeleteKey(tweaks[cheats.ItemIndex].Path)
    else
      case vt
        of
        dtINT:
          begin
          r.OpenKey(tweaks[cheats.ItemIndex].Path);
          r.WriteInteger(tweaks[cheats.ItemIndex].Value_Name, valuex);
          end;
        dtSTR:
          begin
          r.OpenKey(tweaks[cheats.ItemIndex].Path);
          r.WriteString(tweaks[cheats.ItemIndex].Value_Name, valuex);
          end;
        dtBin:
          begin
          r.OpenKey(tweaks[cheats.ItemIndex].Path);
          r.WriteBinaryData(tweaks[cheats.ItemIndex].Value_Name, Raw[0],
            tweaks[cheats.ItemIndex].size);
          end;
        end;
    r.CloseKey;
    r.Free;

    end
  else
  if tweaks[cheats.ItemIndex].TweakType = ttini then
    begin
    ////////////////////////////////// END OF REGISTRY
    ////////////////////////////////// INI FILE
    ini := TiniFile.Create(tweaks[cheats.ItemIndex].Path);
    vt  := tweaks[cheats.ItemIndex].value_type;
    if not tweaks[cheats.ItemIndex].User then
      case
        radio.ItemIndex of
        0:
          if tweaks[cheats.ItemIndex].Val_ON_MDV then
            operation := _delvalue
          else
          if tweaks[cheats.ItemIndex].Val_ON_MDK then
            operation := _delkey
          else
          if vt <> dtBin then
            valuex := tweaks[cheats.ItemIndex].Val_ON
          else
            raw    := TRaw(tweaks[cheats.ItemIndex].Val_ON);
        1:
          if tweaks[cheats.ItemIndex].Val_OFF_MDV then
            operation := _delvalue
          else
          if tweaks[cheats.ItemIndex].Val_OFF_MDK then
            operation := _delkey
          else
          if vt <> dtBin then
            valuex := tweaks[cheats.ItemIndex].Val_OFF
          else
            raw    := TRaw(tweaks[cheats.ItemIndex].Val_OFF);
        end
    else
    if vt <> dtBin then
      valuex := Value.Text
    else
      begin
      SetLength(Raw, tweaks[cheats.ItemIndex].size);
      if not parseraw(Value.Text, tweaks[cheats.ItemIndex].size) then
        raw := TRaw(tweaks[cheats.ItemIndex].Default);

      end;

    if operation = _delvalue then
      ini.DeleteKey(tweaks[cheats.ItemIndex].Section,
        tweaks[cheats.ItemIndex].Value_Name)
    else
    if operation = _delkey then
      ini.EraseSection(tweaks[cheats.ItemIndex].Section)
    else
      case vt
        of
        dtINT:
          ini.WriteInteger(tweaks[cheats.ItemIndex].Section,
            tweaks[cheats.ItemIndex].Value_Name, valuex);
        dtSTR:
          ini.WriteString(tweaks[cheats.ItemIndex].Section,
            tweaks[cheats.ItemIndex].Value_Name, valuex);
        dtBin: ;
        end;
    ini.Free;
    end
  ////////////////
  else
  if tweaks[cheats.ItemIndex].TweakType = ttcfg then
    begin
    ////////////////////////////////// END OF REGISTRY
    ////////////////////////////////// INI FILE
    cfg := TCFG.Create(tweaks[cheats.ItemIndex].Path);
    vt  := tweaks[cheats.ItemIndex].value_type;
    if not tweaks[cheats.ItemIndex].User then
      case
        radio.ItemIndex of
        0:
          if tweaks[cheats.ItemIndex].Val_ON_MDV then
            operation := _delvalue
          else
          if tweaks[cheats.ItemIndex].Val_ON_MDK then
            operation := _delkey
          else
          if vt <> dtBin then
            valuex := tweaks[cheats.ItemIndex].Val_ON
          else
            raw    := TRaw(tweaks[cheats.ItemIndex].Val_ON);
        1:
          if tweaks[cheats.ItemIndex].Val_OFF_MDV then
            operation := _delvalue
          else
          if tweaks[cheats.ItemIndex].Val_OFF_MDK then
            operation := _delkey
          else
          if vt <> dtBin then
            valuex := tweaks[cheats.ItemIndex].Val_OFF
          else
            raw    := TRaw(tweaks[cheats.ItemIndex].Val_OFF);
        end
    else
    if vt <> dtBin then
      valuex := Value.Text
    else
      begin
      SetLength(Raw, tweaks[cheats.ItemIndex].size);
      if not parseraw(Value.Text, tweaks[cheats.ItemIndex].size) then
        raw := TRaw(tweaks[cheats.ItemIndex].Default);

      end;

    if operation = _delvalue then
      cfg.DeleteKey(tweaks[cheats.ItemIndex].Value_Name)
    else
    if operation = _delkey then
      begin
      end
    else
      case vt
        of
        dtINT:
          cfg.WriteInteger(tweaks[cheats.ItemIndex].Value_Name, valuex);
        dtSTR:
          cfg.WriteString(tweaks[cheats.ItemIndex].Value_Name, valuex);
        dtBin: ;
        end;
    cfg.Free;
    end;

  cheats.Enabled := True;
  refrplug.Click;
end;

procedure TFDCMAIN.cheatsSelect(Sender: TObject);
begin
  refrplug.Click;
end;

procedure TFDCMAIN.radioClick(Sender: TObject);
var
  i: integer;
begin
  if cheats.ItemIndex = -1 then
    exit;

  if not tweaks[cheats.ItemIndex].User then
    begin
    Value.Text := '';
    case
      radio.ItemIndex of
      1:
        if tweaks[cheats.ItemIndex].Value_type <> dtbin then
          Value.Text := tweaks[cheats.ItemIndex].Val_off
        else
          for i := 0 to tweaks[cheats.ItemIndex].size - 1 do
            Value.Text := Value.Text + inttohex(
              TRaw(tweaks[cheats.ItemIndex].val_off)[i], 2);
      0:

        if tweaks[cheats.ItemIndex].Value_type <> dtbin then
          Value.Text := tweaks[cheats.ItemIndex].Val_on
        else
          for i := 0 to tweaks[cheats.ItemIndex].size - 1 do
            Value.Text := Value.Text + inttohex(
              TRaw(tweaks[cheats.ItemIndex].val_on)[i], 2);

      end;

    end;
end;

procedure TFDCMAIN.arrefClick(Sender: TObject);
begin
  autorun.Clear;
  findautorun;
end;

procedure TFDCMAIN.Button3Click(Sender: TObject);
var
  str, root, typ: string;
begin
  if (autorun.ItemIndex <> -1) then
    begin
    str  := autorun.Items[autorun.ItemIndex];
    root := copy(str, 1, pos(',', str) - 1);
    str  := copy(str, length(root) + 2, length(str));
    typ  := copy(str, 1, pos(',', str) - 1);
    str  := copy(str, length(typ) + 2, length(str));

    if messagedlg('Действительно удалить ' + str + ' из автозагрузки?',
      mtConfirmation, mbOkCancel, 0) = idOk then
      begin
      setautorun(autorun.Items[autorun.ItemIndex]);
      arref.Click;
      end;
    end;
end;

procedure TFDCMAIN.chtemplClick(Sender: TObject);
var
  s: string;
begin
  if spreset.ItemIndex <> -1 then
    if messagedlg('Действительно изменить заготовку ''' +
      spreset.items[spreset.ItemIndex] + ''''#13#10' на ''' +
      smask.Text + '''?', mtConfirmation, mbOkCancel, 0) = idOk then
      begin
      s := spreset.Items[spreset.ItemIndex];
      templ.values[s] := smask.Text;
      freshtemplates;
      spreset.ItemIndex := spreset.Items.IndexOf(s);
      freshpreset(self);
      end;
end;

procedure TFDCMAIN.deltemplClick(Sender: TObject);
begin
  if messagedlg('Действительно удалить заготовку ''' +
    spreset.items[spreset.ItemIndex] + '''?', mtConfirmation,
    mbOkCancel, 0) = idOk then
    begin
    templ.Values[spreset.items[spreset.ItemIndex]] := '';
    freshtemplates;
    end;
end;

procedure TFDCMAIN.browseClick(Sender: TObject);
var
  s: string;
begin
  s := SysUtils.ExcludeTrailingPathDelimiter(where.Text);
  if inputdir(handle, s, 'Укажите путь для поиска', True) then
    begin
    if pos(ExtractFileDrive(s)[1], getharddrives) > 0 then
      where.Text := s
    else
      ShowMessage('''' + ExtractFileDrive(s)[1] +
        ':'' не является локальным жестким диском.');
    end;
end;


procedure TFDCMAIN.Button4Click(Sender: TObject);
begin
  savedialog.Filter     := '*.fdkar|*.fdkar';
  savedialog.FileName   := mypath + 'autorun_' + FormatDateTime(
    'DD.MMMM.YYYY', now) + '.fdkar';
  savedialog.InitialDir := mypath;
  savedialog.DefaultExt := '.fdkar';
  savedialog.Title      := 'Сохранение шаблона автозагрузки';
  if savedialog.Execute then
    saveruns(savedialog.FileName);
end;

procedure TFDCMAIN.Button5Click(Sender: TObject);
begin
  opendialog.Filter     := '*.fdkar|*.fdkar';
  opendialog.FileName   := mypath + 'default.fdkar';
  opendialog.InitialDir := mypath;
  opendialog.DefaultExt := '.fdkar';
  opendialog.Title      := 'Загрузка шаблона автозагрузки';
  if opendialog.Execute then
    if messagedlg('Действительно заменить записи в автозагрузке?',
      mtConfirmation, mbOkCancel, 0) = idOk then
      loadruns(opendialog.FileName);
  arref.Click;
end;

procedure TFDCMAIN.FormActivate(Sender: TObject);
var
  i: integer;
begin
if nt then begin
otc.Font.Name:='Lucida Console';
otc.Font.Size:=8;
otc.Font.Style:=[];
end else begin
otc.Font.Name:='System';
otc.Font.Size:=8;
otc.Font.Style:=[];
end;
  fdcmain.Update;
  GetXRun;
  gobox.Items.BeginUpdate;
  for i := 0 to pc.PageCount - 1 do
    begin
    gobox.Items.Append(pc.Pages[i].Caption);
    end;
  for i := 0 to pc3.PageCount - 1 do
    begin
    gobox.Items.Append('Система: ' + pc3.Pages[i].Caption);
    end;
  gobox.Items.EndUpdate;
  fdcmain.OnActivate := nil;
end;

procedure FillServices;
var
  r:  TDarkRegistry;
  kn: TStrings;
  i:  integer;
begin
  maxservices := 0;
  setlength(services, 0);
  r := TDarkRegistry.Create;
  r.RootKey := HKey_Local_Machine;
  r.OpenKey('SYSTEM\CurrentControlSet\Services');
  kn := TStringList.Create;
  r.GetKeyNames(kn);
  for i := 0 to kn.Count - 1 do
    begin
    r.CloseKey;
    r.OpenKey('\SYSTEM\CurrentControlSet\Services\' + kn[i]);
    if r.ReadInteger('type') in [$10, $20] then
      begin
      setlength(services, maxservices + 1);
      services[maxservices].Name  :=
        r.ReadString('DisplayName') + ' [' + servicestatus(kn[i]) + ']';
      services[maxservices].start := r.ReadInteger('Start');
      services[maxservices].desc  := r.ReadString('Description');
      services[maxservices].key   := kn[i];
      Inc(maxservices);
      end;
    end;
  kn.Free;
  r.Free;
end;

procedure ApplyServices;
var
  r: TDarkRegistry;
  i: integer;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKey_Local_Machine;
  for i := 0 to maxservices - 1 do
    begin
    r.OpenKey('SYSTEM\CurrentControlSet\Services\' + services[i].key);
    r.WriteInteger('start', services[i].start);
    r.CloseKey;
    end;
  r.Free;
end;


procedure TFDCMAIN.SFreshClick(Sender: TObject);
var
  i, li: integer;
begin
  if not nt then
    exit;
  li := slist.ItemIndex;
  slist.Clear;
  fillservices;
  slist.Items.BeginUpdate;
  for i := 0 to maxservices - 1 do
    slist.Items.Append(services[i].Name);
  slist.Items.EndUpdate;
  slist.ItemIndex := li;
end;

procedure TFDCMAIN.slistDblClick(Sender: TObject);
begin
  if slist.ItemIndex = -1 then
    exit;
  ShowMessage(format('Сервис: %s%sОписание %s',
    [services[slist.ItemIndex].key, #13, services[slist.ItemIndex].desc]));
end;

procedure TFDCMAIN.slistClick(Sender: TObject);
begin
  if slist.ItemIndex = -1 then
    exit;
  srun.ItemIndex := services[slist.ItemIndex].start - 2;
end;

procedure TFDCMAIN.srunClick(Sender: TObject);
begin
  if slist.ItemIndex = -1 then
    exit;
  services[slist.ItemIndex].start := srun.ItemIndex + 2;
end;

procedure TFDCMAIN.SApplyClick(Sender: TObject);
begin
  if not nt then
    exit;
  if maxservices > 0 then
    applyservices;
  sfresh.Click;
end;

function servicestatus(sn: string): string;
var
  sch, sh: thandle;
  ss:      Service_status;
begin
  sch := openscmanager(nil, nil, SC_MANAGER_ALL_ACCESS);
  sh  := openservice(sch, PChar(sn), SERVICE_ALL_ACCESS);
  if sh <> 0 then
    begin
    fillchar(ss, sizeof(ss), #0);
    QueryServiceStatus(sh, ss);
    case ss.dwCurrentState
      of
      SERVICE_STOPPED:
        Result := 'остановлена';
      SERVICE_START_PENDING:
        Result := 'запуск...';
      SERVICE_STOP_PENDING:
        Result := 'остановка...';
      SERVICE_RUNNING:
        Result := 'работает';
      SERVICE_CONTINUE_PENDING:
        Result := 'восстановление...';
      SERVICE_PAUSE_PENDING:
        Result := 'приостановка...';
      SERVICE_PAUSED:
        Result := 'пауза'
      else
        Result := '?';
      end;
    end
  else
    Result := '?';
  CloseServiceHandle(sh);
  CloseServiceHandle(sch);
end;


function servicestatusid(sn: string): cardinal;
var
  sch, sh: thandle;
  ss:      Service_status;
begin
  sch := openscmanager(nil, nil, SC_MANAGER_ALL_ACCESS);
  sh  := openservice(sch, PChar(sn), SERVICE_ALL_ACCESS);
  if sh <> 0 then
    begin
    fillchar(ss, sizeof(ss), #0);
    QueryServiceStatus(sh, ss);
    Result := ss.dwCurrentState;
    end
  else
    Result := invalid_handle_value;
  CloseServiceHandle(sh);
  CloseServiceHandle(sch);
end;


procedure TFDCMAIN.sstopClick(Sender: TObject);
var
  sch, sh: thandle;
  ss:      Service_status;
begin

  if slist.ItemIndex = -1 then
    exit;
  sch := openscmanager(nil, nil, SC_MANAGER_ALL_ACCESS);
  sh  := openservice(sch, PChar(services[slist.ItemIndex].key), SERVICE_ALL_ACCESS);
  if sh <> 0 then
    begin
    fillchar(ss, sizeof(ss), #0);
    QueryServiceStatus(sh, ss);
    if not controlservice(sh, SERVICE_CONTROL_STOP, ss) then
      lasterror;
    end
  else
    ShowMessage('Отказано в доступе!');
  CloseServiceHandle(sh);
  CloseServiceHandle(sch);
end;

procedure TFDCMAIN.sstartClick(Sender: TObject);
var
  sch, sh: thandle;
  dummy:   PChar;
begin
  dummy := nil;
  if slist.ItemIndex = -1 then
    exit;
  sch := openscmanager(nil, nil, SC_MANAGER_ALL_ACCESS);
  sh  := openservice(sch, PChar(services[slist.ItemIndex].key), SERVICE_ALL_ACCESS);
  if sh <> 0 then
    startservice(sh, 0, dummy)
  else
    ShowMessage('Отказано в доступе!');
  CloseServiceHandle(sh);
  CloseServiceHandle(sch);
end;

procedure TFDCMAIN.spauseClick(Sender: TObject);
var
  sch, sh: thandle;
  ss:      Service_status;
begin
  if slist.ItemIndex = -1 then
    exit;
  sch := openscmanager(nil, nil, SC_MANAGER_ALL_ACCESS);
  sh  := openservice(sch, PChar(services[slist.ItemIndex].key), SERVICE_ALL_ACCESS);
  if sh <> 0 then
    begin
    fillchar(ss, sizeof(ss), #0);
    QueryServiceStatus(sh, ss);
    if not controlservice(sh, SERVICE_CONTROL_PAUSE, ss) then
      lasterror;
    end

  else
    ShowMessage('Отказано в доступе!');
  CloseServiceHandle(sh);
  CloseServiceHandle(sch);

end;

procedure TFDCMAIN.sresumeClick(Sender: TObject);
var
  sch, sh: thandle;
  ss:      Service_status;
begin
  if slist.ItemIndex = -1 then
    exit;
  sch := openscmanager(nil, nil, SC_MANAGER_ALL_ACCESS);
  sh  := openservice(sch, PChar(services[slist.ItemIndex].key), SERVICE_ALL_ACCESS);
  if sh <> 0 then
    begin
    fillchar(ss, sizeof(ss), #0);
    QueryServiceStatus(sh, ss);
    if not controlservice(sh, SERVICE_CONTROL_CONTINUE, ss) then
      lasterror;
    end

  else
    ShowMessage('Отказано в доступе!');
  CloseServiceHandle(sh);
  CloseServiceHandle(sch);
end;


procedure TFDCMAIN.servpopupPopup(Sender: TObject);
var
  ss: cardinal;
begin
  sstart.Enabled  := False;
  sstop.Enabled   := False;
  spause.Enabled  := False;
  sresume.Enabled := False;
  if (slist.Items.Count > 0) and (slist.ItemIndex <> -1) then
    begin
    ss := servicestatusid(services[slist.ItemIndex].key);
    case ss
      of
      SERVICE_STOPPED:
        sstart.Enabled  := True;
      SERVICE_RUNNING:
        sstop.Enabled   := True;
      SERVICE_PAUSED:
        sresume.Enabled := True;

      end;
    end;

end;



procedure TFDCMAIN.ClearOptClickCheck(Sender: TObject);
begin
  case clearopt.ItemIndex of
    0:
      if not binenabled then
        clearopt.Checked[0] := False;
    1:
      if gethistoryoff then
        clearopt.Checked[1] := False;
    5:
      if not nt then
        clearopt.Checked[5] := False;
    end;
end;

procedure TFDCMAIN.optionsClickCheck(Sender: TObject);
begin
  case options.ItemIndex of
    0:
      begin
      dsclick(nil);
      ShowMessage('Ярлык на рабочем столе создан.');
      end;
    1:
      begin
      smclick(nil);
      ShowMessage('Ярлык в меню пуск создан.');
      end;
    3:
      begin
      regit;
      ShowMessage('Программа интегрирована в систему.');
      end;
    4:
      begin
      if messagedlg('Действительно восстановить изначальную установку?',
        mtConfirmation, mbOkCancel, 0) = idOk then
        begin
        installmode := True;
        extractinstall;
        smclick(nil);
        dsclick(nil);
        regit;
        copyfile(PChar(mypath + s_temp_fn), PChar(windowsdir + s_temp_fn), False);
        ShowMessage('Программа переустановлена.');
        end;
      options.Checked[4] := False;

      end;
    5:
      begin
      templ.Clear;
      copyfile(PChar(mypath + s_temp_fn), PChar(windowsdir + s_temp_fn), False);
      if FileExists(windowsdir + s_temp_fn) then
        templ.LoadFromFile(windowsdir + s_temp_fn);
      freshtemplates;
      ShowMessage('Шаблоны восстановлены.');
      options.Checked[5] := False;
      end;
    end;
end;

///////
procedure TFDCMain.NilServices;
var
  i: integer;
begin
  if fdcmain.serv9x.Items.Count = 0 then
    exit;
  for i := 0 to fdcmain.Serv9x.Items.Count - 1 do
    begin
    TIdx(fdcmain.Serv9x.Items.Objects[i]).Free;
    fdcmain.Serv9x.Items.Objects[i] := nil;
    end;
  fdcmain.Serv9x.Items.Clear;
  SetLength(Servlist, 0);
end;

procedure TFDCMAIN.Fill9xServices;
var
  r:  Tdarkregistry;
  Sl: TStringList;
  i:  integer;
begin
  numserv := 0;
  r := Tdarkregistry.Create;
  r.RootKey := HKey_Local_Machine;
  r.OpenKey('\System\CurrentControlSet\Services\');
  sl := TStringList.Create;
  sl.CaseSensitive := False;
  r.GetKeyNames(Sl);
  r.CloseKey;
  i := sl.IndexOf('VxD');
  if i > 0 then
    sl.Delete(i);
  numserv := sl.Count;
  setlength(servlist, numserv);
  for i := 0 to sl.Count - 1 do
    begin
    r.OpenKey('\System\CurrentControlSet\Services\' + SL[i]);
    servlist[i].Name    := sl[i];
    servlist[i].path    := r.ReadString('ImagePath');
    servlist[i].regpath := '\System\CurrentControlSet\Services\' + sl[i];
    r.CloseKey;
    end;
  r.OpenKey('\System\CurrentControlSet\Services\VxD');
  sl.Clear;
  r.GetKeyNames(Sl);
  r.CloseKey;
  setlength(servlist, numserv + sl.Count - 1);
  for i := 0 to sl.Count - 1 do
    begin
    r.OpenKey('\System\CurrentControlSet\Services\VxD\' + SL[i]);
    servlist[numserv + i - 1].Name    := sl[i];
    servlist[numserv + i - 1].path    := r.ReadString('StaticVxD');
    servlist[numserv + i - 1].vxd     := True;
    servlist[numserv + i - 1].regpath :=
      '\System\CurrentControlSet\Services\VxD\' + sl[i];
    r.CloseKey;
    end;
  numserv := numserv + sl.Count - 1;
  sl.Free;
  r.Free;
end;


///////

procedure TFDCMAIN.update9xservClick(Sender: TObject);
var
  i:   integer;
  idx: Tidx;
begin
  if nt then
    exit;
  NilServices;
  Fill9xServices;
  for i := 0 to numserv - 1 do
    begin
    idx    := Tidx.Create;
    idx.id := i;
    serv9x.Items.AddObject(servlist[i].Name, idx);
    end;
end;

procedure TFDCMAIN.Serv9xClick(Sender: TObject);
var
  idx: integer;
begin
  idx := serv9x.ItemIndex;
  if idx < 0 then
    exit;
  idx := Tidx(serv9x.Items.Objects[serv9x.ItemIndex]).id;
  ShowMessage('Location: ' + servlist[idx].regpath + #13#10 + 'Path: ' +
    servlist[idx].path);

end;

procedure TFDCMAIN.del9xservClick(Sender: TObject);
var
  idx: integer;
  r:   TDarkRegistry;
begin
  if nt then
    exit;
  r   := TDarkRegistry.Create;
  r.RootKey := HKEY_Local_Machine;
  idx := serv9x.ItemIndex;
  if idx < 0 then
    exit;
  idx := Tidx(serv9x.Items.Objects[serv9x.ItemIndex]).id;
  if MessageDlg('Удалить сервис ' + serv9x.Items[serv9x.ItemIndex] +
    ' ?', mtConfirmation, [mbOK, mbCancel], 0) = idOk then
    r.DeleteKey(servlist[idx].regpath);
  r.Free;
  Update9xServClick(nil);
end;

procedure TfdcMain.acActivateExecute(Sender: TObject);
begin
  if not HTTPServer.Active then
    begin
    HTTPServer.Bindings.Clear;
    HTTPServer.DefaultPort := StrToIntDef(edPort.Text, 16305);
    HTTPServer.Bindings.Add;
    try
      EnableLog := True;
      HTTPServer.Active := True;
    except
      end;
    end
  else
    try
      HTTPServer.Active := False;
    except
      end;
  acActivate.Checked := HTTPserver.Active;

end;

procedure TfdcMain.edPortChange(Sender: TObject);
var
  FinalLength, i: integer;
  FinalText:      string;
begin
  // Filter routine. Remove every char that is not a numeric (must do that for cut'n paste)
  Setlength(FinalText, length(edPort.Text));
  FinalLength := 0;
  for i := 1 to length(edPort.Text) do
    if edPort.Text[i] in ['0'..'9'] then
      begin
      Inc(FinalLength);
      FinalText[FinalLength] := edPort.Text[i];
      end;
  SetLength(FinalText, FinalLength);
  edPort.Text := FinalText;
end;

procedure TfdcMain.edPortKeyPress(Sender: TObject; var Key: char);
begin
  if not (key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure TfdcMain.edPortExit(Sender: TObject);
begin
  if length(trim(edPort.Text)) = 0 then
    edPort.Text := '16305';
end;


function TfdcMain.GetMIMEType(sFile: TFileName): string;
begin
  Result := MIMEMap.GetFileMIMEType(sFile);
end;


procedure TFDCMAIN.obnClick(Sender: TObject);
begin
  if strdest = norm then
    makereport;
end;

procedure TFDCMAIN.sbiClick(Sender: TObject);
begin
  bid.Lines.SaveToFile('c:\boot.ini');
end;

procedure TFDCMAIN.lbiClick(Sender: TObject);
begin
  if fileexists('c:\boot.ini') then
    bid.Lines.LoadFromFile('c:\boot.ini')
  else
    ShowMessage('Boot.ini не существует!');
end;

procedure TFDCMAIN.dlbiClick(Sender: TObject);
begin
  if (bid.Lines.Count > 0) and (bid.CaretPos.Y <> -1) then
    bid.Lines.Delete(bid.CaretPos.Y);
end;

procedure TFDCMAIN.defbiClick(Sender: TObject);
var
  s: string;
begin
  if (bid.Lines.Count = 0) or (bid.CaretPos.Y = -1) then
    exit;
  s := bid.Lines.Names[bid.caretpos.y];
  bid.Lines.Values['default'] := s;
end;


procedure TFDCMAIN.gettClick(Sender: TObject);
begin
  shellapi.ShellExecute(handle, 'open', 'http://www.darksoftware.narod.ru/',
    '', '', sw_show);

end;

procedure TFDCMAIN.Button8Click(Sender: TObject);
begin
  shellapi.ShellExecute(handle, 'open',
    'http://www.hotcd.ru/cgi-bin/index.pl?0==0==0==darksoftware',
    '', '', sw_show);

end;

procedure TFDCMAIN.sendmailClick(Sender: TObject);
begin
  shellapi.ShellExecute(handle, 'open', 'mailto:darksoftware@yandex.ru',
    '', '', sw_show);
end;

procedure TFDCMAIN.k(Sender: TObject);
begin
  if fileexists('c:\autoexec.bat') then
    abat.Lines.LoadFromFile('c:\autoexec.bat')
  else
    ShowMessage('autoexec.bat не существует!');

end;

procedure TFDCMAIN.tbClick(Sender: TObject);
begin
  abat.Lines.SaveToFile('c:\autoexec.bat');
end;

procedure TFDCMAIN.ToolButton6Click(Sender: TObject);
begin
  if fileexists('c:\config.sys') then
    cos.Lines.LoadFromFile('c:\config.sys')
  else
    ShowMessage('config.sys не существует!');

end;

procedure TFDCMAIN.ToolButton5Click(Sender: TObject);
begin
  cos.Lines.SaveToFile('c:\config.sys');
end;

procedure TFDCMAIN.ToolButton10Click(Sender: TObject);
begin
  if fileexists('c:\msdos.sys') then
    msd.Lines.LoadFromFile('c:\msdos.sys')
  else
    ShowMessage('msdos.sys не существует!');

end;

procedure TFDCMAIN.ToolButton9Click(Sender: TObject);
begin
  msd.Lines.SaveToFile('c:\msdos.sys');
end;

procedure TFDCMAIN.abpresetSelect(Sender: TObject);
var
  t: string;
begin
  if (Sender as tcombobox).ItemIndex <> (Sender as tcombobox).Items.Count - 1 then
    begin
    t := abat.Lines[abat.caretpos.y];
    insert(abpreset.Text, T, abat.caretpos.x + 1);
    abat.Lines[abat.caretpos.y] := t;
    end
  else
    begin
    runandwait('notepad.exe ' + (mypath + usrdir) + '\autoexec.fdp');
    abpreset.Items.LoadFromFile(mypath + usrdir + '\autoexec.fdp');
    abpreset.Sorted := True;
    abpreset.Sorted := False;
    abpreset.Items.Add('[Изменить этот список]');
    end;
end;

procedure TFDCMAIN.cspresetSelect(Sender: TObject);
var
  t: string;
begin
  if (Sender as tcombobox).ItemIndex <> (Sender as tcombobox).Items.Count - 1 then
    begin
    t := cos.Lines[cos.caretpos.y];
    insert(cspreset.Text, T, cos.caretpos.x + 1);
    cos.Lines[cos.caretpos.y] := t;
    end
  else
    begin
    runandwait('notepad.exe ' + (mypath + usrdir) + '\config.fdp');
    cspreset.Items.LoadFromFile(mypath + usrdir + '\config.fdp');
    cspreset.Sorted := True;
    cspreset.Sorted := False;
    cspreset.Items.Add('[Изменить этот список]');
    end;

end;

procedure TFDCMAIN.msdpresetSelect(Sender: TObject);
var
  t: string;
begin
  if (Sender as tcombobox).ItemIndex <> (Sender as tcombobox).Items.Count - 1 then
    begin
    t := msd.Lines[msd.caretpos.y];
    insert(msdpreset.Text, T, msd.caretpos.x + 1);
    msd.Lines[msd.caretpos.y] := t;
    end
  else
    begin
    runandwait('notepad.exe ' + (mypath + usrdir) + '\msdos.fdp');
    msdpreset.Items.LoadFromFile(mypath + usrdir + '\msdos.fdp');
    msdpreset.Sorted := True;
    msdpreset.Sorted := False;
    msdpreset.Items.Add('[Изменить этот список]');
    end;

end;

procedure TFDCMAIN.autoabClick(Sender: TObject);
var
  st, st1: string;
  S, S1: TStrings;
  i:   integer;
  bbb: string;
  cnt: integer;
  fi:  boolean;
begin
  abat.Lines.BeginUpdate;
  abat.Lines.Clear;
  abat.Lines.Add('@ECHO OFF');
  abat.Lines.Add('@REM Generated by FDK http://www.darksoftware.narod.ru/');
  st  := GetEnvironmentVariable('PATH');
  s1  := TStringList.Create;
  s1.Delimiter := ';';
  st1 := '';
  for i := 1 to length(st) do
    begin
    case st[i] of
      ';':
        begin
        if st1 <> '' then
          begin
          if pos(' ', st1) > 0 then
            begin
            if (st1[1] <> '"') and (st1[length(st1)] <> '"') then
              st1 := SysUtils.AnsiQuotedStr(st1, '"');
            end;
          s1.Add(st1);
          st1 := '';
          end;
        end;
      else
        begin
        st1 := st1 + st[i];
        end;
      end;
    end;
  s1.Add(windowsdir);
  s1.Add(windowsdir + 'COMMAND');
  for i := 0 to s1.Count - 1 do
    if Trim(s1[i]) <> '' then
      begin
      s1[i] := Trim(UpperCase(ExcludeTrailingBackslash(s1[i])));
      if s1[i][1] = ';' then
        s1[i] := copy(s1[i], 2, length(s1[i]) - 1);
      if s1[i][length(s1[i])] = ';' then
        s1[i] := copy(s1[i], 1, length(s1[i]) - 1);
      end;
  s := TStringList.Create;
  for i := 0 to s1.Count - 1 do

    if s.Count = 0 then
      begin
      if Trim(s1[i]) <> '' then
        s.Add(s1[i]);
      end
    else
    if s.IndexOf(s1[i]) = -1 then
      if Trim(s1[i]) <> '' then
        s.Add(s1[i]);
  s1.Free;
  cnt := 0;
  bbb := '';
  fi  := True;
  //////////////////////////////////

  repeat
    if length(bbb + s[cnt]) > 60 then
      begin
      if fi then
        begin
        abat.Lines.Add('@SET PATH=' + bbb);
        fi := False;
        end
      else
        abat.Lines.Add('@SET PATH=;%PATH%;' + bbb);
      bbb := s[cnt];
      end
    else
    if bbb <> '' then
      bbb := bbb + ';' + s[cnt]
    else
      bbb := s[cnt];
    Inc(cnt);
  until cnt = s.Count;
  if bbb <> '' then
    if fi then
      abat.Lines.Add('@SET PATH=' + bbb)
    else
      abat.Lines.Add('@SET PATH=;%PATH%;' + bbb);
  s.Free;
  abat.Lines.Add('@mode con codepage prepare=((866) ' + windowsdir +
    'Command\ega3.cpi)');
  abat.Lines.Add('@mode con codepage select=866');
  abat.Lines.Add('@keyb.com ru,,' + WindowsDir + 'Command\keybrd3.sys');
  abat.Lines.EndUpdate;
end;

procedure TFDCMAIN.csautoClick(Sender: TObject);
begin
  cos.Lines.BeginUpdate;
  cos.Lines.Clear;
  cos.Lines.Add('dos=high,umb');
  cos.Lines.Add('devicehigh=' + windowsdir + 'COMMAND\display.sys con=(ega,,1)');
  cos.Lines.Add('Country=007,866,' + windowsdir + 'COMMAND\country.sys');
  cos.Lines.EndUpdate;
end;

procedure TFDCMAIN.msdautoClick(Sender: TObject);
var
  i: integer;
begin
  msd.Lines.BeginUpdate;
  msd.Lines.Clear;
  msd.Lines.Add(';SYS');
  msd.Lines.Add('[PATHS]');
  msd.Lines.Add('WINDIR=' + windowsdir);
  msd.Lines.Add('WINBOOTDIR=' + windowsdir);
  msd.Lines.Add('HOSTWINBOOTDRV=' + ExtractFileDrive(windowsdir)[1]);
  msd.Lines.Add('[OPTIONS]');
  msd.Lines.Add('BootGUI=1');
  msd.Lines.Add('DoubleBuffer=1');
  msd.Lines.Add('AutoScan=0');
  msd.Lines.Add('WinVer=' + WinVerNum);
  msd.Lines.Add('BootKeys=1');
  msd.Lines.Add('BootWin=1');
  msd.Lines.Add('BootMulti=0');
  msd.Lines.Add('SystemReg=1');
  msd.Lines.Add('Logo=0');
  msd.Lines.Add('BootMenu=0');
  msd.Lines.Add('LoadTop=1');
  msd.Lines.Add('BootWarn=0');
  msd.Lines.Add('DisableLog=1');
  msd.Lines.Add('DrvSpace=0');
  msd.Lines.Add('DblSpace=0');
  msd.Lines.Add('BootMenuDefault=1');
  msd.Lines.Add('DblSpace=0');
  msd.Lines.Add('BootDelay=5');
  for i := 0 to 25 do
    msd.Lines.Add(';xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
  msd.Lines.EndUpdate;
end;

procedure TFDCMAIN.N6Click(Sender: TObject);
begin
  shellapi.ShellExecute(handle, 'open',
    PChar(view.listviewf.items[view.listviewf.ItemIndex].Caption),
    '', '', sw_show);
end;

procedure TFDCMAIN.gettypesClick(Sender: TObject);
var
  r: TDarkRegistry;
  S: TStringList;
  i: integer;
begin
  typesref.Enabled := False;
  stypes.Items.BeginUpdate;
  stypes.Clear;
  s := TStringList.Create;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_CLASSES_ROOT;
  r.OpenKey('');
  r.GetKeyNames(s);
  s.Sort;
  r.CloseKey;
  for i := 0 to s.Count - 1 do
    begin
    if (s[i] <> '') then
      if ((s[i][1] = '.') or (s[i] = '*')) or (alltypes.Checked) then
        stypes.Items.Add(s[i]);
    end;
  r.Free;
  s.Free;
  stypes.items.EndUpdate;
  typesref.Enabled := True;
end;

procedure TFDCMAIN.Button6Click(Sender: TObject);
var
  r: TDarkRegistry;
begin
  if stypes.ItemIndex = -1 then
    exit;

  if MessageDlg('Удалить тип ' + stypes.Items[stypes.ItemIndex] +
    ' ?', mtConfirmation, [mbOK, mbCancel], 0) = idOk then

    begin
    r := TDarkRegistry.Create;
    r.RootKey := HKey_Classes_Root;
    r.DeleteKey(stypes.Items[stypes.ItemIndex]);
    r.Free;
    typesref.Click;
    end;
end;

procedure TFDCMAIN.stypesClick(Sender: TObject);
var
  r:  TDarkRegistry;
  l, n, o: string;
  ke: boolean;
begin
  if stypes.ItemIndex = -1 then
    exit;
  r := TDarkRegistry.Create;
  r.RootKey := HKey_Classes_Root;
  r.OpenKey(stypes.Items[stypes.ItemIndex]);
  n := Trim(r.ReadString(''));
  if r.KeyExists('shell\open\command') then
    begin
    r.OpenKey('shell\open\command');
    o := Trim(r.ReadString(''));
    end
  else
    o := 'Н/У';
  r.CloseKey;
  l := '';
  if n <> '' then
    repeat
      ke := r.KeyExists(n);
      if ke then
        begin
        r.OpenKey(n);
        l := n;
        n := Trim(r.ReadString(''));
        r.OpenKey('shell\open\command');
        o := Trim(r.ReadString(''));
        r.CloseKey;
        if l = n then
          n := '';
        end;
    until (ke = False) or (n = '');
  if trim(n) = '' then
    n := 'Н/У';
  if (stypes.Items[stypes.ItemIndex][1] = '.') or
    (stypes.Items[stypes.ItemIndex] = '*') then
    ShowMessage(format('Расширение: %s' + #13#10 + 'Описание: %s' +
      #13#10 + 'Связано с : %s', [stypes.Items[stypes.ItemIndex], n, o]))
  else
    ShowMessage(format('Идентификатор: %s' + #13#10 + 'Описание: %s' +
      #13#10 + 'Связано с : %s', [stypes.Items[stypes.ItemIndex], n, o]));

  r.Free;
end;

procedure TFdcMain.FilterRuns;
var
  r:   TDarkRegistry;
  st:  TStrings;
  fnd: integer;

  procedure OneKey(root: hkey; key: string);
  var
    i, x: integer;
  begin
    r.RootKey := root;
    r.OpenKey(key);
    r.GetValueNames(st);
    for i := 0 to st.Count - 1 do
      for x := 0 to badar.Count - 1 do
        if sametext(st[i], badar[x]) then
          begin
          Inc(fnd);
          if messagedlg('Убрать из автозапуска ''' + st[i] + '''?',
            mtConfirmation, mbOkCancel, 0) = idOk then
            r.DeleteValue(st[i]);
          break;
          end;
    r.CloseKey;
  end;

begin
  fnd := 0;
  if badar.Count = 0 then
    if messagedlg(
      'Список нежелательных программ пуст, необходимо ввести идентификаторы этих программ. Желаете это сделать?',
      mtConfirmation, mbOkCancel, 0) = idOk then
      shellapi.ShellExecute(handle, 'open', 'notepad.exe', 'autorun.fdp',
        PChar(mypath + usrdir), sw_show);
  r  := TDarkRegistry.Create;
  st := TStringList.Create;
  onekey(hkey_local_machine, '\SOFTWARE\Microsoft\Windows\CurrentVersion\Run');
  onekey(hkey_local_machine, '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce');
  onekey(hkey_local_machine, '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx');
  onekey(hkey_local_machine, '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices');
  onekey(hkey_local_machine,
    '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServicesOnce');
  onekey(hkey_current_user, '\SOFTWARE\Microsoft\Windows\CurrentVersion\Run');
  onekey(hkey_current_user, '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce');
  onekey(hkey_current_user, '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx');
  onekey(hkey_current_user, '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices');
  onekey(hkey_current_user,
    '\SOFTWARE\Microsoft\Windows\CurrentVersion\RunServicesOnce');
  r.Free;
  st.Free;
  if fnd = 0 then
    ShowMessage('Нежелательные программы не найдены.')
  else
    ShowMessage(Format('Найдено %d нежелательных программ.', [fnd]));
end;

procedure TFDCMAIN.aroptClick(Sender: TObject);
begin
  armenu.Popup(fdcmain.Left + aropt.Left, fdcmain.top + aropt.Top + aropt.Height);
end;

procedure TFDCMain.Regit;
var
  r: TDarkRegistry;
begin
  WriteEnv;
  r := TDarkRegistry.Create;
  r.RootKey := HKey_Classes_root;
  ////////////
  r.CreateKey('\.fdc');
  r.OpenKey('\.fdc');
  r.WriteString('', 'FDKPlugin');
  r.CloseKey;
  /////////

  ////////////
  r.CreateKey('\FDKPlugin');
  r.OpenKey('\FDKPlugin');
  r.WriteString('', 'DLL- плагин FDK by DarkSoftware');
  r.CloseKey;
  /////////
  ////////////
  r.CreateKey('\.tweak');
  r.OpenKey('\.tweak');
  r.WriteString('', 'txtfile');
  r.CloseKey;
  /////////
  ////////////
  r.CreateKey('\.fds');
  r.OpenKey('\.fds');
  r.WriteString('', 'txtfile');
  r.CloseKey;
  /////////

  r.CreateKey('\.fdp');
  r.OpenKey('\.fdp');
  r.WriteString('', 'txtfile');
  r.CloseKey;
  //////////
  /////////
  r.CreateKey('\.fdh');
  r.OpenKey('\.fdh');
  r.WriteString('', 'txtfile');
  r.CloseKey;
  //////////
  r.CreateKey('\.fdkar');
  r.OpenKey('\.fdkar');
  r.WriteString('', 'FDKAutoRun');
  r.CloseKey;
  //////////
  //////////
  r.CreateKey('\.dav');
  r.OpenKey('\.dav');
  r.WriteString('', 'FDKDavScript');
  r.CloseKey;
  //////////
  //////////
  r.CreateKey('\.fdl');
  r.OpenKey('\.fdl');
  r.WriteString('', 'FDKFileList');
  r.CloseKey;
  //////////
  ////////////
  r.CreateKey('\.fdt');
  r.OpenKey('\.fdt');
  r.WriteString('', 'FDKTaskList');
  r.CloseKey;
  /////////
  //////////
  r.CreateKey('\FDKAutoRun\shell\open\command');
  r.OpenKey('\FDKAutoRun');
  r.WriteString('', 'Шаблон автозапуска FDK by DarkSoftware');
  r.OpenKey('\FDKAutoRun\shell\open\command');
  r.WriteString('', mypath + 'fdk.exe -autorun "%1"');
  r.OpenKey('\FDKAutoRun\shell\FDK');
  r.WriteString('', 'Установить системный автозапуск согласно этому шаблону');
  r.OpenKey('\FDKAutoRun\shell\FDK\command');
  r.WriteString('', mypath + 'fdk.exe -autorun "%1"');
  r.CloseKey;
  //////////
  //////////
  r.CreateKey('\FDKDavScript\shell\open\command');
  r.OpenKey('\FDKDavScript');
  r.WriteString('', 'Скрипт FDK by DarkSoftware');
  r.OpenKey('\FDKDavScript\shell\open\command');
  r.WriteString('', mypath + 'fdk.exe -runscript "%1"');
  r.OpenKey('\FDKDavScript\shell\FDK');
  r.WriteString('', 'Выполнить скрипт в FDK by DarkSoftware');
  r.OpenKey('\FDKDavScript\shell\FDK\command');
  r.WriteString('', mypath + 'fdk.exe -runscript "%1"');

  r.OpenKey('\FDKDavScript\shell\FDK2');
  r.WriteString('', 'Выполнить скрипт в FDK by DarkSoftware и выйти');
  r.OpenKey('\FDKDavScript\shell\FDK2\command');
  r.WriteString('', mypath + 'fdk.exe -runscriptandclose "%1"');
  r.CloseKey;
  //////////
  r.CreateKey('\FDKFileList\shell\open\command');
  r.OpenKey('\FDKFileList');
  r.WriteString('', 'Список найденых файлов FDK by DarkSoftware');
  r.OpenKey('\FDKFileList\shell\open\command');
  r.WriteString('', mypath + 'fdk.exe -usefilelist "%1"');
  r.OpenKey('\FDKFileList\shell\FDK');
  r.WriteString('', 'Открыть этот список в FDK by DarkSoftware');
  r.OpenKey('\FDKFileList\shell\FDK\command');
  r.WriteString('', mypath + 'fdk.exe -usefilelist "%1"');
  r.CloseKey;
  //////////
  ////////////////////
  //////////
  r.CreateKey('\FDKTaskList\shell\open\command');
  r.OpenKey('\FDKTaskList');
  r.WriteString('', 'Задача FDK by DarkSoftware');
  r.OpenKey('\FDKTaskList\shell\open\command');
  r.WriteString('', mypath + 'fdk.exe -usetasklist "%1"');
  r.OpenKey('\FDKTaskList\shell\FDK');
  r.WriteString('', 'Выполнить эту задачу в FDK by DarkSoftware');
  r.OpenKey('\FDKTaskList\shell\FDK\command');
  r.WriteString('', mypath + 'fdk.exe -usetasklist "%1"');
  r.CloseKey;
  //////////

  ///////////////////
  //////////
  r.CreateKey('\Directory\shell\FDK\command');
  r.OpenKey('\Directory\shell\FDK');
  r.WriteString('', 'Очистка с помощью FDK by DarkSoftware');
  r.OpenKey('command');
  r.WriteString('', mypath + 'fdk.exe "%1"');
  ///
  if qchk.ItemIndex > 0 then
    begin
    r.OpenKey('\Directory\shell\FDK2');
    r.WriteString('', format('Найти здесь %s', [qchk.Items[qchk.ItemIndex]]));
    r.OpenKey('command');
    r.WriteString('', mypath + 'fdk.exe "%1" ' + Format(
      '"%s"', [templ.Values[qchk.Items[qchk.ItemIndex]]]));
    end;
  ///
  r.CloseKey;
  //////////
  //////////
  r.CreateKey('\Drive\shell\FDK\command');
  r.OpenKey('\Drive\shell\FDK');
  r.WriteString('', 'Очистка с помощью FDK by DarkSoftware');
  r.OpenKey('command');
  r.WriteString('', mypath + 'fdk.exe "%1"');
  ///
  if qchk.ItemIndex > 0 then
    begin
    r.OpenKey('\Drive\shell\FDK2');
    r.WriteString('', format('Найти здесь %s', [qchk.Items[qchk.ItemIndex]]));
    r.OpenKey('command');
    r.WriteString('', mypath + 'fdk.exe "%1" ' + Format(
      '"%s"', [templ.Values[qchk.Items[qchk.ItemIndex]]]));
    end;
  ///

  r.CloseKey;
  //////////
  r.RootKey := HKey_Local_Machine;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FDK');
  r.WriteString('DisplayName', 'НИИ DarkSoftware: Fast Disk Cleaner');
  r.WriteString('UninstallString', Format('%s %s', [application.ExeName, '-uninstall']));
  r.Free;
  options.Checked[3] := False;
end;

procedure TFDCMAIN.addarClick(Sender: TObject);
var
  id, prog: string;
  r: TDarkRegistry;
begin
  id := inputbox('Идентификатор загрузки', 'Имя', '');
  if id = '' then
    exit;
  opendialog.Filter     := '*.*|*.*';
  opendialog.FileName   := '';
  opendialog.InitialDir := windowsdir;
  opendialog.DefaultExt := '*.*';
  opendialog.Title      := 'Автозагружаемый файл';
  if not opendialog.Execute then
    exit;
  prog := inputbox('Команда для загрузки', 'Выполнить', opendialog.FileName);
  if prog = '' then
    exit;
  r := Tdarkregistry.Create;
  r.RootKey := HKey_Local_Machine;
  r.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run');
  r.WriteString(id, prog);
  r.Free;
  arref.Click;
end;

procedure TFDCMAIN.setypClick(Sender: TObject);
var
  s: string;
  i: integer;
begin
  s := Trim(inputbox('Поиск связей', 'Расширение', ''));
  if s <> '' then
    begin
    i := stypes.Items.IndexOf(s);
    if i <> -1 then
      stypes.ItemIndex := i;
    end;
end;

procedure TFDCMAIN.N7Click(Sender: TObject);
begin
  filterruns;
  arref.Click;
end;

procedure TFDCMAIN.N8Click(Sender: TObject);
var
  F: TextFile;
  i: integer;
begin
  if startro then
    begin
    ShowMessage('Запуск с носителя только для чтения! Функция не возможна!');
    exit;
    end;
  assignfile(f, mypath + usrdir + '\lastautorun.fdh');
  rewrite(f);
  writeln(f, '// Файл автоматически сгенерирован FDK. ' + DateToStr(date) +
    ' ' + TimeToStr(Time));
  writeln(f, '// Убедительная просьба не редактировать.');
  if autorun.Items.Count > 0 then
    for i := 0 to autorun.Items.Count - 1 do
      writeln(f, autorun.items[i]);
  closefile(f);
end;

procedure TFDCMAIN.N9Click(Sender: TObject);
var
  F:  TextFile;
  i:  integer;
  AI: TStrings;
  s:  string;
begin
  if startro then
    begin
    ShowMessage('Запуск с носителя только для чтения! Функция не возможна!');
    exit;
    end;
  if not fileexists(mypath + usrdir + '\lastautorun.fdh') then
    begin
    ShowMessage('Прежнее состояние автозапуска не сохранено, сравнение невозможно!');
    exit;
    end;
  assignfile(f, mypath + usrdir + '\lastautorun.fdh');
  system.reset(f);
  ai := TStringList.Create;
  repeat
    readln(f, s);
    s := Trim(s);
    i := Pos('//', s);
    if i > 0 then
      Delete(s, i, length(s) + 1 - i);
    if Trim(s) <> '' then
      ai.Add(Trim(s));
  until EOF(f);
  closefile(f);
  for i := 0 to autorun.Items.Count - 1 do
    if ai.IndexOf(autorun.Items[i]) = -1 then
      if MessageDlg('Новый элемент в атозагрузке: ' + autorun.Items[i] +
        ' Желаете его оставить?', mtConfirmation, mbOkCancel, 0) = idCancel then
        setautorun(autorun.Items[i]);
  ai.Free;
  arref.Click;
end;

procedure TFDCMAIN.Label2MouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clRed;
end;

procedure TFDCMAIN.Label2MouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Color := clBlack;
end;

procedure TFDCMAIN.Label25MouseEnter(Sender: TObject);
begin
  (Sender as tlabel).font.Color := clred;
end;

procedure TFDCMAIN.Label25MouseLeave(Sender: TObject);
begin
  (Sender as tlabel).font.Color := clblack;
end;

procedure TFDCMAIN.HTTPServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);

  {procedure AccessDenied;
  begin
    ResponseInfo.ContentText :=
      '<html><head><title>Error</title></head><body><h1>Access denied</h1>'#13 +
      'You do not have sufficient priviligies to access this document.</body></html>';
    ResponseInfo.ResponseNo := 403;
  end;}
var
  LocalDoc, Option, param: string;
  ResultFile: TFileStream;
  Dummy: TextFile;
  dummyn: string;
  i: integer;
begin
  LocalDoc := lowercase(ARequestInfo.Document);
  dummyn   := IntToStr(random(maxlong)) + IntToStr(random(16384));
  assignfile(dummy, dummyn);
  rewrite(dummy);
  writeln(dummy, '<HTML>');
  writeln(dummy, '<Head>');
  writeln(dummy, '<meta http-equiv="Cache-Control" content="no-cache">');
  writeln(dummy, '<Head>');
  writeln(dummy, '</Head>');
  writeln(dummy, '<Title>FDK Web Interface</Title>');
  writeln(dummy, '<BODY bgcolor="Black" text="LightGreen" link="LightGreen" vlink="LightGreen">');
  writeln(dummy, '<center><H2>FDK Web interface ver0.1 alpha</H2></center>');
  writeln(dummy, '<br>');
  writeln(dummy, '<table border="1">');
  writeln(dummy, '<tr>');
  writeln(dummy, '<td>');
  writeln(dummy, '<a href="/">Main Page</a><br>');
  writeln(dummy, '</td>');
  writeln(dummy, '</tr>');
  writeln(dummy, '<tr>');
  writeln(dummy, '<td>');
  writeln(dummy, '<a href="mask">Choose Mask</a><br>');
  writeln(dummy, '</td>');
  writeln(dummy, '</tr>');
  writeln(dummy, '<tr>');
  writeln(dummy, '<td>');
  writeln(dummy, '<a href="drive">Choose drive</a><br>');
  writeln(dummy, '</td>');
  writeln(dummy, '</tr>');
  writeln(dummy, '<tr>');
  writeln(dummy, '<td>');
  writeln(dummy, '<a href="review">View Options</a><br>');
  writeln(dummy, '</td>');
  writeln(dummy, '</tr>');
  writeln(dummy, '<tr>');
  writeln(dummy, '<td>');
  writeln(dummy, '<a href="info">Get System Info</a><br>');
  writeln(dummy, '</td>');
  writeln(dummy, '</tr>');
  writeln(dummy, '<tr>');
  writeln(dummy, '<td>');
  writeln(dummy, '<a href="about">About</a>');
  writeln(dummy, '</td>');
  writeln(dummy, '</tr>');
  writeln(dummy, '</table>');
  writeln(dummy, '<br><br><br><br><br><br>');


  if (localdoc = '/') or (localdoc = '/index.html') then
    begin
    writeln(dummy, '<center>');
    writeln(dummy, '<b>State</b>:<br>');
    if work then
      writeln(dummy, 'Scanning drive ' + harddrives[current_drive] +
        ': ' + IntToStr(allfiles.PercentDone) + '%')
    else
    if clonemode then
      writeln(dummy, 'Find for Clones')
    else
      writeln(dummy, 'Iddle...');
    writeln(dummy, '</center><br><br>');
    writeln(dummy, '<center><table border="1">');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    writeln(dummy, '<a href="setoptions&alldrives=1">Check All Drives</a>');
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    writeln(dummy, '<a href="setoptions&alldrives=0">Don''t Scan All Drives</a>');
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    writeln(dummy, '<a href="setoptions&kill=1">AutoDelete files</a>');
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    writeln(dummy, '<a href="setoptions&kill=0">Don''t AutoDeleteFiles</a>');
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    writeln(dummy, '<a href="setoptions&zero=1">Search for zero-length files</a>');
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    writeln(dummy, '<a href="setoptions&zero=0">Don''t Search for zero-length files</a>');
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    writeln(dummy, '<a href="command&scantry=1">Begin Scan</a>');
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    writeln(dummy, '<a href="command&stopscan=1">Stop Scan</a>');
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '</table></center>');
    ///////////////////////////////////////////
    writeln(dummy, '<script>');
    writeln(dummy, 'var timer="0:10"');
    writeln(dummy, 'if (document.images){');
    writeln(dummy, 'var Parser=timer.split(":")');
    writeln(dummy, 'Parser=Parser[0]*60+Parser[1]*1');
    writeln(dummy, '}');
    writeln(dummy, 'function refreshnow(){');
    writeln(dummy, 'if (!document.images)');
    writeln(dummy, 'return');
    writeln(dummy, 'if (Parser==1)');
    writeln(dummy, 'window.location.reload()');
    writeln(dummy, 'else{');
    writeln(dummy, 'Parser-=1');
    writeln(dummy, 'currentminutes=Math.floor(Parser/60)');
    writeln(dummy, 'currentsec=Parser%60');
    writeln(dummy, 'if (currentminutes!=0)');
    writeln(dummy,
      'currenttime=currentminutes+" minutes and "+currentsec+" seconds until page refresh!"');
    writeln(dummy, 'else');
    writeln(dummy, 'currenttime=currentsec+" seconds left until page refresh!"');
    writeln(dummy, 'window.status=currenttime');
    writeln(dummy, 'setTimeout("refreshnow()",1000)');
    writeln(dummy, '}');
    writeln(dummy, '}');
    writeln(dummy, 'window.onload=refreshnow');
    writeln(dummy, '</script>');
    ///////////////////////////////////////////
    end
  else
  if localdoc = '/info' then
    begin
    strdest := buf;
    makereport;
    strdest := norm;
    writeln(dummy, '<center><table border="1">');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    for i := 0 to strbuf.Count - 1 do
      writeln(dummy, strbuf[i] + '<br>');
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '</table><center>');
    end
  else
  if localdoc = '/about' then
    begin
    writeln(dummy, '<center><table border="1">');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    writeln(dummy,
      '(c) 2004 <a href="http://www.darksoftware.narod.ru/">DarkSoftware</a><br>');
    writeln(dummy, '(c) 2004 Full Code by Dark. Freeware');
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '</table></center>');
    end
  else
  if localdoc = '/mask' then
    begin
    writeln(dummy, '<center><table border="1">');
    for i := 0 to spreset.Count - 1 do
      begin
      writeln(dummy, '<tr>');
      writeln(dummy, '<td>');
      writeln(dummy, '<a href="/setoptions&mask=' +
        templ.Values[spreset.Items[i]] + '">' + spreset.items[i] + '</a>');
      writeln(dummy, '</td>');
      writeln(dummy, '</tr>');
      end;
    writeln(dummy, '</table></center>');
    end
  else
  if localdoc = '/drive' then
    begin
    writeln(dummy, '<center><table border="1">');
    for i := 0 to where.items.Count - 1 do
      begin
      writeln(dummy, '<tr>');
      writeln(dummy, '<td>');
      writeln(dummy, '<a href="/setoptions&drive=' + where.items[i] +
        '">' + where.items[i] + '</a>');
      writeln(dummy, '</td>');
      writeln(dummy, '</tr>');
      end;
    writeln(dummy, '</table></center>');
    end
  else
  if localdoc = '/review' then
    begin
    writeln(dummy, '</center><br><br>');
    writeln(dummy, '<center><table border="1">');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    writeln(dummy, 'Mask: ' + smask.Text);
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    writeln(dummy, 'All disks check: ' + booltostrYN(alldisks.Checked));
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    writeln(dummy, 'Auto Delete: ' + BoolToStrYN(AutoDel.Checked));
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    writeln(dummy, 'Zero-Length: ' + BoolToStrYN(pust.Checked));
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '<tr>');
    writeln(dummy, '<td>');
    writeln(dummy, 'Path: ' + where.Text);
    writeln(dummy, '</td>');
    writeln(dummy, '</tr>');
    writeln(dummy, '</table></center>');

    end
  else
  if pos('/setoptions&', localdoc) > 0 then
    begin
    Delete(localdoc, 1, pos('/setoptions&', localdoc) + 11);
    option := copy(localdoc, 1, pos('=', localdoc) - 1);
    Delete(localdoc, 1, length(option) + 1);
    param := localdoc;
    if option = 'drive' then
      begin
      where.Text := param;
      writeln(dummy, '<center>Drive set to:' + where.Text + '</center>');
      end
    else
    if option = 'mask' then
      begin
      smask.Text := param;
      writeln(dummy, '<center>Mask set to:' + smask.Text + '</center>');
      end
    else
    if option = 'alldrives' then
      begin
      alldisks.Checked := boolean(StrToInt(param));
      writeln(dummy, '<center>All disks checking set to:',
        alldisks.Checked, '</center>');
      end
    else
    if option = 'kill' then
      begin
      autodel.Checked := boolean(StrToInt(param));
      writeln(dummy, '<center>AutoDeleting Set to:',
        autodel.Checked, '</center>');
      end
    else
    if option = 'zero' then
      begin
      pust.Checked := boolean(StrToInt(param));
      writeln(dummy, '<center>Zero-length finding Set to:',
        pust.Checked, '</center>');
      end
    else
      writeln(dummy, '<center><h2>INVALID OPTIONS!</h2></center>');
    // Разбор Параметров!!!!!!!!!!!!!!
    end
  else
  if pos('/command&', localdoc) > 0 then
    begin
    Delete(localdoc, 1, pos('/command&', localdoc) + 8);
    option := copy(localdoc, 1, pos('=', localdoc) - 1);
    Delete(localdoc, 1, length(option) + 1);
    param := localdoc;
    if option = 'scannow' then
      if (not work) and (not clonemode) and (smask.Text <> '') and
        (where.Text <> '') then
        gotosearch(self)
      else
        writeln(dummy, '<center><h2>CANNOT SCAN NOW!</h2></center>')
    else
    if option = 'scantry' then
      begin
      writeln(dummy, '</center><br><br>');
      writeln(dummy, '<center><table border="1">');
      writeln(dummy, '<tr>');
      writeln(dummy, '<td>');
      writeln(dummy, 'Mask: ' + smask.Text);
      writeln(dummy, '</td>');
      writeln(dummy, '</tr>');
      writeln(dummy, '<tr>');
      writeln(dummy, '<td>');
      writeln(dummy, 'All disks check: ' + booltostrYN(alldisks.Checked));
      writeln(dummy, '</td>');
      writeln(dummy, '</tr>');
      writeln(dummy, '<tr>');
      writeln(dummy, '<td>');
      writeln(dummy, 'Auto Delete: ' + BoolToStrYN(AutoDel.Checked));
      writeln(dummy, '</td>');
      writeln(dummy, '</tr>');
      writeln(dummy, '<tr>');
      writeln(dummy, '<td>');
      writeln(dummy, 'Zero-Length: ' + BoolToStrYN(pust.Checked));
      writeln(dummy, '</td>');
      writeln(dummy, '</tr>');
      writeln(dummy, '<tr>');
      writeln(dummy, '<td>');
      writeln(dummy, 'Path: ' + where.Text);
      writeln(dummy, '</td>');
      writeln(dummy, '</tr>');
      writeln(dummy, '<tr>');
      writeln(dummy, '<td>');
      writeln(dummy,
        '<b><a href="command&scannow=1">Realy begin scan?</a><b>');
      writeln(dummy, '</tr>');
      writeln(dummy, '</td>');
      writeln(dummy, '</table></center>');

      end
    else
    if option = 'stopscan' then
      if work then
        stp.Click
      else
      if clonemode then
        view.stopcl.Click
      else
        writeln(dummy, '<center><h2>INVALID COMMAND!</h2></center>');

    end
  else
    writeln(dummy, '<center><h2>NOT FOUND!</h2></center>');
  writeln(dummy, '</HTML>');
  writeln(dummy, '</BODY>');
  closefile(dummy);

  if FileExists(dummyn) then
    if AnsiSameText(ARequestInfo.Command, 'HEAD') then

      begin
      ResultFile := TFileStream.Create(dummyn, fmOpenRead or fmShareDenyWrite);
      try
        AResponseInfo.ResponseNo    := 200;
        AResponseInfo.ContentType   := GetMIMEType(LocalDoc);
        AResponseInfo.ContentLength := ResultFile.Size;
      finally
        ResultFile.Free;
        deletefileadv(dummyn);
        end;

      end

    else
      begin
      AResponseInfo.ServeFile(AContext, dummyn);
      deletefileadv(dummyn);
      end
  else
    begin
    AResponseInfo.ResponseNo  := 404; // Not found
    AResponseInfo.ContentText :=
      '<html><head><title>Error</title></head><body><h1>' +
      AResponseInfo.ResponseText + '</h1></body></html>';
    end;

end;

procedure TFDCMain.FillOper;
var
  S:  TSearchRec;
  Fi: TextFile;
begin
  oper.Items.Clear;

  if (not directoryexists(mypath + 'scripts')) and not (startro) then
    begin
    CreateDir(mypath + 'scripts');
    AssignFile(Fi, mypath + 'scripts\directory.txt');
    Rewrite(Fi);
    Writeln(Fi, 'Каталог содержит скрипты для выполнения различных автоматизированых задач.');
    Writeln(Fi, '(c) 2003-2006 Dark Software http://www.darksoftware.narod.ru/');
    Writeln(Fi, TimeToStr(time) + ' ' + DateToStr(date));
    CloseFile(Fi);
    end
  else
  if (not fileexists(mypath + 'scripts\directory.txt')) and not (startro) then
    begin
    CreateDir(mypath + 'scripts');
    AssignFile(Fi, mypath + 'scripts\directory.txt');
    Rewrite(Fi);
    Writeln(Fi, 'Каталог содержит скрипты для выполнения различных автоматизированых задач.');
    Writeln(Fi, '(c) 2003-2006 Dark Software http://www.darksoftware.narod.ru/');
    Writeln(Fi, TimeToStr(time) + ' ' + DateToStr(date));
    CloseFile(Fi);

    end;

  if FindFirst(mypath + 'scripts\*.dav', faArchive + faReadOnly +
    faHidden + faSysFile, S) = 0 then
    repeat
      oper.Items.Add(ChangeFileExt(S.Name, ''));
    until FindNext(S) <> 0;
  FindClose(S);
  ////
  if FindFirst(mypath + 'scripts\*.fdt', faArchive + faReadOnly +
    faHidden + faSysFile, S) = 0 then
    repeat
      oper.Items.Add(ChangeFileExt(S.Name, '') + ' *');
    until FindNext(S) <> 0;
  FindClose(S);

  ///
  oper.Enabled     := oper.Items.Count > 0;
  loadoper.Enabled := oper.Items.Count > 0;
end;

procedure dbg(s: string; err: boolean);
begin
  if fdcmain.operdebug.CanFocus then
    fdcmain.operdebug.SetFocus;
  if err then
    fdcmain.operdebug.SelAttributes.Color := clBlue
  else
    fdcmain.operdebug.SelAttributes.Color := clBlack;

  fdcmain.operdebug.Lines.Append(s);
  fdcmain.operdebug.SelStart := length(fdcmain.operdebug.Text);
end;

procedure log(s: string; err: boolean);
begin
  if fdcmain.operlog.CanFocus then
    fdcmain.operlog.SetFocus;
  if err then
    fdcmain.operlog.SelAttributes.Color := clBlue
  else
    fdcmain.operlog.SelAttributes.Color := clBlack;
  fdcmain.operlog.Lines.Append(s);
  fdcmain.operlog.SelStart := length(fdcmain.operlog.Text);
end;


procedure TFDCMAIN.loadoperClick(Sender: TObject);
begin
  if (oper.ItemIndex = -1) then
    exit;
  if ansilastchar(oper.Items[oper.ItemIndex]) = '*' then
    begin
    if not fileexists((mypath + 'scripts\' +
      copy(oper.Items[oper.ItemIndex], 1, length(oper.Items[oper.ItemIndex]) - 2) +
      '.fdt')) then
      begin
      filloper;
      exit;
      end;

    end
  else
    begin
    if not fileexists(mypath + 'scripts\' + oper.Items[oper.ItemIndex] + '.dav') then
      begin
      filloper;
      exit;
      end;

    end;

  operlog.Text     := '';
  operdebug.Text   := '';
  loadoper.Enabled := False;
  oper.Enabled     := False;
  if ansilastchar(oper.Items[oper.ItemIndex]) = '*' then
    NextTaskStep(mypath + 'scripts\' + copy(oper.Items[oper.ItemIndex],
      1, length(oper.Items[oper.ItemIndex]) - 2) + '.fdt')
  else
    RunScript(mypath + 'scripts\' + oper.Items[oper.ItemIndex] + '.dav');
  loadoper.Enabled := True;
  oper.Enabled     := True;
end;

procedure TFDCMAIN.operSelect(Sender: TObject);
begin
  opercode.Clear;
  if oper.ItemIndex <> -1 then
    begin
    if ansilastchar(oper.Items[oper.ItemIndex]) = '*' then
      opercode.Lines.LoadFromFile(mypath + 'scripts\' +
        copy(oper.Items[oper.ItemIndex], 1, length(oper.Items[oper.ItemIndex]) -
        2) + '.fdt')
    else
      opercode.Lines.LoadFromFile(mypath + 'scripts\' +
        oper.Items[oper.ItemIndex] + '.dav');
    end;
end;

procedure rebuildplugins;
var
  s: TSearchRec;
  c: integer;

  procedure build(n: string);
  var
    T:  TextFile;
    SL: TStringList;
    l:  string;
  begin
    sl := TStringList.Create;
    sl.Append('////////////////////////////////////////////////////////////////////////////////');
    sl.Append('');
    sl.Append('//////                    НИИ DARKSOFTWARE - ПЛАГИН FDK                  ///////');
    sl.Append('');
    sl.Append('////////////////////////////////////////////////////////////////////////////////');
    sl.Append('');
    sl.Append('');
    sl.Append('');
    assignfile(t, n);
    reset(t);
    repeat
      readln(t, l);
      l := trim(l);
      if pos('//', l) <> 1 then
        if l <> '' then
          sl.Add(l);
    until EOF(t);
    closefile(t);
    sl.Append('');
    sl.Append('');
    sl.Append('');
    sl.Append('// Автоматически сгенерирован FDK, ' + DateToStr(Date) +
      ' / ' + TimeToStr(Time));
    sl.SaveToFile(n);
    sl.Free;
  end;

begin
  c := 0;
  if findfirst(mypath + '~trash\*.tweak', faHidden + faSysFile +
    faReadOnly + faArchive, S) = 0 then
    repeat
      copyfile(PChar(mypath + '~trash\' + s.Name),
        PChar(mypath + 'plugins\' + s.Name), False);
    until findnext(s) <> 0;
  FindClose(S);
  deletefileadv(mypath + 'plugins\descript.ion');
  if findfirst(mypath + 'plugins\*.tweak', faHidden + faSysFile +
    faReadOnly + faArchive, S) = 0 then
    repeat
      Inc(c);
      build(mypath + 'plugins\' + s.Name);
    until findnext(s) <> 0;
  FindClose(S);
  ShowMessage(Format('Обработка плагинов завершена. Обработано %d файлов', [c]));
end;


procedure CreateNilFile(s: string);
var
  T: TextFile;
begin
  assignfile(t, s);
  rewrite(t);
  closefile(t);
end;

procedure TFDCMAIN.Button2Click(Sender: TObject);
var
  r: TDarkRegistry;
  ext, typ, typdesc, cmd: string;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKey_Classes_root;
  ////////////
  repeat
    ext := trim(inputbox('Расширение', 'Введите расширение (например .txt)', ''));
  until ext <> '';
  if ext[1] <> '.' then
    ext := '.' + ext;
  r.CreateKey('\' + ext);
  r.OpenKey('\' + ext);
  if r.ValueExists('') then
    typ := r.ReadString('');
  repeat
    if typ = '' then
      typ := copy(ext, 2, 255) + 'file';
    typ := trim(inputbox('Внутреннее имя типа в реестре',
      'Введите имя типа (например txtfile)', typ));
  until typ <> '';
  r.WriteString('', typ);
  r.CloseKey;
  //////////
  r.CreateKey('\' + typ + '\shell\open\command');
  r.OpenKey('\' + typ);
  if r.ValueExists('') then
    typdesc := r.ReadString('');
  repeat
    if typdesc = '' then
      typdesc := 'Файл ' + ext;
    typdesc := trim(inputbox('Описание типа файла',
      'Введите описание (например Текстовый документ)', typdesc));
  until typdesc <> '';
  r.WriteString('', typdesc);
  r.OpenKey('shell\open\command');
  opendialog.Filter     := '*.*|*.*';
  opendialog.FileName   := '';
  opendialog.InitialDir := windowsdir;
  opendialog.DefaultExt := '*.*';
  opendialog.Title      := 'Укажите программу';
  opendialog.Execute;
  if opendialog.FileName <> '' then
    cmd := '"' + opendialog.FileName + '" "%1"'
  else
    begin
    if r.ValueExists('') then
      cmd := r.ReadString('');
    end;
  repeat
    cmd := trim(inputbox('Путь к программе',
      'Укажите путь (например "notepad.exe" "%1")', cmd));
  until cmd <> '';
  r.WriteString('', cmd);
  r.CloseKey;
  //////////
  r.Free;
  typesref.Click;
end;



procedure TFDCMAIN.alltypesClick(Sender: TObject);
begin
  typesref.Click;
end;

function isinexcl(s: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to excl.Count - 1 do
    if matchesmask(s, excl[i]) then
      begin
      Result := True;
      break;
      end;
end;

procedure TFDCMAIN.Label4Click(Sender: TObject);
begin
  MessageBox(handle, 'Компиляция: ' + BuildStamp, 'FDK by Dark', mb_OK);
end;


procedure TFDCMain.BuildNetShareList;
var
  I:   integer;
  sn:  array[0..max_computername_length] of char;
  len: cardinal;
var
  ShareList: TNetShareList;
begin
  fillchar(sn[0], max_computername_length, 0);
  len := SizeOf(sn);
  getcomputername(@sn[0], len);
  sharelist := TNetShareList.Create;
  sharelist.ServerName := sn;
  with Shared do
    begin
    Items.BeginUpdate;
    try
      Items.Clear;
      ShareList.Refresh;
      for I := 0 to ShareList.Count - 1 do
        items.Add(ShareList[I].ShareName)
    finally
      Items.EndUpdate;
      end;
    end;
  ShareList.Free;
end;


procedure TFDCMAIN.rsharedClick(Sender: TObject);
var
  ss: cardinal;
begin
  if nt then
    begin
    ss := servicestatusid('LanmanServer');
    if ss <> SERVICE_RUNNING then
      begin
      ShowMessage('Служба сервера не запущена.');
      exit;
      end;
    end;
  BuildNetShareList;
end;

procedure TFDCMAIN.sworksClick(Sender: TObject);
begin
  if shared.ItemIndex = -1 then
    exit;
  spopup.Popup(fdcmain.Left + sworks.Left, fdcmain.top + sworks.Top + sworks.Height);
end;

procedure TFDCMAIN.N11Click(Sender: TObject);
begin
  panel2.Visible := True;
end;

procedure TFDCMAIN.Button7Click(Sender: TObject);
var
  n:     string;
  sn:    array[0..max_computername_length] of char;
  ShareList: TNetShareList;
  len:   cardinal;
  i:     integer;
  found: boolean;
begin
  nfo.Clear;
  found := False;
  n     := shared.Items[shared.ItemIndex];
  fillchar(sn[0], max_computername_length, 0);
  len := SizeOf(sn);
  getcomputername(@sn[0], len);
  sharelist := TNetShareList.Create;
  sharelist.ServerName := sn;
  sharelist.Refresh;
  for i := 0 to sharelist.Count - 1 do
    if sharelist[i].ShareNameSame(n) then
      begin
      found := True;
      break;
      end;
  if found then
    begin
    case sacc.ItemIndex of
      0:
        sharelist[i].ShareFlags := SHI50F_RDONLY;
      1:
        sharelist[i].ShareFlags := SHI50F_FULL;
      2:
        sharelist[i].ShareFlags := SHI50F_DEPENDSON;
      end;
    if spers.Checked then
      sharelist[i].ShareFlags := sharelist[i].ShareFlags + SHI50F_PERSIST;
    if shidd.Checked then
      sharelist[i].ShareFlags := sharelist[i].ShareFlags + SHI50F_SYSTEM;
    sharelist[i].PasswordRO := sreadp.Text;
    sharelist[i].PasswordRW := sfullp.Text;
    end;
  sharelist[i].Update;
  sharelist.Free;
  rshared.Click;
  i := shared.Items.IndexOf(n);
  if i <> -1 then
    begin
    shared.ItemIndex := i;
    shared.OnSelect(shared);
    end;
  panel2.Visible := False;
end;

procedure TFDCMAIN.N15Click(Sender: TObject);
var
  n, p:  string;
  sn:    array[0..max_computername_length] of char;
  ShareList: TNetShareList;
  found: boolean;
  len:   cardinal;
  i:     integer;
begin
  nfo.Clear;
  found := False;
  n     := shared.Items[shared.ItemIndex];
  fillchar(sn[0], max_computername_length, 0);
  len := SizeOf(sn);
  getcomputername(@sn[0], len);
  sharelist := TNetShareList.Create;
  sharelist.ServerName := sn;
  for i := 0 to sharelist.Count - 1 do
    if sharelist[i].ShareNameSame(n) then
      begin
      found := True;
      break;
      end;
  if found then
    begin
    p := ShareList[i].Path;
    p := Trim(inputbox('Путь к ресурсу', 'Новый путь:', p));
    ShareList[i].Path := p;
    sharelist[i].Update;
    end;
  sharelist.Free;
  i := shared.Items.IndexOf(n);
  if i <> -1 then
    begin
    shared.ItemIndex := i;
    shared.OnSelect(shared);
    end;
end;

procedure TFDCMAIN.N14Click(Sender: TObject);
var
  n, p:  string;
  sn:    array[0..max_computername_length] of char;
  ShareList: TNetShareList;
  found: boolean;
  len:   cardinal;
  i:     integer;
begin
  nfo.Clear;
  found := False;
  n     := shared.Items[shared.ItemIndex];
  fillchar(sn[0], max_computername_length, 0);
  len := SizeOf(sn);
  getcomputername(@sn[0], len);
  sharelist := TNetShareList.Create;
  sharelist.ServerName := sn;
  for i := 0 to sharelist.Count - 1 do
    if sharelist[i].ShareNameSame(n) then
      begin
      found := True;
      break;
      end;
  if found then
    begin
    p := ShareList[i].Remark;
    p := Trim(inputbox('Описание ресурса', 'Новое описание:', p));
    ShareList[i].Remark := p;
    sharelist[i].Update;
    end;
  sharelist.Free;
  i := shared.Items.IndexOf(n);
  if i <> -1 then
    begin
    shared.ItemIndex := i;
    shared.OnSelect(shared);
    end;
end;

procedure TFDCMAIN.lrefrClick(Sender: TObject);
var
  R:  TDarkRegistry;
  lo: TStringList;
  i:  integer;
  s:  string;
begin
  lrefr.Enabled   := False;
  ldelete.Enabled := False;
  layouts.Clear;
  layouts.Items.BeginUpdate;
  lo := TStringList.Create;
  r  := TDarkRegistry.Create;
  r.RootKey := HKEY_Local_Machine;
  r.OpenKey('SYSTEM\CurrentControlSet\Control\Keyboard Layouts');
  r.GetKeyNames(lo);
  for i := 0 to lo.Count - 1 do
    begin
    r.CloseKey;
    r.OpenKey('SYSTEM\CurrentControlSet\Control\Keyboard Layouts\' + lo[i]);
    s := r.ReadString('Layout Text');
    layouts.Items.Add(lo[i] + ': ' + s);
    end;
  layouts.Sorted := True;
  layouts.Sorted := False;
  r.Free;
  lo.Free;
  layouts.Items.EndUpdate;
  lrefr.Enabled   := True;
  ldelete.Enabled := True;

end;

procedure TFDCMAIN.ldeleteClick(Sender: TObject);
var
  R:    TDarkRegistry;
  Name: string;
begin
  if layouts.ItemIndex = -1 then
    exit;
  lrefr.Enabled := False;
  ldelete.Enabled := False;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_Local_Machine;
  r.OpenKey('SYSTEM\CurrentControlSet\Control\Keyboard Layouts');
  Name := Copy(layouts.Items[layouts.ItemIndex], 1, pos(
    ':', layouts.Items[layouts.ItemIndex]) - 1);
  if r.keyexists(Name) then
    if messagedlg('Действительно удалить раскладку ' +
      layouts.Items[layouts.ItemIndex] + '?', mtConfirmation,
      mbOkCancel, 0) = idOk then
      r.DeleteKey(Name);
  r.Free;
  lrefr.Click;
  lrefr.Enabled   := True;
  ldelete.Enabled := True;
end;

procedure TFDCMAIN.trefrClick(Sender: TObject);
var
  R:  TDarkRegistry;
  lo: TStringList;
  i:  integer;
  s:  string;
begin
  trefr.Enabled   := False;
  tdelete.Enabled := False;
  times.Clear;
  times.Items.BeginUpdate;
  lo := TStringList.Create;
  r  := TDarkRegistry.Create;
  r.RootKey := HKEY_Local_Machine;
  if nt then
    r.OpenKey('Software\Microsoft\Windows NT\CurrentVersion\Time Zones')
  else
    r.OpenKey('Software\Microsoft\Windows\CurrentVersion\Time Zones');
  r.GetKeyNames(lo);
  for i := 0 to lo.Count - 1 do
    begin
    r.CloseKey;
    if nt then
      r.OpenKey('Software\Microsoft\Windows NT\CurrentVersion\Time Zones\' + lo[i])
    else
      r.OpenKey('Software\Microsoft\Windows\CurrentVersion\Time Zones\' + lo[i]);
    s := r.ReadString('Display');
    times.Items.Add(lo[i] + ': ' + s);
    end;
  times.Sorted := True;
  times.Sorted := False;
  r.Free;
  lo.Free;
  times.Items.EndUpdate;
  trefr.Enabled   := True;
  tdelete.Enabled := True;

end;

procedure TFDCMAIN.tdeleteClick(Sender: TObject);
var
  R:    TDarkRegistry;
  Name: string;
begin
  if times.ItemIndex = -1 then
    exit;
  trefr.Enabled := False;
  tdelete.Enabled := False;
  r := TDarkRegistry.Create;
  r.RootKey := HKEY_Local_Machine;
  if nt then
    r.OpenKey('Software\Microsoft\Windows NT\CurrentVersion\Time Zones')
  else
    r.OpenKey('Software\Microsoft\Windows\CurrentVersion\Time Zones');
  Name := Copy(times.Items[times.ItemIndex], 1,
    pos(':', times.Items[times.ItemIndex]) - 1);
  if r.keyexists(Name) then
    if messagedlg('Действительно удалить часовой пояс ' +
      times.Items[times.ItemIndex] + '?', mtConfirmation, mbOkCancel, 0) = idOk then
      r.DeleteKey(Name);
  r.Free;
  trefr.Click;
  trefr.Enabled   := True;
  tdelete.Enabled := True;
end;

procedure TFdcMain.RunScript(s: string);
var
  sl: TStringList;
  fs: TFScript;
begin
  if not fileexists(s) then
    begin
    ShowMessage('Скрипт не найден ''' + s + '''');
    exit;
    end;
  sl := TStringList.Create;
  sl.LoadFromFile(s);
  fs := TFScript.Create(sl);
  fs.OnDebug := @dbg;
  fs.OnError := @log;
  sl.Free;
  fs.AddVar('NT', _bool, _var, nt);
  fs.Run;
  fs.Free;

end;


procedure TFDCMAIN.autorunClick(Sender: TObject);
var
  s, rk, k, id: string;
  r: TDarkRegistry;
begin
  if autorun.ItemIndex = -1 then
    exit;
  s  := autorun.Items[autorun.ItemIndex];
  rk := copy(s, 1, pos(',', s) - 1);
  Delete(s, 1, length(rk) + 1);
  k := copy(s, 1, pos(',', s) - 1);
  Delete(s, 1, length(k) + 1);
  id := s;
  r  := tdarkregistry.Create;
  if rk = 'HKCU' then
    r.rootkey := HKEY_Current_User;
  if rk = 'HKLM' then
    r.rootkey := HKEY_Local_Machine;
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\' + k);
  ShowMessage(Format('Ветвь: %s%s Ключ: %s%s Идентификатор: %s%s Команда: %s',
    [rk, #13#10, k, #13#10, id, #13#10, r.ReadString(id)]));
  r.CloseKey;
  r.Free;
end;

procedure TFDCMAIN.sharedSelect(Sender: TObject);
var
  n:     string;
  sn:    array[0..max_computername_length] of char;
  ShareList: TNetShareList;
  len:   cardinal;
  i, fl: integer;
  found: boolean;
begin
  dshared.Enabled := False;
  sworks.Enabled  := False;
  if shared.ItemIndex = -1 then
    exit;
  nfo.Clear;
  found := False;
  n     := shared.Items[shared.ItemIndex];
  fillchar(sn[0], max_computername_length, 0);
  len := SizeOf(sn);
  getcomputername(@sn[0], len);
  sharelist := TNetShareList.Create;
  sharelist.ServerName := sn;
  for i := 0 to sharelist.Count - 1 do
    if sharelist[i].ShareNameSame(n) then
      begin
      found := True;
      dshared.Enabled := True;
      sworks.Enabled := True;
      break;
      end;
  if found then
    begin
    nfo.Items.Append(Format('Имя ресурса: %s', [sharelist[i].ShareName]));
    nfo.Items.Append(Format('Описание ресурса: %s', [sharelist[i].Remark]));
    nfo.Items.Append(Format('Физическое расположение ресурса: %s', [sharelist[i].Path]));
    sreadp.Text := sharelist[i].PasswordRO;
    sfullp.Text := sharelist[i].PasswordRW;
    fl := sharelist[i].ShareFlags;
    nfo.Items.Append(Format('Права доступа: %sh', [IntToHex(fl, 3)]));

    ////////
    if fl and SHI50F_RDONLY = SHI50F_RDONLY then
      begin
      if sharelist[i].PasswordRW = '' then
        nfo.Items.Add('x Досуп только для чтения без указания пароля.')
      else
        nfo.Items.Add('x Доступ для чтения c паролем ' + Sharelist[i].PasswordRO);

      sacc.ItemIndex := 0;
      end;
    if fl and SHI50F_FULL = SHI50F_FULL then
      begin
      if sharelist[i].PasswordRW = '' then
        nfo.Items.Add('x Полный доступ без указания пароля.')
      else
        nfo.Items.Add('x Полный доступ c паролем ' + Sharelist[i].PasswordRW);
      sacc.ItemIndex := 1;
      end;
    if fl and SHI50F_PERSIST = SHI50F_PERSIST then
      begin
      nfo.Items.Add('x Постоянный ресурс');
      spers.Checked := True;
      end;
    if fl and SHI50F_SYSTEM = SHI50F_SYSTEM then
      begin
      nfo.Items.Add('x Скрытый ресурс');
      spers.Checked := True;
      end;

    ////////

    end;
  sharelist.Free;
end;

procedure TFDCMAIN.saccClick(Sender: TObject);
begin
  case sacc.ItemIndex
    of
    0:
      begin
      sreadp.Enabled := True;
      sfullp.Enabled := False;
      end;
    1:
      begin
      sreadp.Enabled := False;
      sfullp.Enabled := True;
      end;
    2:
      begin
      sreadp.Enabled := True;
      sfullp.Enabled := True;
      end;
    end;
end;

procedure TFDCMAIN.dsharedClick(Sender: TObject);
var
  n:     string;
  sn:    array[0..max_computername_length] of char;
  ShareList: TNetShareList;
  found: boolean;
  len:   cardinal;
  i:     integer;
begin
  nfo.Clear;
  found := False;
  n     := shared.Items[shared.ItemIndex];
  fillchar(sn[0], max_computername_length, 0);
  len := SizeOf(sn);
  getcomputername(@sn[0], len);
  sharelist := TNetShareList.Create;
  sharelist.ServerName := sn;
  for i := 0 to sharelist.Count - 1 do
    if sharelist[i].ShareNameSame(n) then
      begin
      found := True;
      break;
      end;
  if found then
    begin
    ShareList[i].DeleteShare;
    end;
  sharelist.Free;
  rshared.Click;
end;

procedure TFdcMain.NextTaskStep;
var
  ct: TStringList;
  i:  integer;
begin
  if flistiffirsttime <> '' then
    begin
    tasks.LoadFromFile(flistiffirsttime);
    end
  else
    Inc(tasknum);
  if tasknum = tasks.Count then
    begin
    ShowMessage('Задача выполнена!');
    exit;
    end;
  ct := TStringList.Create;
  StrToSList(tasks[tasknum], ct);
  for i := 0 to ct.Count - 1 do
    ct[i] := FixEnv(LowerCase(Trim(ct[i])));
  if ct[0] = 'findinpath' then
    begin
    where.Text      := ct[1];
    smask.Text      := ct[2];
    autodel.Checked := True;
    //////GS!!!//////
    if options.Checked[6] then
      begin
      if not checksafe(smask.Text) then
        begin
        if messagedlg(
          'Среди файлов, которые могут быть найдены (и удалены) при данном поиске могут быть важные, действительно продолжить?',
          mtConfirmation, mbOkCancel, 0) = idOk then
          gotosearch(self);
        end
      else
        gotosearch(self);

      end
    else
      gotosearch(self);
    /////////

    waitfordk := True;
    exit;
    end
  else
  if ct[0] = 'exit' then
    begin
    ct.Free;
    application.Terminate;
    exit;
    end
  else
  if ct[0] = 'setpriority' then
    begin
    track.Position := strtointdef(ct[1], 3);
    trackchange(self);
    end
  else
  if ct[0] = 'runscript' then
    begin
    runscript(ct[1]);
    end
  else
  if ct[0] = 'sysinfo' then
    begin
    obn.Click;
    otc.Lines.SaveToFile(ct[1]);
    end
  else
    ShowMessage('Ошибка на строке ' + IntToStr(tasknum + 1) + ' "' +
      tasks[tasknum] + '"');

  ct.Free;
  NextTaskStep;
end;

procedure TFDCMain.StrToSList(Value: string; var StrList: TStringList);
var
  P, P1: PChar;
  S:     string;
begin
  P := PChar(Value);
  while P^ in [#1..' '] do
    P := CharNext(P);
  while P^ <> #0 do
    begin
    if P^ = '"' then
      S := AnsiExtractQuotedStr(P, '"')
    else
      begin
      P1 := P;
      while (P^ <> '|') and (P^ >= ' ') do
        P := CharNext(P);
      SetString(S, P1, P - P1);
      end;
    StrList.Add(S);
    while P^ in [#1..' '] do
      P := CharNext(P);
    if P^ = '|' then
      begin
      P1 := P;
      if CharNext(P1)^ = #0 then
        Add('');
      repeat
        P := CharNext(P);
      until not (P^ in [#1..' ']);
      end;

    end;
end;


procedure tfdcmain.WriteEnv;
var
  R: TDarkRegistry;
begin
  r := TDarkRegistry.Create;
  r.RootKey := HKey_Local_Machine;
  r.OpenKey('\SYSTEM\CurrentControlSet\Control\Session Manager\Environment');
  r.WriteString('FDCDIR', SysUtils.ExcludeTrailingPathDelimiter(mypath));
  r.Free;
end;



procedure TFDCMAIN.abntpresetSelect(Sender: TObject);
var
  t: string;
begin
  if (Sender as tcombobox).ItemIndex <> (Sender as tcombobox).Items.Count - 1 then
    begin
    t := abnt.Lines[abnt.caretpos.y];
    insert(FixEnv(abntpreset.Text), T, abnt.caretpos.x + 1);
    abnt.Lines[abnt.caretpos.y] := t;
    end
  else
    begin
    runandwait('notepad.exe ' + (mypath + usrdir) + '\autoexecnt.fdp');
    abntpreset.Items.LoadFromFile(mypath + usrdir + '\autoexecnt.fdp');
    abntpreset.Sorted := True;
    abntpreset.Sorted := False;
    abntpreset.Items.Add('[Изменить этот список]');
    end;
end;

procedure TFDCMAIN.csntpresetSelect(Sender: TObject);
var
  t: string;
begin
  if (Sender as tcombobox).ItemIndex <> (Sender as tcombobox).Items.Count - 1 then
    begin
    t := csnt.Lines[csnt.caretpos.y];
    insert(FixEnv(csntpreset.Text), T, csnt.caretpos.x + 1);
    csnt.Lines[csnt.caretpos.y] := t;
    end
  else
    begin
    runandwait('notepad.exe ' + (mypath + usrdir) + '\confignt.fdp');
    csntpreset.Items.LoadFromFile(mypath + usrdir + '\confignt.fdp');
    csntpreset.Sorted := True;
    csntpreset.Sorted := False;
    csntpreset.Items.Add('[Изменить этот список]');
    end;
end;

procedure TFDCMAIN.ToolButton1Click(Sender: TObject);
begin
  abnt.Lines.SaveToFile(windowsdir + 'system32\autoexec.nt');
end;

procedure TFDCMAIN.ToolButton3Click(Sender: TObject);
begin
  abnt.Lines.LoadFromFile(windowsdir + 'system32\autoexec.nt');
end;

procedure TFDCMAIN.ToolButton7Click(Sender: TObject);
begin
  csnt.Lines.SaveToFile(windowsdir + 'system32\config.nt');
end;

procedure TFDCMAIN.ToolButton8Click(Sender: TObject);
begin
  csnt.Lines.LoadFromFile(windowsdir + 'system32\config.nt');
end;

procedure TFDCMAIN.ToolButton4Click(Sender: TObject);
begin
  abnt.Lines.BeginUpdate;
  abnt.Lines.Clear;
  abnt.Lines.Add(Format('lh %ssystem32\mscdexnt.exe', [windowsdir]));
  abnt.Lines.Add(Format('lh %ssystem32\redir', [windowsdir]));
  abnt.Lines.Add(Format('lh %ssystem32\dosx', [windowsdir]));
  abnt.Lines.Add('SET BLASTER=A220 I5 D1 P330 T3');
  abnt.Lines.EndUpdate;
end;

procedure TFDCMAIN.ToolButton11Click(Sender: TObject);
begin
  csnt.Lines.BeginUpdate;
  csnt.Lines.Clear;
  csnt.Lines.Add(Format('DOS=High,Umb', []));
  csnt.Lines.Add(Format('device=%ssystem32\himem.sys', [windowsdir]));
  csnt.Lines.Add(Format('Files=60', []));
  csnt.Lines.EndUpdate;
end;

procedure ExtractRes(ResType, ResName, ResNewName: string);
var
  Res: TResourceStream;
begin
  Res := TResourceStream.Create(Hinstance, Resname, PChar(ResType));
  Res.SavetoFile(ResNewName);
  Res.Free;
end;

procedure TFDCMAIN.ExtractInstall;
var
  T: TStringList;
  i: integer;

begin
  extractres('FLIST', 'OTHER', mypath + 'flist.txt');
  T := TStringList.Create;
  t.LoadFromFile(mypath + 'flist.txt');
  for i := 0 to t.Count - 1 do
    begin
    if not directoryexists(extractfiledir(mypath + t.ValueFromIndex[i])) then
      forcedirectories(extractfiledir(mypath + t.ValueFromIndex[i]));
    extractres(t.Names[i], 'I', mypath + t.ValueFromIndex[i]);
    end;
  T.Free;
  if nt then
    copyfile(PChar(mypath + 'fdkcp.cpl'), PChar(windowsdir +
      '\system32\fdkcp.cpl'), False)
  else
    copyfile(PChar(mypath + 'fdkcp.cpl'), PChar(windowsdir +
      '\system\fdkcp.cpl'), False);
  deletefileadv(mypath + 'flist.txt');
  deletefileadv(PChar(mypath + 'fdkcp.cpl'));
end;

procedure TFDCMAIN.specClick(Sender: TObject);
begin
  if view.Visible then
    view.Hide
  else
    view.Show;
end;

procedure TFDCMAIN.presetSelect(Sender: TObject);
 //var
 //  E: TNotifyEvent;
begin
  if (preset.ItemIndex <> -1) and (preset.ItemIndex <> preset.Items.Count - 1) then
    begin
    //    E := smask.OnChange;
    //    smask.OnChange := nil;
    //    smask.Text := templ.Values[preset.Items[preset.ItemIndex]];
    //    smask.OnChange := E;
    spreset.ItemIndex := spreset.Items.IndexOf(preset.Items[preset.ItemIndex]);
    Freshpreset(self);
    end;

end;

procedure TFDCMAIN.smaskChange(Sender: TObject);
begin
  preset.ItemIndex := preset.Items.Count - 1;
  preset.Hint      := 'Шаблон поиска: ' + preset.Items[preset.ItemIndex] +
    #13#10 + 'Маски файлов: ' + smask.Text;
end;

procedure TFDCMAIN.refsClick(Sender: TObject);
var
  r:  TDarkRegistry;
  ts: TStringList;
  i:  integer;
begin
  dels.Enabled := False;
  refs.Enabled := False;
  software.Items.BeginUpdate;
  software.Items.Clear;
  r  := TDarkRegistry.Create;
  ts := TStringList.Create;
  r.RootKey := HKey_Local_Machine;
  r.OpenKey('Software');
  r.GetKeyNames(ts);
  for i := 0 to ts.Count - 1 do
    ts[i] := 'LM,' + ts[i];
  software.Items.AddStrings(ts);
  r.RootKey := HKey_Current_User;
  r.OpenKey('Software');
  ts.Clear;
  r.GetKeyNames(ts);
  for i := 0 to ts.Count - 1 do
    ts[i] := 'USR,' + ts[i];
  software.Items.AddStrings(ts);
  r.Free;
  ts.Free;
  software.Items.EndUpdate;
  dels.Enabled := True;
  refs.Enabled := True;
end;

procedure TFDCMAIN.delsClick(Sender: TObject);
var
  r: Tdarkregistry;
begin
  if software.ItemIndex = -1 then
    exit;
  dels.Enabled := False;
  refs.Enabled := False;
  r := Tdarkregistry.Create;
  if pos('LM', software.Items[software.ItemIndex]) = 1 then
    begin
    r.RootKey := HKey_Local_machine;
    r.OpenKey('SOFTWARE');
    if messagedlg('Действительно удалить запись ' + copy(
      software.Items[software.ItemIndex], 4, 255) + ' из реестра?',
      mtConfirmation, mbOkCancel, 0) = idOk then
      r.DeleteKey(copy(software.Items[software.ItemIndex], 4, 255));
    end
  else
    begin
    r.RootKey := HKey_Current_User;
    r.OpenKey('SOFTWARE');
    if messagedlg('Действительно удалить запись ' + copy(
      software.Items[software.ItemIndex], 5, 255) + ' из реестра?',
      mtConfirmation, mbOkCancel, 0) = idOk then
      r.DeleteKey(copy(software.Items[software.ItemIndex], 5, 255));
    end;
  r.Free;
  refs.Click;
  dels.Enabled := True;
  refs.Enabled := True;
end;

procedure TFDCMAIN.safedClick(Sender: TObject);
begin
  if safe.ItemIndex <> -1 then
    begin
    safe.Items.Delete(safe.ItemIndex);
    safe.Sorted := True;
    safe.Sorted := False;
    end;
end;

procedure TFDCMAIN.safeaClick(Sender: TObject);
var
  s: string;
begin
  s := inputbox('Добавление маски', 'Маска', '');
  if s = '' then
    exit;
  if safe.Items.IndexOf(s) = -1 then
    begin
    safe.Items.Add(s);
    safe.Sorted := True;
    safe.Sorted := False;
    end;
end;

procedure TFDCMAIN.addprClick(Sender: TObject);
var
  s: TStringList;
  i: integer;
begin
  if safen.ItemIndex = -1 then
    exit;
  s := TStringList.Create;
  s.Delimiter := ';';
  s.DelimitedText := templ.Values[safen.Items[safen.ItemIndex]];
  for i := 0 to s.Count - 1 do
    if safe.Items.IndexOf(s[i]) = -1 then
      safe.Items.Add(s[i]);
  s.Free;
end;

function TFDCMAIN.CheckSafe(s: string): boolean;
var
  i:  integer;
  sl: TStringList;
begin
  Result := True;
  sl     := TStringList.Create;
  sl.Delimiter := ';';
  sl.DelimitedText := s;
  for i := 0 to sl.Count - 1 do
    begin
    if safe.Items.IndexOf(sl[i]) = -1 then
      begin
      Result := False;
      break;
      end;
    end;
  sl.Free;
end;

procedure TFDCMAIN.sbtnClick(Sender: TObject);
begin
  ////////////
  if options.Checked[6] then
    begin
    if not checksafe(smask.Text) then
      begin
      if messagedlg(
        'Среди файлов, которые могут быть найдены (и удалены) при данном поиске могут быть важные, действительно продолжить?',
        mtConfirmation, mbOkCancel, 0) = idOk then
        gotosearch(self);
      end
    else
      gotosearch(self);

    end
  else
    gotosearch(self);
  /////////
end;

procedure TFDCMAIN.Button1Click(Sender: TObject);
begin
  RebuildIconCache;
  SHChangeNotify(SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
  ///  runandwait('rundll32.exe user,repaintscreen');
end;

procedure TFDCMAIN.setwClick(Sender: TObject);
{var
  pic: TPicture;
  bmp: Tbitmap;
  s:   string;}
begin
{  s := getwallpaper;
  if ansilowercase(extractfileext(s)) = '.bmp' then
   begin
    ShowMessage('Картинка уже в формате bmp!');
    exit;
   end;
  if not fileexists(s) then
   begin
    ShowMessage('Картинка не найдена!');
    exit;
   end;

  pic := TPicture.Create;
  bmp := TBitmap.Create;
  pic.LoadFromFile(s);
  bmp.Canvas.Lock;
  bmp.Width  := pic.Width;
  bmp.Height := pic.Height;
  bmp.Canvas.Draw(0, 0, pic.Graphic);
  bmp.Canvas.UnLock;
  pic.Free;
  bmp.PixelFormat := pf24bit;
  s := changefileext(s, '.bmp');
  bmp.SaveToFile(s);
  bmp.Dormant;
  bmp.FreeImage;
  bmp.Free;
  setwallpaper(s);
  ShowMessage('Картинка преобразована в bmp!');}
end;

procedure TFDCMAIN.checkClick(Sender: TObject);
var
  s: string;
  i: integer;
  fbc, tb: int64;
  mema, memf, proc: integer;
begin
  chk.Lines.BeginUpdate;
  chk.Lines.Clear;
  s := fdcfuncs.getharddrives;
  for i := 1 to length(s) - 1 do
    begin
    SysUtils.GetDiskFreeSpaceEx(PChar(s[i] + ':\'), fbc, tb, nil);
    chk.Lines.Add(format('Диск %s: Емкость: %10.2f Мб   Свободно: %10.2f Мб',
      [s[i], tb / 1024 / 1024, fbc / 1024 / 1024]));
    if fbc < 512 * 1024 * 1204 then
      chk.Lines.Add(s[i] + ': - На диске свободно меньше 512 Мб!');
    if (fbc / tb * 100) < 5 then
      chk.Lines.Add(s[i] + ': - На диске свободно меньше 5% от емкости диска!');
    end;
  if IsActiveDeskTopOn then
    chk.Lines.Add('Используется активный рабочий стол. Это снижает производительность.');
  mema := mem.GetMemoryStatus.TotalPhys;
  memf := mem.GetMemoryStatus.AvailPhys;
  chk.Lines.Add(format('Физическая память (ОЗУ) = Всего: %d Мб   Свободно: %d Мб',
    [mema, memf]));
  if memf / mema * 100 < 20 then
    chk.Lines.Add('Свободно меньше 20% физической памяти!');
  s    := fdcfuncs.WinProduct;
  proc := trunc(getcpuspeed);
  chk.Lines.Add(Format('Скорость процессора: %d МГц', [proc]));
  chk.Lines.Add('Операционная система: ' + s);
  if pos('Windows Xp', s) > 0 then
    begin
    if proc < 500 then
      chk.Lines.Add('Рекомендуется процессор от 500 МГц!');
    if mema < 128 then
      chk.Lines.Add('Рекомендуется как минимум 128 Мб ОЗУ!');
    end
  else
  if pos('Windows 2000', s) > 0 then
    begin
    if proc < 366 then
      chk.Lines.Add('Рекомендуется процессор от 366 МГц!');
    if mema < 128 then
      chk.Lines.Add('Рекомендуется как минимум 128 Мб ОЗУ!');

    end
  else
  if pos('Windows NT', s) > 0 then
    begin
    if proc < 233 then
      chk.Lines.Add('Рекомендуется процессор от 233 МГц!');
    if mema < 64 then
      chk.Lines.Add('Рекомендуется как минимум 64 Мб ОЗУ!');
    chk.Lines.Add('Операционная система устарела, рекомендуется обновление!');
    end
  else
  if pos('Windows 95', s) > 0 then
    begin
    if proc < 133 then
      chk.Lines.Add('Рекомендуется процессор от 133 МГц!');
    if mema < 16 then
      chk.Lines.Add('Рекомендуется как минимум 32 Мб ОЗУ!');
    chk.Lines.Add('Операционная система устарела, рекомендуется обновление!');
    end
  else
  if pos('Windows 98', s) > 0 then
    begin
    if proc < 233 then
      chk.Lines.Add('Рекомендуется процессор от 366 МГц!');
    if mema < 64 then
      chk.Lines.Add('Рекомендуется как минимум 64 Мб ОЗУ!');
    end;
  chk.Lines.EndUpdate;
end;

procedure TFDCMAIN.fixfontsClick(Sender: TObject);
var
  ini: Tinifile;
  reg: TDarkRegistry;
begin
  if not nt then
    begin
    ini := Tinifile.Create(windowsdir + '\win.ini');
    ini.WriteString('FontSubstitutes', 'Arial,0', 'Arial,204');
    ini.WriteString('FontSubstitutes', 'Comic Sans MS,0', 'Comic Sans MS,204');
    ini.WriteString('FontSubstitutes', 'Microsoft Sans Serif,0',
      'Microsoft Sans Serif,204');
    ini.WriteString('FontSubstitutes', 'Tahoma,0', 'Tahoma,204');
    ini.WriteString('FontSubstitutes', 'Times New Roman,0', 'Times New Roman,204');
    ini.WriteString('FontSubstitutes', 'Verdana,0', 'Verdana,204');
    ini.Free;
    reg := TDarkRegistry.Create;
    reg.RootKey := HKey_Local_Machine;
    reg.OpenKey('\System\CurrentControlSet\Control\Nls\Codepage');
    reg.WriteString('1250', 'cp_1251.nls');
    reg.WriteString('1251', 'cp_1251.nls');
    reg.WriteString('1252', 'cp_1251.nls');
    reg.WriteString('1253', 'cp_1251.nls');
    reg.WriteString('1254', 'cp_1251.nls');
    reg.WriteString('1255', 'cp_1251.nls');
    reg.Free;
    end
  else
    begin
    reg := TDarkRegistry.Create;
    reg.RootKey := HKey_Local_Machine;
    reg.OpenKey('\System\CurrentControlSet\Control\Nls\Codepage');
    reg.WriteString('1252', 'c_1251.nls');
    reg.CloseKey;
    reg.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes');
    reg.WriteString('Arial,0', 'Arial,204');
    reg.WriteString('Comic Sans MS,0', 'Comic Sans MS,204');
    reg.WriteString('Microsoft Sans Serif,0', 'Microsoft Sans Serif,204');
    reg.WriteString('Tahoma,0', 'Tahoma,204');
    reg.WriteString('Times New Roman,0', 'Times New Roman,204');
    reg.WriteString('Verdana,0', 'Verdana,204');
    reg.Free;

    end;
end;

procedure TFDCMAIN.goboxSelect(Sender: TObject);
begin
  if gobox.ItemIndex <= pc.PageCount - 1 then
    pc.ActivePageIndex := gobox.ItemIndex
  else
    begin
    pc.ActivePage := tabsheet11;
    pc3.ActivePageIndex := gobox.ItemIndex - (pc.PageCount);
    end;
  pcchange(self);
end;

procedure TFDCMAIN.upUpClick(Sender: TObject);
begin
  if cheats.ItemIndex <> 0 then
    cheats.ItemIndex := cheats.ItemIndex - 1;
  cheatsSelect(self);
end;

procedure TFDCMAIN.upDownClick(Sender: TObject);
begin
  if cheats.ItemIndex <> cheats.Count - 1 then
    cheats.ItemIndex := cheats.ItemIndex + 1;
  cheatsSelect(self);
end;

end.
