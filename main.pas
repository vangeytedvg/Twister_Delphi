unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.Menus,
  Vcl.ToolWin, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.StdActns, System.Actions,
  Vcl.ActnList, Vcl.ExtActns, Vcl.ExtCtrls, Ruler, NHunspell, Vcl.CheckLst,
  EsBase, EsCalc;

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
    dlgLoadDictionary: TOpenDialog;
    ools1: TMenuItem;
    mnuToolsOptions: TMenuItem;
    PopupForEditor: TPopupMenu;
    Edit2: TMenuItem;

    procedure MyEditorSelectionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure ToolButtonSelectFontClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MyEditorChange(Sender: TObject);
    procedure ToolButtonNewClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lbSpellDictsClickCheck(Sender: TObject);
    procedure ToolButtenSpellCheckClick(Sender: TObject);
    procedure SpellTimerTimer(Sender: TObject);
    procedure mnuToolsOptionsClick(Sender: TObject);

    procedure MyEditorContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);

    procedure MyClickEventHandler(Sender: TObject);

  private
    { Private declarations }
    IsDirty: Boolean;
    CanSpellCheck: Boolean;
  public
    { Public declarations }
    MyRuler: TRuler;
    procedure UpdateDicts;
    procedure UpdateButtons;
    function CheckWords: Integer;
    function CheckSingleWord(WordToCheck: String): TUnicodeStringList;
  end;

var
  mainForm: TmainForm;

implementation

uses frmSettings;

{$R *.dfm}
// procedure TmainForm.CheckSpelling1Click(Sender: TObject);
// begin
// CheckWords()
// end;

function TmainForm.CheckWords(): Integer;
{
  Perform a spellingcheck
}
var
  i, j, z, SelStarter: Integer;
  MarkPosition: Integer;
  FindChars: array of Char;
  Line: String;
  Words: TArray<String>;
  A: array of Integer;
  CurrentStyle: TFontStyle;
begin
  FindChars := ['?', '!', ';'];
  MyEditor.SelStart := 0;
  MyEditor.SelLength := MyEditor.GetTextLen + 1;
  MyEditor.SelAttributes.Color := clBlack;
  SelStarter := 0;
  for i := 0 to MyEditor.Lines.Count - 1 do
  begin
    Line := MyEditor.Lines[i];
    Words := Line.Split([' ']);
    for j := 0 to High(Words) do
    begin
      if not TNHSpellDictionary(lbSpellDicts.Items.Objects[0]).Spell(Words[j])
      then
      begin
        MyEditor.SelStart := SelStarter;
        MyEditor.SelLength := Length(Words[j]);
        MyEditor.SelAttributes.Color := clRed;
      end
      else
      begin
        MyEditor.SelStart := SelStarter;
        MyEditor.SelLength := Length(Words[j]);
        MyEditor.SelAttributes.Color := clBlack;
      end;
      SelStarter := SelStarter + Length(Words[j]) + 1;
    end;
    SelStarter := SelStarter + 1;
    MyEditor.SelStart := SelStarter;
  end;
end;

function TmainForm.CheckSingleWord(WordToCheck: String): TUnicodeStringList;
{ Check a single word based on the selection of the popup }
var
  tmpStr: TUnicodeStringList;
  Word: UnicodeString;
begin
  if TNHSpellDictionary(lbSpellDicts.Items.Objects[lbSpellDicts.Itemindex])
    .Spell(WordToCheck) then
  begin
    Word := 'Correct';
    tmpStr.Add(Word);
    Result := tmpStr;
  end
  else
  begin
    tmpStr := TUnicodeStringList.create;
    TNHSpellDictionary(lbSpellDicts.Items.Objects[lbSpellDicts.Itemindex])
      .Suggest(WordToCheck, tmpStr);

    if tmpStr.Count = 0 then
    begin
      Word := 'No suggestions';
      tmpStr.Add(Word);
      Result := tmpStr;
    end
    else
      Result := tmpStr;
  end;
end;

procedure TmainForm.MenuExitClick(Sender: TObject);
{
  Leave the application, note that this can be interrupted if
  the editor is 'dirty'
}
begin
  Application.Terminate;
end;

procedure TmainForm.mnuToolsOptionsClick(Sender: TObject);
{ Create an instance of the settings form }
var
  SettingsDialog: TFSettings;
begin
  SettingsDialog := TFSettings.create(self);
  try
    SettingsDialog.Position := poMainFormCenter;
    SettingsDialog.ShowModal;
  finally
    SettingsDialog.Free;
  end;
end;

procedure TmainForm.FormCreate(Sender: TObject);
{ Creation details }
var
  i: Integer;
