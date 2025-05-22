unit uView.Dashboard;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  System.Skia, FMX.Memo.Types, FMX.Controls.Presentation, FMX.ScrollBox,
  FMX.Memo, FMX.Skia, FMX.Objects, FMX.Edit, System.Net.HttpClient, System.JSON,
  System.NetEncoding, REST.Types, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, uLoading, System.Threading, FMX.Platform, FMX.VirtualKeyboard, System.Generics.Collections,
  FMX.Effects, FMX.Filter.Effects, FMX.Ani,
  uUtils, uAPIKeys;

type
  TChatMessage = record
    Role: string; // 'user' ou 'model'
    Text: string;
  end;

type
  TFrmDashboard = class(TForm)
    LoPrincipal: TLayout;
    Layout2: TLayout;
    Layout3: TLayout;
    Layout4: TLayout;
    Rectangle1: TRectangle;
    Layout5: TLayout;
    Layout6: TLayout;
    Layout7: TLayout;
    SkLabel1: TSkLabel;
    Layout8: TLayout;
    Layout9: TLayout;
    Rectangle3: TRectangle;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    LoForKeyboard: TLayout;
    Layout12: TLayout;
    SkSvgVoltar: TSkSvg;
    Rectangle2: TRectangle;
    StyleBook1: TStyleBook;
    BtnEnviar: TRectangle;
    SkLabel3: TSkLabel;
    SkSvg1: TSkSvg;
    FillRGBEffect1: TFillRGBEffect;
    VertScrollBox2: TVertScrollBox;
    SkLabel9: TSkLabel;
    EditMensagem: TEdit;
    TimerScroll: TTimer;
    Layout1: TLayout;
    BtnSvgMenu: TSkSvg;
    LoMenu: TLayout;
    RecBackgroundMenu: TRectangle;
    RecMenu: TRectangle;
    Layout11: TLayout;
    VertScrollBox1: TVertScrollBox;
    Layout13: TLayout;
    Layout19: TLayout;
    Layout20: TLayout;
    Layout21: TLayout;
    BtnFecharMenu: TSkSvg;
    Layout22: TLayout;
    SkSvg4: TSkSvg;
    SkLabel4: TSkLabel;
    Layout10: TLayout;
    Layout25: TLayout;
    BtnURLGithub: TRectangle;
    SkSvg5: TSkSvg;
    SkLabel7: TSkLabel;
    Layout26: TLayout;
    Layout27: TLayout;
    BtnURLLinkedin: TRectangle;
    Layout28: TLayout;
    SkLabel5: TSkLabel;
    SkSvg6: TSkSvg;
    Layout33: TLayout;
    Rectangle15: TRectangle;
    Layout34: TLayout;
    SkLabel14: TSkLabel;
    SkSvg10: TSkSvg;
    SkLabel6: TSkLabel;
    FAnimationMenu: TFloatAnimation;
    Layout14: TLayout;
    Rectangle4: TRectangle;
    Layout15: TLayout;
    SkLabel8: TSkLabel;
    SkSvg2: TSkSvg;
    Layout16: TLayout;
    BtnCopiar: TRectangle;
    Layout17: TLayout;
    SkLabel10: TSkLabel;
    SkSvg3: TSkSvg;
    Layout23: TLayout;
    BtnNovoConversa: TRectangle;
    Layout24: TLayout;
    SkLabel11: TSkLabel;
    SkSvg7: TSkSvg;
    LoTelaVazia: TLayout;
    Rectangle5: TRectangle;
    Layout29: TLayout;
    Layout30: TLayout;
    Image1: TImage;
    SkLabel2: TSkLabel;
    LoLimparEditMensagem: TLayout;
    BtnCleanPrompt: TSkSvg;
    LoToastMessage: TLayout;
    RecMsg: TRectangle;
    LblMensagemToast: TSkLabel;
    Rectangle10: TRectangle;
    FAnimationWidth: TFloatAnimation;
    FAnimationOpacity: TFloatAnimation;
    LoSizeToastMessage: TLayout;
    Rectangle6: TRectangle;
    procedure FormCreate(Sender: TObject);
    procedure FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure SkSvgVoltarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnFecharMenuClick(Sender: TObject);
    procedure SkSvg2Click(Sender: TObject);
    procedure SkSvg3Click(Sender: TObject);
    procedure FAnimationMenuFinish(Sender: TObject);
    //
    procedure GenerateText(const Prompt: string);
    function MontarConteudoComHistorico: TJSONArray;
    procedure EnviarMensagem(Owner, Text: String);
    procedure ScrollSuaveParaFim;
    procedure AnimaMenu(Expandir: Boolean);
    procedure BtnEnviarClick(Sender: TObject);
    procedure EditMensagemKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    procedure BtnSvgMenuClick(Sender: TObject);
    procedure BtnNovoConversaClick(Sender: TObject);
    procedure BtnCopiarClick(Sender: TObject);
    procedure EditMensagemChangeTracking(Sender: TObject);
    procedure BtnCleanPromptClick(Sender: TObject);
    procedure BtnURLLinkedinClick(Sender: TObject);
    procedure BtnURLGithubClick(Sender: TObject);
    procedure TimerScrollTimer(Sender: TObject);
    procedure RecBackgroundMenuClick(Sender: TObject);
    procedure FAnimationWidthFinish(Sender: TObject);
    procedure FAnimationOpacityFinish(Sender: TObject);

  private
    { Private declarations }
      FScrollTargetY: Single;
    procedure AdicionarMensagemOculta;
    procedure ToastMessage(Texto: String; IsWidth: Boolean);
  public
    { Public declarations }
  end;

