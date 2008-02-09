{$D "Dark Software Live Update"}
program lu;

uses
  Forms,
  upd in 'upd.pas' {LUForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Live! Update by Dark Software';
  Application.CreateForm(TLUForm, LUForm);
  Application.Run;
end.
