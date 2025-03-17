// Humble Bundle API  https://www.schiff.io/projects/humble-bundle-api

program HumbleBundleDL;

uses
  Vcl.Forms,
  WinApi.Windows,
  HumbleBundleDLUnit1 in 'HumbleBundleDLUnit1.pas' {Form1},
  BundleJsonObject in 'BundleJsonObject.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
