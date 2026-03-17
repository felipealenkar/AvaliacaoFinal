unit View.TipoCultura;

interface

uses
  DataModule.Icons, View.RelatorioTipoCultura, Model.TipoCultura, Model.Cultura, Controller.TipoCultura,
  System.Generics.Collections,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.Grids, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList;

type
  TFrmTipoCultura = class(TForm)
    PnlTipoCultura: TPanel;
    grpTipoCultura: TGroupBox;
    StrGrdTipoCultura: TStringGrid;
    VimgLTipoCultura: TVirtualImageList;
    RgOrdenacao: TRadioGroup;
    LblLocalizar: TLabel;
    EdtLocalizar: TEdit;
    StrGrdCulturasVinculadas: TStringGrid;
    PnlSair: TPanel;
    FlwPnlTipoCultura: TFlowPanel;
    SbtnNovo: TSpeedButton;
    SbtnEditar: TSpeedButton;
    SbtnExcluir: TSpeedButton;
    SbtnRelatorio: TSpeedButton;
    SbtnSair: TSpeedButton;
    TmrLocalizar: TTimer;

    procedure SbtnSairClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure RgOrdenacaoClick(Sender: TObject);
    procedure SbtnNovoClick(Sender: TObject);
    procedure SbtnEditarClick(Sender: TObject);
    procedure SbtnExcluirClick(Sender: TObject);
    procedure EdtLocalizarChange(Sender: TObject);
    procedure SbtnRelatorioClick(Sender: TObject);
    procedure StrGrdTipoCulturaSelectCell(Sender: TObject; ACol, ARow: LongInt; var CanSelect: Boolean);
    procedure StrGrdTipoCulturaDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect; State: TGridDrawState);
    procedure StrGrdCulturasVinculadasDrawCell(Sender: TObject; ACol, ARow: LongInt; Rect: TRect; State: TGridDrawState);
    procedure StrGrdTipoCulturaDblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TmrLocalizarTimer(Sender: TObject);

  private
    FTipoCulturaController: TTipoCulturaController;

    procedure ConfigurarGrids;
    procedure CarregarGridTipoCultura(PAcao: String);
    procedure CarregarGridCulturasVinculadas(PId_TipoCultura: Integer);
    procedure PintarPrimeiraLinhaNaGrid(Sender: TObject; ACol, ARow: LongInt; Rect: TRect; State: TGridDrawState);
    procedure AjustarUltimaColuna(PGrid: TStringGrid);

    function ObterOrdenacao: string;

    procedure Atualizar;
    procedure Inserir;
    procedure Excluir;

  public
    constructor Create(POwner: TComponent; PTipoCulturaController: TTipoCulturaController); reintroduce;
    destructor Destroy; override;
  end;

const
  CListar: string = 'Listar';
  CPesquisar: string = 'Pesquisar';

implementation

{$R *.dfm}

uses Factory.Provider;

{ TFrmTipoCultura }

procedure TFrmTipoCultura.CarregarGridCulturasVinculadas(PId_TipoCultura: Integer);
var
  LListaCulturasVinculadas: TObjectList<TCultura>;
  I: Integer;
begin
  LListaCulturasVinculadas := nil;
  StrGrdCulturasVinculadas.BeginUpdate;
  try
    LListaCulturasVinculadas := FTipoCulturaController.ListarCulturasVinculadas(PId_TipoCultura);
    StrGrdCulturasVinculadas.RowCount := LListaCulturasVinculadas.Count + 1;

    for I := 0 to LListaCulturasVinculadas.Count -1 do
    begin
      StrGrdCulturasVinculadas.Cells[0, I + 1] := LListaCulturasVinculadas[I].IdCultura.ToString;
      StrGrdCulturasVinculadas.Cells[1, I + 1] := LListaCulturasVinculadas[I].Nome;
      StrGrdCulturasVinculadas.Cells[2, I + 1] := DateToStr(LListaCulturasVinculadas[I].DataPlantio);
    end;
  finally
    LListaCulturasVinculadas.Free;
    StrGrdCulturasVinculadas.EndUpdate;
  end;