var
  FrmDashboard: TFrmDashboard;
  ChatHistory: TList<TChatMessage>; //
  ControladorIndexLabel: integer;

implementation

{$R *.fmx}

procedure TFrmDashboard.FormCreate(Sender: TObject);
begin
    ControladorIndexLabel := 0;
    ChatHistory := TList<TChatMessage>.Create;
    LoLimparEditMensagem.Visible := False;
    EditMensagem.SetFocus;
    LoTelaVazia.Visible := True;
end;

procedure TFrmDashboard.FormDestroy(Sender: TObject);
begin
    ChatHistory.Free;
end;

function TFrmDashboard.MontarConteudoComHistorico: TJSONArray;
var
  Conteudo: TJSONArray;
  MsgObj, PartObj: TJSONObject;
  Msg: TChatMessage;
begin
    Conteudo := TJSONArray.Create;
    for Msg in ChatHistory do
    begin
        PartObj := TJSONObject.Create;
        PartObj.AddPair('text', Msg.Text);

        MsgObj := TJSONObject.Create;
        MsgObj.AddPair('role', Msg.Role);
        MsgObj.AddPair('parts', TJSONArray.Create(PartObj));

        Conteudo.AddElement(MsgObj);
    end;
    Result := Conteudo;
end;

procedure TFrmDashboard.RecBackgroundMenuClick(Sender: TObject);
begin
    BtnFecharMenu.OnClick(Sender);
end;

procedure TFrmDashboard.EditMensagemChangeTracking(Sender: TObject);
begin
    LoLimparEditMensagem.Visible := EditMensagem.Text <> ''
end;

procedure TFrmDashboard.EditMensagemKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
    if Key = vkReturn then
    begin
        if EditMensagem.Text <> '' then
           BtnEnviar.OnClick(Sender);
        Key := 0;
    end;
end;

procedure TFrmDashboard.EnviarMensagem(Owner, Text: String);
var
  PosAtual, PosInicio, PosFim: Integer;
  TextoNormal, TextoNegrito: string;
