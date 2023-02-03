unit frmSenders;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.TitleBarCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.ExtCtrls,
  Vcl.DBCtrls, Vcl.Mask;

type
  TfrmSenderList = class(TForm)
    SenderDataSource: TDataSource;
    FDSendersQRY: TFDQuery;
    FDSendersQRYName: TWideMemoField;
    FDSendersQRYFirstName: TWideMemoField;
    FDSendersQRYAddress: TWideMemoField;
    FDSendersQRYCity: TWideMemoField;
    FDSendersQRYZipCode: TWideMemoField;
    FDSendersQRYPhone: TWideMemoField;
    FDSendersQRYEmail: TWideMemoField;
    FDSendersQRYsocialsecurity: TWideStringField;
    Label1: TLabel;
    DBMemo1: TDBMemo;
    Label2: TLabel;
    DBMemo2: TDBMemo;
    Label3: TLabel;
    DBMemo3: TDBMemo;
    Label4: TLabel;
    DBMemo4: TDBMemo;
    Postcode: TLabel;
    DBMemo5: TDBMemo;
    Label6: TLabel;
    DBMemo6: TDBMemo;
    Label7: TLabel;
    DBMemo7: TDBMemo;
    Label8: TLabel;
    DBEdit1: TDBEdit;
    DBNavigator1: TDBNavigator;
    FDConnection1: TFDConnection;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSenderList: TfrmSenderList;

implementation

{$R *.dfm}

procedure TfrmSenderList.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmSenderList.FormCreate(Sender: TObject);
begin
  FDSendersQRY.Open();
end;

end.
