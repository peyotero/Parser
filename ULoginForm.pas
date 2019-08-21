unit ULoginForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TLoginForm = class(TForm)
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    Button1: TButton;
    Button2: TButton;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
  private
    { Private declarations }
  public
    { Public declarations }
    class function Execute : boolean;
  end;

var
  LoginForm: TLoginForm;

implementation

{$R *.dfm}

class function TLoginForm.Execute: boolean;
begin
  with TLoginForm.Create(nil) do
  try
    Result:= ShowModal = mrOk;
  finally
    Free;
  end;
 end;

end.
