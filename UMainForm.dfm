object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Parser'
  ClientHeight = 521
  ClientWidth = 771
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 502
    Width = 771
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 50
      end>
  end
  object ControlPanel: TPanel
    Left = 0
    Top = 0
    Width = 771
    Height = 57
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 6447714
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 25
      Top = 21
      Width = 94
      Height = 16
      Caption = 'Period (hours)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object StartBtn: TButton
      Left = 216
      Top = 17
      Width = 96
      Height = 26
      Caption = 'Update Now'
      TabOrder = 0
      OnClick = StartBtnClick
    end
    object UpDown1: TUpDown
      Left = 161
      Top = 17
      Width = 16
      Height = 24
      Associate = Edit1
      Min = 1
      Max = 24
      Position = 1
      TabOrder = 1
      OnChangingEx = UpDown1ChangingEx
    end
    object TimePanel: TPanel
      Left = 374
      Top = 5
      Width = 235
      Height = 46
      BorderStyle = bsSingle
      Caption = '00:00:00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object Edit1: TEdit
      Left = 128
      Top = 17
      Width = 33
      Height = 24
      Alignment = taCenter
      Color = clSilver
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 6447714
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
      Text = '1'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 369
    Width = 771
    Height = 133
    Align = alBottom
    Caption = 'Panel2'
    TabOrder = 2
    object LogMemo: TMemo
      Left = 1
      Top = 1
      Width = 769
      Height = 131
      Align = alClient
      Color = 2372380
      Font.Charset = ANSI_CHARSET
      Font.Color = clLime
      Font.Height = -12
      Font.Name = 'Century Gothic'
      Font.Style = [fsBold]
      Lines.Strings = (
        'LogMemo')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
      StyleElements = []
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 57
    Width = 771
    Height = 312
    Align = alClient
    TabOrder = 3
    object DBGrid1: TDBGrid
      Left = 1
      Top = 1
      Width = 200
      Height = 310
      Align = alLeft
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = DBGrid1CellClick
      Columns = <
        item
          Expanded = False
          FieldName = 'name'
          ReadOnly = True
          Title.Alignment = taCenter
          Title.Caption = 'Lottery'
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Width = 200
          Visible = True
        end>
    end
    object DBGrid2: TDBGrid
      Left = 201
      Top = 1
      Width = 569
      Height = 310
      Align = alClient
      DataSource = DataSource2
      Enabled = False
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Alignment = taRightJustify
          Expanded = False
          FieldName = 'Date'
          ReadOnly = True
          Title.Alignment = taCenter
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Width = 100
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'Draw'
          ReadOnly = True
          Title.Alignment = taCenter
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Visible = True
        end
        item
          Alignment = taCenter
          Color = 16777170
          Expanded = False
          FieldName = 'Results'
          ReadOnly = True
          Title.Alignment = taCenter
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Winner'
          ReadOnly = True
          Title.Alignment = taCenter
          Title.Font.Charset = DEFAULT_CHARSET
          Title.Font.Color = clWindowText
          Title.Font.Height = -11
          Title.Font.Name = 'Tahoma'
          Title.Font.Style = [fsBold]
          Width = 100
          Visible = True
        end>
    end
  end
  object ProgressBar1: TProgressBar
    Left = 8
    Top = 496
    Width = 119
    Height = 17
    Position = 100
    TabOrder = 4
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=MSDASQL.1;Password="";Persist Security Info=True;User I' +
      'D=root;Data Source=ozlotto'
    LoginPrompt = False
    Provider = 'MSDASQL.1'
    Left = 640
    Top = 16
  end
  object ADOTable1: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    TableDirect = True
    TableName = 'lotto_names'
    Left = 48
    Top = 152
  end
  object DataSource1: TDataSource
    DataSet = ADOTable1
    Enabled = False
    Left = 48
    Top = 104
  end
  object DataSource2: TDataSource
    DataSet = ADOTable2
    Enabled = False
    Left = 248
    Top = 112
  end
  object ADOTable2: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    LockType = ltReadOnly
    Left = 248
    Top = 160
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 712
    Top = 16
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 384
    Top = 16
  end
end