begin
    if (SkLabel9.Words.Count - 1) > 0 then
        Inc(ControladorIndexLabel);
    SkLabel9.Words.Insert(ControladorIndexLabel).Text := Owner;
    if Owner = 'Você: ' then
       SkLabel9.Words.Items[ControladorIndexLabel].BackgroundColor := $FF6F6E70;
    SkLabel9.Words.Items[ControladorIndexLabel].Font.Size := 16.000000000000000000;
    SkLabel9.Words.Items[ControladorIndexLabel].Font.Weight := TFontWeight.Black;

    PosAtual := 0;
    while PosAtual < Text.Length do
    begin
        PosInicio := Text.IndexOf('**', PosAtual);
        // Se não achar mais negrito, adiciona o restante como texto normal
        if PosInicio = -1 then
        begin
            TextoNormal := Text.Substring(PosAtual);
            if not TextoNormal.IsEmpty then
            begin
                Inc(ControladorIndexLabel);
                SkLabel9.Words.Insert(ControladorIndexLabel).Text := FormatList(TextoNormal) + sLineBreak;
                if Owner = 'Você: ' then
                   SkLabel9.Words.Items[ControladorIndexLabel].BackgroundColor := $FF6F6E70;
            end;
            Break;
        end;

        // Adiciona texto antes do negrito
        if PosInicio > PosAtual then
        begin
            TextoNormal := Text.Substring(PosAtual, PosInicio - PosAtual);
            Inc(ControladorIndexLabel);
            SkLabel9.Words.Insert(ControladorIndexLabel).Text := FormatList(TextoNormal);
            if Owner = 'Você: ' then
               SkLabel9.Words.Items[ControladorIndexLabel].BackgroundColor := $FF6F6E70;
        end;

        //Avança após os dois **
        PosInicio := PosInicio + 2;
        PosFim := Text.IndexOf('**', PosInicio);

        //Se não encontrar fechamento, trata como texto comum
        if PosFim = -1 then
        begin
            TextoNormal := '**' + Text.Substring(PosInicio);
            Inc(ControladorIndexLabel);
            SkLabel9.Words.Insert(ControladorIndexLabel).Text := FormatList(TextoNormal);
            if Owner = 'Você: ' then
               SkLabel9.Words.Items[ControladorIndexLabel].BackgroundColor := $FF6F6E70;
            Break;
        end;

        //Texto entre os **
        TextoNegrito := Text.Substring(PosInicio, PosFim - PosInicio);
        Inc(ControladorIndexLabel);
        SkLabel9.Words.Insert(ControladorIndexLabel).Text := FormatList(TextoNegrito);
        SkLabel9.Words.Items[ControladorIndexLabel].Font.Weight := TFontWeight.Bold;
        if Owner = 'Você: ' then
           SkLabel9.Words.Items[ControladorIndexLabel].BackgroundColor := $FF6F6E70;
        PosAtual := PosFim + 2; // Avança além do **
    end;
    Inc(ControladorIndexLabel);
    SkLabel9.Words.Insert(ControladorIndexLabel).Text := sLineBreak;
end;

procedure TFrmDashboard.BtnCleanPromptClick(Sender: TObject);
begin
    EditMensagem.Text := '';
end;

procedure TFrmDashboard.BtnCopiarClick(Sender: TObject);
begin
    CopyToClipboard(SkLabel9.Text);
    BtnFecharMenu.OnClick(Sender);
    ToastMessage('Texto copiado com sucesso!', True);
end;

procedure TFrmDashboard.BtnEnviarClick(Sender: TObject);
begin
    GenerateText(EditMensagem.Text);
    EditMensagem.Text := '';
    EditMensagem.SetFocus;
end;

procedure TFrmDashboard.BtnNovoConversaClick(Sender: TObject);
var
  Msg: TChatMessage;
begin
    Msg.Text := '';
    ChatHistory.Clear;
    SkLabel9.Words.Clear;
    ComponentIndex := 0;
    LoTelaVazia.Visible := True;
    BtnFecharMenu.OnClick(Sender);  //
end;

procedure TFrmDashboard.BtnSvgMenuClick(Sender: TObject);
begin
    AnimaMenu(True);
    BtnCopiar.Enabled := NOT(SkLabel9.Text = '');
end;

procedure TFrmDashboard.BtnURLGithubClick(Sender: TObject);
begin
    AbrirURL(URL_GITHUB);
end;

procedure TFrmDashboard.BtnURLLinkedinClick(Sender: TObject);
begin
    AbrirURL(URL_LINKEDIN);
end;

