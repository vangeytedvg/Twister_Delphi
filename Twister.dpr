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
  frmSettings in 'frmSettings.pas' {FormSettings},
  frmNewDoc in 'frmNewDoc.pas' {FormNewDocument},
  CustomComboItem in 'CustomComboItem.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Cyan Dusk');
  Application.CreateForm(TmainForm, mainForm);
  Application.CreateForm(TFormSettings, FormSettings);
  Application.CreateForm(TFormNewDocument, FormNewDocument);
  Application.Run;

end.

