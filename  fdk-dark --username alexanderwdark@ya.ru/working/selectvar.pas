unit selectvar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tselectelement = class(TForm)
    Button1: TButton;
    element: TComboBox;
    Memo:    TMemo;
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  selectelement: Tselectelement;

implementation

uses davinchi;

{$R *.dfm}

procedure Tselectelement.FormResize(Sender: TObject);
begin
  memo.Top      := 8;
  memo.Left     := 8;
  memo.Width    := selectelement.Width - 24;
  memo.Height   := selectelement.Height - element.Height - button1.Height - 60;
  element.Left  := 8;
  element.Width := selectelement.Width - 24;
  element.Top   := memo.Top + memo.Height + 8;
  button1.Top   := element.Top + element.Height + 8;
  button1.Left  := (selectelement.Width div 2) - (button1.Width div 2);
end;

procedure Tselectelement.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  selectedelement    := element.Text;
  selectedelementidx := element.ItemIndex;
end;

procedure Tselectelement.FormShow(Sender: TObject);
var
  i, max: integer;
begin
  max := 0;
  for i := 0 to element.Items.Count do
    if element.Canvas.TextWidth(element.Items[i]) > max then
      max := element.Canvas.TextWidth(element.Items[i]);
  selectelement.Width := max + 40;
end;

end.
