program SenderManager;

uses
  Vcl.Forms,
  frmSenders in 'frmSenders.pas' {frmSenderList};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSenderList, FormSenderList);
  Application.Run;
end.
