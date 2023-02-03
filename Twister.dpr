program Twister;

uses
  Vcl.Forms,
  main in 'main.pas' {mainForm},
  Vcl.Themes,
  Vcl.Styles,
  Ruler in 'Ruler.pas',
  NHunspell in 'NHunspell.pas',
  NHunXml in 'NHunXml.pas',
  PasZip in 'PasZip.pas',
  frmNewDoc in 'frmNewDoc.pas' {FormNewDocument},
  CustomComboItem in 'CustomComboItem.pas',
  frmSplash in 'frmSplash.pas' {FormSplash};


{$R *.res}


begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Cyan Night');
  Application.CreateForm(TmainForm, mainForm);
  Application.CreateForm(TFormNewDocument, FormNewDocument);
  Application.Run;
end.

