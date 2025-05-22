unit uUtils;

interface
uses
  System.SysUtils, FMX.Platform, FMX.VirtualKeyboard,

  {$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.Net,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.App,
  Androidapi.JNI.GraphicsContentViewText,
  {$ENDIF}
  {$IFDEF MSWINDOWS}
  Winapi.ShellAPI, Winapi.Windows,
  {$ENDIF}
  System.IOUtils;

  procedure AbrirURL(const AURL: string);
  function  IfThen(Condition: Boolean; IfTrue, IfFalse: Variant): Variant;
  procedure CopyToClipboard(Const Texto: String);
  function FormatList(const Texto: string): string;
  function VerificaTecladoAtivo: Boolean;
  procedure EsconderTeclado;

const
  URL_GITHUB:   String = 'https://github.com/DanielGomes97';
  URL_LINKEDIN: String = 'https://www.linkedin.com/in/danielgommes/';
  URL:          String = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=';

var
  KeyBoardEstaVisivel: Boolean;

implementation

procedure AbrirURL(const AURL: string);
{$IFDEF ANDROID}
var
  Intent: JIntent;
{$ENDIF}
begin
    {$IFDEF ANDROID}
    Intent := TJIntent.Create;
    Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
    Intent.setData(StrToJURI(AURL));
    TAndroidHelper.Context.startActivity(Intent);
    {$ENDIF}

    {$IFDEF MSWINDOWS}
    ShellExecute(0, 'open', PChar(AURL), nil, nil, SW_SHOWNORMAL);
    {$ENDIF}
end;

function IfThen(Condition: Boolean; IfTrue, IfFalse: Variant): Variant;
begin
    if Condition then
       Result := IfTrue
    else
       Result := IfFalse;
end;

procedure CopyToClipboard(Const Texto: String);
var
  ClipboardService: IFMXClipboardService;
begin
    if Supports(TPlatformServices.Current.GetPlatformService(IFMXClipboardService), IFMXClipboardService, ClipboardService) then
       if Texto <> '' then
          ClipboardService.SetClipboard(Texto);
end;

function FormatList(const Texto: string): string;
begin
    Result := Texto.Replace('* ', '• ', [rfReplaceAll]);
end;

function VerificaTecladoAtivo: Boolean;
begin
    Result := KeyBoardEstaVisivel;
end;

procedure EsconderTeclado;
begin
    if VerificaTecladoAtivo then
    begin
        if TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService) then
        begin
            var VirtualKeyboardService := IFMXVirtualKeyboardService(TPlatformServices.Current.GetPlatformService(IFMXVirtualKeyboardService));
            VirtualKeyboardService.HideVirtualKeyboard;
        end;
    end;
end;

end.
