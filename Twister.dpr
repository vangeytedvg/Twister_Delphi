program Twister;

uses
  Vcl.Forms,
  main in 'main.pas' {mainForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Obsidian');
  Application.CreateForm(TmainForm, mainForm);
  Application.Run;
end.
