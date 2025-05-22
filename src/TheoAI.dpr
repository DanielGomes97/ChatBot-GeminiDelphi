program TheoAI;

uses
  System.StartUpCopy,
  FMX.Forms,
  FMX.Skia,
  uView.Dashboard in 'view\uView.Dashboard.pas' {FrmDashboard},
  uLoading in 'Utils\uLoading.pas',
  uUtils in 'utils\uUtils.pas',
  uAPIKeys in 'View\uAPIKeys.pas';


{$R *.res}

begin
  GlobalUseSkia := True;//
  Application.Initialize;
  Application.CreateForm(TFrmDashboard, FrmDashboard);
  Application.Run;
end.
