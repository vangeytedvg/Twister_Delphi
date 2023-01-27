unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList, Vcl.Menus,
  Vcl.ToolWin, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.StdActns, System.Actions,
  Vcl.ActnList, Vcl.ExtActns;

type
  TmainForm = class(TForm)
    MainAppMenu: TMainMenu;
    MyImages: TImageList;
    Sb: TStatusBar;
    MyEditor: TRichEdit;
    ToolBar1: TToolBar;
    ToolButtonNew: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButtonCut: TToolButton;
    ToolButtonCopy: TToolButton;
    ToolButtonPaste: TToolButton;
    ToolButtonButtons: TToolButton;
    ToolButtonLeftAlign: TToolButton;
    ToolButtonCenter: TToolButton;
    ToolButtonAlignRight: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButtonBold: TToolButton;
    ToolButton15: TToolButton;
    ToolButtonSelectFont: TToolButton;
    ToolButtonItalic: TToolButton;
    ToolButtonStrikeThrough: TToolButton;
    ToolButtonUnderline: TToolButton;
    EditorActions: TActionList;
    EditCut: TEditCut;
    EditCopy: TEditCopy;
    EditPaste: TEditPaste;
    EditUndo: TEditUndo;
    EditDelete: TEditDelete;
    ToolButton17: TToolButton;
    ToolButtonUndo: TToolButton;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Undo1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    Format1: TMenuItem;
    Format2: TMenuItem;
    FormatRichEditBold1: TRichEditBold;
    FormatRichEditItalic1: TRichEditItalic;
    Italic1: TMenuItem;
    FormatRichEditUnderline1: TRichEditUnderline;
    Underline1: TMenuItem;
    FormatRichEditStrikeOut1: TRichEditStrikeOut;
    Strikeout1: TMenuItem;
    FormatRichEditBullets1: TRichEditBullets;
    Bullets1: TMenuItem;
    N2: TMenuItem;
    FormatRichEditAlignLeft1: TRichEditAlignLeft;
    AlignLeft1: TMenuItem;
    FormatRichEditAlignCenter1: TRichEditAlignCenter;
    Center1: TMenuItem;
    FormatRichEditAlignRight1: TRichEditAlignRight;
    AlignRight1: TMenuItem;
    FontSelector: TFontDialog;

    procedure MyEditorSelectionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure ToolButtonSelectFontClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MyEditorChange(Sender: TObject);
    procedure ToolButtonNewClick(Sender: TObject);


  private
    { Private declarations }
    IsDirty : Boolean;
  public
    { Public declarations }
  end;

var
  mainForm: TmainForm;

implementation

{$R *.dfm}



procedure TmainForm.Exit1Click(Sender: TObject);
// Leave the application
begin
  Application.Terminate;
end;

procedure TmainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);

begin
  // If the form is dirty, ask the user if he wants to loose the changes
  if IsDirty then
    if Application.MessageBox('Are you sure you want to quit?', 'Confirmation', MB_YESNO) = IDYES then
      CanClose := true
      else
        CanClose := false;

end;

procedure TmainForm.FormCreate(Sender: TObject);
// Executed when the application is started
begin
  self.IsDirty := False;
end;

procedure TmainForm.MyEditorChange(Sender: TObject);
// Set dirty flag
begin
  IsDirty := true
end;

procedure TmainForm.MyEditorSelectionChange(Sender: TObject);
// Keep track of the cursor position
var
  CursorPosition: TPoint;
begin
  CursorPosition := myEditor.CaretPos;
  Sb.Panels[2].Text := IntToStr(CursorPosition.Y+1);
  Sb.Panels[3].Text := IntToStr(CursorPosition.X+1);
end;


procedure TmainForm.ToolButtonNewClick(Sender: TObject);
begin
  IsDirty := False;
end;

procedure TmainForm.ToolButtonSelectFontClick(Sender: TObject);
begin
  if FontSelector.Execute() then
  begin
    MyEditor.SelAttributes.Name := FontSelector.Font.Name;
    MyEditor.SelAttributes.Size := FontSelector.Font.Size;
    MyEditor.SelAttributes.Color := FontSelector.Font.Color;
  end;
end;

// Create a new file
end.