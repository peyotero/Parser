program Parser;

uses
  Vcl.Forms,
  UMainForm in 'UMainForm.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles,
  Vcl.Controls,
  Vcl.Dialogs;

{$R *.res}

begin

  Application.Initialize;
  //Application.CreateForm(TLoginForm, LoginForm);
 // if LoginForm.ShowModal = mrOk then
 // begin
    Application.MainFormOnTaskbar := True;
    Application.Title := 'Parser';
  //  sUser:=LoginForm.LabeledEdit1.Text;
  //  sPswd:=LoginForm.LabeledEdit2.Text;
  //  sServer:=LoginForm.LabeledEdit3.Text;
  //  sPort:=LoginForm.LabeledEdit4.Text;
  //  LoginForm.Destroy;
    Application.CreateForm(TMainForm, MainForm);
  Application.Run;
  //end
end.
