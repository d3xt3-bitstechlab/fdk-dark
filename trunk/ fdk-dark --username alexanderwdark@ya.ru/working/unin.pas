unit unin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ssbase, shlobj, darkregistry, delcat,
  ComCtrls, shellapi, fdcfuncs;

type
  TUninstallForm = class(TForm)
    Label4: TLabel;
    Label1: TLabel;
    Memo1:  TMemo;
    StaticText10: TStaticText;
    StaticText8: TStaticText;
    StaticText6: TStaticText;
    StaticText4: TStaticText;
    StaticText3: TStaticText;
    StaticText5: TStaticText;
    StaticText7: TStaticText;
    StaticText9: TStaticText;
    Bevel1: TBevel;
    Shape4: TShape;
    Shape3: TShape;
    log:    TRichEdit;
    Label3: TLabel;
    procedure StaticText3Click(Sender: TObject);
    procedure StaticText3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText5Click(Sender: TObject);
    procedure StaticText5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText7MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText9MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText9MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText9Click(Sender: TObject);
    procedure StaticText3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure FormCreate(Sender: TObject);
    procedure Label3MouseEnter(Sender: TObject);
    procedure Label3MouseLeave(Sender: TObject);
    procedure StaticText7Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UninstallForm: TUninstallForm;

implementation

uses mainunit;

{$R *.dfm}

function MakePath(dir: string; fs: TStSpecialRootFolder): string;
var
  IDList: PItemIDList;
  Buff:   array [0..259] of char;
  ParentHandle: integer;
begin
  IDList := nil;
  ParentHandle := 0;
  SHGetSpecialFolderLocation(ParentHandle,
    ShellFolders[FS], IDList);
  if Assigned(IDList) then
  begin
    SHGetPathFromIDList(IDList, Buff);
    Result := string(Buff) + '\';
    if dir <> '' then
      Result := Result + dir + '\';
  end;
end;


procedure TUninstallForm.StaticText3Click(Sender: TObject);
var
  r: TDarkRegistry;
  s: string;
begin
  s := GetEnvironmentVariable('fdcdir');
  if s <> '' then
  begin
    if messagedlg('Удалить все файлы в каталоге ' + s + '?',
      mtConfirmation, mbOkCancel, 0) = idOk then
    begin
      delcat.DarkKillDir(GetEnvironmentVariable('fdcdir'));
      log.Lines.add('Программные файлы удалены.');
    end
    else
      log.Lines.add('Удаление программных файлов отменено');
  end
  else
    ShowMessage('Каталог с программой не найден!');

  ////
  if messagedlg('Удалить настройки пользователя?', mtConfirmation,
    mbOkCancel, 0) = idOk then
  begin
    deletefileadv(windowsdir + 'fdc_config.ini');
    deletefileadv(windowsdir + 'fdc_search.fds');
    log.Lines.add('Настройки пользователя удалены.');
  end
  else
    log.Lines.add('Удаление настроек пользователя отменено');
  ////
  deletefileadv(makepath('', sfdesktop) + 'FDK.lnk');
  log.Lines.add('Удален ярлык на рабочем столе.');
  darkkilldir(makepath('НИИ Dark Software\FDK', sfprograms));
  log.Lines.add('Удалены ярлыки в меню пуск.');
  if nt then
    deletefileadv(windowsdir + 'system32\fdkcp.cpl')
  else
    deletefileadv(windowsdir + 'system\fdkcp.cpl');
  log.Lines.add('Удален элемент в панели управления.');
  r := TDarkRegistry.Create;
  r.RootKey := longword($80000000);
  r.DeleteKey('\directory\shell\fdk');
  r.DeleteKey('\directory\shell\fdk2');
  r.DeleteKey('\drive\shell\fdk');
  r.DeleteKey('\drive\shell\fdk2');
  r.DeleteKey('\.fdc');
  r.DeleteKey('\fdkplugin');
  r.DeleteKey('\.tweak');
  r.DeleteKey('\.fds');
  r.DeleteKey('\.fdp');
  r.DeleteKey('\.fdh');
  r.DeleteKey('\.fdkar');
  r.DeleteKey('\fdkautorun');
  r.DeleteKey('\.dav');
  r.DeleteKey('\fdkdavscript');
  r.DeleteKey('\.fdl');
  r.DeleteKey('\fdkfilelist');
  r.DeleteKey('\.fdt');
  r.DeleteKey('\fdktasklist');
  r.RootKey := HKey_Local_Machine;
  r.DeleteKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FDK');
  log.Lines.add('Удален элемент в панели уcтановки и удаления программ.');
  r.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce');
  r.WriteString('remove_fdk_uninstaller', 'Command /Cdel c:\fdk$$$.exe');
  log.Lines.add('Временный файл удалится после перезапуска системы.');
  r.Free;
  statictext5.Caption := 'Готово';
  statictext3.OnClick := nil;
  ShowMessage('Программа удалена!');
end;

procedure TUninstallForm.StaticText3MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  statictext4.Visible := False;
  if not Assigned(statictext3.OnClick) then
    shape4.Visible := False;
end;

procedure TUninstallForm.StaticText5Click(Sender: TObject);
begin
  Close;
end;

procedure TUninstallForm.StaticText5MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  statictext6.Visible := True;
end;

procedure TUninstallForm.StaticText5MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  statictext6.Visible := False;
end;

procedure TUninstallForm.StaticText7MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  statictext8.Visible := True;
end;

procedure TUninstallForm.StaticText7MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  statictext8.Visible := False;
end;

procedure TUninstallForm.StaticText9MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  statictext10.Visible := True;
end;

procedure TUninstallForm.StaticText9MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  statictext10.Visible := False;
end;

procedure TUninstallForm.StaticText9Click(Sender: TObject);
begin
  shellapi.ShellExecute(handle, 'open',
    'http://www.hotcd.ru/cgi-bin/index.pl?0==0==0==darksoftware', '', '', 0);

end;

procedure TUninstallForm.StaticText3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  statictext4.Visible := True;
  if not Assigned(statictext3.OnClick) then
    shape4.Visible := True;
end;

procedure TUninstallForm.FormCreate(Sender: TObject);
var
  s: string;
begin
  memo1.Lines.Add('Код компиляции: ' + buildstr);
  memo1.Lines.Add('Дата компиляции: ' + buildstamp);
  s := GetEnvironmentVariable('fdcdir');
  if s <> '' then
    log.Lines.Add('Программа найдена в каталоге ' + s)
  else
    log.Lines.Add('Путь к программе не известен!');
end;

procedure TUninstallForm.Label3MouseEnter(Sender: TObject);
begin
  shape4.Visible      := True;
  statictext4.Visible := True;
  statictext6.Visible := True;
  statictext8.Visible := True;
  statictext10.Visible := True;

end;

procedure TUninstallForm.Label3MouseLeave(Sender: TObject);
begin
  shape4.Visible      := False;
  statictext4.Visible := False;
  statictext6.Visible := False;
  statictext8.Visible := False;
  statictext10.Visible := False;
end;

procedure TUninstallForm.StaticText7Click(Sender: TObject);
begin
  shellapi.ShellExecute(handle, 'open', 'http://www.darksoftware.narod.ru', '', '', 0);
end;

end.
