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
    procedure FormCreate(Sender: TObject);
    procedure SendersListChange(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCANCELClick(Sender: TObject);
  private
    { Private declarations }
    FCancelled: Boolean;
    procedure LoadSenders;
  public
    property UserClickedCancel: Boolean read FCancelled write FCancelled;
  end;

var
  FormNewDocument: TFormNewDocument;

implementation

{$R *.dfm}

procedure TFormNewDocument.ButtonCANCELClick(Sender: TObject);
begin
  // If the user clicks on this button, set the flag to true,
  // this avoids inserting bad data in het main form
  UserClickedCancel := True;
  Close;
end;

procedure TFormNewDocument.ButtonOKClick(Sender: TObject);
begin
  if (MemoFROM.Lines.Count = 0) or (MemoTO.Lines.Count = 0) then
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
    LoadSenders;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
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
    // Add the address to the FROM box
    MemoFROM.Lines.Clear;
    MemoFROM.Lines.Add(FDQryListOfSenders.FieldByName('name').AsString + ' ' +
      FDQryListOfSenders.FieldByName('firstname').AsString);
    MemoFROM.Lines.Add(FDQryListOfSenders.FieldByName('address').AsString);
    MemoFROM.Lines.Add(FDQryListOfSenders.FieldByName('zipcode').AsString + ' '
      + FDQryListOfSenders.FieldByName('city').AsString);
    MemoFROM.Lines.Add('GSM ' + FDQryListOfSenders.FieldByName('phone')
      .AsString);
    MemoFROM.Lines.Add('email ' + FDQryListOfSenders.FieldByName('email')
      .AsString);
    CheckBox_SocialSecurityNr.Caption := FDQryListOfSenders.FieldByName
      ('socialsecurity').AsString;
  end;
end;

end.