end;

procedure TFrmTipoCultura.CarregarGridTipoCultura(PAcao: String);
var
  LListaTipoCultura: TObjectList<TTipoCultura>;
  I: Integer;
begin
  LListaTipoCultura := nil;
  StrGrdTipoCultura.BeginUpdate;
  try
    if PAcao = CListar then LListaTipoCultura := FTipoCulturaController.Listar(ObterOrdenacao);
    if PAcao = CPesquisar then LListaTipoCultura := FTipoCulturaController.Pesquisar(EdtLocalizar.Text, ObterOrdenacao);
    StrGrdTipoCultura.RowCount := LListaTipoCultura.Count + 1;

    for I := 0 to LListaTipoCultura.Count - 1 do
    begin
      StrGrdTipoCultura.Cells[0, I + 1] := LListaTipoCultura[I].IdTipoCultura.ToString;
      StrGrdTipoCultura.Cells[1, I + 1] := LListaTipoCultura[I].Descricao;
    end;

    if StrGrdTipoCultura.RowCount > 1 then
    begin
      StrGrdTipoCultura.Row := 1;
      CarregarGridCulturasVinculadas(StrToIntDef(StrGrdTipoCultura.Cells[0, 1], 0));
    end;
  finally
    StrGrdTipoCultura.EndUpdate;
    LListaTipoCultura.Free;
  end;
end;

procedure TFrmTipoCultura.ConfigurarGrids;
begin
  // Grid Principal
  StrGrdTipoCultura.ColCount := 2;
  StrGrdTipoCultura.FixedRows := 1;
  StrGrdTipoCultura.FixedCols := 0;
  StrGrdTipoCultura.Options := StrGrdTipoCultura.Options + [goRowSelect] - [goEditing];

  StrGrdTipoCultura.Cells[0,0] := 'Id';
  StrGrdTipoCultura.Cells[1,0] := 'Descrição';
  StrGrdTipoCultura.ColWidths[0] := 50;
  StrGrdTipoCultura.ColWidths[1] := 120;
  StrGrdTipoCultura.ColWidths[1] := 200;

  // Grid de Culturas Vinculadas
  StrGrdCulturasVinculadas.ColCount := 3;
  StrGrdCulturasVinculadas.FixedRows := 1;
  StrGrdCulturasVinculadas.FixedCols := 0;
  StrGrdCulturasVinculadas.Options := StrGrdCulturasVinculadas.Options + [goRowSelect] - [goEditing];

  StrGrdCulturasVinculadas.Cells[0,0] := 'Id';
  StrGrdCulturasVinculadas.Cells[1,0] := 'Culturas vinculadas';
  StrGrdCulturasVinculadas.Cells[2,0] := 'Data de plantio';

  StrGrdCulturasVinculadas.ColWidths[0] := 40;
  StrGrdCulturasVinculadas.ColWidths[1] := 200;
  StrGrdCulturasVinculadas.ColWidths[2] := 120;

  RgOrdenacao.ItemIndex := 0;
  AjustarUltimaColuna(StrGrdTipoCultura);
  AjustarUltimaColuna(StrGrdCulturasVinculadas);
end;

constructor TFrmTipoCultura.Create(POwner: TComponent; PTipoCulturaController: TTipoCulturaController);
begin
  inherited Create(POwner);
  FTipoCulturaController := PTipoCulturaController;
  ConfigurarGrids;
end;

destructor TFrmTipoCultura.Destroy;
begin
  FTipoCulturaController.Free;
  inherited;
end;

procedure TFrmTipoCultura.EdtLocalizarChange(Sender: TObject);
begin
  TmrLocalizar.Enabled := False;
  TmrLocalizar.Enabled := True;
end;

