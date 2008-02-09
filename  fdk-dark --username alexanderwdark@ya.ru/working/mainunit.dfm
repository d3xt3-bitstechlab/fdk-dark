object FDCMAIN: TFDCMAIN
  Left = 231
  Top = 205
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 329
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  PrintScale = poNone
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PC: TPageControl
    Left = 0
    Top = 24
    Width = 498
    Height = 240
    ActivePage = TabSheet36
    Align = alBottom
    HotTrack = True
    ParentShowHint = False
    ShowHint = False
    Style = tsFlatButtons
    TabOrder = 1
    OnChange = PCChange
    object TabSheet5: TTabSheet
      Caption = #1055#1086#1080#1089#1082
      ImageIndex = 4
      ParentShowHint = False
      ShowHint = False
      object Bevel3: TBevel
        Left = 200
        Top = 8
        Width = 289
        Height = 129
        Shape = bsFrame
      end
      object Label19: TLabel
        Left = 24
        Top = 32
        Width = 144
        Height = 13
        Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1087#1088#1086#1094#1077#1089#1089#1072' '#1087#1086#1080#1089#1082#1072
      end
      object Bevel4: TBevel
        Left = -8
        Top = 160
        Width = 497
        Height = 25
        Shape = bsTopLine
      end
      object Bevel5: TBevel
        Left = 0
        Top = 176
        Width = 489
        Height = 25
        Shape = bsTopLine
      end
      object sbtn: TButton
        Left = 8
        Top = 56
        Width = 75
        Height = 25
        Caption = #1057#1090#1072#1088#1090
        TabOrder = 2
        OnClick = sbtnClick
      end
      object res: TButton
        Left = 112
        Top = 96
        Width = 75
        Height = 25
        Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100
        Enabled = False
        TabOrder = 3
        OnClick = resume
      end
      object sus: TButton
        Left = 112
        Top = 56
        Width = 75
        Height = 25
        Caption = #1055#1072#1091#1079#1072
        Enabled = False
        TabOrder = 4
        OnClick = Pause
      end
      object stp: TButton
        Left = 8
        Top = 96
        Width = 75
        Height = 25
        Caption = #1054#1090#1084#1077#1085#1072
        Enabled = False
        TabOrder = 5
        OnClick = gotostop
      end
      object autodel: TCheckBox
        Left = 384
        Top = 16
        Width = 97
        Height = 20
        Caption = #1040#1074#1090#1086#1091#1076#1072#1083#1077#1085#1080#1077
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object track: TScrollBar
        Left = 8
        Top = 8
        Width = 177
        Height = 16
        Max = 6
        PageSize = 0
        TabOrder = 1
        OnChange = trackChange
      end
      object alldisks: TCheckBox
        Left = 217
        Top = 17
        Width = 148
        Height = 17
        Caption = #1042#1089#1077' '#1074#1086#1079#1084#1086#1078#1085#1099#1077' '#1076#1080#1089#1082#1080
        TabOrder = 6
        OnClick = alldisksClick
      end
      object where: TComboBox
        Left = 216
        Top = 56
        Width = 161
        Height = 21
        Color = clWhite
        ItemHeight = 13
        TabOrder = 7
        Text = 'C:\'
      end
      object browse: TButton
        Left = 392
        Top = 56
        Width = 75
        Height = 25
        Caption = #1054#1073#1079#1086#1088
        TabOrder = 8
        OnClick = browseClick
      end
      object spec: TButton
        Left = 392
        Top = 96
        Width = 75
        Height = 25
        Caption = #1056#1077#1076#1072#1082#1090#1086#1088
        TabOrder = 9
        OnClick = specClick
      end
      object preset: TComboBox
        Left = 216
        Top = 96
        Width = 161
        Height = 21
        Style = csDropDownList
        Color = clWhite
        ItemHeight = 13
        ParentShowHint = False
        ShowHint = True
        TabOrder = 10
        OnSelect = presetSelect
      end
    end
    object TabSheet19: TTabSheet
      Caption = #1057#1094#1077#1085#1072#1088#1080#1080
      ImageIndex = 9
      object oper: TComboBox
        Left = 8
        Top = 8
        Width = 393
        Height = 21
        AutoComplete = False
        BevelInner = bvNone
        BevelOuter = bvNone
        Style = csDropDownList
        Color = clWhite
        Ctl3D = True
        ItemHeight = 0
        ParentCtl3D = False
        TabOrder = 0
        OnSelect = operSelect
      end
      object loadoper: TButton
        Left = 408
        Top = 8
        Width = 75
        Height = 25
        Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
        TabOrder = 1
        OnClick = loadoperClick
      end
      object operpc: TPageControl
        Left = 8
        Top = 40
        Width = 481
        Height = 169
        ActivePage = TabSheet20
        MultiLine = True
        TabOrder = 2
        TabPosition = tpLeft
        object TabSheet20: TTabSheet
          Caption = #1051#1086#1075
          object operlog: TRichEdit
            Left = 0
            Top = 0
            Width = 449
            Height = 161
            Cursor = crArrow
            Color = clWhite
            Ctl3D = True
            HideScrollBars = False
            ParentCtl3D = False
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
          end
        end
        object TabSheet21: TTabSheet
          Caption = #1054#1090#1083#1072#1076#1082#1072
          ImageIndex = 1
          object operdebug: TRichEdit
            Left = 0
            Top = 0
            Width = 449
            Height = 161
            Cursor = crArrow
            HideScrollBars = False
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
          end
        end
        object TabSheet22: TTabSheet
          Caption = #1050#1086#1076
          ImageIndex = 2
          object opercode: TRichEdit
            Left = 8
            Top = 0
            Width = 441
            Height = 161
            Cursor = crArrow
            HideScrollBars = False
            ReadOnly = True
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
          end
        end
      end
    end
    object TabSheet36: TTabSheet
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1089#1080#1089#1090#1077#1084#1099
      ImageIndex = 10
      object chk: TRichEdit
        Left = 8
        Top = 8
        Width = 473
        Height = 161
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object check: TButton
        Left = 8
        Top = 176
        Width = 75
        Height = 25
        Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
        TabOrder = 1
        OnClick = checkClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = #1052#1072#1089#1082#1072
      object Label3: TLabel
        Left = 8
        Top = 8
        Width = 190
        Height = 13
        Caption = #1059#1082#1072#1078#1080#1090#1077' '#1096#1072#1073#1083#1086#1085' '#1092#1072#1081#1083#1086#1074' '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072':'
      end
      object SpeedButton1: TButton
        Left = 8
        Top = 80
        Width = 89
        Height = 25
        Caption = #1053#1086#1074#1099#1081
        TabOrder = 3
        OnClick = SpeedButton1Click
      end
      object deltempl: TButton
        Left = 104
        Top = 80
        Width = 89
        Height = 25
        Caption = #1059#1076#1072#1083#1080#1090#1100
        Enabled = False
        TabOrder = 4
        OnClick = deltemplClick
      end
      object chtempl: TButton
        Left = 8
        Top = 112
        Width = 185
        Height = 25
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        Enabled = False
        TabOrder = 5
        OnClick = chtemplClick
      end
      object spreset: TListBox
        Left = 208
        Top = 50
        Width = 273
        Height = 159
        BevelOuter = bvNone
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        Sorted = True
        TabOrder = 0
        OnClick = Freshpreset
        OnKeyUp = spresetKeyUp
      end
      object assoc: TComboBox
        Left = 8
        Top = 48
        Width = 193
        Height = 21
        Style = csDropDownList
        Color = clWhite
        ItemHeight = 0
        TabOrder = 1
        OnChange = assocChange
        OnSelect = assocChange
      end
      object smask: TEdit
        Left = 8
        Top = 24
        Width = 473
        Height = 21
        Color = clWhite
        TabOrder = 2
        OnChange = smaskChange
      end
    end
    object TabSheet3: TTabSheet
      Caption = #1060#1080#1083#1100#1090#1088#1099
      ImageIndex = 2
      object Bevel1: TBevel
        Left = 8
        Top = 8
        Width = 233
        Height = 97
        Shape = bsFrame
      end
      object pust: TCheckBox
        Left = 8
        Top = 112
        Width = 169
        Height = 17
        Caption = #1048#1089#1082#1072#1090#1100' '#1090#1072#1082#1078#1077' '#1087#1091#1089#1090#1099#1077' '#1092#1072#1081#1083#1099
        TabOrder = 0
      end
      object tn: TCheckBox
        Left = 16
        Top = 16
        Width = 193
        Height = 25
        Caption = #1058#1086#1083#1100#1082#1086' '#1076#1086#1087#1091#1089#1090#1080#1084#1099#1077' '#1072#1090#1090#1088#1080#1073#1091#1090#1099':'
        TabOrder = 1
        OnClick = tnClick
      end
      object hid: TCheckBox
        Left = 16
        Top = 48
        Width = 73
        Height = 17
        Caption = #1057#1082#1088#1099#1090#1099#1081' '
        Enabled = False
        TabOrder = 2
        OnClick = roClick
      end
      object ro: TCheckBox
        Left = 16
        Top = 72
        Width = 97
        Height = 17
        Caption = #1058#1086#1083#1100#1082#1086' '#1095#1090#1077#1085#1080#1077
        Enabled = False
        TabOrder = 3
        OnClick = roClick
      end
      object arc: TCheckBox
        Left = 144
        Top = 72
        Width = 89
        Height = 17
        Caption = #1053#1086#1088#1084#1072#1083#1100#1085#1099#1081
        Checked = True
        Enabled = False
        State = cbChecked
        TabOrder = 4
        OnClick = roClick
      end
      object sys: TCheckBox
        Left = 144
        Top = 48
        Width = 81
        Height = 17
        Caption = #1057#1080#1089#1090#1077#1084#1085#1099#1081
        Enabled = False
        TabOrder = 5
        OnClick = roClick
      end
    end
    object TabSheet6: TTabSheet
      Caption = #1054#1087#1094#1080#1080
      ImageIndex = 5
      object opc: TPageControl
        Left = 0
        Top = 0
        Width = 490
        Height = 209
        ActivePage = TabSheet34
        Align = alClient
        MultiLine = True
        Style = tsButtons
        TabOrder = 0
        object TabSheet34: TTabSheet
          Caption = #1048#1085#1090#1077#1075#1088#1072#1094#1080#1103
          ImageIndex = 1
          object Label7: TLabel
            Left = 8
            Top = 136
            Width = 361
            Height = 13
            Caption = 
              #1064#1072#1073#1083#1086#1085' '#1076#1083#1103' '#1073#1099#1089#1090#1088#1086#1081' '#1086#1095#1080#1089#1090#1082#1080' ('#1082#1086#1085#1090#1077#1082#1089#1090#1085#1086#1077' '#1084#1077#1085#1102' '#1092#1072#1081#1083#1086#1074' '#1080' '#1082#1072#1090#1072#1083#1086#1075#1086#1074')' +
              ':'
          end
          object options: TCheckListBox
            Left = 8
            Top = 8
            Width = 473
            Height = 121
            OnClickCheck = optionsClickCheck
            Color = clWhite
            ItemHeight = 13
            Items.Strings = (
              #1071#1088#1083#1099#1082' '#1085#1072' '#1088#1072#1073#1086#1095#1077#1084' '#1089#1090#1086#1083#1077
              #1071#1088#1083#1099#1082' '#1074' '#1084#1077#1085#1102' '#1087#1091#1089#1082
              #1047#1072#1087#1086#1084#1085#1080#1090#1100' '#1087#1086#1083#1086#1078#1077#1085#1080#1077
              #1048#1085#1090#1077#1075#1088#1080#1088#1086#1074#1072#1090#1100' '#1074' '#1089#1080#1089#1090#1077#1084#1091
              #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1080#1079#1085#1072#1095#1072#1083#1100#1085#1091#1102' '#1091#1089#1090#1072#1085#1086#1074#1082#1091
              #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1096#1072#1073#1083#1086#1085#1099' '#1087#1086'-'#1091#1084#1086#1083#1095#1072#1085#1080#1102
              #1041#1077#1079#1086#1087#1072#1089#1085#1099#1081' '#1087#1086#1080#1089#1082': '#1087#1088#1086#1074#1077#1088#1103#1090#1100' '#1084#1072#1089#1082#1080' '#1085#1072' '#1087#1086#1090#1077#1085#1094#1080#1072#1083#1100#1091#1102' '#1086#1087#1072#1089#1085#1086#1089#1090#1100)
            TabOrder = 0
          end
          object qchk: TComboBox
            Left = 11
            Top = 152
            Width = 470
            Height = 21
            Style = csDropDownList
            Color = clWhite
            ItemHeight = 0
            TabOrder = 1
          end
        end
        object TabSheet33: TTabSheet
          Caption = #1041#1077#1079#1086#1087#1072#1089#1085#1099#1077' '#1090#1080#1087#1099
          object Label10: TLabel
            Left = 0
            Top = 16
            Width = 305
            Height = 13
            Caption = #1056#1072#1089#1089#1084#1072#1090#1088#1080#1074#1072#1090#1100' '#1089#1083#1077#1076#1091#1102#1097#1080#1077' '#1084#1072#1089#1082#1080' '#1092#1072#1081#1083#1086#1074' '#1082#1072#1082' '#1073#1077#1079#1086#1087#1072#1089#1085#1099#1077':'
          end
          object safe: TComboBox
            Left = 0
            Top = 32
            Width = 481
            Height = 21
            ItemHeight = 0
            TabOrder = 0
          end
          object safea: TButton
            Left = 0
            Top = 64
            Width = 75
            Height = 25
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100
            TabOrder = 1
            OnClick = safeaClick
          end
          object safed: TButton
            Left = 80
            Top = 64
            Width = 75
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100
            TabOrder = 2
            OnClick = safedClick
          end
          object safen: TComboBox
            Left = 304
            Top = 64
            Width = 177
            Height = 21
            Style = csDropDownList
            Color = clWhite
            ItemHeight = 0
            TabOrder = 3
            OnSelect = presetSelect
          end
          object addpr: TButton
            Left = 224
            Top = 64
            Width = 75
            Height = 25
            Caption = #1047#1072#1075#1086#1090#1086#1074#1082#1091
            TabOrder = 4
            OnClick = addprClick
          end
        end
      end
    end
    object TabSheet9: TTabSheet
      Caption = #1055#1072#1084#1103#1090#1100
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ImageIndex = 6
      ParentFont = False
      object Bevel10: TBevel
        Left = 224
        Top = 16
        Width = 257
        Height = 97
      end
      object memav: TLabel
        Left = 256
        Top = 48
        Width = 181
        Height = 19
        Caption = #1053#1077#1090' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1080'. '#1046#1076#1080#1090#1077'...'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
      end
      object upd: TLabel
        Left = 8
        Top = 123
        Width = 74
        Height = 15
        Caption = '0 '#1052#1041' '#1080#1079' 0 '#1052#1073
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
      end
      object clear: TButton
        Left = 8
        Top = 48
        Width = 121
        Height = 23
        Caption = #1054#1095#1080#1089#1090#1082#1072
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = clearClick
      end
      object proc: TStaticText
        Left = 141
        Top = 48
        Width = 68
        Height = 24
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = '1024 '#1052#1041
        TabOrder = 1
      end
      object barfree: TProgressBar
        Left = 8
        Top = 80
        Width = 201
        Height = 10
        TabOrder = 2
      end
      object sld: TScrollBar
        Left = 8
        Top = 96
        Width = 201
        Height = 16
        Max = 1500
        Min = 10
        PageSize = 0
        Position = 15
        TabOrder = 3
        OnChange = sldChange
      end
      object slider: TScrollBar
        Left = 8
        Top = 16
        Width = 201
        Height = 16
        Max = 20
        Min = 1
        PageSize = 0
        Position = 1
        TabOrder = 4
        OnChange = SliderChange
      end
    end
    object TabSheet10: TTabSheet
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
      ImageIndex = 7
      object obn: TButton
        Left = 8
        Top = 184
        Width = 105
        Height = 22
        Caption = #1054#1073#1085#1086#1074#1080#1090#1100
        TabOrder = 0
        OnClick = obnClick
      end
      object savenow: TButton
        Left = 120
        Top = 184
        Width = 105
        Height = 22
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        Enabled = False
        TabOrder = 1
        OnClick = Saveit
      end
      object otc: TMemo
        Left = 8
        Top = 8
        Width = 481
        Height = 169
        Color = clWhite
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Lucida Console'
        Font.Pitch = fpFixed
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 2
        WordWrap = False
      end
    end
    object TabSheet11: TTabSheet
      Caption = #1057#1080#1089#1090#1077#1084#1072
      ImageIndex = 8
      object pc3: TPageControl
        Left = 0
        Top = 0
        Width = 489
        Height = 209
        ActivePage = TabSheet14
        Style = tsButtons
        TabOrder = 0
        OnChange = pc3Change
        object TabSheet16: TTabSheet
          Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1080' '#1091#1076#1072#1083#1077#1085#1080#1077
          ImageIndex = 4
          object Bevel2: TBevel
            Left = 400
            Top = 72
            Width = 73
            Height = 33
            Shape = bsFrame
            Style = bsRaised
          end
          object installed: TListView
            Left = 0
            Top = 8
            Width = 393
            Height = 169
            Color = clWhite
            Columns = <
              item
                Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082
                MaxWidth = 350
                MinWidth = 150
                Width = 150
              end
              item
                Caption = #1048#1084#1103
                MaxWidth = 350
                MinWidth = 150
                Width = 150
              end
              item
                AutoSize = True
                Caption = #1055#1091#1090#1100
                MaxWidth = 350
                MinWidth = 150
              end>
            ColumnClick = False
            FlatScrollBars = True
            GridLines = True
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
          end
          object DelSoft: TButton
            Left = 400
            Top = 40
            Width = 75
            Height = 25
            Caption = #1059#1073#1088#1072#1090#1100
            TabOrder = 1
            OnClick = DelSoftClick
          end
          object RunSoft: TButton
            Left = 408
            Top = 80
            Width = 57
            Height = 17
            Caption = #1059#1076#1072#1083#1080#1090#1100
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 2
            OnClick = RunSoftClick
          end
          object RefSoft: TButton
            Left = 400
            Top = 8
            Width = 75
            Height = 25
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 3
            OnClick = RefSoftClick
          end
        end
        object TabSheet25: TTabSheet
          Caption = #1057#1080#1089#1090#1077#1084#1085#1099#1077' '#1087#1072#1087#1082#1080
          ImageIndex = 13
          object Bevel8: TBevel
            Left = 0
            Top = 0
            Width = 481
            Height = 169
          end
          object SysF: TListView
            Left = 8
            Top = 8
            Width = 393
            Height = 153
            Color = clWhite
            Columns = <
              item
                Caption = #1047#1072#1075#1086#1083#1086#1074#1086#1082
                MaxWidth = 350
                MinWidth = 150
                Width = 150
              end
              item
                AutoSize = True
                Caption = #1055#1091#1090#1100
                MaxWidth = 750
                MinWidth = 150
              end>
            ColumnClick = False
            FlatScrollBars = True
            GridLines = True
            HotTrack = True
            HotTrackStyles = [htHandPoint]
            RowSelect = True
            TabOrder = 0
            ViewStyle = vsReport
            OnDblClick = SysFDblClick
          end
          object SFR: TButton
            Left = 410
            Top = 9
            Width = 65
            Height = 25
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 1
            OnClick = SFRClick
          end
          object SFC: TButton
            Left = 410
            Top = 39
            Width = 65
            Height = 25
            Caption = #1048#1079#1084#1077#1085#1080#1090#1100
            TabOrder = 2
            OnClick = SFCClick
          end
        end
        object TabSheet23: TTabSheet
          Caption = 'OEM - '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
          ImageIndex = 11
          object oemlogo: TImage
            Left = 6
            Top = 2
            Width = 86
            Height = 86
            Center = True
            Stretch = True
          end
          object proiz: TEdit
            Left = 120
            Top = 6
            Width = 121
            Height = 21
            Color = clBtnFace
            TabOrder = 0
            Text = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          end
          object model: TEdit
            Left = 120
            Top = 30
            Width = 121
            Height = 21
            Color = clBtnFace
            TabOrder = 1
            Text = #1052#1086#1076#1077#1083#1100
          end
          object local: TEdit
            Left = 120
            Top = 56
            Width = 121
            Height = 21
            Color = clBtnFace
            TabOrder = 2
            Text = #1051#1086#1082#1072#1083#1100#1085#1072#1103' '#1089#1090#1088#1072#1085#1080#1094#1072
          end
          object site: TEdit
            Left = 118
            Top = 84
            Width = 121
            Height = 21
            Color = clBtnFace
            TabOrder = 3
            Text = #1057#1072#1081#1090' '#1087#1086#1076#1076#1077#1088#1078#1082#1080
          end
          object sinfo: TMemo
            Left = 250
            Top = 8
            Width = 219
            Height = 73
            Color = clWhite
            Lines.Strings = (
              #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103)
            TabOrder = 4
          end
          object apply: TButton
            Left = 252
            Top = 90
            Width = 103
            Height = 25
            Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
            Enabled = False
            TabOrder = 5
            OnClick = applyClick
          end
          object reset: TButton
            Left = 364
            Top = 90
            Width = 105
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100
            TabOrder = 6
            OnClick = resetClick
          end
          object change: TButton
            Left = 4
            Top = 92
            Width = 87
            Height = 25
            Caption = #1048#1079#1084#1077#1085#1080#1090#1100
            TabOrder = 7
            OnClick = changeClick
          end
        end
        object TabSheet28: TTabSheet
          Caption = #1058#1086#1085#1082#1072#1103' '#1085#1072#1089#1090#1088#1086#1081#1082#1072
          ImageIndex = 16
          object Label60: TLabel
            Left = 8
            Top = 160
            Width = 76
            Height = 13
            Caption = #1055#1086'-'#1059#1084#1086#1083#1095#1072#1085#1080#1102
          end
          object saveplug: TButton
            Left = 400
            Top = 104
            Width = 75
            Height = 25
            Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
            TabOrder = 0
            OnClick = saveplugClick
          end
          object refrplug: TButton
            Left = 400
            Top = 144
            Width = 75
            Height = 25
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 1
            OnClick = refrplugClick
          end
          object value: TEdit
            Left = 8
            Top = 112
            Width = 377
            Height = 21
            TabOrder = 2
            Visible = False
          end
          object defval: TEdit
            Left = 96
            Top = 152
            Width = 289
            Height = 21
            Color = clBtnFace
            ReadOnly = True
            TabOrder = 3
          end
          object cheats: TListBox
            Left = 0
            Top = 0
            Width = 449
            Height = 89
            BevelInner = bvLowered
            BevelOuter = bvRaised
            ItemHeight = 13
            TabOrder = 5
            OnClick = cheatsSelect
          end
          object radio: TRadioGroup
            Left = 0
            Top = 96
            Width = 393
            Height = 49
            Color = clBtnFace
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              #1044#1072
              #1053#1077#1090)
            ParentColor = False
            TabOrder = 4
            Visible = False
            OnClick = radioClick
          end
          object up: TSpinButton
            Left = 456
            Top = 0
            Width = 20
            Height = 89
            DownGlyph.Data = {
              0E010000424D0E01000000000000360000002800000009000000060000000100
              200000000000D800000000000000000000000000000000000000008080000080
              8000008080000080800000808000008080000080800000808000008080000080
              8000008080000080800000808000000000000080800000808000008080000080
              8000008080000080800000808000000000000000000000000000008080000080
              8000008080000080800000808000000000000000000000000000000000000000
              0000008080000080800000808000000000000000000000000000000000000000
              0000000000000000000000808000008080000080800000808000008080000080
              800000808000008080000080800000808000}
            TabOrder = 6
            UpGlyph.Data = {
              0E010000424D0E01000000000000360000002800000009000000060000000100
              200000000000D800000000000000000000000000000000000000008080000080
              8000008080000080800000808000008080000080800000808000008080000080
              8000000000000000000000000000000000000000000000000000000000000080
              8000008080000080800000000000000000000000000000000000000000000080
              8000008080000080800000808000008080000000000000000000000000000080
              8000008080000080800000808000008080000080800000808000000000000080
              8000008080000080800000808000008080000080800000808000008080000080
              800000808000008080000080800000808000}
            OnDownClick = upDownClick
            OnUpClick = upUpClick
          end
        end
        object TabSheet29: TTabSheet
          Caption = #1040#1074#1090#1086#1079#1072#1087#1091#1089#1082
          ImageIndex = 17
          object arref: TButton
            Left = 0
            Top = 152
            Width = 65
            Height = 25
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 0
            OnClick = arrefClick
          end
          object Button3: TButton
            Left = 88
            Top = 152
            Width = 65
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100
            TabOrder = 1
            OnClick = Button3Click
          end
          object autorun: TListBox
            Left = 0
            Top = 8
            Width = 473
            Height = 137
            Color = clWhite
            ItemHeight = 13
            TabOrder = 2
            OnDblClick = autorunClick
          end
          object Button4: TButton
            Left = 168
            Top = 152
            Width = 65
            Height = 25
            Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
            TabOrder = 3
            OnClick = Button4Click
          end
          object Button5: TButton
            Left = 248
            Top = 152
            Width = 65
            Height = 25
            Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
            TabOrder = 4
            OnClick = Button5Click
          end
          object aropt: TButton
            Left = 328
            Top = 152
            Width = 65
            Height = 25
            Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072
            TabOrder = 5
            OnClick = aroptClick
          end
          object addar: TButton
            Left = 408
            Top = 152
            Width = 65
            Height = 25
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100
            TabOrder = 6
            OnClick = addarClick
          end
        end
        object TabSheet8: TTabSheet
          Caption = #1057#1083#1091#1078#1073#1099
          ImageIndex = 15
          object SFresh: TButton
            Left = 416
            Top = 8
            Width = 65
            Height = 25
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 0
            OnClick = SFreshClick
          end
          object slist: TListBox
            Left = 0
            Top = 8
            Width = 409
            Height = 129
            Color = clWhite
            ItemHeight = 13
            PopupMenu = servpopup
            TabOrder = 1
            OnClick = slistClick
            OnDblClick = slistDblClick
          end
          object srun: TRadioGroup
            Left = 0
            Top = 144
            Width = 409
            Height = 33
            Caption = #1047#1072#1087#1091#1089#1082
            Columns = 3
            Items.Strings = (
              #1040#1074#1090#1086
              #1042#1088#1091#1095#1085#1091#1102
              #1054#1090#1082#1083#1102#1095#1077#1085#1086)
            TabOrder = 2
            OnClick = srunClick
          end
          object SApply: TButton
            Left = 416
            Top = 40
            Width = 65
            Height = 25
            Caption = #1048#1079#1084#1077#1085#1080#1090#1100
            TabOrder = 3
            OnClick = SApplyClick
          end
        end
        object TabSheet2: TTabSheet
          Caption = #1057#1083#1091#1078#1073#1099' Win9x'
          ImageIndex = 7
          object Serv9x: TListBox
            Left = 0
            Top = 8
            Width = 409
            Height = 169
            Color = clWhite
            ItemHeight = 13
            TabOrder = 0
            OnDblClick = Serv9xClick
          end
          object update9xserv: TButton
            Left = 416
            Top = 8
            Width = 65
            Height = 25
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 1
            OnClick = update9xservClick
          end
          object del9xserv: TButton
            Left = 416
            Top = 40
            Width = 65
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100
            TabOrder = 2
            OnClick = del9xservClick
          end
        end
        object TabSheet4: TTabSheet
          Caption = #1048#1089#1090#1086#1088#1080#1103
          ImageIndex = 14
          object Clr: TButton
            Left = 0
            Top = 144
            Width = 81
            Height = 25
            Caption = #1054#1095#1080#1089#1090#1080#1090#1100
            Font.Charset = RUSSIAN_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            OnClick = ClrClick
          end
          object ClearOpt: TCheckListBox
            Left = 0
            Top = 8
            Width = 481
            Height = 129
            OnClickCheck = ClearOptClickCheck
            Color = clWhite
            ItemHeight = 13
            Items.Strings = (
              #1050#1086#1088#1079#1080#1085#1072
              #1048#1089#1090#1086#1088#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
              #1050#1101#1096' Microsoft Internet Explorer'
              #1060#1072#1081#1083#1099' Temp - '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1080
              'Cookie, History'
              'Prefetch'
              #1048#1089#1090#1086#1088#1080#1103' Windows Media Player')
            TabOrder = 1
          end
        end
        object TabSheet12: TTabSheet
          Caption = 'Boot.ini'
          ImageIndex = 8
          object bid: TMemo
            Left = 0
            Top = 29
            Width = 481
            Height = 149
            Align = alClient
            Color = clWhite
            Font.Charset = OEM_CHARSET
            Font.Color = clWindowText
            Font.Height = -12
            Font.Name = 'Terminal'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
          end
          object ToolBar1: TToolBar
            Left = 0
            Top = 0
            Width = 481
            Height = 29
            ButtonHeight = 21
            ButtonWidth = 87
            Caption = 'ToolBar1'
            ShowCaptions = True
            TabOrder = 1
            Transparent = True
            object sbi: TToolButton
              Left = 0
              Top = 2
              Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
              ImageIndex = 0
              OnClick = sbiClick
            end
            object lbi: TToolButton
              Left = 87
              Top = 2
              Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
              ImageIndex = 1
              OnClick = lbiClick
            end
            object dlbi: TToolButton
              Left = 174
              Top = 2
              Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
              ImageIndex = 2
              OnClick = dlbiClick
            end
            object defbi: TToolButton
              Left = 261
              Top = 2
              Caption = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
              ImageIndex = 3
              OnClick = defbiClick
            end
          end
        end
        object TabSheet14: TTabSheet
          Caption = 'AutoExec.Bat'
          ImageIndex = 9
          object ToolBar2: TToolBar
            Left = 0
            Top = 0
            Width = 481
            Height = 29
            ButtonHeight = 21
            ButtonWidth = 60
            Caption = 'ToolBar1'
            ShowCaptions = True
            TabOrder = 0
            Transparent = True
            Wrapable = False
            object tb: TToolButton
              Left = 0
              Top = 2
              Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
              ImageIndex = 0
              OnClick = tbClick
            end
            object ToolButton2: TToolButton
              Left = 60
              Top = 2
              Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
              ImageIndex = 1
              OnClick = k
            end
            object autoab: TToolButton
              Left = 120
              Top = 2
              Caption = #1040#1074#1090#1086
              ImageIndex = 2
              OnClick = autoabClick
            end
            object abpreset: TComboBox
              Left = 180
              Top = 2
              Width = 300
              Height = 21
              Style = csDropDownList
              Color = clWhite
              ItemHeight = 0
              TabOrder = 0
              OnSelect = abpresetSelect
            end
          end
          object abat: TMemo
            Left = 0
            Top = 29
            Width = 481
            Height = 149
            Align = alClient
            Color = clWhite
            Font.Charset = OEM_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Terminal'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 1
          end
        end
        object TabSheet15: TTabSheet
          Caption = 'Config.Sys'
          ImageIndex = 10
          object ToolBar3: TToolBar
            Left = 0
            Top = 0
            Width = 481
            Height = 29
            ButtonHeight = 21
            ButtonWidth = 60
            Caption = 'ToolBar1'
            Color = clBtnFace
            ParentColor = False
            ShowCaptions = True
            TabOrder = 0
            Transparent = True
            Wrapable = False
            object ToolButton5: TToolButton
              Left = 0
              Top = 2
              Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
              ImageIndex = 0
              OnClick = ToolButton5Click
            end
            object ToolButton6: TToolButton
              Left = 60
              Top = 2
              Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
              ImageIndex = 1
              OnClick = ToolButton6Click
            end
            object csauto: TToolButton
              Left = 120
              Top = 2
              Caption = #1040#1074#1090#1086
              ImageIndex = 2
              OnClick = csautoClick
            end
            object cspreset: TComboBox
              Left = 180
              Top = 2
              Width = 300
              Height = 21
              Style = csDropDownList
              Color = clWhite
              ItemHeight = 0
              TabOrder = 0
              OnSelect = cspresetSelect
            end
          end
          object cos: TMemo
            Left = 0
            Top = 29
            Width = 481
            Height = 149
            Align = alClient
            Color = clWhite
            Font.Charset = OEM_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Terminal'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 1
          end
        end
        object TabSheet17: TTabSheet
          Caption = 'MSDOS.Sys'
          ImageIndex = 11
          object ToolBar4: TToolBar
            Left = 0
            Top = 0
            Width = 481
            Height = 29
            ButtonHeight = 21
            ButtonWidth = 60
            Caption = 'ToolBar1'
            ShowCaptions = True
            TabOrder = 0
            Transparent = True
            object ToolButton9: TToolButton
              Left = 0
              Top = 2
              Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
              ImageIndex = 0
              OnClick = ToolButton9Click
            end
            object ToolButton10: TToolButton
              Left = 60
              Top = 2
              Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
              ImageIndex = 1
              OnClick = ToolButton10Click
            end
            object msdauto: TToolButton
              Left = 120
              Top = 2
              Caption = #1040#1074#1090#1086
              ImageIndex = 2
              OnClick = msdautoClick
            end
            object msdpreset: TComboBox
              Left = 180
              Top = 2
              Width = 300
              Height = 21
              Style = csDropDownList
              Color = clWhite
              ItemHeight = 0
              TabOrder = 0
              OnSelect = msdpresetSelect
            end
          end
          object msd: TMemo
            Left = 0
            Top = 29
            Width = 481
            Height = 149
            Align = alClient
            Color = clWhite
            Font.Charset = OEM_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Terminal'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 1
          end
        end
        object TabSheet30: TTabSheet
          Caption = 'AutoExec.NT'
          ImageIndex = 16
          object ToolBar5: TToolBar
            Left = 0
            Top = 0
            Width = 481
            Height = 29
            ButtonHeight = 21
            ButtonWidth = 60
            Caption = 'ToolBar1'
            ShowCaptions = True
            TabOrder = 0
            Transparent = True
            Wrapable = False
            object ToolButton1: TToolButton
              Left = 0
              Top = 2
              Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
              ImageIndex = 0
              OnClick = ToolButton1Click
            end
            object ToolButton3: TToolButton
              Left = 60
              Top = 2
              Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
              ImageIndex = 1
              OnClick = ToolButton3Click
            end
            object ToolButton4: TToolButton
              Left = 120
              Top = 2
              Caption = #1040#1074#1090#1086
              ImageIndex = 2
              OnClick = ToolButton4Click
            end
            object abntpreset: TComboBox
              Left = 180
              Top = 2
              Width = 300
              Height = 21
              Style = csDropDownList
              Color = clWhite
              ItemHeight = 0
              TabOrder = 0
              OnSelect = abntpresetSelect
            end
          end
          object abnt: TMemo
            Left = 0
            Top = 29
            Width = 481
            Height = 149
            Align = alClient
            Color = clWhite
            Font.Charset = OEM_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Terminal'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 1
          end
        end
        object TabSheet31: TTabSheet
          Caption = 'Config.NT'
          ImageIndex = 17
          object ToolBar6: TToolBar
            Left = 0
            Top = 0
            Width = 481
            Height = 29
            ButtonHeight = 21
            ButtonWidth = 60
            Caption = 'ToolBar1'
            ShowCaptions = True
            TabOrder = 0
            Transparent = True
            Wrapable = False
            object ToolButton7: TToolButton
              Left = 0
              Top = 2
              Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
              ImageIndex = 0
              OnClick = ToolButton7Click
            end
            object ToolButton8: TToolButton
              Left = 60
              Top = 2
              Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
              ImageIndex = 1
              OnClick = ToolButton8Click
            end
            object ToolButton11: TToolButton
              Left = 120
              Top = 2
              Caption = #1040#1074#1090#1086
              ImageIndex = 2
              OnClick = ToolButton11Click
            end
            object csntpreset: TComboBox
              Left = 180
              Top = 2
              Width = 300
              Height = 21
              Style = csDropDownList
              Color = clWhite
              ItemHeight = 0
              TabOrder = 0
              OnSelect = csntpresetSelect
            end
          end
          object csnt: TMemo
            Left = 0
            Top = 29
            Width = 481
            Height = 149
            Align = alClient
            Color = clWhite
            Font.Charset = OEM_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Terminal'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssBoth
            TabOrder = 1
          end
        end
        object TabSheet18: TTabSheet
          Caption = #1058#1080#1087#1099' '#1092#1072#1081#1083#1086#1074
          ImageIndex = 12
          object typesref: TButton
            Left = 168
            Top = 152
            Width = 75
            Height = 20
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 0
            OnClick = gettypesClick
          end
          object stypes: TListBox
            Left = 0
            Top = 8
            Width = 481
            Height = 137
            Color = clWhite
            ItemHeight = 13
            TabOrder = 1
            OnDblClick = stypesClick
          end
          object Button6: TButton
            Left = 88
            Top = 152
            Width = 75
            Height = 20
            Caption = #1059#1076#1072#1083#1080#1090#1100
            TabOrder = 2
            OnClick = Button6Click
          end
          object setyp: TButton
            Left = 6
            Top = 152
            Width = 75
            Height = 20
            Caption = #1055#1086#1080#1089#1082
            TabOrder = 3
            OnClick = setypClick
          end
          object Button2: TButton
            Left = 248
            Top = 152
            Width = 75
            Height = 20
            Caption = #1044#1086#1073#1072#1074#1080#1090#1100
            TabOrder = 4
            OnClick = Button2Click
          end
          object alltypes: TCheckBox
            Left = 336
            Top = 152
            Width = 97
            Height = 17
            Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
            TabOrder = 5
            OnClick = alltypesClick
          end
        end
        object TabSheet24: TTabSheet
          Caption = #1054#1073#1097#1080#1081' '#1076#1086#1089#1090#1091#1087
          ImageIndex = 13
          object shared: TComboBox
            Left = 8
            Top = 8
            Width = 393
            Height = 21
            Style = csDropDownList
            Color = clWhite
            ItemHeight = 0
            TabOrder = 0
            OnSelect = sharedSelect
          end
          object rshared: TButton
            Left = 408
            Top = 8
            Width = 67
            Height = 25
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 1
            OnClick = rsharedClick
          end
          object dshared: TButton
            Left = 408
            Top = 72
            Width = 67
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100
            Enabled = False
            TabOrder = 2
            OnClick = dsharedClick
          end
          object nfo: TListBox
            Left = 8
            Top = 32
            Width = 393
            Height = 81
            Color = clWhite
            ItemHeight = 13
            TabOrder = 3
          end
          object sworks: TButton
            Left = 408
            Top = 40
            Width = 67
            Height = 25
            Caption = #1044#1077#1081#1089#1090#1074#1080#1103
            Enabled = False
            TabOrder = 4
            OnClick = sworksClick
          end
          object Panel2: TPanel
            Left = 0
            Top = 0
            Width = 401
            Height = 113
            TabOrder = 5
            Visible = False
            object Label5: TLabel
              Left = 152
              Top = 48
              Width = 90
              Height = 13
              Caption = #1055#1072#1088#1086#1083#1100' '#1085#1072' '#1095#1090#1077#1085#1080#1077
            end
            object Label6: TLabel
              Left = 152
              Top = 8
              Width = 131
              Height = 13
              Caption = #1055#1072#1088#1086#1083#1100' '#1085#1072' '#1087#1086#1083#1085#1099#1081' '#1076#1086#1089#1090#1091#1087
            end
            object Button7: TButton
              Left = 312
              Top = 72
              Width = 67
              Height = 25
              Caption = #1047#1072#1082#1088#1099#1090#1100
              TabOrder = 0
              OnClick = Button7Click
            end
            object sacc: TRadioGroup
              Left = 8
              Top = 8
              Width = 137
              Height = 97
              Caption = #1044#1086#1089#1090#1091#1087
              ItemIndex = 0
              Items.Strings = (
                #1063#1090#1077#1085#1080#1077
                #1055#1086#1083#1085#1099#1081
                #1047#1072#1074#1080#1089#1080#1090' '#1086#1090' '#1087#1072#1088#1086#1083#1103)
              TabOrder = 1
              OnClick = saccClick
            end
            object shidd: TCheckBox
              Left = 296
              Top = 24
              Width = 73
              Height = 17
              Caption = #1057#1082#1088#1099#1090#1099#1081
              TabOrder = 2
            end
            object sreadp: TEdit
              Left = 152
              Top = 64
              Width = 121
              Height = 21
              Color = clWhite
              Enabled = False
              MaxLength = 8
              TabOrder = 3
            end
            object sfullp: TEdit
              Left = 152
              Top = 24
              Width = 121
              Height = 21
              Color = clWhite
              Enabled = False
              MaxLength = 8
              TabOrder = 4
            end
            object spers: TCheckBox
              Left = 296
              Top = 48
              Width = 89
              Height = 17
              Caption = #1055#1086#1089#1090#1086#1103#1085#1085#1099#1081
              TabOrder = 5
            end
          end
        end
        object TabSheet26: TTabSheet
          Caption = #1056#1072#1089#1082#1083#1072#1076#1082#1080
          ImageIndex = 14
          object layouts: TListBox
            Left = 0
            Top = 8
            Width = 393
            Height = 169
            Color = clWhite
            ItemHeight = 13
            TabOrder = 0
          end
          object lrefr: TButton
            Left = 400
            Top = 8
            Width = 75
            Height = 25
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 1
            OnClick = lrefrClick
          end
          object ldelete: TButton
            Left = 400
            Top = 40
            Width = 75
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100
            TabOrder = 2
            OnClick = ldeleteClick
          end
        end
        object TabSheet27: TTabSheet
          Caption = #1063#1072#1089#1086#1074#1099#1077' '#1087#1086#1103#1089#1072
          ImageIndex = 15
          object times: TListBox
            Left = 0
            Top = 8
            Width = 393
            Height = 169
            Color = clWhite
            ItemHeight = 13
            TabOrder = 0
          end
          object trefr: TButton
            Left = 400
            Top = 8
            Width = 75
            Height = 25
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 1
            OnClick = trefrClick
          end
          object tdelete: TButton
            Left = 400
            Top = 40
            Width = 75
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100
            TabOrder = 2
            OnClick = tdeleteClick
          end
        end
        object TabSheet32: TTabSheet
          Caption = #1047#1072#1087#1080#1089#1080' '#1087#1088#1086#1075#1088#1072#1084#1084' '#1074' '#1088#1077#1077#1089#1090#1088#1077
          ImageIndex = 18
          object Software: TListBox
            Left = 0
            Top = 8
            Width = 393
            Height = 169
            Color = clWhite
            ItemHeight = 13
            TabOrder = 0
          end
          object refs: TButton
            Left = 400
            Top = 8
            Width = 75
            Height = 25
            Caption = #1054#1073#1085#1086#1074#1080#1090#1100
            TabOrder = 1
            OnClick = refsClick
          end
          object dels: TButton
            Left = 400
            Top = 40
            Width = 75
            Height = 25
            Caption = #1059#1076#1072#1083#1080#1090#1100
            TabOrder = 2
            OnClick = delsClick
          end
        end
        object TabSheet35: TTabSheet
          Caption = #1056#1072#1079#1085#1086#1077
          ImageIndex = 19
          object Button1: TButton
            Left = 8
            Top = 8
            Width = 265
            Height = 25
            Caption = #1055#1077#1088#1077#1089#1090#1088#1086#1080#1090#1100' '#1089#1080#1089#1090#1077#1084#1085#1099#1077' '#1080#1082#1086#1085#1082#1080
            TabOrder = 0
            OnClick = Button1Click
          end
          object setw: TButton
            Left = 8
            Top = 72
            Width = 265
            Height = 25
            Caption = #1055#1088#1077#1086#1073#1088#1072#1079#1086#1074#1072#1090#1100' '#1082#1072#1088#1090#1080#1085#1082#1091' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1089#1090#1086#1083#1072' '#1074' bmp'
            Enabled = False
            TabOrder = 1
            OnClick = setwClick
          end
          object fixfonts: TButton
            Left = 8
            Top = 40
            Width = 265
            Height = 25
            Caption = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1086#1090#1086#1073#1088#1072#1078#1077#1085#1080#1077' '#1088#1091#1089#1089#1082#1080#1093' '#1096#1088#1080#1092#1090#1086#1074
            TabOrder = 2
            OnClick = fixfontsClick
          end
        end
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Web - '#1080#1085#1090#1077#1088#1092#1077#1081#1089
      ImageIndex = 7
      object GroupBox1: TGroupBox
        Left = 8
        Top = 8
        Width = 201
        Height = 113
        Caption = #1043#1083#1072#1074#1085#1086#1077
        TabOrder = 2
        object Label1: TLabel
          Left = 18
          Top = 66
          Width = 28
          Height = 13
          HelpType = htKeyword
          Caption = #1055#1086#1088#1090':'
        end
      end
      object acActivate: TCheckBox
        Left = 24
        Top = 32
        Width = 169
        Height = 17
        Caption = #1042#1082#1083#1102#1095#1080#1090#1100' Web-'#1091#1087#1088#1072#1074#1083#1077#1085#1080#1077
        TabOrder = 0
        OnClick = acActivateExecute
      end
      object edPort: TEdit
        Left = 64
        Top = 72
        Width = 41
        Height = 21
        TabOrder = 1
        Text = '16305'
        OnClick = edPortChange
        OnExit = edPortExit
      end
    end
    object TabSheet13: TTabSheet
      Caption = #1057#1087#1088#1072#1074#1082#1072
      ImageIndex = 8
      object gosite: TLabel
        Left = 280
        Top = 192
        Width = 196
        Height = 13
        Cursor = crHandPoint
        Caption = #1054#1092#1080#1094#1080#1072#1083#1100#1085#1099#1081' '#1089#1072#1081#1090' DarkSoftware'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        OnClick = gettClick
        OnMouseEnter = Label2MouseEnter
        OnMouseLeave = Label2MouseLeave
      end
      object Label2: TLabel
        Left = 16
        Top = 191
        Width = 154
        Height = 13
        Cursor = crHandPoint
        Caption = #1044#1080#1089#1082#1080' '#1087#1086#1095#1090#1086#1081' - 50 '#1088#1091#1073#1083#1077#1081
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold, fsUnderline]
        ParentFont = False
        OnClick = Button8Click
        OnMouseEnter = Label2MouseEnter
        OnMouseLeave = Label2MouseLeave
      end
      object Label4: TLabel
        Left = 136
        Top = 0
        Width = 212
        Height = 80
        Cursor = crHandPoint
        Caption = 'F. - D. - K.'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clYellow
        Font.Height = -64
        Font.Name = 'Impact'
        Font.Style = []
        ParentFont = False
        Transparent = True
        OnClick = Label4Click
      end
      object Label25: TLabel
        Left = 16
        Top = 82
        Width = 453
        Height = 24
        Alignment = taCenter
        AutoSize = False
        Caption = #1057#1080#1089#1090#1077#1084#1072' '#1087#1088#1086#1092#1077#1089#1089#1080#1086#1085#1072#1083#1100#1085#1086#1081' '#1086#1087#1090#1080#1084#1080#1079#1072#1094#1080#1080' '#1055#1050
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Pitch = fpVariable
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
        OnMouseEnter = Label25MouseEnter
        OnMouseLeave = Label25MouseLeave
      end
      object Label8: TLabel
        Left = 16
        Top = 122
        Width = 453
        Height = 24
        Alignment = taCenter
        AutoSize = False
        Caption = #1055#1086#1089#1074#1103#1097#1072#1077#1090#1089#1103' '#1083#1102#1073#1080#1084#1086#1081' '#1052'.'#1042'.'#1064'.'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'MS Sans Serif'
        Font.Pitch = fpVariable
        Font.Style = [fsBold]
        ParentFont = False
        WordWrap = True
        OnMouseEnter = Label25MouseEnter
        OnMouseLeave = Label25MouseLeave
      end
      object Label9: TLabel
        Left = 133
        Top = 1
        Width = 212
        Height = 80
        Cursor = crHandPoint
        Caption = 'F. - D. - K.'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -64
        Font.Name = 'Impact'
        Font.Style = []
        ParentFont = False
        Transparent = True
        OnClick = Label4Click
        OnMouseEnter = Label25MouseEnter
        OnMouseLeave = Label25MouseLeave
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 264
    Width = 498
    Height = 65
    Align = alBottom
    BorderStyle = bsSingle
    TabOrder = 0
    object allfiles: TGauge
      Left = 320
      Top = 32
      Width = 161
      Height = 20
      BackColor = clBtnFace
      ForeColor = clWhite
      MaxValue = 0
      Progress = 0
    end
    object curpath: TStaticText
      Left = 8
      Top = 8
      Width = 481
      Height = 17
      AutoSize = False
      BorderStyle = sbsSunken
      Caption = #1053#1072#1078#1084#1080#1090#1077' '#1055#1086#1080#1089#1082' '#1076#1083#1103' '#1085#1072#1095#1072#1083#1072' '#1087#1086#1080#1089#1082#1072
      TabOrder = 0
    end
    object total: TStaticText
      Left = 8
      Top = 32
      Width = 145
      Height = 17
      AutoSize = False
      BorderStyle = sbsSunken
      Caption = #1060#1072#1081#1083#1099' '#1085#1077' '#1085#1072#1081#1076#1077#1085#1099
      TabOrder = 1
    end
    object found: TStaticText
      Left = 160
      Top = 32
      Width = 145
      Height = 17
      AutoSize = False
      BorderStyle = sbsSunken
      Caption = '0'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 2
    end
  end
  object gobox: TComboBox
    Left = 0
    Top = 0
    Width = 497
    Height = 21
    Style = csDropDownList
    Color = clBtnFace
    ItemHeight = 13
    TabOrder = 3
    OnSelect = goboxSelect
  end
  object debug: TPanel
    Left = 440
    Top = 328
    Width = 50
    Height = 50
    TabOrder = 2
    Visible = False
    object Memo: TMemo
      Left = 1
      Top = 1
      Width = 48
      Height = 48
      Align = alClient
      BevelInner = bvNone
      BevelOuter = bvNone
      Color = clNavy
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clSilver
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object cool: TDarkThreadTimer
    OnTimer = coolTimer
    Enabled = False
    Interval = 1500
    ThreadPriority = tpNormal
    Left = 298
    Top = 408
  end
  object refr: TDarkThreadTimer
    OnTimer = Timer1Timer
    Enabled = False
    Interval = 1000
    ThreadPriority = tpNormal
    Left = 332
    Top = 408
  end
  object SaveDialog: TSaveDialog
    Options = [ofHideReadOnly, ofEnableSizing, ofDontAddToRecent, ofForceShowHidden]
    Left = 206
    Top = 406
  end
  object opd: TOpenPictureDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 402
    Top = 410
  end
  object OpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing]
    Left = 432
    Top = 408
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 264
    Top = 408
    object N1: TMenuItem
      Caption = #1057#1074#1086#1081#1089#1090#1074#1072
      OnClick = N1Click
    end
    object N6: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100
      OnClick = N6Click
    end
  end
  object servpopup: TPopupMenu
    OnPopup = servpopupPopup
    Left = 392
    Top = 312
    object sstart: TMenuItem
      Caption = #1057#1090#1072#1088#1090
      OnClick = sstartClick
    end
    object sstop: TMenuItem
      Caption = #1057#1090#1086#1087
      OnClick = sstopClick
    end
    object spause: TMenuItem
      Caption = #1055#1072#1091#1079#1072
      OnClick = spauseClick
    end
    object sresume: TMenuItem
      Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100
      OnClick = sresumeClick
    end
  end
  object HTTPServer: TIdHTTPServer
    Bindings = <>
    DefaultPort = 16305
    MaxConnections = 1
    TerminateWaitTime = 20000
    ServerSoftware = 'FDK Simple Webserver v0.1a'
    SessionTimeOut = 1200000
    OnCommandGet = HTTPServerCommandGet
    Left = 344
    Top = 312
  end
  object armenu: TPopupMenu
    Left = 432
    Top = 328
    object N7: TMenuItem
      Caption = #1053#1072#1081#1090#1080' '#1080' '#1091#1076#1072#1083#1080#1090#1100' '#1085#1077#1078#1077#1083#1072#1090#1077#1083#1100#1085#1099#1077' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      OnClick = N7Click
    end
    object N8: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1086#1089#1090#1086#1103#1085#1080#1077
      OnClick = N8Click
    end
    object N9: TMenuItem
      Caption = #1053#1072#1081#1090#1080' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
      OnClick = N9Click
    end
  end
  object spopup: TPopupMenu
    Left = 312
    Top = 320
    object N14: TMenuItem
      Caption = #1057#1084#1077#1085#1080#1090#1100' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080
      OnClick = N14Click
    end
    object N15: TMenuItem
      Caption = #1057#1084#1077#1085#1080#1090#1100' '#1087#1091#1090#1100
      OnClick = N15Click
    end
    object N11: TMenuItem
      Caption = #1057#1084#1077#1085#1080#1090#1100' '#1076#1086#1089#1090#1091#1087
      OnClick = N11Click
    end
  end
end
