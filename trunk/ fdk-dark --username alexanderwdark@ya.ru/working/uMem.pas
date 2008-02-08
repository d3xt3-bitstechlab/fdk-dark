unit uMem;

interface

uses
 SysUtils, Forms, Windows;

type

  TMemoryEvent = procedure(Sender: TObject; AQuantity: integer) of object;

  TStatusMonitor = record
    TotalPhys:     integer;
    AvailPhys:     integer;
    TotalPageFile: integer;
    AvailPageFile: integer;
    TotalVirtual:  integer;
    AvailVirtual:  integer;
  end;

  TMem = class
  private
    MemoryStatus: TMemoryStatus;
    FOnAllocMemory: TMemoryEvent;
    FOnDeallocMemory: TMemoryEvent;


  public

    function GetMemoryStatus: TStatusMonitor;

    procedure FreeRAM(const ARAMAmount: integer);


  published
    property OnAllocMemory: TMemoryEvent Read FOnAllocMemory Write FOnAllocMemory;
    property OnDeallocMemory: TMemoryEvent Read FOnDeallocMemory Write FOnDeallocMemory;
  end;


var
  mem: TMem;

implementation





function TMem.GetMemoryStatus: TStatusMonitor;
begin
  GlobalMemoryStatus(MemoryStatus);
  Result.TotalPhys     := Trunc(MemoryStatus.dwTotalPhys /1024 / 1024);
  Result.AvailPhys     := Trunc(MemoryStatus.dwAvailPhys /1024 / 1024);
  Result.TotalPageFile := Trunc(MemoryStatus.dwTotalPageFile / 1024 / 1024);
  Result.AvailPageFile := Trunc(MemoryStatus.dwAvailPageFile / 1024 / 1024);
  Result.TotalVirtual  := Trunc(MemoryStatus.dwTotalVirtual / 1024 / 1024);
  Result.AvailVirtual  := Trunc(MemoryStatus.dwAvailVirtual / 1024 / 1024);

end;


procedure TMem.FreeRAM(const ARAMAmount: integer);
var
  PMem: array of pointer;
  i:    integer;

begin
  SetLength(PMem, ARAMAmount);
  for i := 0 to (ARAMAmount - 1) do
  begin
    PMem[i] := AllocMem(1048576);
    if Assigned(FOnAllocMemory) then
      FOnAllocMemory(Self, i);
    Application.ProcessMessages;
  end;
  for i := 0 to (ARAMAmount - 1) do
  begin
    FreeMem(PMem[i], 1048576);
    if Assigned(FOnDeallocMemory) then
      FOnDeallocMemory(Self, i);
    Application.ProcessMessages;
  end;

end;


end.
