unit upd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtrls, SHDocVw, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, ExtCtrls, cfg, shellapi,
  ComCtrls;

type
  TLUForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    url:     TEdit;
    Button1: TButton;
    hhh:     TIdHTTP;
    log:     TMemo;
    localver: TEdit;
    sitever: TEdit;
    Label1:  TLabel;
    fileurl: TEdit;
    Label8:  TLabel;
    Panel1:  TPanel;
    Label6:  TLabel;
    Label7:  TLabel;
    Progress: TProgressBar;
    GroupBox1: TGroupBox;
    Label2:  TLabel;
    Label3:  TLabel;
    proxyport: TEdit;
    proxy:   TEdit;
    puser:   TEdit;
    ppassw:  TEdit;
    Label5:  TLabel;
    Label4:  TLabel;
    GroupBox2: TGroupBox;
    hostname: TEdit;
    Label9:  TLabel;
    ba:      TCheckBox;
    agent:   TEdit;
    Label10: TLabel;
    Panel2:  TPanel;
    Image1:  TImage;
    procedure Button1Click(Sender: TObject);
    procedure hhhStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure hhhWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCountMax: integer);
    procedure hhhWork(Sender: TObject; AWorkMode: TWorkMode;
      const AWorkCount: integer);
    procedure hhhWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LUForm: TLUForm;

implementation

{$R *.dfm}

var
  update_string: string = '';

var
  last_update: string = '';

var
  max: integer = 0;

procedure TLUForm.Button1Click(Sender: TObject);
var
  fil: TStream;
begin
  button1.Enabled := False;
  log.Clear;
  localver.Text := last_update;
  hhh.ProxyParams.ProxyServer := proxy.Text;
  hhh.ProxyParams.ProxyPort := strtointdef(proxyport.Text, 80);
  hhh.ProxyParams.ProxyUserName := puser.Text;
  hhh.ProxyParams.ProxyPassword := ppassw.Text;
  hhh.ProxyParams.BasicAuthentication := ba.Checked;
  hhh.Request.UserAgent := agent.Text;
  hhh.Host      := hostname.Text;
  hhh.Request.Accept := 'text/plain';
  try
    log.Lines.Add('get ' + url.Text);
    update_string := Trim(hhh.get(url.Text));
  except
    on e: Exception do
      ShowMessage('Update failed with error: ' + e.Message);
  end;
  if update_string <> '' then
  begin
    Delete(update_string, 1, pos('=', update_string) + 1);
    sitever.Text := update_string;
    if last_update = update_string then
    begin
      ShowMessage('No changes since last update!');
    end
    else
    begin
      fil := TFileStream.Create(ExtractFilePath(application.ExeName) +
        'fdc.rar', fmCreate);
      try
        hhh.Request.Accept := 'application/*';
        log.Lines.Add('get ' + fileurl.Text);
        hhh.Get(fileurl.Text, fil);
        ShellExecute(luform.Handle, PChar('open'),
          PChar(ExtractFilePath(application.ExeName) + 'fdc.rar'),
          '', '', 0);
        last_update := update_string;
      except
        on e: Exception do
          ShowMessage('Update aborted: ' + e.Message);
      end;

      fil.Free;
    end;
  end;
  button1.Enabled := True;
end;

procedure TLUForm.hhhStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  log.Lines.Add(AStatusText);
end;

procedure TLUForm.FormCreate(Sender: TObject);
var
  i: TCFG;
begin
  i := TCFG.Create(ExtractFilePath(application.ExeName) + 'lu.ini');
  last_update := i.ReadString('lastupdate', 'none');
  url.Text := i.ReadString('url', url.Text);
  fileurl.Text := i.ReadString('fileurl', fileurl.Text);
  proxyport.Text := i.ReadString('proxyport', proxyport.Text);
  proxy.Text := i.ReadString('proxy', proxy.Text);
  puser.Text := i.ReadString('proxyuser', puser.Text);
  ppassw.Text := i.ReadString('proxypass', ppassw.Text);
  puser.Text := i.ReadString('proxyuser', puser.Text);
  hostname.Text := i.ReadString('hostname', hostname.Text);
  agent.Text := i.ReadString('useragent', agent.Text);
  ba.Checked := i.ReadBool('basicauth', ba.Checked);
  i.Free;
end;

procedure TLUForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: TCFG;
begin
  i := TCFG.Create(ExtractFilePath(application.ExeName) + 'lu.ini');
  i.WriteString('hostname', hostname.Text);
  i.WriteString('lastupdate', last_update);
  i.WriteString('proxyport', proxyport.Text);
  i.WriteString('proxy', proxy.Text);
  i.WriteString('proxyuser', puser.Text);
  i.WriteString('proxypass', ppassw.Text);
  i.WriteString('proxyuser', puser.Text);
  i.WriteString('url', url.Text);
  i.WriteString('fileurl', fileurl.Text);
  i.WriteString('useragent', agent.Text);
  i.WriteBool('basicauth', ba.Checked);
  i.Free;

end;

procedure TLUForm.hhhWorkBegin(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCountMax: integer);
begin
  max := AWorkCountMax;
  progress.Max := max;
  progress.Position := 0;
end;

procedure TLUForm.hhhWork(Sender: TObject; AWorkMode: TWorkMode;
  const AWorkCount: integer);
begin
  progress.Position := AWorkCount;
end;

procedure TLUForm.hhhWorkEnd(Sender: TObject; AWorkMode: TWorkMode);
begin
  progress.Position := max;
end;

procedure TLUForm.Image1Click(Sender: TObject);
begin
  shellexecute(luform.Handle, 'open', 'http://www.executor03.narod.ru/dark.html',
    '', '', 0);
end;

end.
