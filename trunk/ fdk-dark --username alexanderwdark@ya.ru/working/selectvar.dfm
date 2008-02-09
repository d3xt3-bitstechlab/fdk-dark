object selectelement: Tselectelement
  Left = 327
  Top = 295
  Width = 232
  Height = 171
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 72
    Top = 112
    Width = 75
    Height = 25
    Caption = #1054#1050
    ModalResult = 1
    TabOrder = 0
  end
  object element: TComboBox
    Left = 8
    Top = 80
    Width = 209
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
  object Memo: TMemo
    Left = 8
    Top = 8
    Width = 209
    Height = 57
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
  end
end
