object FormNewDocument: TFormNewDocument
  Left = 0
  Top = 0
  Caption = 'New Document'
  ClientHeight = 377
  ClientWidth = 578
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblSelectSender: TLabel
    Left = 16
    Top = 8
    Width = 170
    Height = 20
    Caption = 'Select sender of the letter'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 320
    Top = 51
    Width = 121
    Height = 13
    Caption = 'Label1'
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 358
    Width = 578
    Height = 19
    Panels = <
      item
        Width = 200
      end>
  end
  object SendersList: TComboBox
    Left = 8
    Top = 48
    Width = 289
    Height = 21
    Style = csDropDownList
    Sorted = True
    TabOrder = 1
    OnChange = SendersListChange
  end
  object TwisterConnection: TFDConnection
    Params.Strings = (
      'ConnectionDef=Twister')
    Connected = True
    LoginPrompt = False
    Left = 108
    Top = 295
  end
  object DataSource1: TDataSource
    DataSet = FDQryListOfSenders
    Left = 24
    Top = 296
  end
  object FDQryListOfSenders: TFDQuery
    Connection = TwisterConnection
    Left = 232
    Top = 296
  end
end
