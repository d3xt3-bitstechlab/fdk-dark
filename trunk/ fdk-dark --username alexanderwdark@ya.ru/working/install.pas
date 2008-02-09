unit install;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  StdCtrls, ExtCtrls, Dialogs, shellapi;

type
  TFDCINSTFORM = class(TForm)
    Edit1:  TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Memo1:  TMemo;
    Label4: TLabel;
    Label1: TLabel;
    StaticText2: TStaticText;
    StaticText1: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    StaticText10: TStaticText;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Shape2: TShape;
    Shape1: TShape;
    Shape3: TShape;
    Shape4: TShape;
    dr:     TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Label3MouseEnter(Sender: TObject);
    procedure Label3MouseLeave(Sender: TObject);
    procedure StaticText2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText7MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText7Click(Sender: TObject);
    procedure StaticText9MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText9MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure StaticText9Click(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure Edit1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure drSelect(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  FDCINSTFORM: TFDCINSTFORM;

implementation


uses mainunit, davinchi, fdcfuncs;

{$R *.dfm}

procedure TFDCINSTFORM.Button1Click(Sender: TObject);
begin
  edit1.Text := Trim(edit1.Text);
  if edit1.Text = '' then
  begin
    ShowMessage('Не указан путь установки.');
    if nt then
      edit1.Text := FixEnv('%programfiles%\НИИ DarkSoftware\FDK\')
    else
      edit1.Text := extractfiledrive(windowsdir) +
        '\Program Files\НИИ DarkSoftware\FDK\';
    exit;
  end;

  edit1.Text := SysUtils.IncludeTrailingBackslash(edit1.Text);


  if pos(edit1.Text[1], getharddrives) = 0 then
  begin
    ShowMessage('Неверно указан путь для установки. Диск не существует или сменный.');
    exit;
  end;
  if not forcedirectories(edit1.Text) then
  begin
    ShowMessage('Не могу создать каталог для установки.');
    exit;
  end;
  copyfile(PChar(ParamStr(0)), PChar(edit1.Text + 'fdk.exe'), False);
  ShowMessage('Внимательно ознакомтесь с кратким описанием продукта и особенностями его использования.');
  extractres('README', 'I', tempdir + 'Руководство.txt');
  RunAndWait('notepad ' + tempdir + 'Руководство.txt');
  deletefileadv(tempdir + 'Руководство.txt');
  if messagedlg('Вы прочитали руководство и согласны с условиями использования программы?',
    mtConfirmation, mbOkCancel, 0) = idOk then
  begin
    RunAndWait(edit1.Text + 'fdk.exe -install');
    statictext3.OnClick := nil;
    statictext5.Caption := 'Готово';
    ShowMessage('Программа установлена! Спасибо за использование продуктов НИИ DarkSoftware!');
  end
  else
    ShowMessage('Продолжение устновки возможно лишь при согласии с условиями использования программы.');
end;

procedure TFDCINSTFORM.FormCreate(Sender: TObject);
var
  i: integer;
  s: string;
begin
  if nt then
    edit1.Text := FixEnv('%programfiles%\НИИ DarkSoftware\FDK\')
  else
    edit1.Text := extractfiledrive(windowsdir) + '\Program Files\НИИ DarkSoftware\FDK\';

  memo1.Lines.Add('Код компиляции: ' + buildstr);
  memo1.Lines.Add('Дата компиляции: ' + buildstamp);
  s := getharddrives;
  for i := 1 to length(s) do
    dr.Items.Add(s[i]);
end;

procedure TFDCINSTFORM.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TFDCINSTFORM.Button3Click(Sender: TObject);
var
  s: string;
begin
  s := SysUtils.ExcludeTrailingPathDelimiter(edit1.Text);
  if inputdir(handle, s, 'Укажите путь для поиска', True) then
    if POS(s[1], getharddrives) > 0 then
      edit1.Text := s;
end;

procedure TFDCINSTFORM.Label3MouseEnter(Sender: TObject);
begin
  shape2.Visible      := True;
  shape4.Visible      := True;
  statictext2.Visible := True;
  statictext4.Visible := True;
  statictext6.Visible := True;
  statictext8.Visible := True;
  statictext10.Visible := True;
end;

procedure TFDCINSTFORM.Label3MouseLeave(Sender: TObject);
begin
  shape2.Visible      := False;
  shape4.Visible      := False;
  statictext2.Visible := False;
  statictext4.Visible := False;
  statictext6.Visible := False;
  statictext8.Visible := False;
  statictext10.Visible := False;
end;

procedure TFDCINSTFORM.StaticText2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  statictext2.Visible := True;
end;

procedure TFDCINSTFORM.StaticText2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  statictext2.Visible := False;
end;

procedure TFDCINSTFORM.StaticText3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  statictext4.Visible := True;
  if not Assigned(statictext3.OnClick) then
    shape4.Visible := True;
end;

procedure TFDCINSTFORM.StaticText3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  statictext4.Visible := False;
  if not Assigned(statictext3.OnClick) then
    shape4.Visible := False;

end;

procedure TFDCINSTFORM.StaticText5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  statictext6.Visible := False;
end;

procedure TFDCINSTFORM.StaticText5MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  statictext6.Visible := True;
end;

procedure TFDCINSTFORM.StaticText7MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  statictext8.Visible := True;
end;

procedure TFDCINSTFORM.StaticText7MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  statictext8.Visible := False;
end;

procedure TFDCINSTFORM.StaticText7Click(Sender: TObject);
begin
  shellapi.ShellExecute(handle, 'open', 'http://www.darksoftware.narod.ru/', '', '', 0);
end;

procedure TFDCINSTFORM.StaticText9MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  statictext10.Visible := False;
end;

procedure TFDCINSTFORM.StaticText9MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  statictext10.Visible := True;
end;

procedure TFDCINSTFORM.StaticText9Click(Sender: TObject);
begin
  shellapi.ShellExecute(handle, 'open',
    'http://www.hotcd.ru/cgi-bin/index.pl?0==0==0==darksoftware', '', '', 0);
end;

procedure TFDCINSTFORM.Edit1KeyUp(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  shape2.Visible := False;
end;

procedure TFDCINSTFORM.Edit1KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  shape2.Visible := True;
end;


procedure TFDCINSTFORM.drSelect(Sender: TObject);
var
  s: string;
begin
  s := Trim(edit1.Text);
  if s = '' then
  begin
    if nt then
      S := FixEnv('%programfiles%\НИИ DarkSoftware\FDK\')
    else
      S := extractfiledrive(windowsdir) + '\Program Files\НИИ DarkSoftware\FDK\';

  end;
  s[1] := dr.Items[dr.ItemIndex][1];
  edit1.Text := s;
end;

end.
