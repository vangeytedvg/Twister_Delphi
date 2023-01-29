unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList, Vcl.Menus,
  Vcl.ToolWin, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.StdActns, System.Actions,
  Vcl.ActnList, Vcl.ExtActns, Vcl.ExtCtrls, Ruler, NHunspell, Vcl.CheckLst;

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
    RulerHolder: TPanel;
    ToolButtenSpellCheck: TToolButton;
    lbSpellDicts: TCheckListBox;
    Memo1: TMemo;
    Edit2: TEdit;
    dlgLoadDictionary: TOpenDialog;
    Button1: TButton;
    btnSpeller: TButton;
    Button2: TButton;

    procedure MyEditorSelectionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure ToolButtonSelectFontClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MyEditorChange(Sender: TObject);
    procedure ToolButtonNewClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnSpellerClick(Sender: TObject);
    procedure lbSpellDictsClickCheck(Sender: TObject);
    procedure ToolButtenSpellCheckClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    IsDirty : Boolean;
  public
    { Public declarations }
    MyRuler: TRuler;
    procedure UpdateDicts;
    procedure UpdateButtons;
    function CheckWords:Integer;
//    procedure UpdateButtons;
  end;

var
  mainForm: TmainForm;

implementation

{$R *.dfm}

procedure TmainForm.btnSpellerClick(Sender: TObject);
var
  tmpStr: TUnicodeStringList;
begin
//  Hunspell.SpellDictionaries[0].Active := lbSpellDicts.Checked[0];
//  btnSpeller.Enabled := (lbSpellDicts.ItemIndex > -1) and TNHSpellDictionary(lbSpellDicts.Items.Objects[lbSpellDicts.ItemIndex]).Loaded;
  if TNHSpellDictionary(lbSpellDicts.Items.Objects[0]).Spell(Edit2.Text) then
    Memo1.Text := 'Correct'
  else
  begin
    tmpStr := TUnicodeStringList.create;
    TNHSpellDictionary(lbSpellDicts.Items.Objects[lbSpellDicts.Itemindex]).Suggest(Edit2.Text, tmpStr);

    if tmpStr.count = 0 then
      Memo1.Text := 'No suggestions'
    else
      Memo1.Text := tmpStr.Text;
    FreeAndNil(tmpStr);
  end;
end;

function TMainForm.CheckWords(): integer;
var
  i, j, SelStarter: Integer;
  Line: String;
  Words: TArray<String>;
begin
  MyEditor.SelStart := 0;
  MyEditor.SelLength := MyEditor.GetTextLen;
  MyEditor.SelAttributes.Color := clBlack;
  SelStarter := 0;
  for i := 0 to MyEditor.Lines.Count - 1 do
  begin
    Line := MyEditor.Lines[i];
    Words := Line.Split([' ']);
    for j := 0 to High(Words) do
    begin
      if not TNHSpellDictionary(lbSpellDicts.Items.Objects[0]).Spell(Words[j])  then
      begin
        Memo1.Lines.Add(Words[j]);
        MyEditor.SelStart := SelStarter;
        MyEditor.SelLength := Length(Words[j]);
        MyEditor.SelAttributes.Color := clRed;
      end;
//      else
//         MyEditor.SelAttributes.Color := clBlack;
      SelStarter := SelStarter + Length(Words[j]) + 1;
//      MyEditor.SelAttributes.Color := clBlack;
    end;
    SelStarter := SelStarter + 1;
  end;
  MyEditor.SelStart := SelStarter;
  MyEditor.SelAttributes.Color := clBlack;
end;


procedure TmainForm.Button1Click(Sender: TObject);
begin
  Hunspell.ReadOXT('C:\Development\Delphi\Twister\Dictionaries\OpenTaal-210G-LO.oxt');
  UpdateDicts;
end;


procedure TmainForm.Button2Click(Sender: TObject);
var
  t: Integer;
begin
  t := CheckWords();
end;

procedure TmainForm.Exit1Click(Sender: TObject);
// Leave the application
begin
  Application.Terminate;
end;


procedure TmainForm.FormCreate(Sender: TObject);
{ Creation details }
var
  i: Integer;
begin
  self.IsDirty := False;
  // create an instance of the ruler
  MyRuler:=TRuler.Create(Self);
  MyRuler.Parent := RulerHolder;
  MyRuler.Width:=RulerHolder.Width;
  MyRuler.RulerMeasure := 10;
  MyRuler.RulerColor := clWhite;
  Hunspell.ReadOXT('C:\Development\Delphi\Twister\Dictionaries\OpenTaal-210G-LO.oxt');
  UpdateDicts;
