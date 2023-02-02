unit frmNewDoc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DbxSqlite, Data.FMTBcd, Data.DB,
  Data.SqlExpr, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.DBCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, Vcl.ExtCtrls, CustomComboItem, Vcl.Imaging.pngimage;

type
  TFormNewDocument = class(TForm)
    StatusBar: TStatusBar;
    lblSelectSender: TLabel;
    TwisterConnection: TFDConnection;
    DataSource1: TDataSource;
    FDQryListOfSenders: TFDQuery;
    SendersList: TComboBox;
    MemoFROM: TMemo;
    LabelFROM: TLabel;
    LabelTO: TLabel;
    MemoTO: TMemo;
    ButtonOK: TButton;
    ButtonCANCEL: TButton;
    Image1: TImage;
    CheckBox_SocialSecurityNr: TCheckBox;
    Label1: TLabel;
    EditSubject: TEdit;
    LabelSubject: TLabel;
    GroupBox1: TGroupBox;
    rbGeachte: TRadioButton;
    rbMijnheer: TRadioButton;
    rbMevrouw: TRadioButton;
    rbBeste: TRadioButton;
    rbNone: TRadioButton;
    GroupBox2: TGroupBox;
    rbMetAchting: TRadioButton;
    rbHoogachtend: TRadioButton;
    rbMetVriendelijkegroeten: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure SendersListChange(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCANCELClick(Sender: TObject);
    procedure SetSalutation(Sender: TObject);
    procedure SetSignature(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OptionsChanged(Sender: TObject);
  private
    { Private declarations }
    FCancelled: Boolean;
    FSalutation: string;
    FSignature: string;
    FSenderFullName: string;
    IsDirty: Boolean;
    procedure LoadSenders;
  public
    property UserClickedCancel: Boolean read FCancelled write FCancelled;
    property Salutation: string read FSalutation write FSalutation;
    property Signature: string read FSignature write FSignature;
    property SenderFullName: string read FSenderFullName write FSenderFullName;
    procedure ClearFields;
  end;

var
  FormNewDocument: TFormNewDocument;

implementation

{$R *.dfm}

procedure TFormNewDocument.ButtonCANCELClick(Sender: TObject);
begin
  // If the user clicks on this button, set the flag to true,
  // this avoids inserting bad data in het main form
  if IsDirty then
    If MessageDlg('Wijzigingen vergeten?', mtConfirmation, [mbYes, mbNo],
      0) = mrYes then
    begin
      UserClickedCancel := True;
      Close;
  end;
end;

procedure TFormNewDocument.ButtonOKClick(Sender: TObject);
{ Close the form, but warn if some fields not filled in }
var
  t1, t2: string;
begin
  t1 := Signature;
  t2 := Signature;
  if (MemoFROM.Lines.Count = 0) or (MemoTO.Lines.Count = 0) or (t1.Length = 0)
    or (t2.Length = 0) then
    ShowMessage('Niet alle velden zijn ingevuld!')
  else
    Close;
end;

procedure TFormNewDocument.FormCreate(Sender: TObject);
{ When form is created, load the senders from the database }
var
  dbName: String;
begin
  dbName := 'Twister';
  // TwisterConnection.da
  try
    TwisterConnection.Open(dbName);
    IsDirty := False;
    ClearFields;
    LoadSenders;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TFormNewDocument.FormShow(Sender: TObject);
begin
  ClearFields;
  LoadSenders;
  IsDirty := False;
end;

procedure TFormNewDocument.LoadSenders();
{ Load the list of senders }
var
  qryString: string;
begin
  qryString := 'SELECT Id, Name, FirstName FROM senders ORDER BY name ASC';
  with FDQryListOfSenders do
  begin
    Close;
    SQL.Text := qryString;
    Open;
  end;
  // Fill The ComboBox
  while Not FDQryListOfSenders.Eof do
  begin
    SendersList.items.AddObject(FDQryListOfSenders.FieldByName('Name').AsString,
      TCustomComboBoxItem.Create(FDQryListOfSenders.FieldByName('id').AsInteger,
      FDQryListOfSenders.FieldByName('Name').AsString));
    FDQryListOfSenders.Next;
  end;
end;

procedure TFormNewDocument.OptionsChanged(Sender: TObject);
begin
  IsDirty := True;
end;

procedure TFormNewDocument.SendersListChange(Sender: TObject);
{ Get the selected Item and fill the FROM box }
var
  myItem: TCustomComboBoxItem;
  qryString: string;
begin
  myItem := TCustomComboBoxItem(SendersList.items.Objects
    [SendersList.ItemIndex]);
  qryString := 'SELECT * FROM senders WHERE id=' + myItem.Value.ToString;
  with FDQryListOfSenders do
  begin
    Close;
    SQL.Text := qryString;
    Open
  end;
  if Not(FDQryListOfSenders.Eof) then
  begin
    // Store sender name and firstname for later use
    SenderFullName := FDQryListOfSenders.FieldByName('name').AsString + ' ' +
      FDQryListOfSenders.FieldByName('firstname').AsString;
    // Add the address to the FROM box
    MemoFROM.Lines.Clear;
    MemoFROM.Lines.Add(FDQryListOfSenders.FieldByName('name').AsString + ' ' +
      FDQryListOfSenders.FieldByName('firstname').AsString);
    MemoFROM.Lines.Add(FDQryListOfSenders.FieldByName('address').AsString);
    MemoFROM.Lines.Add(FDQryListOfSenders.FieldByName('zipcode').AsString + ' '
      + FDQryListOfSenders.FieldByName('city').AsString);
    MemoFROM.Lines.Add('GSM: ' + FDQryListOfSenders.FieldByName('phone')
      .AsString);
    MemoFROM.Lines.Add('email: ' + FDQryListOfSenders.FieldByName('email')
      .AsString);
    CheckBox_SocialSecurityNr.Caption := FDQryListOfSenders.FieldByName
      ('socialsecurity').AsString;
  end;
end;

procedure TFormNewDocument.SetSalutation(Sender: TObject);
{ Property handler }
begin
  with Sender as TRadioButton do
  begin
    Salutation := Caption;
    IsDirty := True;
  end;

end;

procedure TFormNewDocument.SetSignature(Sender: TObject);
{ Property handler }
begin
  with Sender as TRadioButton do
  begin
    Signature := Caption;
    IsDirty := True;
  end;
end;

procedure TFormNewDocument.ClearFields;
{ Clear all the fields }
begin
  MemoFROM.Text := '';
  MemoTO.Text := '';
  EditSubject.Text := '';
  SendersList.items.Clear;
end;

end.