procedure TFrmTipoCultura.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmTipoCultura.FormDestroy(Sender: TObject);
begin
  //Isso aqui envia a mensagem ao form pai para habilitar o botão que o chamou.
  if (Owner is TForm) and not (csDestroying in TForm(Owner).ComponentState) then
    PostMessage(TForm(Owner).Handle, WM_USER + 1234, 0, 0);
end;

procedure TFrmTipoCultura.FormResize(Sender: TObject);
begin
  AjustarUltimaColuna(StrGrdTipoCultura);
  AjustarUltimaColuna(StrGrdCulturasVinculadas);
end;

procedure TFrmTipoCultura.FormShow(Sender: TObject);
begin
  CarregarGridTipoCultura(CListar);
  EdtLocalizar.SetFocus;
end;

function TFrmTipoCultura.ObterOrdenacao: string;
begin
  case RgOrdenacao.ItemIndex of
    0: Result := 'id_tipocultura';
    1: Result := 'descricao';
  else
    Result := 'id_tipocultura';
  end;
end;

procedure TFrmTipoCultura.PintarPrimeiraLinhaNaGrid(Sender: TObject; ACol,
      ARow: LongInt; Rect: TRect; State: TGridDrawState);
var
  Texto: string;
  LGrid: TStringGrid;
begin
  if not (Sender is TStringGrid) then
    Exit;

  LGrid := TStringGrid(Sender);

  if ARow = 0 then
  begin
    Texto := LGrid.Cells[ACol, ARow];
    LGrid.Canvas.Brush.Color := clBtnFace;
    LGrid.Canvas.FillRect(Rect);
    LGrid.Canvas.Font.Style := [fsBold];

    DrawText(
      LGrid.Canvas.Handle,
      PChar(Texto),
      Length(Texto),
      Rect,
      DT_LEFT or DT_VCENTER or DT_SINGLELINE
    );
  end;
end;

procedure TFrmTipoCultura.RgOrdenacaoClick(Sender: TObject);
begin
  CarregarGridTipoCultura(CPesquisar);
end;

procedure TFrmTipoCultura.AjustarUltimaColuna(PGrid: TStringGrid);
var
  I, LLarguraOcupada: Integer;
begin
  LLarguraOcupada := 0;

  // Soma a largura de todas as colunas anteriores (no seu caso, apenas a coluna 0)
  for I := 0 to PGrid.ColCount - 2 do
    LLarguraOcupada := LLarguraOcupada + PGrid.ColWidths[I];

  // Subtraímos 4 pixels de margem de segurança para evitar a scrollbar horizontal.
  PGrid.ColWidths[PGrid.ColCount - 1] := PGrid.ClientWidth - LLarguraOcupada - 1;
end;

procedure TFrmTipoCultura.Atualizar;
var
  LIdTipoCultura: Integer;
  LDescricaoAtual: string;
  LNovaDescricao: string;
  LResposta: Boolean;
begin
  if StrGrdTipoCultura.Row <= 0 then
  begin
    MessageBox(Handle, PChar('Selecione um registro.'), 'HortiSys', MB_OK or MB_ICONINFORMATION or MB_TASKMODAL);
    Exit;
  end;

  LIdTipoCultura := StrToInt(StrGrdTipoCultura.Cells[0, StrGrdTipoCultura.Row]);
  LDescricaoAtual := StrGrdTipoCultura.Cells[1, StrGrdTipoCultura.Row];
  repeat
    LResposta := InputQuery('Descrição:', 'Editar tipo de cultura', LDescricaoAtual);
    if LResposta then
    try
      if Trim(LDescricaoAtual) <> '' then
      begin
        LNovaDescricao := LDescricaoAtual;
        FTipoCulturaController.Atualizar(LIdTipoCultura, LNovaDescricao);
        CarregarGridTipoCultura(CListar);
        Exit;
      end;
      MessageBox(0, PChar('Digite a descrição.'), 'Inserir', MB_OK or MB_ICONWARNING or MB_TASKMODAL);
    except
      on E: Exception do
        MessageBox(0, PChar(E.ToString), 'Inserir', MB_OK or MB_ICONINFORMATION or MB_TASKMODAL);
    end;
  until not LResposta;
