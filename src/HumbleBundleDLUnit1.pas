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

  FireDAC.Stan.StorageBin, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, Winapi.WebView2,
  Winapi.ActiveX, Vcl.Edge, BundleJsonObject;

type
  TForm1 = class(TForm)
    btnGetKeys: TButton;
    btnGetUrls: TButton;
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
    btnDownload: TButton;
    btnClear: TButton;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    Label1: TLabel;
    btnGetTotal: TButton;
    EdgeBrowser1: TEdgeBrowser;
    ckAuto: TCheckBox;
    procedure btnGetKeysClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbKeysClick(Sender: TObject);
    procedure btnGetUrlsClick(Sender: TObject);
    procedure btnFilterClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btnDownloadClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnGetTotalClick(Sender: TObject);
    procedure EdgeBrowser1ExecuteScript(Sender: TCustomEdgeBrowser;
      AResult: HRESULT; const AResultObjectAsJson: string);
    procedure EdgeBrowser1NavigationCompleted(Sender: TCustomEdgeBrowser;
      IsSuccess: Boolean; WebErrorStatus: TOleEnum);
  private
    { Private declarations }
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
  System.JSON, System.Hash, System.NetEncoding,  System.RegularExpressions;

{$R *.dfm}

procedure TForm1.btnFilterClick(Sender: TObject);
begin
  tblDownloads.Filtered := False;
  tblDownloads.Filter := editFilter.Text;
  tblDownloads.Filtered := True;
end;

procedure TForm1.btnGetKeysClick(Sender: TObject);
begin
  EdgeBrowser1.Navigate(CGetKeys);
end;

procedure TForm1.btnGetUrlsClick(Sender: TObject);
begin
  while not tblDownloads.Eof do tblDownloads.Delete;
  ckAuto.Checked := True;
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

procedure TForm1.btnDownloadClick(Sender: TObject);
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

procedure TForm1.btnClearClick(Sender: TObject);
begin
  TDirectory.Delete(FCachePath, True);
  TDirectory.CreateDirectory(FCachePath);
  while not tblDownloads.Eof do tblDownloads.Delete;

end;

procedure TForm1.btnGetTotalClick(Sender: TObject);
 var
  order: TBundle;
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

    TJSONMapper<TBundle>.SetDefaultLibrary('REST.Json');
    order := TJSONMapper<TBundle>.Default.FromObject(json);
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
    ckAuto.Checked := False;
end;

function StripHTML(const AHTML: string): string;
var
  JSONEndPos: Integer;
begin
  // Define regex pattern to remove HTML tags
  Result := TRegEx.Replace(AHTML, '<[^>]+>', '', [roMultiLine]);

  // Find the position of "}Code folding" and truncate the string if found
  JSONEndPos := Pos('}Code folding', Result);
  if JSONEndPos > 0 then
    Result := Copy(Result, 1, JSONEndPos);
end;

procedure TForm1.DBGrid1DblClick(Sender: TObject);
begin
  EdgeBrowser1.Navigate(tblDownloadsURL.Value);
end;

procedure ExtractGameKeys(const Input: string; const GameKeys: TStrings);
begin
  Assert(Assigned(GameKeys));
  // Define regex pattern to find gamekey values
  var Regex := TRegEx.Create('"gamekey":"(.*?)"');

  // Find all matches
  var Matches := Regex.Matches(Input);

  // Iterate through the matches and extract gamekey values
  for var Match in Matches do
  begin
    GameKeys.Add(Match.Groups[1].Value);
  end;
end;

procedure TForm1.EdgeBrowser1ExecuteScript(Sender: TCustomEdgeBrowser;
  AResult: HRESULT; const AResultObjectAsJson: string);
begin
  if AResultObjectAsJson='null' then exit;
  var content := TNetEncoding.URL.Decode(AResultObjectAsJson);
  if content.StartsWith('"') and content.EndsWith('"') then
  begin
    content := content.Remove(0,1);
    content := content.Remove(pred(content.Length),1);
  end;
  if EdgeBrowser1.LocationURL = CGetKeys then
  begin
    lbKeys.Clear;
    ExtractGameKeys(StripHTML(content), lbKeys.Items);
    lbKeys.Items.SaveToFile(TPath.Combine(FCachePath, 'keys.txt'));
  end
  else if EdgeBrowser1.LocationURL.StartsWith(CGetOrders) then
  begin
    var json := StripHTML(content);
    if ckAuto.Checked then
    begin
      var key := EdgeBrowser1.LocationURL.Substring(CGetOrders.Length);
      TFile.WriteAllText(tPath.combine(FCachePath, key + '.json'), json);
      JsonToDataset(json);
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
  if not FileExists('WebView2Loader.dll') then
    raise Exception.Create('WebView2Loader.dll must be deployed with the program.');

  EdgeBrowser1.Navigate('about:blank');
  FCachePath := TPath.Combine( TPath.GetTempPath, 'HumbleBundleDL');
  if not TDirectory.Exists(FCachePath) then
    TDirectory.CreateDirectory(FCachePath);
  fTableFile := TPath.Combine(FCachePath, 'tblDownloads.bin');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  EdgeBrowser1.Navigate('https://www.humblebundle.com/home/purchases');
  ckAuto.Checked := False;
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
    if ckAuto.Checked then
    begin
      NextOrder(AOrderKey);
    end;
  end;
end;

procedure TForm1.JsonToDataset(json: string);
var
  url: string;
  order: TBundle;
  product: Integer;
  download: Integer;
  files: Integer;
begin
  TJSONMapper<TBundle>.SetDefaultLibrary('REST.Json');
  order := TJSONMapper<TBundle>.Default.FromObject(json);
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
  ckAuto.Checked := False;
  GetOrder(lbKeys.Items[lbKeys.ItemIndex])
end;

end.
