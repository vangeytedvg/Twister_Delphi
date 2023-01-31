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
    procedure FormCreate(Sender: TObject);
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
  myItem: TCustomComboBox;
begin
  qryString := 'SELECT Id, Name, FirstName FROM senders';
  with FDQryListOfSenders do
  begin
    Close;
    SQL.Text := qryString;
    Open;
  end;

  while Not FDQryListOfSenders.Eof do
  begin
    SendersList.items.AddObject(FDQryListOfSenders.FieldByName('Name').AsString,
      TCustomComboBoxItem.Create(FDQryListOfSenders.FieldByName('id').AsInteger,
      FDQryListOfSenders.FieldByName('Name').AsString));
    FDQryListOfSenders.Next;
  end;

  // try
  // SQLQuery.SQLConnection := SQLConnection;
  // SQLQuery.SQL.Text := qry;
  // SQLQuery.Active := True;
  // except
  // on E: Exception do
  // begin
  // ShowMessage(E.Message);
  // end;
  // end;
end;

end.
