unit UMainForm;

{$define ONLINE}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.ComCtrls, Vcl.StdCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, IdSSL, IdSSLOpenSSL,
  Vcl.ExtCtrls, Vcl.OleCtrls, SHDocVw, MSHTML, ActiveX, UrlMon, IdCookieManager,
  IdZLibCompressorBase, IdCompressorZLib, IdIOHandler, IdIOHandlerSocket,
  IdIOHandlerStack, Data.Win.ADODB, Vcl.DBGrids, Data.DB,
  MyDacVcl, MyAccess, MemDS, DBAccess;

type

  TLotteryEvent = Record
    Name : string;
    Date : string;
    Draw : integer;
    Results : string;
    Winner : string;
  End;

  TMainForm = class(TForm)
    StatusBar1: TStatusBar;
    ControlPanel: TPanel;
    StartBtn: TButton;
    Panel2: TPanel;
    LogMemo: TMemo;
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    DBGrid2: TDBGrid;
    UpDown1: TUpDown;
    Label1: TLabel;
    TimePanel: TPanel;
    Timer1: TTimer;
    Edit1: TEdit;
    ProgressBar1: TProgressBar;
    MyConnection1: TMyConnection;
    MyQuery1: TMyQuery;
    MyTable1: TMyTable;
    MyTable2: TMyTable;
    MyConnectDialog1: TMyConnectDialog;
    procedure FormCreate(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure Timer1Timer(Sender: TObject);
    procedure UpDown1ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Integer; Direction: TUpDownDirection);
  private
    { Private declarations }
    LottoNames : TStringList;
    CountDown : integer;

    function DownloadFile(SourceFile, DestFile: string): Boolean; // Download site data to the temporary file
    procedure LoadLottoNames; // Get names of lotteries from DB
    function IsNameExist(sname : string) : boolean; // Check for a new lottery name
    procedure AppendLottoName(sname : string); // Append a new lottery name to list and DB
    procedure UpdateLottoTable(le : TLotteryEvent); // Create DB table if not exist
    function DataUpdate : boolean; // Update information from site
    function ParseSite(sbody : TStringList) : boolean; // Parse site structure
    procedure ParseEventBlock(root : IHTMLElement); // Extract information about lottery draw
    function ExtractLottoName(divEl : IHTMLElement) : string; // Processing site part with a lottery logo
    function ExtractLottoDate(divEl : IHTMLElement ) : string;  // Processing site part with a draw date
    function ExtractLottoDraw(divEl : IHTMLElement ) : string;  // Processing site part with a draw number
    function ExtractLottoResults(divEl : IHTMLElement ) : string; // Processing site part with lottery results and winner name

  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  sServer : string;
  sPort : string;
  sUser : string;
  sPswd : string;

implementation

{$R *.dfm}

//------------------------------------------------------------------------------
procedure TMainForm.LoadLottoNames;
begin
  try
    MyQuery1.SQL.Clear;
    MyQuery1.SQL.Add('CREATE TABLE IF NOT EXISTS lotto_names(id MEDIUMINT NOT NULL AUTO_INCREMENT, name VARCHAR(50) NOT NULL, PRIMARY KEY(id))');
    MyQuery1.ExecSQL;
  finally
    MyTable1.TableName:='lotto_names';
    MyTable1.Active:=true;
    if MyTable1.RecordCount > 0 then begin
      MyTable1.First;
      while not MyTable1.Eof do begin
        LottoNames.Add(MyTable1.FieldByName('name').AsString);
        MyTable1.Next;
      end;
    end;
    DataSource1.Enabled:=true;
  end;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
procedure TMainForm.AppendLottoName(sname : string);
begin
  LottoNames.Append(sname);
  with MyTable1 do begin
    try
      Active:=true;
      Insert;
      FieldByName('name').AsString  :=sname;
      Post;
    finally
      Active:=true;
    end;
  end;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
