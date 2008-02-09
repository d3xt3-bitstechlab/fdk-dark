object View: TView
  Left = 244
  Top = 291
  Width = 561
  Height = 189
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1085#1072#1081#1076#1077#1085#1086#1075#1086
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object ListViewF: TListView
    Left = 0
    Top = 23
    Width = 553
    Height = 120
    Align = alClient
    BevelInner = bvLowered
    BevelOuter = bvRaised
    Checkboxes = True
    Color = clWhite
    Columns = <
      item
        Caption = #1048#1084#1103
        MinWidth = 140
        Width = 300
      end
      item
        Caption = #1056#1072#1079#1084#1077#1088
        Width = 80
      end
      item
        Caption = #1044#1072#1090#1072
        Width = 80
      end>
    ColumnClick = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    FlatScrollBars = True
    GridLines = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 1
    ViewStyle = vsReport
    OnClick = ListViewFClick
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 553
    Height = 23
    AutoSize = True
    ButtonHeight = 21
    ButtonWidth = 44
    Caption = 'ToolBar1'
    Flat = True
    Menu = MainMenu1
    ShowCaptions = True
    TabOrder = 0
    Transparent = False
    Wrapable = False
  end
  object sb: TStatusBar
    Left = 0
    Top = 143
    Width = 553
    Height = 19
    Panels = <>
    ParentShowHint = False
    ShowHint = False
    SimplePanel = True
  end
  object Poisk: TPanel
    Left = 96
    Top = 504
    Width = 681
    Height = 115
    BevelInner = bvLowered
    BevelWidth = 2
    BorderStyle = bsSingle
    Caption = #1055#1088#1086#1076#1086#1083#1078#1072#1077#1090#1089#1103' '#1087#1086#1080#1089#1082'....'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    Visible = False
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
    object N12: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = N12Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object N8: TMenuItem
      Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1089#1077
      OnClick = challClick
    end
    object N9: TMenuItem
      Caption = #1057#1085#1103#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1080#1077
      OnClick = dchallClick
    end
    object N10: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1086#1090#1084#1077#1095#1077#1085#1085#1099#1077
      OnClick = delfClick
    end
    object N11: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077
      OnClick = allfClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 168
    Top = 72
    object N2: TMenuItem
      Caption = #1060#1072#1081#1083#1099
      object delf: TMenuItem
        Caption = #1059#1076#1072#1083#1080#1090#1100
        OnClick = delfClick
      end
      object allf: TMenuItem
        Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077
        OnClick = allfClick
      end
    end
    object N3: TMenuItem
      Caption = #1055#1086#1080#1089#1082
      object findf: TMenuItem
        Caption = #1053#1072#1081#1090#1080
        OnClick = findfClick
      end
      object self: TMenuItem
        Caption = #1054#1090#1084#1077#1090#1080#1090#1100
        OnClick = selfClick
      end
    end
    object N4: TMenuItem
      Caption = #1050#1083#1086#1085#1099
      object cl: TMenuItem
        Caption = #1055#1086#1080#1089#1082
        OnClick = clClick
      end
      object stopcl: TMenuItem
        Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1086#1080#1089#1082
        Enabled = False
        OnClick = stopclClick
      end
    end
    object N5: TMenuItem
      Caption = #1057#1087#1080#1089#1086#1082
      object savefl: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        OnClick = saveflClick
      end
      object loadfl: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
        OnClick = loadflClick
      end
      object addfl: TMenuItem
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        OnClick = addflClick
      end
      object clrfl: TMenuItem
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        OnClick = clrflClick
      end
      object delsel: TMenuItem
        Caption = #1059#1073#1088#1072#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1077
        OnClick = delselClick
      end
      object chall: TMenuItem
        Caption = #1054#1090#1084#1077#1090#1080#1090#1100' '#1074#1089#1077
        OnClick = challClick
      end
      object dchall: TMenuItem
        Caption = #1057#1085#1103#1090#1100' '#1086#1090#1084#1077#1090#1082#1091
        OnClick = dchallClick
      end
    end
  end
end
