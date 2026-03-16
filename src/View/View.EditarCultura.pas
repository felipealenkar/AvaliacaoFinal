unit View.EditarCultura;

interface

uses
  DataModule.Icons, Controller.TipoCultura, Controller.Cultura, Controller.ApiCultura, Model.Cultura, Model.TipoCultura,
  System.Generics.Collections,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Buttons, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList,
  Vcl.VirtualImage, Vcl.ExtDlgs, Vcl.Imaging.pngimage;

type
  TFrmEditarCultura = class(TForm)
    PnlEditarCultura: TPanel;
    LblTipoCultura: TLabel;
    LblDescricao: TLabel;
    LblId: TLabel;
    EdtDescricao: TEdit;
    EdtId: TEdit;
    CbbTipoCultura: TComboBox;
    DtpDataPlantio: TDateTimePicker;
    LblDataPlantio: TLabel;
    ChkAtiva: TCheckBox;
    FlwPnlCultura: TFlowPanel;
    VimgLCultura: TVirtualImageList;
    DlgOpenPicImg: TOpenPictureDialog;
    VimgLCulturaMenor: TVirtualImageList;
    ImgFoto: TImage;
    RgAPIs: TRadioGroup;
    SpeedButton1: TSpeedButton;
    SbtnSalvar: TSpeedButton;
    SbtnSair: TSpeedButton;
    SbtnAbrirImg: TSpeedButton;
    SbtnImgPorApi: TSpeedButton;
    SbtnLimparImg: TSpeedButton;
    RgChaveGemini: TRadioGroup;
    procedure SbtnSalvarClick(Sender: TObject);
    procedure SbtnSairClick(Sender: TObject);
    procedure SbtnAbrirImgClick(Sender: TObject);
    procedure SbtnLimparImgClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SbtnImgPorApiClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure RgChaveGeminiClick(Sender: TObject);
    procedure EscolherChaveGemini;
  private
    FCulturaController: TCulturaController;
    FTipoCulturaController: TTipoCulturaController;
    FCulturaApiController: TCulturaApiController;
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;

    procedure CarregarTiposCultura;
    procedure CarregarImagemPorArquivo;
    procedure CarregarImagemPorMemoryStream(PFoto: TMemoryStream);
    procedure ModoInsercao;
    procedure ModoEdicao(PId: Integer);
    procedure Salvar;
  end;

implementation

{$R *.dfm}
uses
  Factory.Provider;
{ TFrmEditarCultura }

procedure TFrmEditarCultura.ModoEdicao(PId: Integer);
var
  LCultura: TCultura;
  I: Integer;
begin
  DtpDataPlantio.Enabled := False;
  CarregarTiposCultura;
  LCultura := FCulturaController.ObterPorId(PId);
  try
    EdtId.Text := LCultura.IdCultura.ToString;
    EdtDescricao.Text := LCultura.Nome;
    ChkAtiva.Checked := LCultura.Ativo;
    DtpDataPlantio.Date := LCultura.DataPlantio;
    CarregarImagemPorMemoryStream(LCultura.Foto);

    for I := 0 to CbbTipoCultura.Items.Count - 1 do
    begin
      if Integer(CbbTipoCultura.Items.Objects[I]) = LCultura.IdTipoCultura then
      begin
        CbbTipoCultura.ItemIndex := I;
        Break;
      end;
    end;
  finally
    LCultura.Free;
  end;
end;

procedure TFrmEditarCultura.CarregarImagemPorArquivo;
begin
  if DlgOpenPicImg.Execute then
    ImgFoto.Picture.LoadFromFile(DlgOpenPicImg.FileName);
end;

procedure TFrmEditarCultura.CarregarImagemPorMemoryStream(PFoto: TMemoryStream);
var
  LImgCultura: TBitmap;
begin
  LImgCultura := nil;
  try
    if Assigned(PFoto) and (PFoto.Size > 0) then
      begin
        PFoto.Position := 0;
        ImgFoto.Picture.LoadFromStream(PFoto);
      end
      else
      begin
        LImgCultura := DmIcons.ImgCltIcons.GetBitmap(13, ImgFoto.Width, ImgFoto.Height);
        ImgFoto.Picture.Bitmap := LImgCultura;
      end;
  finally
    LImgCultura.Free;
  end;
end;

procedure TFrmEditarCultura.CarregarTiposCultura;
var
  LLista: TObjectList<TTipoCultura>;
  I: Integer;
begin
  CbbTipoCultura.Items.Clear;

  LLista := FTipoCulturaController.Listar('descricao');
  try
    for I := 0 to LLista.Count - 1 do
    begin
      CbbTipoCultura.Items.AddObject(
        LLista[I].Descricao,
        TObject(LLista[I].IdTipoCultura)
      );
    end;
  finally
    LLista.Free;
  end;
end;

constructor TFrmEditarCultura.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCulturaController := TProviderFactory.NewCulturaController;
  FTipoCulturaController := TProviderFactory.NewTipoCulturaController;
  FCulturaApiController := TProviderFactory.NewCulturaApiController;
end;

destructor TFrmEditarCultura.Destroy;
begin
  FCulturaController.Free;
  FTipoCulturaController.Free;
  FCulturaApiController.Free;
  inherited;