procedure TMainForm.UpdateLottoTable(le : TLotteryEvent);
begin
  try
    MyQuery1.SQL.Clear;
    MyQuery1.SQL.Add('CREATE TABLE IF NOT EXISTS '+le.Name+'(Date VARCHAR(20), Draw int(10), Results VARCHAR(50), Winner VARCHAR(50), UNIQUE(Draw))');
    MyQuery1.ExecSQL;
  finally
    MyQuery1.SQL.Clear;
    MyQuery1.SQL.Add('INSERT INTO `'+le.Name+'`(`Date`,`Draw`,`Results`,`Winner`) VALUES (');
    MyQuery1.SQL.Add(''''+le.Date+''','+IntToStr(le.Draw)+','''+le.Results+''','''+le.Winner+''')');
    MyQuery1.SQL.Add(' ON DUPLICATE KEY UPDATE Date='''+le.Date+''', Results='''+le.Results+''', Winner='''+le.Winner+'''');
    MyQuery1.ExecSQL;
  end;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
procedure TMainForm.UpDown1ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Integer;
  Direction: TUpDownDirection);
var hh, md, rs : integer;
begin
  if (NewValue < UpDown1.Min) or (NewValue > UpDown1.Max) then
    exit;
  rs:=NewValue-StrToInt(Edit1.Text);
  hh:=(CountDown div 3600)+rs;
  md:=CountDown mod 3600;
  CountDown:=hh*3600 + md;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
function TMainForm.DownloadFile(SourceFile, DestFile: string): Boolean;
var s : string;
begin
  try
  s:='Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.84 Safari/537.36 OPR/38.0.2220.31';
  if UrlMkSetSessionOption(URLMON_OPTION_USERAGENT, @s[1], Length(s), 0)<>S_OK then raise Exception.Create('Oops');
  Result := UrlDownloadToFile(nil, PChar(SourceFile), PChar(DestFile), 0, nil) = 0;
  except
    Result := False;
  end;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
function TMainForm.IsNameExist(sname : string) : boolean;
var i : ShortInt;
begin
  Result:=false;
  if LottoNames.Count>0 then begin
    for i := 0 to LottoNames.Count-1 do begin
      if LottoNames[i] = sname then begin
        Result:=true;
        exit;
      end;
    end;
  end;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
function TMainForm.ExtractLottoName(divEl : IHTMLElement) : string;
var
  logo: string;
  ps,len: integer;
begin
  logo:=divEl.getAttribute('className',0);
  ps:=ansipos('is-',logo)+3;
  len:=ansipos('css',logo)-ps-1;
  logo:=copy(logo,ps,len);
  Result:=logo;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
function TMainForm.ExtractLottoDate(divEl : IHTMLElement ) : string;
var
  ps : integer;
  str : string;
begin
  str:=divEl.innerText;
  ps:=pos('Draw',str);
  Result:=str.Remove(ps-1);
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
function TMainForm.ExtractLottoDraw(divEl : IHTMLElement ) : string;
var
  ps : integer;
  str : string;
begin
  str:=divEl.innerText;
  ps:=pos('Draw',str)+4;
  delete(str,1,ps);
  Result:=str;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
function TMainForm.ExtractLottoResults(divEl : IHTMLElement ) : string;
var
  yg1, yg2, qx200 : IHTMLElementCollection;
  elem1, elem2, elem3 : IHTMLElement;
  str : string;
  i, j, z: Integer;
begin
  Result:='';
  yg1:=(divEl.children as IHTMLElementCollection).tags('div') as IHTMLElementCollection;
  if yg1.length > 0  then begin
    for i := 0 to Pred(yg1.length) do begin
      elem1:=yg1.item(i,0) as IHTMLElement;
      str:= elem1.getAttribute('className',0);
      if not VarIsNull(str) then begin
        if System.Pos('e1l90eyg2',str)>0 then begin
          yg2:=(elem1.children  as IHTMLElementCollection).tags('div')  as IHTMLElementCollection;
          if yg2.length > 0 then begin
            for j := 0 to Pred(yg2.length) do begin
              elem2:=yg2.item(j,0) as IHTMLElement;
              str:=elem2.getAttribute('className',0);
              if not VarIsNull(str) then begin
                if System.Pos('e1lkqx200',str) > 0 then begin
                  qx200:=(elem2.children as IHTMLElementCollection);
                  if qx200.length > 0 then begin
                    for z := 0 to Pred(qx200.length) do begin
                      elem3:=qx200.item(z,0) as IHTMLElement;
                      str:=elem3.innerText;
                      if Result.Length>0 then
                        Result:=Result+' ';
                      Result:=Result+str;
                    end;
                  end;
                end;
              end;
            end;
          end;
        end
        else if System.Pos('e1l90eyg3',str)>0 then begin  // Draw Winner`s tag for some lotteries
          Result:=' '+elem1.innerText;
        end;
      end;
    end;
  end;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
function TMainForm.DataUpdate : boolean;
var StrURL, sFileName : string;
    htmlBody : TStringList;
begin
  Result:=false;

  StrURL := 'http://www.ozlotteries.com/lotto-results#';

  Timer1.Enabled:=false;
  LogMemo.Lines.Append('Download site...');

  sFileName := ExtractFilePath(Application.ExeName) + 'cache.txt';
  htmlBody:=TStringList.Create;

  {$IFDEF ONLINE}
  if DownloadFile(StrURL,sFileName) then
  {$ENDIF}
   try
      htmlBody.LoadFromFile(sFileName);
    except
      ShowMessage('Error file open');
      exit;
    end;
   {$IFDEF RELEASE}
   DeleteFile(sFileName);
   {$ENDIF}

   LogMemo.Lines.Append('Downloading is done.');

   if ParseSite(htmlBody) then begin
      MyTable1.Active:=true;
      DataSource1.Enabled:=true;
      DBGrid1.Enabled:=true;
      MyTable1.First;
      if MyTable1.RecordCount > 0 then
      begin
        MyTable2.Close;
        MyTable2.TableName:=MyTable1.FieldByName('name').AsString;
        MyTable2.Open;
        DataSource2.Enabled:=true;
        DBGrid2.Enabled:=true;
      end;

      LogMemo.Lines.Append('Updated at '+DateTimeToStr(Now));
      Result:=true;
   end;
   Timer1.Enabled:=true;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
function TMainForm.ParseSite(sbody : TStringList): boolean;
var Doc : IHTMLDocument2;
    v, vdiv : OleVariant;
    DocAll, DocDiv : IHTMLElementCollection;
    DElement : IHtmlElement;
    i, count : integer;
begin
  Result:=false;

  LogMemo.Lines.Append('Parsing...');

  Doc := coHTMLDocument.Create as IHTMLDocument2;
  if Doc = nil then
  begin
    ShowMessage('Cannot create IHTMLDocument2');
    exit;
  end;
  v := VarArrayCreate([0,0],VarVariant);
  v[0] := sbody.Text;
  Doc.write(PSafeArray(TVarData(v).VArray));

  //---------------- parsing site -------------------------
  DocAll := Doc.all;
  DocDiv  := DocAll.Tags('div') as IHTMLElementCollection;

  count:=0;
  ProgressBar1.Position:=0;
  ProgressBar1.Max:=DocDiv.length;

  for i := 0 to DocDiv.length-1 do
  begin
    Application.ProcessMessages;
    DElement:=DocDiv.item(i,0) as IHtmlElement;
    vdiv:=  DElement.getAttribute('className',0);
    if not VarIsNull(vdiv) then begin
      if Pos('_3t76jRD2',vdiv)>0 then // Lottery Draw tag
      begin
        ParseEventBlock(DElement);
        Inc(count);
      end;
    end;
    ProgressBar1.StepIt;
  end;

  LogMemo.Lines.Append('Parsing is done. Processed '+IntToStr(count)+' event(s)');
  Result:=true;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
procedure TMainForm.ParseEventBlock(root : IHTMLElement);
var le : TLotteryEvent;
    k4l0, celem, cl: IHTMLElementCollection;
    elem, helem,
    rd2, k4l1, k4l2, k4l3, k4l4, logo, h4, yg1 : IHTMLElement;
    vdiv : Variant;
    pos : integer;
    str : string;
begin

  k4l0:=(root.children as IHTMLElementCollection).tags('div') as IHTMLElementCollection;
  celem:=((k4l0.item(0,0)  as IHTMLElement).children as IHTMLElementCollection).tags('div') as IHTMLElementCollection;
  k4l1:=celem.item(0,0) as IHTMLElement;
  str:=k4l1.getAttribute('className',0);
  k4l2:=celem.item(1,0) as IHTMLElement;
  str:=k4l2.getAttribute('className',0);
  celem:= (k4l1.children as IHTMLElementCollection).tags('div') as IHTMLElementCollection;
  logo:=celem.item(0,0) as IHTMLElement;
//  logo:=k4l1.children as IHTMLElement;
  str:=logo.getAttribute('className',0);
  le.Name:=ExtractLottoName(logo).Replace('-','_');
  if not IsNameExist(le.Name) then begin
    AppendLottoName(le.Name);
  end;
  celem:= (k4l2.children as IHTMLElementCollection).tags('div') as IHTMLElementCollection;
  k4l3:= celem.item(0,0) as IHTMLElement;
  celem:= (k4l3.children as IHTMLElementCollection).tags('div') as IHTMLElementCollection;
  k4l4:= celem.item(0,0) as IHTMLElement;
  celem:= (k4l4.children as IHTMLElementCollection);
  celem:=((celem.item(0,0)  as IHTMLElement).children as IHTMLElementCollection).tags('h4')  as IHTMLElementCollection;
  h4:=celem.item(0,0) as IHTMLElement;
  le.Date:= ExtractLottoDate(h4);
  le.Draw:=StrToInt(ExtractLottoDraw(h4));

  celem:= (k4l4.children as IHTMLElementCollection);
  celem:=((celem.item(0,0)  as IHTMLElement).children as IHTMLElementCollection).tags('div')  as IHTMLElementCollection;
  yg1:=celem.item(0,0) as IHTMLElement;
  str:= ExtractLottoResults(yg1);
  pos:= System.Pos('Winner',str);
  if  pos > 0 then begin
    le.Results:=system.Copy(str,1,pos-2);
    le.Winner:=system.Copy(str,pos+8,str.Length-pos-7);
  end else
    le.Results:=str;

    UpdateLottoTable(le);
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
procedure TMainForm.StartBtnClick (Sender: TObject);
begin
  TimePanel.Caption:='--:--:--';
  DataUpdate;
  CountDown:=UpDown1.Position*3600;
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
procedure TMainForm.Timer1Timer(Sender: TObject);
var hh, mm, ss : integer;
begin
  Dec(CountDown);
  if CountDown = 0 then begin
    DataUpdate;
    CountDown:=UpDown1.Position*3600;
  end;
  hh:=CountDown div 3600;
  mm:=(CountDown - hh*3600) div 60;
  ss:=CountDown - (hh*60+mm)*60;
  TimePanel.Caption:=Format('%.*d:%.*d:%.*d',[2,hh,2,mm,2,ss]);
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
procedure TMainForm.FormCreate(Sender: TObject);
var  sConnStr: String;
begin

  LogMemo.Clear;
  with ProgressBar1 do begin
    Parent:=StatusBar1;
    Top:=0;
    Left:=0;
    Width:=StatusBar1.Panels[0].Width;
    Height:=StatusBar1.Height-2;
  end;
  CountDown:=UpDown1.Position*3600;

 // MyConnection1. Params.UserName:=sUser;
 // MyConnection1.Params.Password:=sPswd;
 // MyConnection1.Params.Values['Server']:=sServer;
 // MyConnection1.Params.Values['Port']:=sPort;

  try
    MyConnection1.Database:='mysql';
    MyConnection1.Connected := True;
  except
   ShowMessage('Can`t connect to MySQL Server');
   Halt;
  end;

  MyQuery1.SQL.Add('CREATE DATABASE IF NOT EXISTS ozlotto;');
  MyQuery1.ExecSQL;
  try
    MyConnection1.Database:='ozlotto';
    MyConnection1.Connected := True;
  except
    ShowMessage('ozlotto Datadase connection error!');
    Halt;
  end;

  LottoNames:=TStringList.Create;
  LoadLottoNames;
  MyTable1.Active:=true;
  MyTable1.First;


  if MyTable1.RecordCount > 0 then
  begin
    MyTable2.Close;
    MyTable2.TableName:=MyTable1.FieldByName('name').AsString;
    MyTable2.Open;
    DataSource2.Enabled:=true;
    DBGrid2.Enabled:=true;
  end;

  LogMemo.Lines.Add('Waiting for update...');
end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
procedure TMainForm.DBGrid1CellClick(Column: TColumn);
begin
  MyTable2.Active:=false;
  MyTable2.TableName:=DBGrid1.Fields[0].AsString;
  DataSource2.Enabled:=true;
  DBGrid2.Enabled:=true;
  StatusBar1.Panels[1].Text:=MyTable2.TableName;
  MyTable2.Active:=true;
end;
//------------------------------------------------------------------------------

end. //  ------------------ TMainForm ----
