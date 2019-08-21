object LoginForm: TLoginForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'MySQL Server Connect'
  ClientHeight = 225
  ClientWidth = 242
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object LabeledEdit1: TLabeledEdit
    Left = 24
    Top = 101
    Width = 193
    Height = 21
    EditLabel.Width = 22
    EditLabel.Height = 13
    EditLabel.Caption = 'User'
    TabOrder = 0
    Text = 'root'
  end
  object LabeledEdit2: TLabeledEdit
    Left = 24
    Top = 142
    Width = 193
    Height = 21
    EditLabel.Width = 46
    EditLabel.Height = 13
    EditLabel.Caption = 'Password'
    PasswordChar = '*'
    TabOrder = 1
    Text = '1qaZXsw2'
  end
  object Button1: TButton
    Left = 24
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Connect'
    ModalResult = 1
    TabOrder = 2
  end
  object Button2: TButton
    Left = 142
    Top = 184
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object LabeledEdit3: TLabeledEdit
    Left = 24
    Top = 20
    Width = 193
    Height = 21
    EditLabel.Width = 32
    EditLabel.Height = 13
    EditLabel.Caption = 'Server'
    TabOrder = 4
    Text = 'localhost'
  end
  object LabeledEdit4: TLabeledEdit
    Left = 24
    Top = 60
    Width = 65
    Height = 21
    EditLabel.Width = 20
    EditLabel.Height = 13
    EditLabel.Caption = 'Port'
    TabOrder = 5
    Text = '3306'
  end
end
