unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Winapi.ShlObj,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.Menus, System.IniFiles, Math,
  Vcl.ToolWin, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.StdActns, System.Actions,
  Vcl.ActnList, Vcl.ExtActns, Vcl.ExtCtrls, Ruler, NHunspell, Vcl.CheckLst,
  EsBase, EsCalc, frmSettings, Vcl.Printers, frmNewDoc;

type
  TmainForm = class(TForm)
    MainAppMenu: TMainMenu;
    MyImages: TImageList;
    Sb: TStatusBar;
    MyEditor: TRichEdit;
    ToolBar1: TToolBar;
    ToolButtonNew: TToolButton;
    ToolButtonOpenFile: TToolButton;
    ToolButtonSave: TToolButton;
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
    MenuFileExit: TMenuItem;
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
    Panel1: TPanel;
    Panel2: TPanel;
    MenuNewFile: TMenuItem;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    ActionList1: TActionList;
    Print1: TMenuItem;
    ActionSaveFile: TAction;
    MenuSaveFile: TMenuItem;
    ActionNewFile: TAction;
    ActionOpenFile: TAction;
    MenuOpenFile: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    ActionPrint: TAction;
    ToolButtonPrint: TToolButton;

    procedure MyEditorSelectionChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure ToolButtonSelectFontClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MyEditorChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lbSpellDictsClickCheck(Sender: TObject);
    procedure ToolButtenSpellCheckClick(Sender: TObject);
    procedure MyEditorContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure MyClickEventHandler(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActionNewFileExecute(Sender: TObject);
    procedure ActionSaveFileExecute(Sender: TObject);
    procedure ActionOpenFileExecute(Sender: TObject);
    procedure ActionPrintExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PrintRichEdit(RichEdit: TRichEdit; const Caption: string;
      const PrinterMargin: Integer);
    procedure SaveRichEdit(RichEdit: TRichEdit; const fileName: string);
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
    function CheckSingleWord(const WordToCheck: String): TUnicodeStringList;
  end;

var
  mainForm: TmainForm;

implementation

{$R *.dfm}

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

procedure TmainForm.ActionNewFileExecute(Sender: TObject);
var
  currentDate: TDateTime;
  cursorPosition: TPoint;
  localShortDate: string;
  subjecText: string;
begin
  if IsDirty then
  begin
    If MessageDlg('Do you want to save changes?', mtConfirmation, [mbYes, mbNo],
      0) = mrYes then
      // Save the file
    else
    begin
      IsDirty := False;
      MyEditor.Lines.Clear;
    end;
  end;
  // FormNewDocument.Left := (Self.Width - FormNewDocument.Width) div 2;
  // FormNewDocument.Top := (Self.Height - FormNewDocument.Height) div 2
  FormNewDocument.Position := poOwnerFormCenter;
  FormNewDocument.ShowModal();
  if not FormNewDocument.UserClickedCancel then
  begin
    // Begin with the sender's details
    MyEditor.SelectAll;
    MyEditor.SelAttributes.Style := [fsBold];
    MyEditor.Lines.Add(FormNewDocument.MemoFROM.Text);
    currentDate := Now;
    // If the social security checkbox is checked
    if FormNewDocument.CheckBox_SocialSecurityNr.Checked then
    begin
      MyEditor.Lines.Add('Rijksregister: ' +
        FormNewDocument.CheckBox_SocialSecurityNr.Caption);
    end;
    localShortDate := FormatDateTime('dddd, dd mmmm, yyyy', currentDate);

    MyEditor.Lines.Add('');
    MyEditor.Lines.Add('');
    // Add the current date
    MyEditor.Lines.Add(localShortDate);
    MyEditor.Lines.Add('');

    // The destineation of the letter
    MyEditor.Lines.Add(FormNewDocument.MemoTO.Text);
    MyEditor.Lines.Add('');
    MyEditor.Lines.Add('');

    // Handle the subject if any
    if FormNewDocument.EditSubject.Text <> '' then
    begin
      MyEditor.SelAttributes.Style := [fsBold, fsUnderLine];
      MyEditor.Lines.Add('Betreft: ' + FormNewDocument.EditSubject.Text);
      MyEditor.SelAttributes.Style := [];
    end;

    MyEditor.Lines.Add('');

    // Disable the bold characters
    MyEditor.SelStart := MyEditor.GetTextLen;
    MyEditor.SelLength := 10;

    MyEditor.SelAttributes.Style := [];

    // Salutation
    MyEditor.Lines.Add(FormNewDocument.Salutation);

    MyEditor.Lines.Add('');
    MyEditor.Lines.Add('');
    MyEditor.Lines.Add('');

    // Signature
    MyEditor.Lines.Add(FormNewDocument.Signature);
    MyEditor.Lines.Add('');
    MyEditor.Lines.Add('');
    MyEditor.Lines.Add('');

    MyEditor.Lines.Add(FormNewDocument.SenderFullName);

  end;
end;

procedure TmainForm.ActionOpenFileExecute(Sender: TObject);
var
  myFileName: string;
  openFileDialog: TOpenDialog;
  Path: array[0..MAX_PATH] of Char;
begin
  try
    openFileDialog := TOpenDialog.Create(self);
    openFileDialog.Title := 'Open een bestaand bestand';
    // This is tricky, but ChatGPT gave me the correct answer to get the
    // user's Documents folder
    if SUCCEEDED(SHGetFolderPath(0, CSIDL_PERSONAL, 0, 0, @Path[0])) then
      openFileDialog.InitialDir := ExpandFileName(Path);
    openFileDialog.Filter := 'Twister Document|*.twister';
    openFileDialog.DefaultExt := 'twister';
    openFileDialog.FilterIndex := 1;
    if openFileDialog.Execute() then
    begin
      myFileName := openFileDialog.fileName;
      MyEditor.Lines.LoadFromFile(myFilename);
    end;
  finally
    openFileDialog.Free;
  end;
end;

procedure TmainForm.ActionPrintExecute(Sender: TObject);
begin
  if IsDirty then
    If MessageDlg('Bent U zeker dat U het document wilt afdrukken?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      PrintRichEdit(MyEditor, '', 20)
end;

procedure TmainForm.ActionSaveFileExecute(Sender: TObject);
var
  myFileName: string;
  saveFileDialog: TSaveDialog;
  Path: array[0..MAX_PATH] of Char;
begin
  try
    saveFileDialog := TSaveDialog.Create(self);
    saveFileDialog.Title := 'Geef een naam voor dit bestand';
    // This is tricky, but ChatGPT gave me the correct answer to get the
    // user's Documents folder
    if SUCCEEDED(SHGetFolderPath(0, CSIDL_PERSONAL, 0, 0, @Path[0])) then
      SaveFileDialog.InitialDir := ExpandFileName(Path);
    saveFileDialog.Filter := 'Twister Document|*.twister';
    saveFileDialog.DefaultExt := 'twister';
    saveFileDialog.FilterIndex := 1;
    if saveFileDialog.Execute() then
    begin
      myFileName := saveFileDialog.fileName;
      SaveRichEdit(MyEditor, myFilename);
    end;
  finally
    saveFileDialog.Free;
  end;

end;

function TmainForm.CheckSingleWord(const WordToCheck: String)
  : TUnicodeStringList;
{ Check a single word based on the selection of the popup }
var
  tmpStr: TUnicodeStringList;
  Word: UnicodeString;
begin
  if not TNHSpellDictionary(lbSpellDicts.Items.Objects[lbSpellDicts.Itemindex])
    .Spell(WordToCheck) then
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
  end
  else
  begin
    Word := 'Word is Correct';
    tmpStr := TUnicodeStringList.create();
    tmpStr.Add(Word);
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

procedure TmainForm.FormCreate(Sender: TObject);
{ Creation details }
var
  i: Integer;
  width, height: LongInt;
begin
  // Read the position of the form
  IsDirty := False;
  // Can not print an empty form
  ActionPrint.Enabled := False;
  // create an instance of the ruler
  MyRuler := TRuler.create(self);
  MyRuler.Parent := RulerHolder;
  MyRuler.width := RulerHolder.width;
  MyRuler.RulerMeasure := 10;
  MyRuler.RulerColor := clWhite;
  Hunspell.ReadOXT
    ('C:\Development\Delphi\Twister\Dictionaries\nl-dict-v2.00g.oxt');
  UpdateDicts;
  lbSpellDicts.CheckAll(cbChecked, False, true);
  CanSpellCheck := true;
  ActionSaveFile.Enabled := False;
  lbSpellDicts.CheckAll(cbChecked, False, true);
  lbSpellDicts.Selected[0] := true;
end;

procedure TmainForm.FormClose(Sender: TObject; var Action: TCloseAction);
{ Save the window position and size to file }
var
  SettingFile: TIniFile;
begin

  try
    SettingFile := TIniFile.create(ChangeFileExt(Application.ExeName, '.INI'));
    SettingFile.WriteInteger('WindowPosition', 'Left', mainForm.Left);
    SettingFile.WriteInteger('WindowPosition', 'Top', mainForm.Top);
    SettingFile.WriteInteger('WindowSize', 'Width', mainForm.width);
    SettingFile.WriteInteger('WindowSize', 'Height', mainForm.height);
  finally
    SettingFile.Free;
  end;
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
  MyRuler.width := RulerHolder.width;
end;

procedure TmainForm.FormShow(Sender: TObject);
var
  i: Integer;
  SettingFile: TIniFile;
  width, height: LongInt;
begin
  // Read the position of the form, if this code is ran in the Create method,
  // it generates an exception in Width and height
  try
    SettingFile := TIniFile.create(ChangeFileExt(Application.ExeName, '.INI'));
    mainForm.Left := SettingFile.ReadInteger('WindowPosition', 'Left', 0);
    mainForm.Top := SettingFile.ReadInteger('WindowPosition', 'Top', 0);
    mainForm.width := SettingFile.ReadInteger('WindowSize', 'Width',
      mainForm.width);
    mainForm.height := SettingFile.ReadInteger('WindowSize', 'Height',
      mainForm.width);
  finally
    SettingFile.Free;
  end;

end;

procedure TmainForm.MyEditorChange(Sender: TObject);
{ Text changes }
begin
  IsDirty := true;
  ActionSaveFile.Enabled := true;
  ActionPrint.Enabled := true;
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
  // If nothing is selected
  if SelString = '' then
  begin
    PopupForEditor.Items.Clear;
    PopupItem := TMenuItem.create(PopupForEditor);
    PopupItem.Caption := 'Nothing Selected';
    PopupItem.OnClick := MyClickEventHandler;
    PopupItem.Enabled := False;
    PopupForEditor.Items.Add(PopupItem);
    PopupItem.Free;
    exit;
  end
  else
  begin
    // We have a suggestion
    mRes := CheckSingleWord(Trim(SelString));
    PopupForEditor.Items.Clear;
    PopupForEditor.AutoHotkeys := maManual;
    try
      for i := 0 to mRes.Count - 1 do
      begin
        PopupItem := TMenuItem.create(PopupForEditor);
        PopupItem.Caption := mRes[i];
        PopupItem.OnClick := MyClickEventHandler;
        PopupForEditor.Items.Add(PopupItem);
      end;
    finally
    end;
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
    if Caption = 'Word is Correct' then
      exit;

    acceptText := Caption.Substring(0, Caption.Length);
    MyEditor.SelText := acceptText + ' ';
    // After accepting the corrections, check spelling again
    CheckWords();
  end;

end;

procedure TmainForm.MyEditorSelectionChange(Sender: TObject);
{ Selection changed, inform the position }
var
  cursorPosition: TPoint;
begin
  // Get the cursor position
  cursorPosition := MyEditor.CaretPos;
  // Show in the statusbar
  Sb.Panels[2].Text := IntToStr(cursorPosition.Y + 1);
  Sb.Panels[3].Text := IntToStr(cursorPosition.X + 1);

end;

procedure TmainForm.ToolButtenSpellCheckClick(Sender: TObject);
begin
  // lbSpellDicts.CheckAll(cbChecked, False, true);
  // lbSpellDicts.Selected[0] := true;
  Hunspell.SpellDictionaries[0].Active := lbSpellDicts.Checked[0];
  Hunspell.UpdateAndLoadDictionaries;
  // Indicate that the spell check routine can be run for the timer
  CanSpellCheck := true;
  CheckWords();
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
{ Update the dictionary and initialize it }
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
end;

procedure TmainForm.lbSpellDictsClickCheck(Sender: TObject);
{ Execute the spellchecker }
var
  i: Integer;
begin
  Hunspell.UpdateAndLoadDictionaries;
  UpdateButtons;
end;

procedure TmainForm.PrintRichEdit(RichEdit: TRichEdit; const Caption: string;
  const PrinterMargin: Integer);
{ Print the document with correct margin settings }
var
  PrinterHeight, PrinterWidth: Integer;
  LogPixels, PrinterTopLeft: TPoint;
  PageRect: TRect;
  Handle: HDC;
  Printer: TPrinter;
begin
  try
    // Create an instance of the printer
    Printer := TPrinter.create;
    Handle := Printer.Handle;
    LogPixels := Point(GetDeviceCaps(Handle, LOGPIXELSX),
      GetDeviceCaps(Handle, LOGPIXELSY));
    PrinterTopLeft := Point(GetDeviceCaps(Handle, PHYSICALOFFSETX),
      GetDeviceCaps(Handle, PHYSICALOFFSETY));
    PrinterWidth := Printer.PageWidth;
    PrinterHeight := Printer.PageHeight;
    PageRect.Left := Max(0, Round(PrinterMargin * LogPixels.X / 25.4) -
      PrinterTopLeft.X);
    PageRect.Top := Max(0, Round(PrinterMargin * LogPixels.Y / 25.4) -
      PrinterTopLeft.Y);
    PageRect.Right := PrinterWidth - PageRect.Left;
    PageRect.Bottom := PrinterHeight - PageRect.Top;
    if (PageRect.Left >= PageRect.Right) or (PageRect.Top >= PageRect.Bottom)
    then
      // the margins are too big
      PageRect := Rect(0, 0, 0, 0);
    RichEdit.PageRect := PageRect;
  finally
    // Always be sure to free the printer instance
    Printer.Free;
  end;
end;

procedure TmainForm.SaveRichEdit(RichEdit: TRichEdit; const fileName: string);
{ Write the contents of the editor to disk }
var
  RichEditStream: TMemoryStream;
begin
  RichEditStream := TMemoryStream.create;
  try
    MyEditor.Lines.SaveToStream(RichEditStream);
    RichEditStream.SaveToFile(fileName);
  finally
    RichEditStream.Free;
  end;
end;

end.