end;

procedure TFrmTipoCultura.SbtnEditarClick(Sender: TObject);
begin
  Atualizar;
end;

procedure TFrmTipoCultura.SbtnExcluirClick(Sender: TObject);
begin
  Excluir;
end;

procedure TFrmTipoCultura.Excluir;
var
  LIdTipoCultura: Integer;
begin
  if StrGrdTipoCultura.Row <= 0 then
  begin
    MessageBox(Handle, PChar('Selecione um registro.'), 'HortiSys', MB_OK or MB_ICONINFORMATION or MB_TASKMODAL);
    Exit;
  end;

  LIdTipoCultura := StrToIntDef(StrGrdTipoCultura.Cells[0, StrGrdTipoCultura.Row], 0);

  if LIdTipoCultura = 0 then
    Exit;

  if MessageBox(Handle, PChar('Confirma a exclusão do registro?.'), 'HortiSys', MB_YESNO or MB_ICONQUESTION or MB_TASKMODAL) = IDYES then
  begin
    FTipoCulturaController.Excluir(LIdTipoCultura);
    CarregarGridTipoCultura(CListar);
  end;
end;

procedure TFrmTipoCultura.SbtnNovoClick(Sender: TObject);
begin
  Inserir;
end;

procedure TFrmTipoCultura.Inserir;
var
  LDescricao: String;
  LResposta: Boolean;
begin
  repeat
    LResposta := InputQuery('Descrição:', 'Novo tipo de cultura', LDescricao);
    if LResposta then
    try
      if Trim(LDescricao) <> '' then
      begin
        FTipoCulturaController.Inserir(LDescricao);
        CarregarGridTipoCultura(CListar);
        Exit;
      end;
      MessageBox(0, PChar('Digite a descrição.'), 'Inserir', MB_OK or MB_ICONWARNING or MB_TASKMODAL);
    except
      on E: Exception do
        MessageBox(0, PChar(E.ToString), 'Inserir', MB_OK or MB_ICONWARNING or MB_TASKMODAL);
    end;
  until not LResposta;
end;

procedure TFrmTipoCultura.SbtnRelatorioClick(Sender: TObject);
var
  LFrmRelatorioTipoCultura: TFrmRelatorioTipoCultura;
begin
  LFrmRelatorioTipoCultura := TProviderFactory.NewRelatorioTipoCulturaView(Self);
  LFrmRelatorioTipoCultura.CarregarRelatorio(EdtLocalizar.Text, ObterOrdenacao);
end;

procedure TFrmTipoCultura.SbtnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmTipoCultura.StrGrdCulturasVinculadasDrawCell(Sender: TObject;
  ACol, ARow: LongInt; Rect: TRect; State: TGridDrawState);
begin
  PintarPrimeiraLinhaNaGrid(Sender, ACol, ARow, Rect, State);
end;

procedure TFrmTipoCultura.StrGrdTipoCulturaDblClick(Sender: TObject);
begin
  Atualizar;
end;

procedure TFrmTipoCultura.StrGrdTipoCulturaDrawCell(Sender: TObject; ACol,
  ARow: LongInt; Rect: TRect; State: TGridDrawState);
begin
  PintarPrimeiraLinhaNaGrid(Sender, ACol, ARow, Rect, State);
end;

procedure TFrmTipoCultura.StrGrdTipoCulturaSelectCell(Sender: TObject; ACol, ARow: LongInt; var CanSelect: Boolean);
var
  LIdCultura: Integer;
begin
  if ARow > 0 then
  begin
    LIdCultura := StrToIntDef(StrGrdTipoCultura.Cells[0, ARow], 0);
    CarregarGridCulturasVinculadas(LIdCultura);
  end;
end;
procedure TFrmTipoCultura.TmrLocalizarTimer(Sender: TObject);
begin
  TmrLocalizar.Enabled := False;
  CarregarGridTipoCultura(CPesquisar);
end;

end.
