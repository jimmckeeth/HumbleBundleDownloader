// Humble Bundle API  https://www.schiff.io/projects/humble-bundle-api
// CEF4Delphi         https://github.com/salvadordf/CEF4Delphi.git

program HumbleBundleDL;

uses
  Vcl.Forms,
  WinApi.Windows,
  uCEFApplication,
  HumbleBundleDLUnit1 in 'HumbleBundleDLUnit1.pas' {Form1},
  HumbleBundleJSONObjects in 'HumbleBundleJSONObjects.pas';

{$R *.res}

// CEF3 needs to set the LARGEADDRESSAWARE flag which allows 32-bit processes to use up to 3GB of RAM.
// If you don't add this flag the rederer process will crash when you try to load large images.
{$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  GlobalCEFApp := TCefApplication.Create;
  GlobalCEFApp.FrameworkDirPath     := 'cef';
  GlobalCEFApp.ResourcesDirPath     := 'cef';
  GlobalCEFApp.LocalesDirPath       := 'cef\locales';

  // In case you want to use custom directories for the CEF3 binaries, cache, cookies and user data.
  // If you don't set a cache directory the browser will use in-memory cache.
{
  GlobalCEFApp.FrameworkDirPath     := 'cef';
  GlobalCEFApp.ResourcesDirPath     := 'cef';
  GlobalCEFApp.LocalesDirPath       := 'cef\locales';
  GlobalCEFApp.cache                := 'cef\cache';
  GlobalCEFApp.cookies              := 'cef\cookies';
  GlobalCEFApp.UserDataPath         := 'cef\User Data';
}
  //GlobalCEFApp.cache                := '.';
  GlobalCEFApp.cookies              := '.';

  // You *MUST* call GlobalCEFApp.StartMainProcess in a if..then clause
  // with the Application initialization inside the begin..end.
  // Read this https://www.briskbard.com/index.php?lang=en&pageid=cef
  if GlobalCEFApp.StartMainProcess then
    begin
      Application.Initialize;
      Application.MainFormOnTaskbar := True;
      Application.CreateForm(TForm1, Form1);
  Application.Run;
    end;

  GlobalCEFApp.Free;
end.