//  for i := 0 to lbSpellDicts.Items.Count-1 do
//  begin
//    lbSpellDicts.Checked[i] := i = lbSpellDicts.ItemIndex;
//    Hunspell.SpellDictionaries[i].Active := lbSpellDicts.Checked[i];
//  end;
//  Hunspell.UpdateAndLoadDictionaries;
//
//  btnSpeller.Enabled := (lbSpellDicts.ItemIndex > -1) and TNHSpellDictionary(lbSpellDicts.Items.Objects[lbSpellDicts.ItemIndex]).Loaded;

end;


procedure TmainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{ Avoid unintended closing of the application }
begin
  // If the form is dirty, ask the user if he wants to loose the changes
  if IsDirty then
    if Application.MessageBox('Are you sure you want to quit?', 'Confirmation', MB_YESNO) = IDYES then
      CanClose := true
      else
        CanClose := false;
end;


procedure TmainForm.FormResize(Sender: TObject);
{ Resizeing the windows also resizes the ruler }
begin
  MyRuler.Width:=RulerHolder.Width;
end;


procedure TmainForm.MyEditorChange(Sender: TObject);
{ Text changes }
begin
  IsDirty := true
end;


procedure TmainForm.MyEditorSelectionChange(Sender: TObject);
{ Selection changed, inform the position }
var
  CursorPosition: TPoint;
begin
  // Get the cursor position
  CursorPosition := myEditor.CaretPos;
  // Show in the statusbar
  Sb.Panels[2].Text := IntToStr(CursorPosition.Y+1);
  Sb.Panels[3].Text := IntToStr(CursorPosition.X+1);
end;


procedure TmainForm.ToolButtenSpellCheckClick(Sender: TObject);
begin
    lbSpellDicts.CheckAll(cbChecked, false, true);
    lbSpellDicts.Selected[0] := true;
    Hunspell.SpellDictionaries[0].Active := lbSpellDicts.Checked[0];
    Hunspell.UpdateAndLoadDictionaries;
    btnSpeller.Enabled := True; //(lbSpellDicts.ItemIndex > -1) and TNHSpellDictionary(lbSpellDicts.Items.Objects[lbSpellDicts.ItemIndex]).Loaded;
end;

procedure TmainForm.ToolButtonNewClick(Sender: TObject);
{ When creating a new document, reset the edited flag }
begin
  IsDirty := False;
end;


procedure TmainForm.ToolButtonSelectFontClick(Sender: TObject);
// Let the user select a font
begin
  if FontSelector.Execute() then
  begin
    MyEditor.SelAttributes.Name := FontSelector.Font.Name;
    MyEditor.SelAttributes.Size := FontSelector.Font.Size;
    MyEditor.SelAttributes.Color := FontSelector.Font.Color;
  end;
end;


procedure TmainForm.UpdateDicts;
{ Update the dictionary }
var
  intIndex: integer;
begin
  with lbSpellDicts do
  try
    Items.BeginUpdate;
    clear;
    for intIndex := 0 to Hunspell.SpellDictionaryCount-1 do
      Items.AddObject(Format('%s - %s Version: %s', [Hunspell.SpellDictionaries[intIndex].LanguageName,
                                                     Hunspell.SpellDictionaries[intIndex].DisplayName,
                                                     Hunspell.SpellDictionaries[intIndex].Version]),
                      Hunspell.SpellDictionaries[intIndex]);
  finally
    Items.EndUpdate;
  end;
end;


procedure TMainForm.UpdateButtons;
{ The spelling button is enabled only if the dictionary is loaded }
begin
    btnSpeller.Enabled := (lbSpellDicts.ItemIndex > -1) and TNHSpellDictionary(lbSpellDicts.Items.Objects[lbSpellDicts.ItemIndex]).Loaded;
//  btnHyphenate.Enabled := (lbHyphenDicts.ItemIndex > -1) and TNHHyphenDictionary(lbHyphenDicts.Items.Objects[lbHyphenDicts.ItemIndex]).Loaded;
end;


procedure TmainForm.lbSpellDictsClickCheck(Sender: TObject);
{ Execute the spellchecker }
var
  i: integer;
begin
  Hunspell.UpdateAndLoadDictionaries;
  UpdateButtons;
end;


end.