end;

procedure TFrmEditarCultura.EscolherChaveGemini;
var
  LChave: String;
  LResposta: Boolean;
begin
  if RgChaveGemini.ItemIndex = 0 then
  begin
    FCulturaApiController.AtualizarChaveGemini('AIzaSyDPdAyuuvTwzMgghmZFoYvYv0jSbhEZBbk');
    MessageBox(0, PChar('A chave padrão foi definida'),
                        'Chave Gemini', MB_OK or MB_ICONINFORMATION or MB_TASKMODAL);
  end
  else
  begin
    repeat
    LResposta := InputQuery('Digite a chave:', 'Chave Gemini', LChave);
    if LResposta then
    try
      if Trim(LChave) <> '' then
      begin
        FCulturaApiController.AtualizarChaveGemini(LChave);
        MessageBox(0, PChar('A chave personalizada foi definida'),
                        'Chave Gemini', MB_OK or MB_ICONINFORMATION or MB_TASKMODAL);
        Exit;
      end;
    except
      on E: Exception do
        MessageBox(0, PChar(E.ToString), 'Inserir', MB_OK or MB_ICONINFORMATION or MB_TASKMODAL);
    end;
  until not LResposta;
  end;
end;

procedure TFrmEditarCultura.FormShow(Sender: TObject);
begin
  RgAPIs.ItemIndex := 0;
  EdtDescricao.SetFocus;
end;

procedure TFrmEditarCultura.ModoInsercao;
begin
  CarregarTiposCultura;
  EdtId.Text := '0';
  EdtDescricao.Text := EmptyStr;
  CbbTipoCultura.ItemIndex := -1;
  ChkAtiva.Checked := True;
  DtpDataPlantio.DateTime := Now;
end;

procedure TFrmEditarCultura.RgChaveGeminiClick(Sender: TObject);
begin
  EscolherChaveGemini;
end;

procedure TFrmEditarCultura.Salvar;
var
  LIdCultura: Integer;
  LIdTipoCultura: Integer;
  LFotoStream: TMemoryStream;
begin
  LFotoStream := TMemoryStream.Create;
  try
    if CbbTipoCultura.ItemIndex < 0 then
    begin
      MessageBox(Handle,
        PChar('Selecione um Tipo de Cultura.'), 'HortiSys', MB_OK or MB_ICONWARNING or MB_TASKMODAL);
      Exit;
    end;
    LIdCultura := StrToIntDef(EdtId.Text,0);
    LIdTipoCultura := Integer(CbbTipoCultura.Items.Objects[CbbTipoCultura.ItemIndex]);

    if Assigned(ImgFoto.Picture.Graphic) then
    begin
      ImgFoto.Picture.Graphic.SaveToStream(LFotoStream);
      LFotoStream.Position := 0;
    end
    else
      LFotoStream.Clear;

    if LIdCultura = 0 then
      FCulturaController.Inserir(EdtDescricao.Text, LIdTipoCultura,
                                DtpDataPlantio.DateTime, ChkAtiva.Checked, LFotoStream)
    else
      FCulturaController.Atualizar(LIdCultura, EdtDescricao.Text, LIdTipoCultura,
                                  DtpDataPlantio.DateTime, ChkAtiva.Checked, LFotoStream);
    ModalResult := mrOk;
  finally
    LFotoStream.Free;
  end;
end;

procedure TFrmEditarCultura.SbtnAbrirImgClick(Sender: TObject);
begin
  CarregarImagemPorArquivo;
end;

procedure TFrmEditarCultura.SbtnImgPorApiClick(Sender: TObject);
var
  LImgCultura: TMemoryStream;
begin
  if Trim(EdtDescricao.Text) = '' then
  begin
    MessageBox(0, PChar('!!!Digite o nome da planta!!!.'),
                        'Buscar na web', MB_OK or MB_ICONINFORMATION or MB_TASKMODAL);
    Exit;
  end;

  LImgCultura := FCulturaApiController.ObterUrlFotoPorApi(EdtDescricao.Text, RgAPIs.Items.Strings[RgAPIs.ItemIndex]);
  try
    CarregarImagemPorMemoryStream(LImgCultura);
  finally
    LImgCultura.Free;
  end;
end;

procedure TFrmEditarCultura.SbtnLimparImgClick(Sender: TObject);
begin
  ImgFoto.Picture.Graphic := nil;
end;

procedure TFrmEditarCultura.SbtnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmEditarCultura.SbtnSalvarClick(Sender: TObject);
begin
  Salvar;
end;

procedure TFrmEditarCultura.SpeedButton1Click(Sender: TObject);
begin
  MessageBox(0, PChar('!!!Ao clicar no botão "Buscar na web" o sistema consultará na web para obter a imagem.' + sLineBreak +
                     'A consulta é inteligente e na maioria das vezes vai funcionar mesmo com erros de português.' + sLineBreak + sLineBreak +
                     'A chave do Gemini é minha, porém se bloquear pode se utilizar qualquer chave, basta marcar a opção "Usar minha chave Gemini".'),
                        'Ajuda', MB_OK or MB_ICONINFORMATION or MB_TASKMODAL);
end;

end.
