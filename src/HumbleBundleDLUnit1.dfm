object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 1322
  ClientWidth = 1684
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -22
  Font.Name = 'Tahoma'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 192
  TextHeight = 27
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1684
    Height = 1322
    Margins.Left = 6
    Margins.Top = 6
    Margins.Right = 6
    Margins.Bottom = 6
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'GetKeys'
      object lbKeys: TListBox
        Left = 0
        Top = 146
        Width = 386
        Height = 1121
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alLeft
        ItemHeight = 27
        TabOrder = 0
        OnClick = lbKeysClick
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 1668
        Height = 146
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alTop
        Caption = ' '
        TabOrder = 1
        object Button1: TButton
          Left = 32
          Top = 32
          Width = 150
          Height = 86
          Margins.Left = 6
          Margins.Top = 6
          Margins.Right = 6
          Margins.Bottom = 6
          Caption = 'Get Keys'
          TabOrder = 0
          OnClick = Button1Click
        end
        object Button2: TButton
          Left = 194
          Top = 32
          Width = 150
          Height = 86
          Margins.Left = 6
          Margins.Top = 6
          Margins.Right = 6
          Margins.Bottom = 6
          Caption = 'Get URLs'
          TabOrder = 1
          OnClick = Button2Click
        end
        object Button4: TButton
          Left = 356
          Top = 32
          Width = 150
          Height = 82
          Margins.Left = 6
          Margins.Top = 6
          Margins.Right = 6
          Margins.Bottom = 6
          Caption = 'Clear'
          TabOrder = 2
          OnClick = Button4Click
        end
      end
      object EdgeBrowser1: TEdgeBrowser
        Left = 386
        Top = 146
        Width = 1282
        Height = 1121
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alClient
        TabOrder = 2
        ExplicitLeft = 1664
        ExplicitTop = 1264
        ExplicitWidth = 200
        ExplicitHeight = 80
      end
    end
    object TabSheet2: TTabSheet
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'TabSheet2'
      ImageIndex = 1
      object DBGrid1: TDBGrid
        Left = 0
        Top = 82
        Width = 1668
        Height = 1185
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alClient
        DataSource = DataSource1
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -22
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDblClick = DBGrid1DblClick
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 1668
        Height = 82
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Align = alTop
        BevelOuter = bvNone
        Caption = ' '
        TabOrder = 1
        object btnFilter: TButton
          Left = 0
          Top = 0
          Width = 102
          Height = 82
          Margins.Left = 6
          Margins.Top = 6
          Margins.Right = 6
          Margins.Bottom = 6
          Align = alLeft
          Caption = 'Filter'
          TabOrder = 0
          OnClick = btnFilterClick
        end
        object editFilter: TEdit
          Left = 114
          Top = 20
          Width = 818
          Height = 35
          Margins.Left = 6
          Margins.Top = 6
          Margins.Right = 6
          Margins.Bottom = 6
          TabOrder = 1
          Text = 'format like '#39'%PDF%'#39
        end
        object Button3: TButton
          Left = 960
          Top = 16
          Width = 150
          Height = 50
          Margins.Left = 6
          Margins.Top = 6
          Margins.Right = 6
          Margins.Bottom = 6
          Caption = 'Download'
          TabOrder = 2
          OnClick = Button3Click
        end
      end
    end
    object TabSheet3: TTabSheet
      Margins.Left = 6
      Margins.Top = 6
      Margins.Right = 6
      Margins.Bottom = 6
      Caption = 'TabSheet3'
      ImageIndex = 2
      object Label1: TLabel
        Left = 208
        Top = 10
        Width = 64
        Height = 27
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Caption = 'Label1'
      end
      object Memo1: TMemo
        Left = 6
        Top = 62
        Width = 1010
        Height = 1026
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Lines.Strings = (
          'Memo1')
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
      object Button5: TButton
        Left = 0
        Top = 0
        Width = 150
        Height = 50
        Margins.Left = 6
        Margins.Top = 6
        Margins.Right = 6
        Margins.Bottom = 6
        Caption = 'Total'
        TabOrder = 1
        OnClick = Button5Click
      end
    end
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