procedure TFrmDashboard.AnimaMenu(Expandir: Boolean);
begin
    if not LoMenu.Visible then
       LoMenu.Visible := True;
    FAnimationMenu.StartValue := IfThen(Expandir, 0, RecMenu.Width);
    FAnimationMenu.StopValue  := IfThen(Expandir, (LoMenu.Width / 1.5), 0);
    FAnimationMenu.Duration   := 0.3;
    FAnimationMenu.Start;
end;

procedure TFrmDashboard.ToastMessage(Texto: String; IsWidth: Boolean); //tes
begin
    if not LoToastMessage.Visible then
       LoToastMessage.Visible := True;
    LblMensagemToast.Text := Texto;
    if IsWidth then
    begin
        RecMsg.Width := 0;
        RecMsg.TagString := Texto;
        RecMsg.Opacity := 1;
        FAnimationWidth.StartValue := 0;
        FAnimationWidth.StopValue  := LoSizeToastMessage.Width;
        FAnimationWidth.Duration   := 0.5;
        FAnimationWidth.Start;
    end
    else
    begin
        LblMensagemToast.Text := RecMsg.TagString;
        FAnimationOpacity.StartValue := 1;
        FAnimationOpacity.StopValue  := 0;
        FAnimationOpacity.Duration   := 0.3;
        FAnimationOpacity.Delay      := 2;
        FAnimationOpacity.Start;
    end;
end;

procedure TFrmDashboard.FAnimationMenuFinish(Sender: TObject);
begin
    if RecMenu.Width = 0 then
       LoMenu.Visible := False;
end;

procedure TFrmDashboard.FAnimationOpacityFinish(Sender: TObject);
begin
    if LoToastMessage.Visible then
       LoToastMessage.Visible := False;
end;

procedure TFrmDashboard.FAnimationWidthFinish(Sender: TObject);
begin
    if RecMsg.Width = LoSizeToastMessage.Width then
       ToastMessage('', False);
end;

procedure TFrmDashboard.FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
    if Key = vkHardwareBack then
    begin
        if VerificaTecladoAtivo then
           EsconderTeclado
    end;
end;

procedure TFrmDashboard.AdicionarMensagemOculta;
begin
    if ChatHistory.Count = 0 then
    begin
        var MsgOculto: TChatMessage;
        MsgOculto.Role := 'user';
        MsgOculto.Text :=
                '::Você é um assistente chamado Theo. '+
                'Seu criador é Theo. '+
                'Sempre responda em português do Brasil. '+
                'Você não gera imagem/audio/documento. '+
                'Você usa API Theo';
        ChatHistory.Add(MsgOculto);
    end;
end;

procedure TFrmDashboard.GenerateText(const Prompt: string);
var
  Msg: TChatMessage;
