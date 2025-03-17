// Humble Bundle API  https://www.schiff.io/projects/humble-bundle-api

program HumbleBundleDL;

uses
  Vcl.Forms,
  WinApi.Windows,
  HumbleBundleDLUnit1 in 'HumbleBundleDLUnit1.pas' {Form1},
  HumbleBundleJSONObjects in 'HumbleBundleJSONObjects.pas';

{$R *.res}

begin
  {$IFDEF MSWINDOWS}
  {$WARN SYMBOL_PLATFORM OFF}
  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  {$WARN SYMBOL_PLATFORM ON}
  {$ENDIF}
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
