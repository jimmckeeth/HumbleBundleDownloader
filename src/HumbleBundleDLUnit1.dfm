object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 661
  ClientWidth = 842
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 842
    Height = 661
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'GetKeys'
      object lbKeys: TListBox
        Left = 0
        Top = 73
        Width = 193
        Height = 560
        Align = alLeft
        ItemHeight = 13
        TabOrder = 0
        OnClick = lbKeysClick
      end
      object CEFWindowParent1: TCEFWindowParent
        Left = 193
        Top = 73
        Width = 641
        Height = 560
        Align = alClient
        TabOrder = 1
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 834
        Height = 73
        Align = alTop
        Caption = ' '
        TabOrder = 2
        object Button1: TButton
          Left = 16
          Top = 16
          Width = 75
          Height = 43
          Caption = 'Get Keys'
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 97
          Top = 16
          Width = 75
          Height = 43
          Caption = 'Get URLs'
          TabOrder = 1
          OnClick = Button2Click
        end
        object Button4: TButton
          Left = 178
          Top = 16
          Width = 75
          Height = 41
          Caption = 'Clear'
          TabOrder = 2
          OnClick = Button4Click
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      object DBGrid1: TDBGrid
        Left = 0
        Top = 41
        Width = 834
        Height = 592
        Align = alClient
        DataSource = DataSource1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = DBGrid1DblClick
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 834
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        object btnFilter: TButton
          Left = 0
          Top = 0
          Width = 51
          Height = 41
          Align = alLeft
          Caption = 'Filter'
          TabOrder = 0
          OnClick = btnFilterClick
        end
        object editFilter: TEdit
          Left = 57
          Top = 10
          Width = 409
          Height = 21
          TabOrder = 1
          Text = 'format like '#39'%PDF%'#39
        end
        object Button3: TButton
          Left = 480
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Download'
          TabOrder = 2
          OnClick = Button3Click
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
      object Label1: TLabel
        Left = 104
        Top = 5
        Width = 31
        Height = 13
        Caption = 'Label1'
      end
      object Memo1: TMemo
        Left = 3
        Top = 31
        Width = 505
        Height = 513
        Lines.Strings = (
          'Memo1')
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
      object Button5: TButton
        Left = 0
        Top = 0
        Width = 75
        Height = 25
        Caption = 'Total'
        TabOrder = 1
        OnClick = Button5Click
      end
    end
  end
  object Chromium1: TChromium
    OnTextResultAvailable = Chromium1TextResultAvailable
    OnLoadEnd = Chromium1LoadEnd
    Left = 264
    Top = 128
  end
  object tblDownloads: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 264
    Top = 224
    object tblDownloadsBundle: TWideStringField
      FieldName = 'Bundle'
      Size = 100
    end
    object tblDownloadsProduct: TWideStringField
      FieldName = 'Product'
      Size = 100
    end
    object tblDownloadsPlatform: TWideStringField
      FieldName = 'Platform'
    end
    object tblDownloadsFileSize: TLongWordField
      FieldName = 'FileSize'
    end
    object tblDownloadsMD5: TWideStringField
      FieldName = 'MD5'
      Size = 32
    end
    object tblDownloadsURL: TWideStringField
      FieldName = 'URL'
      Size = 1024
    end
    object tblDownloadsSHA1: TWideStringField
      FieldName = 'SHA1'
      Size = 40
    end
    object tblDownloadsDownloadName: TWideStringField
      FieldName = 'DownloadName'
      Size = 100
    end
    object tblDownloadsFormat: TWideStringField
      FieldName = 'Format'
    end
    object tblDownloadsIcon: TWideStringField
      FieldName = 'Icon'
      Size = 1024
    end
    object tblDownloadsPaid: TCurrencyField
      FieldName = 'Paid'
    end
    object tblDownloadsBundleKey: TWideStringField
      FieldName = 'BundleKey'
      Size = 40
    end
  end
  object DataSource1: TDataSource
    DataSet = tblDownloads
    Left = 264
    Top = 176
  end
end
