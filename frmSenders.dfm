object frmSenderList: TfrmSenderList
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Lijst van Afzenders'
  ClientHeight = 483
  ClientWidth = 345
  Color = clBtnFace
  CustomTitleBar.Height = 31
  CustomTitleBar.SystemHeight = False
  CustomTitleBar.ShowIcon = False
  CustomTitleBar.SystemColors = False
  CustomTitleBar.SystemButtons = False
  CustomTitleBar.BackgroundColor = clGreen
  CustomTitleBar.ForegroundColor = 65793
  CustomTitleBar.InactiveBackgroundColor = clWhite
  CustomTitleBar.InactiveForegroundColor = 10066329
  CustomTitleBar.ButtonForegroundColor = 65793
  CustomTitleBar.ButtonBackgroundColor = clMenuHighlight
  CustomTitleBar.ButtonHoverForegroundColor = 65793
  CustomTitleBar.ButtonHoverBackgroundColor = 16053492
  CustomTitleBar.ButtonPressedForegroundColor = 65793
  CustomTitleBar.ButtonPressedBackgroundColor = clRed
  CustomTitleBar.ButtonInactiveForegroundColor = 10066329
  CustomTitleBar.ButtonInactiveBackgroundColor = clYellow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Naam'
    FocusControl = DBMemo1
  end
  object Label2: TLabel
    Left = 8
    Top = 55
    Width = 48
    Height = 13
    Caption = 'Voornaam'
    FocusControl = DBMemo2
  end
  object Label3: TLabel
    Left = 8
    Top = 103
    Width = 28
    Height = 13
    Caption = 'Adres'
    FocusControl = DBMemo3
  end
  object Label4: TLabel
    Left = 8
    Top = 151
    Width = 49
    Height = 13
    Caption = 'Gemeente'
    FocusControl = DBMemo4
  end
  object Postcode: TLabel
    Left = 8
    Top = 199
    Width = 44
    Height = 13
    Caption = 'Postcode'
    FocusControl = DBMemo5
  end
  object Label6: TLabel
    Left = 8
    Top = 247
    Width = 67
    Height = 13
    Caption = 'Telefoon/GSM'
    FocusControl = DBMemo6
  end
  object Label7: TLabel
    Left = 8
    Top = 295
    Width = 24
    Height = 13
    Caption = 'Email'
    FocusControl = DBMemo7
  end
  object Label8: TLabel
    Left = 8
    Top = 344
    Width = 73
    Height = 13
    Caption = 'Rijksregister Nr'
    FocusControl = DBEdit1
  end
  object DBMemo1: TDBMemo
    Left = 8
    Top = 24
    Width = 329
    Height = 25
    DataField = 'Name'
    DataSource = SenderDataSource
    TabOrder = 0
  end
  object DBMemo2: TDBMemo
    Left = 8
    Top = 74
    Width = 329
    Height = 23
    DataField = 'FirstName'
    DataSource = SenderDataSource
    TabOrder = 1
  end
  object DBMemo3: TDBMemo
    Left = 8
    Top = 122
    Width = 329
    Height = 23
    DataField = 'Address'
    DataSource = SenderDataSource
    TabOrder = 2
  end
  object DBMemo4: TDBMemo
    Left = 8
    Top = 170
    Width = 329
    Height = 23
    DataField = 'City'
    DataSource = SenderDataSource
    TabOrder = 3
  end
  object DBMemo5: TDBMemo
    Left = 8
    Top = 218
    Width = 137
    Height = 23
    DataField = 'ZipCode'
    DataSource = SenderDataSource
    TabOrder = 4
  end
  object DBMemo6: TDBMemo
    Left = 8
    Top = 266
    Width = 217
    Height = 23
    DataField = 'Phone'
    DataSource = SenderDataSource
    TabOrder = 5
  end
  object DBMemo7: TDBMemo
    Left = 8
    Top = 314
    Width = 329
    Height = 23
    DataField = 'Email'
    DataSource = SenderDataSource
    TabOrder = 6
  end
  object DBEdit1: TDBEdit
    Left = 8
    Top = 360
    Width = 329
    Height = 21
    DataField = 'socialsecurity'
    DataSource = SenderDataSource
    TabOrder = 7
  end
  object DBNavigator1: TDBNavigator
    Left = 7
    Top = 403
    Width = 330
    Height = 25
    DataSource = SenderDataSource
    TabOrder = 8
  end
  object Button1: TButton
    Left = 262
    Top = 448
    Width = 75
    Height = 25
    Caption = 'Sluit'
    TabOrder = 9
    OnClick = Button1Click
  end
  object SenderDataSource: TDataSource
    DataSet = FDSendersQRY
    Left = 104
    Top = 432
  end
  object FDSendersQRY: TFDQuery
    DetailFields = 'Name;FirstName;Address;City;ZipCode;Phone;Email;socialsecurity'
    Connection = FDConnection1
    UpdateOptions.AssignedValues = [uvLockMode]
    UpdateOptions.LockMode = lmOptimistic
    SQL.Strings = (
      'select * from senders')
    Left = 192
    Top = 432
    object FDSendersQRYName: TWideMemoField
      FieldName = 'Name'
      Origin = 'Name'
      Required = True
      BlobType = ftWideMemo
    end
    object FDSendersQRYFirstName: TWideMemoField
      FieldName = 'FirstName'
      Origin = 'FirstName'
      Required = True
      BlobType = ftWideMemo
    end
    object FDSendersQRYAddress: TWideMemoField
      FieldName = 'Address'
      Origin = 'Address'
      Required = True
      BlobType = ftWideMemo
    end
    object FDSendersQRYCity: TWideMemoField
      FieldName = 'City'
      Origin = 'City'
      Required = True
      BlobType = ftWideMemo
    end
    object FDSendersQRYZipCode: TWideMemoField
      FieldName = 'ZipCode'
      Origin = 'ZipCode'
      Required = True
      BlobType = ftWideMemo
    end
    object FDSendersQRYPhone: TWideMemoField
      FieldName = 'Phone'
      Origin = 'Phone'
      BlobType = ftWideMemo
    end
    object FDSendersQRYEmail: TWideMemoField
      FieldName = 'Email'
      Origin = 'Email'
      BlobType = ftWideMemo
    end
    object FDSendersQRYsocialsecurity: TWideStringField
      FieldName = 'socialsecurity'
      Origin = 'socialsecurity'
      Size = 25
    end
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'ConnectionDef=Twister')
    Left = 32
    Top = 432
  end
end
