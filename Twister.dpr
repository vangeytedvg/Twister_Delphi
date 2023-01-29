program Twister;

uses
  Vcl.Forms,
  main in 'main.pas' {mainForm} ,
  Vcl.Themes,
  Vcl.Styles,
  Ruler in 'Ruler.pas',
  NHunspell in 'NHunspell.pas',
  NHunXml in 'NHunXml.pas',
  PasZip in 'PasZip.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Obsidian');
  Application.CreateForm(TmainForm, mainForm);
  Application.Run;

end.

