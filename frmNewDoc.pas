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
  FireDAC.Comp.DataSet, Vcl.ExtCtrls, CustomComboItem;

type
  TFormNewDocument = class(TForm)
    StatusBar: TStatusBar;
    lblSelectSender: TLabel;
    TwisterConnection: TFDConnection;
    DataSource1: TDataSource;

    FDQryListOfSenders: TFDQuery;
    SendersList: TComboBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SendersListChange(Sender: TObject);
  private
    { Private declarations }
    procedure LoadSenders;
  public
    { Public declarations }
  end;

var
  FormNewDocument: TFormNewDocument;

implementation

{$R *.dfm}

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
{ Get the selected Item and fill the FROM box
  And use this }
var
  myItem: TCustomComboBoxItem;
  qryString: string;
begin
  myItem := TCustomComboBoxItem(SendersList.items.Objects[SendersList.ItemIndex]);
  qryString := 'SELECT * FROM senders WHERE id=' + myItem.Value.ToString;
  with FDQryListOfSenders do
  begin
    Close;
    SQL.Text := qryString;
    Open
  end;
  if Not(FDQryListOfSenders.Eof) then
  begin
    ShowMessage(FDQryListOfSenders.FieldByName('address').AsString);
  end;
end;

end.