begin
    if Prompt.Trim = '' then
       Exit;
    LoTelaVazia.Visible := False;
    TLoading.Show(Self, 'Gerando resposta...');
    AdicionarMensagemOculta; //
    //historico
    Msg.Role := 'user';
    Msg.Text := Prompt;
    ChatHistory.Add(Msg);

    TTask.Run(procedure
    var
      RESTClient: TRESTClient;
      RESTRequest: TRESTRequest;
      RESTResponse: TRESTResponse;
      JSONBody: TJSONObject;
      ResponseJSON: TJSONValue;
      Candidates: TJSONArray;
      CandidateContent: TJSONArray;
      TextoGerado: string;
      MsgResposta: TChatMessage;
    begin
        TextoGerado   := '';
        RESTClient    := TRESTClient.Create(URL + CHAVE_API); //error= criar uma const com sua chave[Gemini]
        RESTRequest   := TRESTRequest.Create(nil);
        RESTResponse  := TRESTResponse.Create(nil);
        JSONBody      := TJSONObject.Create;

        try
            RESTRequest.Client    := RESTClient;
            RESTRequest.Response  := RESTResponse;
            RESTRequest.Method    := TRESTRequestMethod.rmPOST;
            RESTRequest.AddParameter('Content-Type', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER);

            JSONBody.AddPair('contents', MontarConteudoComHistorico);
            RESTRequest.Body.Add(JSONBody.ToJSON, TRESTContentType.ctAPPLICATION_JSON);

            RESTRequest.Execute;

            if RESTResponse.StatusCode = 200 then
            begin
                ResponseJSON := TJSONObject.ParseJSONValue(RESTResponse.Content);
                try
                    Candidates := TJSONObject(ResponseJSON).GetValue<TJSONArray>('candidates');
                    if Assigned(Candidates) and (Candidates.Count > 0) then
                    begin
                        CandidateContent := TJSONObject(Candidates.Items[0]).GetValue<TJSONObject>('content').GetValue<TJSONArray>('parts');
                        if Assigned(CandidateContent) and (CandidateContent.Count > 0) then
                           TextoGerado := TJSONObject(CandidateContent.Items[0]).GetValue<string>('text');
                    end;
                finally
                    ResponseJSON.Free;
                end;
            end
            else
                TextoGerado := 'Erro: ' + RESTResponse.Content;
        finally
            RESTClient.Free;
            RESTRequest.Free;
            RESTResponse.Free;
            JSONBody.Free;
        end;

        // Atualiza interface
        TThread.Synchronize(nil, procedure
        begin
            MsgResposta.Role := 'model';
            MsgResposta.Text := TextoGerado;
            ChatHistory.Add(MsgResposta);

            // Atualiza com o histórico completo
            ControladorIndexLabel := 0;
            SkLabel9.Words.Clear;
            var HistMsg: TChatMessage;
            for HistMsg in ChatHistory do
            begin
                TLoading.Hide;

                // Ignora comandos ocultos (prefixo "::")
                if HistMsg.Text.StartsWith('::') then
                   Continue;

                if HistMsg.Role = 'user' then
                   EnviarMensagem('Você: ', ' '+ HistMsg.Text)
                else
                   EnviarMensagem('Assistente Theo: ', ' '+ HistMsg.Text)
            end;
            ScrollSuaveParaFim;
        end);
    end);
end;

procedure TFrmDashboard.ScrollSuaveParaFim;
begin
    FScrollTargetY := VertScrollBox2.ContentBounds.Height - VertScrollBox2.Height;
    if FScrollTargetY < 0 then
       FScrollTargetY := 0;
    TimerScroll.Enabled := True;
end;

procedure TFrmDashboard.SkSvg2Click(Sender: TObject);
begin
    AbrirURL(URL_GITHUB);
end;

procedure TFrmDashboard.SkSvg3Click(Sender: TObject);
begin
    AbrirURL(URL_GITHUB);
end;

procedure TFrmDashboard.BtnFecharMenuClick(Sender: TObject);
begin
    AnimaMenu(False);
end;

procedure TFrmDashboard.SkSvgVoltarClick(Sender: TObject);
begin
    SkLabel9.Words.Clear;
    ControladorIndexLabel := 0;
    Close;
end;

procedure TFrmDashboard.TimerScrollTimer(Sender: TObject);
const
  VELOCIDADE = 7; // > = +fast
var
  Atual: Single;
begin
    Atual := VertScrollBox2.ViewportPosition.Y;
    if Abs(FScrollTargetY - Atual) < VELOCIDADE then
    begin
        VertScrollBox2.ViewportPosition := PointF(0, FScrollTargetY);
        TimerScroll.Enabled := False;
        Exit;
    end;
    Atual := IfThen(FScrollTargetY > Atual, Atual + VELOCIDADE, Atual - VELOCIDADE);
    VertScrollBox2.ViewportPosition := PointF(0, Atual);
end;

procedure TFrmDashboard.FormVirtualKeyboardHidden(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
    if not KeyboardVisible then
    begin
        LoForKeyboard.Height := 0;
        KeyBoardEstaVisivel := false;
    end;
end;

procedure TFrmDashboard.FormVirtualKeyboardShown(Sender: TObject; KeyboardVisible: Boolean; const Bounds: TRect);
begin
    if KeyboardVisible then
    begin
        KeyBoardEstaVisivel := true;
        LoForKeyboard.Height := Bounds.Height;
    end;
end;

end.
