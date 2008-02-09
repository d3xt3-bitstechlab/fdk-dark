library fdkcp;

uses
  CtlPanel,
  fdccp in 'fdccp.pas' {FDKControl: TAppletModule};

exports CPlApplet;

{$R *.RES}

{$E cpl}

begin
  Application.Initialize;
  Application.CreateForm(TFDKControl, FDKControl);
  Application.Run;
end.
