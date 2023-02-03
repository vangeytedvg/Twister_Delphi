unit frmAppSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.IniFiles,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage, Vcl.Buttons;

type
  TFormSettings = class(TForm)
    btnSave: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    EditDBPath: TEdit;
    Label2: TLabel;
    EditPathOXT: TEdit;
    btnOpenTwisterDBPath: TSpeedButton;
    btnOpenOXTPath: TSpeedButton;
    Image1: TImage;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    IsDirty: Boolean;
    procedure LoadInitData;
  public
    { Public declarations }
  end;

var
  FormSettings: TFormSettings;

implementation

{$R *.dfm}

procedure TFormSettings.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFormSettings.FormCreate(Sender: TObject);
begin
  IsDirty := false;
end;

procedure TFormSettings.LoadInitData;
var
  SettingFile: TIniFile;
begin

  try
//    SettingFile := TIniFile.Create(ChangeFileExt(Application.ExeName, '.INI'));

//    mainForm.height := SettingFile.ReadInteger('WindowSize', 'Height',
//      mainForm.width)
  finally
///    SettingFile.Free;
  end;
end;

end.
