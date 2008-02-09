{$I SsDefine.inc}

{$I+}{I/O Checking On}
{$H+}{Huge strings}

unit StShrtCt;

interface

uses
  SysUtils, Windows, Forms, Classes, Controls, Messages, ShlObj,
  {$IFDEF VERSION3}
  ActiveX, ComObj,
  {$ELSE}
  Ole2,
  {$ENDIF}
  SsBase, SsConst, Dialogs;

{$Z+}
type
  TShowState = (ssNormal, ssMinimized, ssMaximized);


  TStShortcutEvent = procedure(Sender: TObject; Point: TPoint) of object;

  TStCustomShortcut = class(TSsShellComponent)
  protected{private}
    {property variables}
    FDescription: string;
    FDestinationDir: string;
    FFileName:  string;
    FHotKey:    word;
    FIconIndex: integer;
    FIconPath:  string;
    FSdir:      string;
    FParameters: string;
    FShortcutFileName: string;
    FShowCommand: TShowState;
    FSpecialFolder: TStSpecialRootFolder;
    FStartInDir: string;

    {internal variables}
    {$IFNDEF VERSION3 }
    Initialized: boolean;
    {$ENDIF}

    procedure SetSpecialFolder(const Value: TStSpecialRootFolder);
    {event variables}

    procedure MakePath(var Path: string);
    function Save(const AFileName: string): boolean;

  protected
{$Z-}
    {properties}

    property Description: string Read FDescription Write FDescription;
    property SDir: string Read FSdir Write FSdir;

    property DestinationDir: string Read FDestinationDir Write FDestinationDir;

    property FileName: string Read FFileName Write FFileName;

    property HotKey: word Read FHotKey Write FHotKey default 0;

    property IconIndex: integer Read FIconIndex Write FIconIndex;

    property IconPath: string Read FIconPath Write FIconPath;

    property Parameters: string Read FParameters Write FParameters;

    property ShortcutFileName: string Read FShortcutFileName Write FShortcutFileName;

    property ShowCommand: TShowState
      Read FShowCommand Write FShowCommand default ssNormal;

    property SpecialFolder: TStSpecialRootFolder
      Read FSpecialFolder Write SetSpecialFolder;

    property StartInDir: string Read FStartInDir Write FStartInDir;

{$Z+}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {methods}
{$Z-}
    function CreateShortcut: boolean;
    function ResolveShortcut: boolean;
  end;

  TStShortcut = class(TStCustomShortcut)
  published
    {properties}
    property Description;
    property DestinationDir;
    property FileName;
    property HotKey;
    property IconIndex;
    property IconPath;
    property Parameters;
    property ShortcutFileName;
    property ShowCommand;
    property SpecialFolder;
    property StartInDir;
    property SDir;
  end;

implementation

constructor TStCustomShortcut.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSpecialFolder := sfDesktop;
  FShowCommand   := ssNormal;
end;

function TStCustomShortcut.CreateShortcut: boolean;
var
  S: string;
begin
  if not FileExists(FFileName) then
    if not DirectoryExists(FFileName) then
      RaiseStError(ESsShortcutError, ssscInvalidTargetFile);

  MakePath(S);
  ForceDirectories(ExtractFileDir(s));
  S      := S + FDescription + '.lnk';
  Result := Save(S);
end;

destructor TStCustomShortcut.Destroy;
begin
  {$IFNDEF VERSION3}
  if not (csDesigning in ComponentState) and Initialized then
    CoUninitialize;
  {$ENDIF}
  inherited Destroy;
end;

procedure TStCustomShortcut.MakePath(var Path: string);
var
  IDList: PItemIDList;
  Buff:   array [0..MAX_PATH - 1] of char;
  ParentHandle: integer;
begin
  IDList := nil;

  if Owner is TWinControl then
    ParentHandle := (Owner as TWinControl).Handle
  else if Owner is TApplication then
    ParentHandle := (Owner as TApplication).Handle
  else
    ParentHandle := 0;

  SHGetSpecialFolderLocation(ParentHandle,
    ShellFolders[FSpecialFolder], IDList);
  if Assigned(IDList) then
  begin
    SHGetPathFromIDList(IDList, Buff);
    Path := string(Buff) + '\' + FSdir + '\';
  end;
end;

function TStCustomShortcut.ResolveShortcut: boolean;
var
  Res:   integer;
  {$IFDEF VERSION3}
  CO:    IUnknown;
  {$ENDIF}
  Link:  IShellLink;
  PFile: IPersistFile;
  WBuff: array [0..MAX_PATH - 1] of widechar;
  Buff:  array [0..MAX_PATH - 1] of char;
  FD:    TWin32FindData;
  Cmd:   integer;
  ParentHandle: integer;
