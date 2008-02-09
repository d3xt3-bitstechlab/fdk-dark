{$I SsDefine.inc}

unit SsBase;

interface

uses
  Windows,
  Classes,
  SysUtils,
  Messages,
  SsConst,
  ShellApi,
  ShlObj,
  {$IFDEF VERSION3}
  ActiveX,
  ComObj,
  {$ELSE}
  Ole2,
  {$ENDIF}

  {$IFDEF VERSION6} {$WARN UNIT_PLATFORM OFF} {$ENDIF}
  FileCtrl,
  {$IFDEF VERSION6} {$WARN UNIT_PLATFORM ON} {$ENDIF}
  Dialogs;

type
{$IFDEF CBuilder}
  TStHwnd = integer;
{$ELSE}
  TStHwnd = HWND;
{$ENDIF}

  TStNotifyRegister = record
    Pidl: PItemIDList;
    WatchSubTree: longbool;
  end;

const
  StMaxBlockSize  = MaxLongInt;
  { These the following constants are not defined in ShellObj.PAS. }
  { Their use is not supported on all versions of Windows.         }
  CSIDL_Internet  = $0001;
  CSIDL_AltStartup = $001d;
  CSIDL_Common_AltStartup = $001e;
  CSIDL_Common_Favorites = $001f;
  CSIDL_Internet_Cache = $0020;
  CSIDL_Cookies   = $0021;
  CSIDL_History   = $0022;
  CSIDL_Connections = $0031;
  Bif_EditBox     = $0010;
  Bif_Validate    = $0020;
  { The following constants are not defined in Delphi 2's OLE2.PAS. }
  { Their use is not supported on all versions of Windows.          }
  {$IFNDEF VERSION3}
  Fof_NoErrorUI   = $0400;
  CSIDL_Common_StartMenu = $0016;
  CSIDL_Common_Programs = $0017;
  CSIDL_Common_Startup = $0018;
  CSIDL_Common_DesktopDirectory = $0019;
  CSIDL_AppData   = $001a;
  CSIDL_PrintHood = $001b;
  Bif_BrowseIncludeFiles = $4000;
  IId_IPersistFile: TGUID = (
    D1: $0000010B; D2: $0000; D3: $0000; D4: ($C0, $00, $00, $00, $00, $00, $00, $46));
  IId_IShellLink: TGUID = (
    D1: $000214EE; D2: $0000; D3: $0000; D4: ($C0, $00, $00, $00, $00, $00, $00, $46));
  {$ENDIF}

type
  TStSpecialRootFolder = (
    sfAltStartup, sfAppData, sfBitBucket, sfCommonAltStartup,
    sfCommonDesktopDir, sfCommonFavorites, sfCommonPrograms,
    sfCommonStartMenu, sfCommonStartup, sfConnections,
    sfControls, sfCookies,
    sfDesktop, sfDesktopDir, sfDrives, sfFavorites, sfFonts,
    sfHistory, sfInternet, sfInternetCache, sfNetHood,
    sfNetwork, sfNone, sfPersonal, sfPrinters, sfPrintHood, sfPrograms,
    sfRecentFiles, sfSendTo, sfStartMenu, sfStartup, sfTemplates);

const
  ShellFolders: array [TStSpecialRootFolder] of integer =
    (CSIDL_ALTSTARTUP, CSIDL_APPDATA, CSIDL_BITBUCKET, CSIDL_COMMON_ALTSTARTUP,
    CSIDL_COMMON_DESKTOPDIRECTORY, CSIDL_COMMON_FAVORITES, CSIDL_COMMON_PROGRAMS,
    CSIDL_COMMON_STARTMENU, CSIDL_COMMON_STARTUP, CSIDL_Connections,
    CSIDL_CONTROLS, CSIDL_COOKIES,
    CSIDL_DESKTOP, CSIDL_DESKTOPDIRECTORY, CSIDL_DRIVES, CSIDL_FAVORITES,
    CSIDL_FONTS, CSIDL_HISTORY, CSIDL_INTERNET, CSIDL_INTERNET_CACHE,
    CSIDL_NETHOOD, CSIDL_NETWORK, 0, CSIDL_PERSONAL, CSIDL_PRINTERS,
    CSIDL_PRINTHOOD, CSIDL_PROGRAMS, CSIDL_RECENT, CSIDL_SENDTO,
    CSIDL_STARTMENU, CSIDL_STARTUP, CSIDL_TEMPLATES);

type
  TIncludeItemFunc = function(const SR: TSearchRec; ForInclusion: boolean): boolean;

  {base component for ShellShock non-visual components}
  TSsComponent = class(TComponent)
  end;

  {base component for ShellShock shell components}
  TSsShellComponent = class(TSsComponent)
  protected {private}
    FError: integer;
    FErrorString: string;

    FOnError: TNotifyEvent;

    procedure CheckSystemError(ErrCode: integer);

    {properties}

    property Error: integer Read FError Write FError;

    property ErrorString: string Read FErrorString;

    {events}
    property OnError: TNotifyEvent Read FOnError Write FOnError;

    {protected methods}
    procedure DoError;

  public
    constructor Create(AOwner: TComponent);
      override;
  end;

{$Z-}
  { Undocumented PIDL functions that we import. }
  TStILClone = function(Pidl: PItemIDList): PItemIDList; stdcall;
  TStILCloneFirst = function(Pidl: PItemIDList): PItemIDList; stdcall;
  TStILCombine = function(Pidl1, Pidl2: PItemIDList): PItemIDList; stdcall;
  TStILGetNext = function(Pidl: PItemIDList): PItemIDList; stdcall;
  TStILFindLastID = function(Pidl: PItemIDList): PItemIDList; stdcall;
  TStILIsEqual = function(Pidl1, Pidl2: PItemIDList): longbool; stdcall;
  TStILRemoveLastID = function(Pidl: PItemIDList): longbool; stdcall;
  TStILGetSize = function(Pidl: PItemIDList): word; stdcall;
  TStILFree = procedure(Pidl: PItemIDList); stdcall;

  TStSHChangeNotifyRegister = function(HWnd: THandle; Flags: DWORD;
    EventMask: DWORD; MessageID: UINT; ItemCount: DWORD;
    var Items: TStNotifyRegister): THandle; stdcall;
  TStSHChangeNotifyDeregister = function(HNotificationObject: THandle): boolean;
    stdcall;

  {-ShellShock exception class tree}
  ESsException = class(Exception)     {ancestor to all ShellShock exceptions}
  protected {private}
    FErrorCode: longint;

  public
    constructor CreateResTP(Ident: longint; Dummy: word);
    constructor CreateResFmtTP(Ident: longint; const Args: array of const;
      Dummy: word);
    property ErrorCode: longint Read FErrorCode Write FErrorCode;
  end;

  ESsExceptionClass = class of ESsException;

  ESsContainerError = class(ESsException);    {container exceptions}
  ESsStringError = class(ESsException);       {String class exceptions}
  ESsVersionInfoError = class(ESsException);  {Version info exception}
  ESsShellError = class(ESsException);        {Shell version exception}
  ESsFileOpError = class(ESsException);       {Shell file operation exception}
  ESsTrayIconError = class(ESsException);     {Tray Icon exception}
  ESsDropFilesError = class(ESsException);    {Drop files exception}
  ESsShortcutError = class(ESsException);     {Shortcut exception}
  ESsShellFormatError = class(ESsException);  {Format exception}
  ESsInvalidFolder = class(ESsException);     {Bad folder exception}
  ESsInvalidSortDir = class(ESsException);    {Bad sort direction exception}
  ESsBufStreamError = class(ESsException);    {Buffered stream errors}
  ESsRegExError = class(ESsException);        {RegEx errors}

  TStNode = class(TPersistent)
  protected {private}
    FData: Pointer;
  public
    constructor Create(AData: Pointer);
      virtual;
    property Data: Pointer Read FData Write FData;
  end;

  TStNodeClass = class of TStNode;

  TStContainer = class;

  TCompareFunc    =
    function(Data1, Data2: Pointer): integer;
  TStCompareEvent =
    procedure(Sender: TObject; Data1, Data2: Pointer; var Compare: integer) of object;

  TDisposeDataProc    =
    procedure(Data: Pointer);
  TStDisposeDataEvent =
    procedure(Sender: TObject; Data: Pointer) of object;

  TLoadDataFunc    =
    function(Reader: TReader): Pointer;
  TStLoadDataEvent =
    procedure(Sender: TObject; Reader: TReader; var Data: Pointer) of object;

  TStoreDataProc =
    procedure(Writer: TWriter; Data: Pointer);
  TStStoreDataEvent =
    procedure(Sender: TObject; Writer: TWriter; Data: Pointer) of object;

  TStringCompareFunc    =
    function(const String1, String2: string): integer;
  TStStringCompareEvent =
    procedure(Sender: TObject; const String1, String2: string;
    var Compare: integer) of object;

  TUntypedCompareFunc    =
    function(const El1, El2): integer;
  TStUntypedCompareEvent =
    procedure(Sender: TObject; const El1, El2; var Compare: integer) of object;

  TIterateFunc =
    function(Container: TStContainer; Node: TStNode; OtherData: Pointer): boolean;
  TIteratePointerFunc =
    function(Container: TStContainer; Data, OtherData: Pointer): boolean;
  TIterateUntypedFunc =
    function(Container: TStContainer; var Data; OtherData: Pointer): boolean;

  TStContainer = class(TPersistent)
  protected {private}
    {property instance variables}
    FCompare:     TCompareFunc;
    FDisposeData: TDisposeDataProc;
    FLoadData:    TLoadDataFunc;
    FStoreData:   TStoreDataProc;

    {event variables}
    FOnCompare:     TStCompareEvent;
    FOnDisposeData: TStDisposeDataEvent;
    FOnLoadData:    TStLoadDataEvent;
    FOnStoreData:   TStStoreDataEvent;

    {private instance variables}
    {$IFDEF ThreadSafe}
    conThreadSafe: TRTLCriticalSection;
    {$ENDIF}

    procedure SetCompare(C: TCompareFunc);
    procedure SetDisposeData(D: TDisposeDataProc);
    procedure SetLoadData(L: TLoadDataFunc);
    procedure SetStoreData(S: TStoreDataProc);

  protected
    conNodeClass: TStNodeClass;
    conNodeProt: integer;
    FCount: longint;

    {protected undocumented methods}
    function AssignPointers(Source: TPersistent;
      AssignData: TIteratePointerFunc): boolean;
    function AssignUntypedVars(Source: TPersistent;
      AssignData: TIterateUntypedFunc): boolean;
    procedure ForEachPointer(Action: TIteratePointerFunc; OtherData: Pointer);
      virtual;
    procedure ForEachUntypedVar(Action: TIterateUntypedFunc; OtherData: pointer);
      virtual;
    procedure GetArraySizes(var RowCount, ColCount, ElSize: cardinal);
      virtual;
    procedure SetArraySizes(RowCount, ColCount, ElSize: cardinal);
      virtual;
    function StoresPointers: boolean;
      virtual;
    function StoresUntypedVars: boolean;
      virtual;

    {protected documented}
    procedure IncNodeProtection;
    {-Prevent container Destroy from destroying its nodes}
    procedure DecNodeProtection;
    {-Allow container Destroy to destroy its nodes}
    procedure EnterCS;
    {-Enter critical section for this instance}
    procedure LeaveCS;
    {-Leave critical section for this instance}
  public
    constructor CreateContainer(NodeClass: TStNodeClass; Dummy: integer);
    {-Create an abstract container (called by descendants)}
    destructor Destroy;
      override;
    {-Destroy a collection, and perhaps its nodes}
    procedure Clear;
      virtual; abstract;
    {-Remove all elements from collection}
    procedure DisposeNodeData(P: TStNode);
    {-Destroy the data associated with a node}

    {wrapper methods for using events or proc/func pointers}
    function DoCompare(Data1, Data2: Pointer): integer;
      virtual;
    procedure DoDisposeData(Data: Pointer);
      virtual;
    function DoLoadData(Reader: TReader): Pointer;
      virtual;
    procedure DoStoreData(Writer: TWriter; Data: Pointer);
      virtual;

    procedure LoadFromFile(const FileName: string);
      dynamic;
    {-Create a container and its data from a file}
    procedure LoadFromStream(S: TStream);
      dynamic; abstract;
    {-Create a container and its data from a stream}
    procedure StoreToFile(const FileName: string);
      dynamic;
    {-Create a container and its data from a file}
    procedure StoreToStream(S: TStream);
      dynamic; abstract;
    {-Write a container and its data to a stream}

    property Count: longint
    {-Return the number of elements in the collection} Read FCount;

    property Compare: TCompareFunc
    {-Set or read the node comparison function} Read FCompare Write SetCompare;

    property DisposeData: TDisposeDataProc
    {-Set or read the node data dispose function}
      Read FDisposeData Write SetDisposeData;

    property LoadData: TLoadDataFunc
    {-Set or read the node data load function} Read FLoadData Write SetLoadData;

    property StoreData: TStoreDataProc
    {-Set or read the node data load function} Read FStoreData Write SetStoreData;

    {events}
    property OnCompare: TStCompareEvent Read FOnCompare Write FOnCompare;

    property OnDisposeData: TStDisposeDataEvent
      Read FOnDisposeData Write FOnDisposeData;

    property OnLoadData: TStLoadDataEvent Read FOnLoadData Write FOnLoadData;

    property OnStoreData: TStStoreDataEvent Read FOnStoreData Write FOnStoreData;
  end;

  PVerTranslation = ^TVerTranslation;

  TVerTranslation = record
    Language: word;
    CharSet:  word;
  end;


  TAssignRowData = record
    RowNum: integer;
    Data:   array [0..0] of byte;
  end;

{---Generic node routines---}
function DestroyNode(Container: TStContainer; Node: TStNode;
  OtherData: Pointer): boolean;
{-Generic function to pass to iterator to destroy a container node}

{---Miscellaneous---}

function IsOrInheritsFrom(Root, Candidate: TClass): boolean;
{-Return true if the classes are equal or Candidate is a descendant of Root}

procedure RaiseContainerError(Code: longint);
{-Internal routine: raise an exception for a container}

procedure RaiseContainerErrorFmt(Code: longint; Data: array of const);
{-Internal routine: raise an exception for a container}


{general routine to raise a specific class of ShellShock exception}
procedure RaiseStError(ExceptionClass: ESsExceptionClass; Code: longint);

{general routines to raise a specific Win32 exception in ShellShock}
procedure RaiseStWin32Error(ExceptionClass: ESsExceptionClass; Code: longint);
procedure RaiseStWin32ErrorEx(ExceptionClass: ESsExceptionClass;
  Code: longint; Info: string);

var
  Shell32Inst: THandle;
  PidlFormat: word;
  ILClone: TStILClone;
  ILCloneFirst: TStILCloneFirst;
  ILCombine: TStILCombine;
  ILGetNext: TStILGetNext;
  ILFindLastID: TStILFindLastID;
  ILIsEqual: TStILIsEqual;
  ILRemoveLastID: TStILRemoveLastID;
  ILGetSize: TStILGetSize;
  ILFree: TStILFree;
  SHChangeNotifyRegister: TStSHChangeNotifyRegister;
  SHChangeNotifyDeregister: TStSHChangeNotifyDeregister;

function GetSpecialFolderPath(Handle: TStHwnd; Folder: TStSpecialRootFolder): string;
procedure GetSpecialFolderFiles(Handle: TStHwnd; Folder: TStSpecialRootFolder;
  Files: TStrings);
function GetParentPidl(Pidl: PItemIDList): PItemIDList;
procedure LoadILFunctions;

{String routines}
function LeftPadChS(const S: ShortString; C: AnsiChar; Len: cardinal): ShortString;

function LeftPadS(const S: ShortString; Len: cardinal): ShortString;

function CharExistsS(const S: ShortString; C: AnsiChar): boolean;

function StrChPosS(const P: ShortString; C: AnsiChar; var Pos: cardinal): boolean;

function Long2StrL(L: longint): ansistring;

function TrimL(const S: ansistring): ansistring;

function AddBackSlashL(const DirName: ansistring): ansistring;

function CommaizeL(L: longint): ansistring;

function CommaizeChL(L: longint; Ch: AnsiChar): ansistring;

procedure EnumerateFiles(StartDir: string; FL: TStrings; SubDirs: boolean;
  IncludeItem: TIncludeItemFunc);

function IsDirectory(const DirName: string): boolean;

implementation

procedure RaiseStError(ExceptionClass: ESsExceptionClass; Code: longint);
var
  E: ESsException;
begin
  E := ExceptionClass.CreateResTP(Code, 0);
  E.ErrorCode := Code;
  raise E;
end;

procedure RaiseStWin32Error(ExceptionClass: ESsExceptionClass; Code: longint);
var
  E: ESsException;
begin
  E := ExceptionClass.Create(SysErrorMessage(Code));
  E.ErrorCode := Code;
  raise E;
end;

procedure RaiseStWin32ErrorEx(ExceptionClass: ESsExceptionClass;
  Code: longint; Info: string);
var
  E: ESsException;
begin
  E := ExceptionClass.Create(SysErrorMessage(Code) + ' [' + Info + ']');
  E.ErrorCode := Code;
  raise E;
end;

constructor ESsException.CreateResTP(Ident: longint; Dummy: word);
begin
  inherited Create(ShellShockStr(Ident));
end;

constructor ESsException.CreateResFmtTP(Ident: longint; const Args: array of const;
  Dummy: word);
begin
  inherited CreateFmt(ShellShockStr(Ident), Args);
end;

function AbstractCompare(Data1, Data2: Pointer): integer; far;
begin
  raise ESsContainerError.CreateResTP(ssscNoCompare, 0);
end;

function DestroyNode(Container: TStContainer; Node: TStNode;
  OtherData: Pointer): boolean;
begin
  Container.DisposeNodeData(Node);
  Node.Free;
  Result := True;
end;

function IsOrInheritsFrom(Root, Candidate: TClass): boolean;
begin
  Result := (Root = Candidate) or Candidate.InheritsFrom(Root);
end;

procedure RaiseContainerError(Code: longint);
var
  E: ESsContainerError;
begin
  E := ESsContainerError.CreateResTP(Code, 0);
  E.ErrorCode := Code;
  raise E;
end;

procedure RaiseContainerErrorFmt(Code: longint; Data: array of const);
var
  E: ESsContainerError;
begin
  E := ESsContainerError.CreateResFmtTP(Code, Data, 0);
  E.ErrorCode := Code;
  raise E;
end;

{$IFNDEF HStrings}
function StNewStr(S: string): PShortString;
begin
  GetMem(Result, succ(length(S)));
  Result^ := S;
end;

procedure StDisposeStr(PS: PShortString);
begin
  if (PS <> nil) then
    FreeMem(PS, succ(length(PS^)));
end;

{$ENDIF}

{----------------------------------------------------------------------}

constructor TStNode.Create(AData: Pointer);
begin
  Data := AData;
end;

{----------------------------------------------------------------------}

function TStContainer.AssignPointers(Source: TPersistent;
  AssignData: TIteratePointerFunc): boolean;
begin
  Result := False;
  if (Source is TStContainer) then
    if TStContainer(Source).StoresPointers then
    begin
      Clear;
      TStContainer(Source).ForEachPointer(AssignData, Self);
      Result := True;
    end;
end;

function TStContainer.AssignUntypedVars(Source: TPersistent;
  AssignData: TIterateUntypedFunc): boolean;
var
  RowCount: cardinal;
  ColCount: cardinal;
  ElSize:   cardinal;
begin
  Result := False;
  if (Source is TStContainer) then
    if TStContainer(Source).StoresUntypedVars then
    begin
      Clear;
      TStContainer(Source).GetArraySizes(RowCount, ColCount, ElSize);
      SetArraySizes(RowCount, ColCount, ElSize);
      TStContainer(Source).ForEachUntypedVar(AssignData, Self);
      Result := True;
    end;
end;

procedure TStContainer.ForEachPointer(Action: TIteratePointerFunc; OtherData: pointer);
begin
  {do nothing}
end;

procedure TStContainer.ForEachUntypedVar(Action: TIterateUntypedFunc;
  OtherData: pointer);
begin
  {do nothing}
end;

procedure TStContainer.GetArraySizes(var RowCount, ColCount, ElSize: cardinal);
begin
  RowCount := 0;
  ColCount := 0;
  ElSize   := 0;
end;

procedure TStContainer.SetArraySizes(RowCount, ColCount, ElSize: cardinal);
begin
  {do nothing}
end;

procedure TStContainer.SetCompare(C: TCompareFunc);
begin
  FCompare := C;
end;

procedure TStContainer.SetDisposeData(D: TDisposeDataProc);
begin
  FDisposeData := D;
end;

procedure TStContainer.SetLoadData(L: TLoadDataFunc);
begin
  FLoadData := L;
end;

procedure TStContainer.SetStoreData(S: TStoreDataProc);
begin
  FStoreData := S;
end;

function TStContainer.StoresPointers: boolean;
begin
  Result := False;
end;

function TStContainer.StoresUntypedVars: boolean;
begin
  Result := False;
end;

constructor TStContainer.CreateContainer(NodeClass: TStNodeClass; Dummy: integer);
begin
{$IFDEF ThreadSafe}
  Windows.InitializeCriticalSection(conThreadSafe);
{$ENDIF}

  FCompare     := AbstractCompare;
  conNodeClass := NodeClass;

  inherited Create;
end;

procedure TStContainer.DecNodeProtection;
begin
  Dec(conNodeProt);
end;

destructor TStContainer.Destroy;
begin
  if conNodeProt = 0 then
    Clear;
{$IFDEF ThreadSafe}
  Windows.DeleteCriticalSection(conThreadSafe);
{$ENDIF}
  inherited Destroy;
end;

procedure TStContainer.DisposeNodeData(P: TStNode);
begin
{$IFDEF ThreadSafe}
  EnterCS;
  try
{$ENDIF}
  if Assigned(P) then
    DoDisposeData(P.Data);
{$IFDEF ThreadSafe}
  finally
    LeaveCS;
   end;
{$ENDIF}
end;

function TStContainer.DoCompare(Data1, Data2: Pointer): integer;
begin
  Result := 0;
  if Assigned(FOnCompare) then
    FOnCompare(Self, Data1, Data2, Result)
  else if Assigned(FCompare) then
    Result := FCompare(Data1, Data2);
end;

procedure TStContainer.DoDisposeData(Data: Pointer);
begin
  if Assigned(FOnDisposeData) then
    FOnDisposeData(Self, Data)
  else if Assigned(FDisposeData) then
    FDisposeData(Data);
end;

function TStContainer.DoLoadData(Reader: TReader): Pointer;
begin
  Result := nil;
  if Assigned(FOnLoadData) then
    FOnLoadData(Self, Reader, Result)
  else if Assigned(FLoadData) then
    Result := FLoadData(Reader)
  else
    RaiseContainerError(ssscNoLoadData);
end;

procedure TStContainer.DoStoreData(Writer: TWriter; Data: Pointer);
begin
  if Assigned(FOnStoreData) then
    FOnStoreData(Self, Writer, Data)
  else if Assigned(FStoreData) then
    FStoreData(Writer, Data)
  else
    RaiseContainerError(ssscNoStoreData);
end;

procedure TStContainer.EnterCS;
begin
{$IFDEF ThreadSafe}
  EnterCriticalSection(conThreadSafe);
{$ENDIF}
end;

procedure TStContainer.IncNodeProtection;
begin
  Inc(conNodeProt);
end;

procedure TStContainer.LeaveCS;
begin
{$IFDEF ThreadSafe}
  LeaveCriticalSection(conThreadSafe);
{$ENDIF}
end;

procedure TStContainer.LoadFromFile(const FileName: string);
var
  S: TStream;
begin
  S := TFileStream.Create(FileName, fmOpenRead + fmShareDenyWrite);
  try
    LoadFromStream(S);
  finally
    S.Free;
  end;
end;

procedure TStContainer.StoreToFile(const FileName: string);
var
  S: TStream;
begin
  S := TFileStream.Create(FileName, fmCreate);
  try
    StoreToStream(S);
  finally
    S.Free;
  end;
end;




{ String routines }
function LeftPadChS(const S: ShortString; C: AnsiChar; Len: cardinal): ShortString;
  {-Pad a string on the left with a specified character.}
begin
  if Length(S) >= Len then
    Result := S
  else if Length(S) < 255 then
  begin
    if Len > 255 then
      Len := 255;
    Result[0] := Chr(Len);
    Move(S[1], Result[Succ(word(Len)) - Length(S)], Length(S));
    FillChar(Result[1], Len - Length(S), C);
  end;
end;

function LeftPadS(const S: ShortString; Len: cardinal): ShortString;
  {-Pad a string on the left with spaces.}
begin
  Result := LeftPadChS(S, ' ', Len);
end;

function CharExistsS(const S: ShortString; C: AnsiChar): boolean;
  register;
asm
  xor   ecx, ecx
  mov   ch, [eax]
  inc   eax
  or    ch, ch
  jz    @@Done
  jmp   @@5

  @@Loop:
  cmp   dl, [eax+3]
  jne   @@1
  inc   cl
  jmp   @@Done

  @@1:
  cmp   dl, [eax+2]
  jne   @@2
  inc   cl
  jmp   @@Done

  @@2:
  cmp   dl, [eax+1]
  jne   @@3
  inc   cl
  jmp   @@Done

  @@3:
  cmp   dl, [eax+0]
  jne   @@4
  inc   cl
  jmp   @@Done

  @@4:
  add   eax, 4
  sub   ch, 4
  jna   @@Done

  @@5:
  cmp   ch, 4
  jae   @@Loop

  cmp   ch, 3
  je    @@1

  cmp   ch, 2
  je    @@2

  cmp   ch, 1
  je    @@3

  @@Done:
  xor   eax, eax
  mov   al, cl
end;

function StrChPosS(const P: ShortString; C: AnsiChar; var Pos: cardinal): boolean;
asm
  push  ebx             { Save registers }
  push  edi

  xor   edi, edi        { Zero counter }
  xor   ebx, ebx
  add   bl, [eax]       { Get input length }
  jz    @@NotFound
  inc   eax

  @@Loop:
  inc   edi             { Increment counter }
  cmp[eax], dl          { Did we find it? }
  jz    @@Found
  inc   eax             { Increment pointer }

  cmp   edi, ebx        { End of string? }
  jnz   @@Loop          { If not, loop }

  @@NotFound:
  xor   eax, eax        { Not found, zero EAX for False }
  mov[ecx], eax
  jmp   @@Done

  @@Found:
  mov[ecx], edi         { Set Pos }
  mov   eax, 1          { Set EAX to True }

  @@Done:
  pop   edi             { Restore registers }
  pop   ebx
end;

function Long2StrL(L: longint): ansistring;
  {-Convert an integer type to a string.}
begin
  Str(L, Result);
end;

function TrimL(const S: ansistring): ansistring;
  {-Return a string with leading and trailing white space removed.}
var
  I: longint;
begin
  Result := S;
  while (Length(Result) > 0) and (Result[Length(Result)] <= ' ') do
    SetLength(Result, Pred(Length(Result)));

  I := 1;
  while (I <= Length(Result)) and (Result[I] <= ' ') do
    Inc(I);
  Dec(I);
  if I > 0 then
    System.Delete(Result, 1, I);
end;

function AddBackSlashL(const DirName: ansistring): ansistring;
  {-Add a default backslash to a directory name}
begin
  Result := DirName;
  if (Length(Result) = 0) then
    Exit;
  if ((Length(Result) = 2) and (Result[2] = ':')) or
    ((Length(Result) > 2) and (Result[Length(Result)] <> '\')) then
    Result := Result + '\';
end;

function CommaizeChL(L: longint; Ch: AnsiChar): ansistring;
  {-Convert a long integer to a string with Ch in comma positions}
var
  Temp: string;
  NumCommas, I, Len: cardinal;
  Neg:  boolean;
begin
  SetLength(Temp, 1);
  Temp[1] := Ch;
  if L < 0 then
  begin
    Neg := True;
    L   := Abs(L);
  end
  else
    Neg := False;
  Result := Long2StrL(L);
  Len := Length(Result);
  NumCommas := (Pred(Len)) div 3;
  for I := 1 to NumCommas do
    System.Insert(Temp, Result, Succ(Len - (I * 3)));
  if Neg then
    System.Insert('-', Result, 1);
end;

function CommaizeL(L: longint): ansistring;
  {-Convert a long integer to a string with commas}
begin
  Result := CommaizeChL(L, ',');
end;

procedure EnumerateFiles(StartDir: string; FL: TStrings; SubDirs: boolean;
  IncludeItem: TIncludeItemFunc);

  procedure SearchBranch;
  var
    SR:    TSearchRec;
    Error: smallint;
    Dir:   string;
  begin
    Error := FindFirst('*.*', faAnyFile, SR);
    GetDir(0, Dir);
    if Dir[Length(Dir)] <> '\' then
      Dir := Dir + '\';
    while Error = 0 do
    begin
      try
        if (@IncludeItem = nil) or (IncludeItem(SR, True)) then
          FL.Add(Dir + SR.Name);
      except
        on EOutOfMemory do
        begin
          raise EOutOfMemory.Create('..\source\String list is full');
        end;
      end;
      Error := FindNext(SR);
    end;
    FindClose(SR);

    if SubDirs then
    begin
      Error := FindFirst('*.*', faAnyFile, SR);
      while Error = 0 do
      begin
        if ((SR.Attr and faDirectory = faDirectory) and (SR.Name <> '.') and
          (SR.Name <> '..')) then
          if (@IncludeItem = nil) or (IncludeItem(SR, False)) then
          begin
            ChDir(SR.Name);
            SearchBranch;
            ChDir('..');
          end;
        Error := FindNext(SR);
      end;
      FindClose(SR);
    end;
  end;

var
  OrgDir: string;

begin
  if IsDirectory(StartDir) then
  begin
    GetDir(0, OrgDir);
    try
      ChDir(StartDir);
      SearchBranch;
    finally
      ChDir(OrgDir);
    end;
  end
  else
    raise Exception.Create('Invalid starting directory');
end;

{!!.01 -- Rewritten}
function IsDirectory(const DirName: ansistring): boolean;
  {-Return true if DirName is a directory}
var
  Attrs: DWORD;
begin
  Result := False;
  Attrs  := GetFileAttributes(PAnsiChar(DirName));
  if Attrs <> DWORD(-1) then
    Result := (FILE_ATTRIBUTE_DIRECTORY and Attrs <> 0);
end;


procedure LoadILFunctions;
begin
  Shell32Inst := LoadLibrary('shell32.dll');
  if Shell32Inst <> 0 then
  begin
    @ILClone := GetProcAddress(Shell32Inst, PChar(18));
    @ILCloneFirst := GetProcAddress(Shell32Inst, PChar(19));
    @ILCombine := GetProcAddress(Shell32Inst, PChar(25));
    @ILGetNext := GetProcAddress(Shell32Inst, PChar(153));
    @ILFindLastID := GetProcAddress(Shell32Inst, PChar(16));
    @ILIsEqual := GetProcAddress(Shell32Inst, PChar(21));
    @ILRemoveLastID := GetProcAddress(Shell32Inst, PChar(17));
    @ILGetSize := GetProcAddress(Shell32Inst, PChar(152));
    @ILFree := GetProcAddress(Shell32Inst, PChar(155));
    @SHChangeNotifyRegister := GetProcAddress(Shell32Inst, PChar(2));
    @SHChangeNotifyDeregister := GetProcAddress(Shell32Inst, PChar(4));
  end;
end;

function GetParentPidl(Pidl: PItemIDList): PItemIDList;
var
  TempPidl: PItemIDList;
begin
  TempPidl := ILClone(Pidl);
  ILRemoveLastID(TempPidl);
  Result := ILFindLastID(TempPidl);
end;

function GetSpecialFolderPath(Handle: TStHwnd; Folder: TStSpecialRootFolder): string;
var
  IDList: PItemIDList;
  Buff:   array [0..MAX_PATH * 2{ - 1}] of char;
begin
  if SHGetSpecialFolderLocation(Handle, ShellFolders[Folder], IDList) <> NOERROR then
    RaiseStError(ESsShellError, ssscShellVersionError);
  if not SHGetPathFromIDList(IDList, Buff) then
    RaiseStError(ESsShellError, ssscShellVersionError);
  Result := Buff;
end;

function FilterFunc(const SR: TSearchRec; B: boolean): boolean; far;
begin
  if (SR.Attr and faDirectory = faDirectory) then
    Result := False
  else
    Result := True;
end;

procedure GetSpecialFolderFiles(Handle: TStHwnd; Folder: TStSpecialRootFolder;
  Files: TStrings);
var
  S: string;
begin
  S := GetSpecialFolderPath(Handle, Folder);
  if not DirectoryExists(S) then
    RaiseStError(ESsShellError, ssscShellVersionError);
  EnumerateFiles(S, Files, False, FilterFunc);
end;

constructor TSsShellComponent.Create(AOwner: TComponent);
begin
end;

procedure TSsShellComponent.CheckSystemError(ErrCode: integer);
var
  Buff: array [0..1023] of char;
begin
  if ErrCode <> 0 then
    FError := ErrCode
  else
    FError := GetLastError;
  if FError <> 0 then
    if (FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, FError, 0,
      Buff, SizeOf(Buff), nil) <> 0) then
      FErrorString := Buff
    else
      FErrorString := ''
  else
    FErrorString := '';
end;

procedure TSsShellComponent.DoError;
begin
  if Assigned(FOnError) then
    FOnError(Self);
end;


{$IFDEF VERSION3}
initialization
  PidlFormat := RegisterClipboardFormat(CFSTR_SHELLIDLIST);
  LoadILFunctions;

finalization
  if Shell32Inst <> 0 then
   begin
    FreeLibrary(Shell32Inst);
    Shell32Inst := 0;
   end;
{$ENDIF}

end.
