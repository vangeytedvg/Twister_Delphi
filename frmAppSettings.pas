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
    procedure btnOpenTwisterDBPathClick(Sender: TObject);
    procedure btnOpenOXTPathClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure EditDBPathChange(Sender: TObject);
    procedure EditPathOXTChange(Sender: TObject);
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
  if IsDirty then
  begin
    If MessageDlg('Wilt U de wijzigingen oplsaan?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
      Close;
  end
  else
    Close;
end;

procedure TFormSettings.btnOpenOXTPathClick(Sender: TObject);
var
  openPathToDBDialog: TOpenDialog;
  path: string;
  myFilename: string;
begin
  path := ExtractFilePath(ParamStr(0));
  openPathToDBDialog := TOpenDialog.Create(self);
  openPathToDBDialog.InitialDir := path;
  openPathToDBDialog.Filter := 'Twister Translation|*.oxt';
  openPathToDBDialog.DefaultExt := 'oxt';
  openPathToDBDialog.FilterIndex := 1;

  if openPathToDBDialog.Execute() then
  begin
    EditPathOXT.Text := openPathToDBDialog.fileName;
  end;
end;

procedure TFormSettings.btnOpenTwisterDBPathClick(Sender: TObject);
{ Get the path to the Twister.db file }
var
  openPathToDBDialog: TOpenDialog;
  path: string;
  myFilename: string;
begin
  path := ExtractFilePath(ParamStr(0));
  openPathToDBDialog := TOpenDialog.Create(self);
  openPathToDBDialog.InitialDir := path;
  openPathToDBDialog.Filter := 'Twister Database|*.db';
  openPathToDBDialog.DefaultExt := 'db';
  openPathToDBDialog.FilterIndex := 1;

  if openPathToDBDialog.Execute() then
  begin
    EditDBPath.Text := openPathToDBDialog.fileName;
  end;

end;

procedure TFormSettings.btnSaveClick(Sender: TObject);
var
  SettingFile: TInifile;
  width, height: LongInt;
begin
  // Read the position of the form, if this code is ran in the Create method,
  // it generates an exception in Width and height
  try
    SettingFile := TInifile.Create(ChangeFileExt(Application.ExeName, '.INI'));
    SettingFile.WriteString('Database', 'pathtotwisterdb', EditDBPath.Text);
    SettingFile.WriteString('Spelling', 'dictionarypath', EditPathOXT.Text);
  finally
    SettingFile.Free;
  end;
  Close;

end;

procedure TFormSettings.EditDBPathChange(Sender: TObject);
begin
  IsDirty := True;
end;

procedure TFormSettings.EditPathOXTChange(Sender: TObject);
begin
  IsDirty := True;
end;

procedure TFormSettings.FormCreate(Sender: TObject);
begin
  LoadInitData;
  IsDirty := false;
end;

procedure TFormSettings.LoadInitData;
var
  SettingFile: TInifile;
begin

  try
    SettingFile := TInifile.Create(ChangeFileExt(Application.ExeName, '.INI'));
    EditDBPath.Text := SettingFile.ReadString('Database', 'pathtotwisterdb',
      'not set');
    EditPathOXT.Text := SettingFile.ReadString('Spelling', 'dictionarypath',
      'not set');
  finally
    SettingFile.Free;
  end;
end;

end.
