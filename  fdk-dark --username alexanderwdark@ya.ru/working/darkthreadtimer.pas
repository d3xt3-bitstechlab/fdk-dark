unit DarkThreadTimer;

interface

uses
  Windows, Forms, Messages, SysUtils, Classes, Controls, StdCtrls, Graphics, ShellApi;

type
  TDarkThreadTimer = class;

  TBreakMode = (thSuspend, thTerminate);


  TExtThread = class(TThread)
  private
    FOwner: TDarkThreadTimer;
    FStop:  THandle;
  protected
    procedure Execute; override;
  end;


  TDarkThreadTimer = class(TComponent)
  private
    FOnTimer:   TNotifyEvent;
    FExtThread: TExtThread;

    FEnabled:  boolean;
    FThreadPriority: TThreadPriority;
    FInterval: cardinal;

    procedure DoTimer;

    procedure SetEnabled(const Value: boolean);
    procedure SetInterval(const Value: cardinal);
    procedure SetThreadPriority(const Value: TThreadPriority);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnTimer: TNotifyEvent Read FOnTimer Write FOnTimer;
    property Enabled: boolean Read FEnabled Write SetEnabled;
    property Interval: cardinal Read FInterval Write SetInterval;
    property ThreadPriority: TThreadPriority
      Read FThreadPriority Write SetThreadPriority;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('CH Pack', [TDarkThreadTimer]);
end;

{ ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
procedure TExtThread.Execute;
begin
  repeat
    if WaitForSingleObject(FStop, FOwner.Interval) = WAIT_TIMEOUT then
      Synchronize(FOwner.DoTimer);
  until Terminated;
end;

{ ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
constructor TDarkThreadTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnabled   := False;
  FInterval  := 1000;
  FThreadPriority := tpNormal;
  FExtThread := TExtThread.Create(True);
  FExtThread.FOwner := Self;
  FExtThread.Priority := tpNormal;
  FExtThread.FStop := CreateEvent(nil, False, False, nil);

end;

{ ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
destructor TDarkThreadTimer.Destroy;
begin
  Enabled := False;

  FExtThread.Terminate;
  SetEvent(FExtThread.FStop);
  if FExtThread.Suspended then
    FExtThread.Resume;

  FExtThread.WaitFor;
  CloseHandle(FExtThread.FStop);
  FExtThread.Free;

  inherited Destroy;
end;

{ ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ }
procedure TDarkThreadTimer.DoTimer;
begin
  if FEnabled and Assigned(FOnTimer) and not (csDestroying in ComponentState) then
    try
      FOnTimer(Self);
    except
    end;
end;


procedure TDarkThreadTimer.SetEnabled(const Value: boolean);
begin
  if Value <> FEnabled then
  begin
    FEnabled := Value;
    // Enable = True
    if FEnabled then
    begin
      if (FInterval > 0) then
      begin
        SetEvent(FExtThread.FStop);
        FExtThread.Resume;
      end;
    end
    // Enable = False
    else
      FExtThread.Suspend;
  end;
end;

procedure TDarkThreadTimer.SetInterval(const Value: cardinal);
var
  tmpEnabled:  boolean;
  tmpInterval: cardinal;
begin
  if Value <> FInterval then
  begin
    tmpEnabled  := FEnabled;
    tmpInterval := FInterval;
    Enabled     := False;

    if (FInterval = 0) then
      FInterval := tmpInterval
    else
      FInterval := Value;

    Enabled := tmpEnabled;
  end;
end;

procedure TDarkThreadTimer.SetThreadPriority(const Value: TThreadPriority);
begin
  if FThreadPriority <> Value then
  begin
    FExtThread.Priority := Value;
    FThreadPriority     := FExtThread.Priority;
  end;
end;


end.
