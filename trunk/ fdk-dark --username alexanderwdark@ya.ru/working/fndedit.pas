unit fndedit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, masks, killunit, ExtCtrls,
  Menus, darkregistry, support, shellapi, ToolWin,fdcfuncs;

type
  TView = class(TForm)
    ListViewF: TListView;
    ToolBar1: TToolBar;
    sb:     TStatusBar;
    Poisk:  TPanel;
    PopupMenu1: TPopupMenu;
    N1:     TMenuItem;
    N6:     TMenuItem;
    MainMenu1: TMainMenu;
    delf:   TMenuItem;
    allf:   TMenuItem;
    findf:  TMenuItem;
    self:   TMenuItem;
    cl:     TMenuItem;
    stopcl: TMenuItem;
    N2:     TMenuItem;
    N3:     TMenuItem;
    N4:     TMenuItem;
    N5:     TMenuItem;
    savefl: TMenuItem;
    loadfl: TMenuItem;
    addfl:  TMenuItem;
    clrfl:  TMenuItem;
    delsel: TMenuItem;
    chall:  TMenuItem;
    N7:     TMenuItem;
    N8:     TMenuItem;
    N9:     TMenuItem;
    N10:    TMenuItem;
    N11:    TMenuItem;
    N12:    TMenuItem;
    dchall: TMenuItem;
    procedure delfClick(Sender: TObject);
    procedure allfClick(Sender: TObject);
    procedure findfClick(Sender: TObject);
    procedure selfClick(Sender: TObject);
    procedure clClick(Sender: TObject);
    procedure stopclClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure ListViewFClick(Sender: TObject);
    procedure saveflClick(Sender: TObject);
    procedure loadflClick(Sender: TObject);
    procedure addflClick(Sender: TObject);
    procedure clrflClick(Sender: TObject);
    procedure delselClick(Sender: TObject);
    procedure challClick(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure dchallClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure LoadFList(fname: string; append: boolean);
    procedure SaveFList(fname: string);
    procedure beginupdatelv;
    procedure endupdatelv;
  end;

procedure EnableSearchControlsKill(mode: boolean);

var
  View: TView;

implementation

uses srchunit, mainunit;

{$R *.dfm}


procedure EnableSearchControlsKill(mode: boolean);
var
  i: integer;
begin
  clonemode := not mode;
  if exiting then
    exit;
  if not mode then
    view.listviewf.items.BeginUpdate;
  if mode then
  begin
    view.ListViewF.MultiSelect := True;
    view.ListViewF.SelectAll;
    for i := 0 to foundlist.Count - 1 do
      view.listviewf.Items[integer(foundlist.Items[i])].Selected := False;
    view.ListViewF.DeleteSelected;
    view.ListViewF.MultiSelect := False;
    view.listviewf.Items.EndUpdate;
    view.sb.SimpleText := Format('Проверено: %d файлов, из них одинаковы: %d',
      [Checked + 1, view.ListViewF.Items.Count]);
  end;
  fdcmain.cool.Enabled := not mode;
  fdcmain.sbtn.Enabled := mode;
  view.poisk.Visible   := not mode;
  fdcmain.spec.Enabled := mode;
  view.poisk.Visible   := not mode;
  view.cl.Enabled      := mode;
  view.stopcl.Enabled  := not mode;
  view.delf.Enabled    := mode;
  view.allf.Enabled    := mode;
  view.findf.Enabled   := mode;
  view.self.Enabled    := mode;
  view.savefl.Enabled  := mode;
  view.loadfl.Enabled  := mode;
  view.addfl.Enabled   := mode;
  view.clrfl.Enabled   := mode;
  view.delsel.Enabled  := mode;
  view.chall.Enabled   := mode;
  view.dchall.Enabled  := mode;
  if mode then
    view.ListViewF.PopupMenu := view.popupmenu1
  else
    view.ListViewF.PopupMenu := nil;
end;



procedure TView.delfClick(Sender: TObject);
var
  i: longint;
begin
  if messagedlg('Действительно удалить отмеченные файлы?', mtConfirmation,
    mbOkCancel, 0) <> idOk then
    exit;
  ListViewF.Items.BeginUpdate;
  ListViewF.MultiSelect := True;
  listviewF.Enabled := False;
  delf.Enabled := False;
  allf.Enabled := False;
  for i := 0 to listviewf.Items.Count - 1 do
  begin
    ListViewf.Items.Item[i].Selected := False;
    if ListViewf.Items.Item[i].Checked then
    begin
      if deletefileadv(listviewf.Items.Item[i].Caption) then

      begin
        Inc(delsize, StrToInt(listviewf.Items[i].SubItems[0]));
        listviewf.Items[i].Selected := True;
        if DelSize > 0 then
          sb.simpletext := Format('Освобождено %f МБ', [delsize / 1024 / 1024]);
      end;
    end;
  end;
  ListViewf.DeleteSelected;
  ListViewF.MultiSelect := False;
  ListViewf.Items.EndUpdate;
  listviewf.Enabled := True;
  delf.Enabled      := True;
  allf.Enabled      := True;
end;

procedure TView.allfClick(Sender: TObject);
var
  i: longint;
begin
  if messagedlg('Действительно удалить все найденые файлы?',
    mtConfirmation, mbOkCancel, 0) <> idOk then
    exit;
  ListViewf.Items.BeginUpdate;
  ListViewf.MultiSelect := True;
  listviewf.Enabled := False;
  delf.Enabled := False;
  allf.Enabled := False;
  for i := 0 to listviewf.Items.Count - 1 do
  begin
    listviewf.Items[i].Selected := False;
    if deletefileadv(listviewf.Items.Item[i].Caption) then
    begin
      Inc(delsize, StrToInt(listviewf.Items[i].SubItems[0]));
      listviewf.Items[i].Selected := True;
      if DelSize > 0 then
        sb.simpletext := Format('Освобождено %f МБ', [delsize / 1024 / 1024]);
    end;
  end;
  ListViewf.DeleteSelected;
  ListViewf.MultiSelect := False;
  ListViewf.Items.EndUpdate;
  listviewf.Enabled := True;
  delf.Enabled      := True;
  allf.Enabled      := True;
end;

procedure TView.findfClick(Sender: TObject);
var
  i:    integer;
  mask: string;
begin
  listviewf.SetFocus;
  mask := Trim(inputbox('Найти по маске', 'Маска файлов:', '*.*'));
  if (mask <> '') and (listviewf.Items.Count > 2) then
  begin
    for i := 0 to listviewf.Items.Count - 1 do
      if MatchesMask(ExtractFileName(listviewf.Items.Item[i].Caption), mask) then
      begin
        listviewf.ItemIndex := i;
        listviewf.Items.Item[i].Checked := True;
        listviewf.Items.Item[i].Focused := True;
        listviewf.Items.Item[i].Selected := True;
        listviewf.Items.Item[i].MakeVisible(True);
        break;
      end;
  end;
end;

procedure TView.selfClick(Sender: TObject);
var
  i:    integer;
  mask: string;
begin
  listviewf.ClearSelection;
  mask := Trim(inputbox('Отметить по маске', 'Маска файлов:', '*.*'));
  if Trim(mask) <> '' then
  begin
    for i := 0 to listviewf.Items.Count - 1 do
      if MatchesMask(ExtractFileName(listviewf.Items.Item[i].Caption), mask) then
        listviewf.Items.Item[i].Checked := True;
  end;
end;

procedure TView.clClick(Sender: TObject);
begin
  if (listviewf.Items.Count > 1) then
  begin
    EnableSearchControlsKill(False);
    killt := TKillThread.Create(@listviewf, @EnableSearchControlsKill);
  end
  else
    ShowMessage('Нет файлов для поиска клонов!');
end;

procedure TView.stopclClick(Sender: TObject);
begin
  killt.Terminate;
end;

procedure TView.FormResize(Sender: TObject);
begin
  poisk.Top    := listviewf.Top;
  poisk.Height := listviewf.Height;
  poisk.Left   := listviewf.Left;
  poisk.Width  := listviewf.Width;
  listviewf.Columns[0].Width := listviewf.Width - listviewf.Width div 4;
end;

procedure TView.PopupMenu1Popup(Sender: TObject);
var
  r:    TDarkRegistry;
  n, l: string;
  ke:   boolean;
begin
  N1.Enabled  := (ListViewf.Items.Count > 0) and (listviewf.ItemIndex <> -1) and
    (listviewf.SelCount > 0);
  N6.Enabled  := (ListViewf.Items.Count > 0) and (listviewf.ItemIndex <> -1) and
    (listviewf.SelCount > 0);
  n8.Enabled  := ListViewf.Items.Count > 0;
  n9.Enabled  := ListViewf.Items.Count > 0;
  n10.Enabled := ListViewf.Items.Count > 0;
  n11.Enabled := ListViewf.Items.Count > 0;
  N12.Enabled := (ListViewf.Items.Count > 0) and (listviewf.ItemIndex <> -1) and
    (listviewf.SelCount > 0);

  if N1.Enabled then
  begin
    r := TDarkRegistry.Create;
    r.RootKey := HKEY_Classes_Root;
    ///////////
    n := ExtractFileExt(listviewf.Items[listviewf.ItemIndex].Caption);
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

procedure TView.N1Click(Sender: TObject);
begin
  if (listviewf.Items.Count > 0) and (listviewf.ItemIndex >= 0) and
    (listviewf.SelCount > 0) then
    ShowObjectPropertiesDialog(listviewf.Items[listviewf.ItemIndex].Caption,
      sdPathObject, '');
end;

procedure TView.N6Click(Sender: TObject);
begin
  shellapi.ShellExecute(handle, 'open',
    PChar(listviewf.items[listviewf.ItemIndex].Caption),
    '', '', sw_show);
end;

procedure TView.ListViewFClick(Sender: TObject);
begin
  if (Listviewf.Items.Count > 0) and (listviewf.ItemIndex >= 0) and
    (listviewf.SelCount > 0) then
    listviewf.Items[listviewf.ItemIndex].Checked :=
      not listviewf.Items[listviewf.ItemIndex].Checked;
end;

procedure TView.saveflClick(Sender: TObject);
begin
  fdcmain.savedialog.Filter     := '*.fdl|*.fdl';
  fdcmain.savedialog.FileName   :=
    mypath + 'filelist_' + FormatDateTime('DD.MMMM.YYYY', now) + '.fdl';
  fdcmain.savedialog.InitialDir := mypath;
  fdcmain.savedialog.Title      := 'Сохранение списка файлов';
  fdcmain.savedialog.DefaultExt := '.fdl';
  if fdcmain.SaveDialog.Execute then
  begin
    saveflist(fdcmain.SaveDialog.FileName);
  end;
end;

procedure TView.loadflClick(Sender: TObject);
begin
  fdcmain.opendialog.Filter     := '*.fdl|*.fdl';
  fdcmain.opendialog.FileName   := mypath + 'filelist.fdl';
  fdcmain.opendialog.InitialDir := mypath;
  fdcmain.opendialog.Title      := 'Открытие списка файлов';
  fdcmain.opendialog.DefaultExt := '.fdl';
  if fdcmain.openDialog.Execute then
  begin
    loadflist(fdcmain.opendialog.FileName, False);
  end;
end;

procedure TView.LoadFList;
var
  T:  TextFile;
  s, n, sz: string;
  li: TListItem;
begin
  listviewf.Items.BeginUpdate;
  if not append then
    listviewf.Items.Clear;
  assignfile(T, fname);
  reset(T);
  repeat
    readln(T, s);
    s := Trim(s);
    if s <> '' then
    begin
      n := copy(s, 1, pos('|', s) - 1);
      Delete(s, 1, length(n) + 1);
      n  := trim(n);
      sz := copy(s, 1, pos('|', s) - 1);
      Delete(s, 1, length(sz) + 1);
      sz := trim(sz);
      s  := trim(s);
      li := ListViewf.Items.Add;
      li.Caption := n;
      li.SubItems.Add(sz);
      li.SubItems.Add(s);
    end;
  until EOF(T);
  closefile(T);
  listviewf.Items.EndUpdate;

end;

procedure TView.SaveFList;
var
  T: TextFile;
  i: integer;
begin
  listviewf.Items.BeginUpdate;
  assignfile(T, fdcmain.SaveDialog.FileName);
  rewrite(T);
  for i := 0 to listviewf.Items.Count - 1 do
    writeln(T, listviewf.Items[i].Caption, '|', listviewf.Items[i].subitems[0],
      '|', listviewf.Items[i].subitems[1]);
  closefile(T);
  listviewf.Items.EndUpdate;
end;

procedure TView.addflClick(Sender: TObject);
begin
  fdcmain.opendialog.Filter     := '*.fdl|*.fdl';
  fdcmain.opendialog.FileName   := mypath + 'filelist.fdl';
  fdcmain.opendialog.InitialDir := mypath;
  fdcmain.opendialog.Title      := 'Открытие списка файлов';
  fdcmain.opendialog.DefaultExt := '.fdl';
  if fdcmain.openDialog.Execute then
  begin
    loadflist(fdcmain.opendialog.FileName, True);
  end;

end;

procedure TView.clrflClick(Sender: TObject);
begin
  listviewf.Items.BeginUpdate;
  listviewf.Items.Clear;
  listviewf.Items.EndUpdate;
end;

procedure TView.delselClick(Sender: TObject);
var
  i: integer;
begin
  listviewf.Items.BeginUpdate;
  listviewf.MultiSelect := True;
  for i := 0 to listviewf.Items.Count - 1 do
    listviewf.Items[i].Selected := listviewf.Items[i].Checked;
  listviewf.DeleteSelected;
  listviewf.MultiSelect := False;
  listviewf.Items.EndUpdate;
end;

procedure TView.challClick(Sender: TObject);
var
  i: integer;
begin
  listviewf.Items.BeginUpdate;
  for i := 0 to listviewf.Items.Count - 1 do
    listviewf.Items[i].Checked := True;
  listviewf.Items.EndUpdate;
end;

procedure tview.beginupdatelv;
begin
  listviewf.Items.BeginUpdate;
end;

procedure tview.endupdatelv;
begin
  listviewf.Items.EndUpdate;
end;


procedure TView.N12Click(Sender: TObject);
var
  idx: integer;
begin
  if messagedlg('Действительно удалить ' + listviewf.Items.Item[
    ListViewf.ItemIndex].Caption + '?', mtConfirmation, mbOkCancel, 0) <> idOk then
    exit;
  ListViewF.Items.BeginUpdate;
  idx := ListViewf.ItemIndex;
  listviewf.MultiSelect := True;
  listviewf.Items.Item[idx].Selected := False;
  listviewF.Enabled := False;
  delf.Enabled := False;
  allf.Enabled := False;
  if deletefileadv(listviewf.Items.Item[idx].Caption) then

  begin
    Inc(delsize, StrToInt(listviewf.Items[idx].SubItems[0]));
    listviewf.Items[idx].Selected := True;
    if DelSize > 0 then
      sb.simpletext := Format('Освобождено %f МБ', [delsize / 1024 / 1024]);
  end;
  ListViewf.DeleteSelected;
  listviewf.MultiSelect := False;
  ListViewf.Items.EndUpdate;
  listviewf.Enabled := True;
  delf.Enabled      := True;
  allf.Enabled      := True;
end;

procedure TView.dchallClick(Sender: TObject);
var
  i: integer;
begin
  listviewf.Items.BeginUpdate;
  for i := 0 to listviewf.Items.Count - 1 do
    listviewf.Items[i].Checked := False;
  listviewf.Items.EndUpdate;
end;

end.