begin
  self.IsDirty := False;
  // create an instance of the ruler
  MyRuler := TRuler.create(self);
  MyRuler.Parent := RulerHolder;
  MyRuler.Width := RulerHolder.Width;
  MyRuler.RulerMeasure := 10;
  MyRuler.RulerColor := clWhite;
  Hunspell.ReadOXT
    ('C:\Development\Delphi\Twister\Dictionaries\nl-dict-v2.00g.oxt');
  UpdateDicts;
end;

procedure TmainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{ Avoid unintended closing of the application }
begin
  // If the form is dirty, ask the user if he wants to loose the changes
  if IsDirty then
    if Application.MessageBox('Are you sure you want to quit?', 'Confirmation',
      MB_YESNO) = IDYES then
      CanClose := true
    else
      CanClose := False;
end;

procedure TmainForm.FormResize(Sender: TObject);
{ Resizeing the windows also resizes the ruler }
begin
  MyRuler.Width := RulerHolder.Width;
end;

procedure TmainForm.MyEditorChange(Sender: TObject);
{ Text changes }
begin
  IsDirty := true;
end;

procedure TmainForm.MyEditorContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
{ Handle the richt click on the editor }
var
  SelString: String;
  PopupItem: TMenuItem;
  mRes: TUnicodeStringList;
  i: Integer;
  short: TShortCut;
begin
  SelString := MyEditor.SelText;
  Sb.Panels[0].Text := SelString;
  mRes := CheckSingleWord(SelString);
  PopupForEditor.Items.Clear;
  PopupForEditor.AutoHotkeys := maManual;
  for i := 0 to mRes.Count - 1 do
  begin
    PopupItem := TMenuItem.create(PopupForEditor);
    PopupItem.Caption := mRes[i];
    PopupItem.OnClick := MyClickEventHandler;
    PopupForEditor.Items.Add(PopupItem);
  end;
end;

procedure TmainForm.MyClickEventHandler(Sender: TObject);
{ Get the correction word }
var
  acceptText: String;
begin
  // Add code to handle the first menu item
  with Sender as TMenuItem do
  begin
    acceptText := Caption.Substring(0, Caption.Length);
    MyEditor.SelText := acceptText +' ';
    CheckWords();
  end;

end;

procedure TmainForm.MyEditorSelectionChange(Sender: TObject);
{ Selection changed, inform the position }
var
  CursorPosition: TPoint;
begin
  // Get the cursor position
  CursorPosition := MyEditor.CaretPos;
  // Show in the statusbar
  Sb.Panels[2].Text := IntToStr(CursorPosition.Y + 1);
  Sb.Panels[3].Text := IntToStr(CursorPosition.X + 1);

end;

procedure TmainForm.SpellTimerTimer(Sender: TObject);
begin
  CheckWords();
end;

procedure TmainForm.ToolButtenSpellCheckClick(Sender: TObject);
begin
  lbSpellDicts.CheckAll(cbChecked, False, true);
  lbSpellDicts.Selected[0] := true;
  Hunspell.SpellDictionaries[0].Active := lbSpellDicts.Checked[0];
  Hunspell.UpdateAndLoadDictionaries;
  // Indicate that the spell check routine can be run for the timer
  CanSpellCheck := true;
  CheckWords();
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
  intIndex: Integer;
begin
  with lbSpellDicts do
    try
      Items.BeginUpdate;
      Clear;
      for intIndex := 0 to Hunspell.SpellDictionaryCount - 1 do
        Items.AddObject(Format('%s - %s Version: %s',
          [Hunspell.SpellDictionaries[intIndex].LanguageName,
          Hunspell.SpellDictionaries[intIndex].DisplayName,
          Hunspell.SpellDictionaries[intIndex].Version]),
          Hunspell.SpellDictionaries[intIndex]);
    finally
      Items.EndUpdate;
    end;
end;

procedure TmainForm.UpdateButtons;
{ The spelling button is enabled only if the dictionary is loaded }
begin
  ToolButtenSpellCheck.Enabled := (lbSpellDicts.Itemindex > -1) and
    TNHSpellDictionary(lbSpellDicts.Items.Objects
    [lbSpellDicts.Itemindex]).Loaded;
  // btnHyphenate.Enabled := (lbHyphenDicts.ItemIndex > -1) and TNHHyphenDictionary(lbHyphenDicts.Items.Objects[lbHyphenDicts.ItemIndex]).Loaded;
end;

procedure TmainForm.lbSpellDictsClickCheck(Sender: TObject);
{ Execute the spellchecker }
var
  i: Integer;
begin
  Hunspell.UpdateAndLoadDictionaries;
  UpdateButtons;
end;

end.