begin
  if (FShortcutFileName = '') or not FileExists(FShortcutFileName) then
    RaiseStError(ESsShortcutError, ssscFileOpen);
  if UpperCase(ExtractFileExt(FShortcutFileName)) <> '.LNK' then
    RaiseStError(ESsShortcutError, ssscNotShortcut);

  if Owner is TWinControl then
    ParentHandle := (Owner as TWinControl).Handle
  else if Owner is TApplication then
    ParentHandle := (Owner as TApplication).Handle
  else
    ParentHandle := 0;

  { Create an IShellLink interface. }
  {$IFDEF VERSION3}
  CO    := CreateComObject(CLSID_ShellLink);
  Link  := CO as IShellLink;
  PFile := CO as IPersistFile;
  Res   := integer(PFile);
  {$ELSE}
  if not Initialized then
  begin
    Res := CoInitialize(nil);
    if Res <> S_OK then
      RaiseStError(EStShortcutError, ssscIShellLinkError);
    Initialized := True;
  end;
  Res := CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
    IID_IShellLink, Link);
  if Res = S_OK then
    Res := Link.QueryInterface(IID_IPersistFile, PFile);
  if Res <> S_OK then
    RaiseStError(EStShortcutError, ssscIShellLinkError);
  {$ENDIF}
  if Assigned(Link) and Assigned(PFile) then
  begin
    MultiByteToWideChar(CP_ACP, 0,
      PChar(FShortcutFileName), -1, WBuff, MAX_PATH);
    Res := PFile.Load(WBuff, STGM_READ);
    if Res = S_OK then
    begin
      Res := Link.Resolve(ParentHandle, SLR_ANY_MATCH or SLR_UPDATE);
      if Res = S_OK then
      begin
        Link.GetPath(Buff, MAX_PATH, FD, SLGP_UNCPRIORITY);
        FFileName := Buff;
        Link.GetDescription(Buff, MAX_PATH);
        FDescription := Buff;
        Link.GetArguments(Buff, MAX_PATH);
        FParameters := Buff;
        Link.GetWorkingDirectory(Buff, MAX_PATH);
        FStartInDir := Buff;
        Link.GetHotkey(FHotKey);
        Link.GetShowCmd(Cmd);
        case Cmd of
          SW_SHOWNORMAL:
            FShowCommand := ssNormal;
          SW_SHOWMAXIMIZED:
            FShowCommand := ssMaximized;
          SW_SHOWMINIMIZED:
            FShowCommand := ssMinimized;
          else
            FShowCommand := ssNormal;
        end;
      end;
    end;
  end;
  Result := not boolean(Res);
end;

function TStCustomShortcut.Save(const AFileName: string): boolean;
var
  Res:   integer;
  {$IFDEF VERSION3}
  CO:    IUnknown;
  {$ENDIF}
  Link:  IShellLink;
  PFile: IPersistFile;
  WBuff: array [0..MAX_PATH - 1] of widechar;
begin
  { Create an IShellLink interface. }
  {$IFDEF VERSION3}
  CO    := CreateComObject(CLSID_ShellLink);
  Link  := CO as IShellLink;
  PFile := CO as IPersistFile;
  Res   := integer(PFile);
  {$ELSE}
  if not Initialized then
  begin
    Res := CoInitialize(nil);
    if Res <> S_OK then
      RaiseStError(EStShortcutError, ssscIShellLinkError);
    Initialized := True;
  end;
  Res := CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
    IID_IShellLink, Link);
  if Res = S_OK then
    Res := Link.QueryInterface(IID_IPersistFile, PFile);
  if Res <> S_OK then
    RaiseStError(EStShortcutError, ssscIShellLinkError);
  {$ENDIF}

  if Assigned(Link) and Assigned(PFile) then
  begin
    Link.SetPath(PChar(FFileName));
    Link.SetArguments(PChar(FParameters));
    Link.SetDescription(PChar(FDescription));
    Link.SetHotkey(FHotKey);
    case FShowCommand of
      ssNormal:
        Link.SetShowCmd(SW_SHOWNORMAL);
      ssMaximized:
        Link.SetShowCmd(SW_SHOWMAXIMIZED);
      ssMinimized:
        Link.SetShowCmd(SW_SHOWMINIMIZED);
    end;
    if FStartInDir <> '' then
      Link.SetWorkingDirectory(PChar(FStartInDir));
    if FIconPath <> '' then
      Link.SetIconLocation(PChar(FIconPath), FIconIndex);
    MultiByteToWideChar(CP_ACP, 0, PChar(AFileName), -1, WBuff, MAX_PATH);
    Res := PFile.Save(WBuff, False);
    if Res = S_OK then
    {$IFDEF VERSION 3}
     begin
      FShortcutFileName := WBuff
     end;
    {$ELSE}
      FShortcutFileName := WideCharToString(WBuff);
    {$ENDIF}
  end
  else
    RaiseStError(ESsShortcutError, ssscIShellLinkError);
  Result := not boolean(Res);
end;

procedure TStCustomShortcut.SetSpecialFolder(const Value: TStSpecialRootFolder);
begin
  FSpecialFolder := Value;
end;


end.
