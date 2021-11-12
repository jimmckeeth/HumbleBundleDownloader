// Setup TEdgeBrowser correctly
//
// https://blogs.embarcadero.com/execute-scripts-and-view-source-with-tedgebrowser/
// https://docwiki.embarcadero.com/RADStudio/en/Using_TEdgeBrowser_Component_and_Changes_to_the_TWebBrowser_Component

unit HumbleBundleDLUnit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, System.IOUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.OleCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids, Vcl.DBGrids,

  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  Generics.Collections, System.Generics.Defaults, System.Threading,

  HumbleBundleJSONObjects,

  REST.Client, FireDAC.Stan.StorageBin, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, Winapi.WebView2,
  Winapi.ActiveX, Vcl.Edge;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    lbKeys: TListBox;
    tblDownloads: TFDMemTable;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    btnFilter: TButton;
    Panel2: TPanel;
    editFilter: TEdit;
    tblDownloadsBundle: TWideStringField;
    tblDownloadsProduct: TWideStringField;
    tblDownloadsPlatform: TWideStringField;
    tblDownloadsFileSize: TLongWordField;
    tblDownloadsMD5: TWideStringField;
    tblDownloadsURL: TWideStringField;
    tblDownloadsSHA1: TWideStringField;
    tblDownloadsDownloadName: TWideStringField;
    tblDownloadsFormat: TWideStringField;
    tblDownloadsIcon: TWideStringField;
    tblDownloadsPaid: TCurrencyField;
    tblDownloadsBundleKey: TWideStringField;
    Button3: TButton;
    Button4: TButton;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    Label1: TLabel;
    Button5: TButton;
    EdgeBrowser1: TEdgeBrowser;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbKeysClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnFilterClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure EdgeBrowser1ExecuteScript(Sender: TCustomEdgeBrowser;
      AResult: HRESULT; const AResultObjectAsJson: string);
    procedure EdgeBrowser1NavigationCompleted(Sender: TCustomEdgeBrowser;
      IsSuccess: Boolean; WebErrorStatus: TOleEnum);
  private
    { Private declarations }
    FAutomatic: Boolean;
    FCachePath: String;
    FTableFile: string;
    function CreateDownloadTask(AUrl, ALocalFile, AFormat, AExt: string): ITask;
    const
      CGetKeys = 'https://www.humblebundle.com/api/v1/user/order';
      CGetOrders = 'https://www.humblebundle.com/api/v1/order/';
    procedure NextOrder(Akey: String);
    procedure JsonToDataset(json: string);
    procedure GetOrder(const AOrderKey: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  System.JSON, System.Hash, System.NetEncoding;

{$R *.dfm}

procedure TForm1.btnFilterClick(Sender: TObject);
begin
  tblDownloads.Filtered := False;
  tblDownloads.Filter := editFilter.Text;
  tblDownloads.Filtered := True;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  EdgeBrowser1.Navigate(CGetKeys);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  while not tblDownloads.Eof do tblDownloads.Delete;
  FAutomatic := True;
  lbKeys.ItemIndex := 0;
  GetOrder(lbKeys.Items[lbKeys.ItemIndex]);
end;

function GetFileNameFromUrl(AUrl: String): String;
var
  last, first: integer;
begin
  Result := TNetEncoding.URL.Decode(AUrl);
  last := LastDelimiter('/\', Result);
  Result := Copy(Result, last + 1, maxInt);
  first := FindDelimiter('?&', Result);
  Result := Copy(result, 1, first - 1);
end;

function TForm1.CreateDownloadTask(AUrl, ALocalFile, AFormat, AExt: String): ITask;
begin
  Result := TTask.Create(procedure
    var
      client: THTTPClient;
      resp: IHTTPResponse;
      saveFile: TFileStream;
    begin
      client := THTTPClient.Create;
      try
        saveFile := TFileStream.Create(ALocalFile, fmCreate);
        try
          if TTask.CurrentTask.Status = TTaskStatus.Canceled then exit;
          resp := client.Get(AUrl, saveFile);
        finally
          saveFile.Free;
        end;
      finally
        client.Free;
      end;
    end);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  tasks: TList<ITask>;
  task: ITask;
  localName: String;
begin
  tasks := TList<ITask>.Create;
  try
    tblDownloads.First;

    while not tblDownloads.Eof do
    begin
      if tblDownloadsURL.IsNull or (tblDownloadsURL.AsString.Length = 0) then next;

      localName := TPath.Combine(FCachePath, GetFileNameFromUrl(tblDownloadsURL.AsString));
      if not TFile.Exists(localName) then
        tasks.Add(CreateDownloadTask(
          tblDownloadsURL.AsString,
          localName,
          tblDownloadsDownloadName.Value,
          tblDownloadsFormat.Value));

      tblDownloads.Next;
    end;
    for task in tasks do
    begin
      task.Start;
    end;
  finally
    tasks.Free;
  end;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  TDirectory.Delete(FCachePath, True);
  TDirectory.CreateDirectory(FCachePath);
  while not tblDownloads.Eof do tblDownloads.Delete;

end;

procedure TForm1.Button5Click(Sender: TObject);
 var
  order: THumbleOrderClass;
  key, json, f: string;
  I: Integer;
  total: Currency;
begin
  total := 0;
  memo1.Clear;
  for I := 0 to lbKeys.Count - 1 do
  begin
    key := lbKeys.Items[i];
    f := TPath.Combine(FCachePath, key + '.json');
    if not TFile.Exists(f) then raise Exception.Create('File not found '+ f);
    json := TFile.ReadAllText(f);
    order := THumbleOrderClass.FromJsonString(json);
    try
      total := total + order.amount_spent;
      memo1.Lines.Add(format('"%s"'#10'%s'#10'%f',
        [order.product.human_name,
         order.created,
         order.amount_spent]));
    finally
      order.Free;
    end;
  end;
  label1.Caption := Format('$%f',[total]);
end;

procedure TForm1.NextOrder(Akey: String);
var
  idx: Integer;
begin
  idx := lbKeys.Items.IndexOf(AKey);
  if idx < pred(lbKeys.Items.Count) then
  begin
    lbKeys.ItemIndex := idx + 1;
    GetOrder(lbKeys.Items[lbKeys.ItemIndex]);
  end
  else
    FAutomatic := False;
end;

function StripHTML(AHTML: String): String;
begin
  Result := AHTML
    .Replace('<html><head></head><body><pre style=word-wrap: break-word; white-space: pre-wrap;>','')
    .Replace('<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">','')
    .Replace('</pre></body></html>','');
end;


procedure TForm1.DBGrid1DblClick(Sender: TObject);
begin
  EdgeBrowser1.Navigate(tblDownloadsURL.Value);
end;

procedure TForm1.EdgeBrowser1ExecuteScript(Sender: TCustomEdgeBrowser;
  AResult: HRESULT; const AResultObjectAsJson: string);
begin
  if AResultObjectAsJson='null' then exit;
  var json := StripHTML(TNetEncoding.URL.Decode(AResultObjectAsJson));
  if json.StartsWith('"') and json.EndsWith('"') then
    json := json.Remove(0,1);
    json := json.Remove(pred(json.Length),1);
  if EdgeBrowser1.LocationURL = CGetKeys then
  begin
    json := json.DeQuotedString('"')
      .Replace('['#$A'{'#$A'"gamekey":"','')
      .Replace('['#$A'{'#$A'gamekey:','')
      .Replace('"'#$A'},'#$A'{'#$A'"gamekey":"',sLineBreak)
      .Replace(''#$A'},'#$A'{'#$A'gamekey:',sLineBreak)
      .Replace('"'#$A'}'#$A']','')
      .Replace(''#$A'}'#$A']','');
    lbKeys.Items.Text := Json;
    lbKeys.Items.SaveToFile(TPath.Combine(FCachePath, 'keys.txt'));
  end
  else if EdgeBrowser1.LocationURL.StartsWith(CGetOrders) then
  begin
    if FAutomatic then
    begin

      JsonToDataset(json);
      var key := EdgeBrowser1.LocationURL.Substring(CGetOrders.Length);
      TFile.WriteAllText(tPath.combine(FCachePath, key + '.json'), json);
      NextOrder(key);
    end;
  end;
end;

procedure TForm1.EdgeBrowser1NavigationCompleted(
  Sender: TCustomEdgeBrowser; IsSuccess: Boolean;
  WebErrorStatus: TOleEnum);
begin
  EdgeBrowser1.ExecuteScript('encodeURI(document.documentElement.outerHTML)');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tblDownloads.filtered := False;
  if tblDownloads.RecordCount > 0 then
    tblDownloads.SaveToFile(fTableFile);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  EdgeBrowser1.Navigate('about:blank');
  FCachePath := TPath.Combine( TPath.GetTempPath, 'HumbleBundleDL');
  if not TDirectory.Exists(FCachePath) then
    TDirectory.CreateDirectory(FCachePath);
  fTableFile := TPath.Combine(FCachePath, 'tblDownloads.bin');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  EdgeBrowser1.Navigate('https://www.humblebundle.com/home/purchases');
  FAutomatic := False;
  if TFile.Exists(fTableFile) then
    tblDownloads.LoadFromFile(fTableFile);
  if TFile.Exists(TPath.Combine(FCachePath, 'keys.txt')) then
    lbKeys.Items.LoadFromFile(TPath.Combine(FCachePath, 'keys.txt'));
end;

procedure TForm1.GetOrder(const AOrderKey: string);
var
  json, f: string;
begin
  f := TPath.Combine(FCachePath, AOrderKey + '.json');
  if not TFile.Exists(f) then
  begin
    EdgeBrowser1.Navigate(CGetOrders + AOrderKey);
  end
  else
  begin
    json := TFile.ReadAllText(f);
    JsonToDataset(json);
    if FAutomatic then
    begin
      NextOrder(AOrderKey);
    end;
  end;
end;

procedure TForm1.JsonToDataset(json: string);
var
  url: string;
  order: THumbleOrderClass;
  product: Integer;
  download: Integer;
  files: Integer;
begin
  order := THumbleOrderClass.FromJsonString(json);
  try
    tblDownloads.Open;
    for product := Low(order.subproducts) to High(order.subproducts) do
      for download := Low(order.subproducts[product].downloads) to High(order.subproducts[product].downloads) do
        for files := Low(order.subproducts[product].downloads[download].download_struct) to High(order.subproducts[product].downloads[download].download_struct) do
        begin
          url := order.subproducts[product].downloads[download].download_struct[files].url.web.Trim;
          if url.Length = 0 then next;
          tblDownloads.Filter := 'url = '''+url+'''';
          tblDownloads.Filtered := true;
          if tblDownloads.RecordCount > 0 then next;

          tblDownloads.Insert;
          tblDownloadsBundleKey.Value := order.gamekey;
          tblDownloadsBundle.Value := TNetEncoding.HTML.Decode(order.product.human_name);
          tblDownloadsIcon.Value := TNetEncoding.HTML.Decode(order.subproducts[product].icon);
          tblDownloadsProduct.Value := TNetEncoding.HTML.Decode(order.subproducts[product].human_name);
          tblDownloadsPlatform.Value := TNetEncoding.HTML.Decode(order.subproducts[product].downloads[download].platform);
          tblDownloadsDownloadName.Value := TNetEncoding.HTML.Decode(order.subproducts[product].downloads[download].machine_name);
          tblDownloadsMd5.Value := TNetEncoding.HTML.Decode(order.subproducts[product].downloads[download].download_struct[files].md5);
          tblDownloadsSha1.Value := TNetEncoding.HTML.Decode(order.subproducts[product].downloads[download].download_struct[files].sha1);
          tblDownloadsUrl.Value := TNetEncoding.HTML.Decode(order.subproducts[product].downloads[download].download_struct[files].url.web);
          tblDownloadsFormat.Value := TNetEncoding.HTML.Decode(order.subproducts[product].downloads[download].download_struct[files].name);
          tblDownloadsFileSize.Value := Trunc(order.subproducts[product].downloads[download].download_struct[files].file_size);
          tblDownloadsPaid.Value := order.amount_spent;
          tblDownloads.Post;
        end;
  finally
    order.Free;
  end;
  tblDownloads.IndexesActive := True;
  tblDownloads.Filtered := false;
end;

procedure TForm1.lbKeysClick(Sender: TObject);
begin
  FAutomatic := False;
  GetOrder(lbKeys.Items[lbKeys.ItemIndex])
end;

end.
