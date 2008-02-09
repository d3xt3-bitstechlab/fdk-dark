unit fdccp;

interface

uses
  Classes, CtlPanel, SysUtils, Registry;

type
  TFDKControl = class(TAppletModule)
    procedure AppletModuleActivate(Sender: TObject; Data: integer);
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
  end;

var
  FDKControl: TFDKControl;

implementation

{$R *.DFM}

function ShellExecute(hWnd: longword; Operation, FileName, Parameters, Directory: PChar;
  ShowCmd: integer): HINST; stdcall; external 'shell32.dll' Name 'ShellExecuteA';


procedure TFDKControl.AppletModuleActivate(Sender: TObject; Data: integer);
var
  s: string;
  R: TRegistry;

begin
  r := TRegistry.Create;
  r.RootKey := $80000002;
  r.OpenKey('\SYSTEM\CurrentControlSet\Control\Session Manager\Environment', True);
  s := r.ReadString('FDCDIR');
  r.Free;
  if s <> '' then
  begin
    if s[length(s)] <> '\' then
      s := s + '\';
    shellexecute(0, 'open', PChar(s + 'fdk.exe'), '', PChar(s), 0);
  end;
end;

end.
