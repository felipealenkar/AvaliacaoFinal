unit Controller.Manejo;

interface

uses
  System.SysUtils, System.Generics.Collections,
  Model.Manejo, Service.Manejo;

type
  TManejoController = class
  private
    FManejoService: TManejoService;
  public
    constructor Create(PManejoService: TManejoService);
    destructor Destroy; override;

    procedure Inserir(PIdTipoManejo: Integer; PIdCultura: Integer; PDataManejo: TDateTime;
                                    PQuantidade: Double; PDescricao, PUnidade, PObservacao: string);

    procedure Atualizar(PIdManejo: Integer; PIdTipoManejo: Integer; PIdCultura: Integer; PDataManejo: TDateTime;
                                    PQuantidade: Double; PDescricao, PUnidade, PObservacao: string);

    procedure Excluir(PId: Integer);

    function Listar(POrdenacao: string): TObjectList<TManejo>;
    function Pesquisar(PBusca, POrdenacao: string): TObjectList<TManejo>;
    function ObterPorId(PId: Integer): TManejo;

    function ListarPorCultura(PIdCultura: Integer): TObjectList<TManejo>;
  end;

implementation

{ TManejoController }

constructor TManejoController.Create(PManejoService: TManejoService);
begin
  FManejoService := PManejoService;
end;

destructor TManejoController.Destroy;
begin
  FManejoService.Free;
  inherited;
end;

procedure TManejoController.Inserir(PIdTipoManejo: Integer; PIdCultura: Integer; PDataManejo: TDateTime;
                                    PQuantidade: Double; PDescricao, PUnidade, PObservacao: string);
var
  LManejo: TManejo;
begin
  LManejo := TManejo.Create;
  try
    LManejo.IdTipoManejo := PIdTipoManejo;
    LManejo.IdCultura := PIdCultura;
    LManejo.DataManejo := PDataManejo;
    LManejo.Quantidade := PQuantidade;
    LManejo.Descricao := PDescricao;
    LManejo.Unidade := PUnidade;
    LManejo.Observacao := PObservacao;

    FManejoService.Inserir(LManejo);
  finally
    LManejo.Free;
  end;
end;

procedure TManejoController.Atualizar(PIdManejo: Integer; PIdTipoManejo: Integer; PIdCultura: Integer; PDataManejo: TDateTime;
                                    PQuantidade: Double; PDescricao, PUnidade, PObservacao: string);
var
  LManejo: TManejo;
begin
  LManejo := FManejoService.ObterPorId(PIdManejo);

  if not Assigned(LManejo) then
    raise Exception.Create('Manejo não encontrado');

  try
    LManejo.IdTipoManejo := PIdTipoManejo;
    LManejo.IdCultura := PIdCultura;
    LManejo.DataManejo := PDataManejo;
    LManejo.Quantidade := PQuantidade;
    LManejo.Descricao := PDescricao;
    LManejo.Unidade := PUnidade;
    LManejo.Observacao := PObservacao;

    FManejoService.Atualizar(LManejo);
  finally
    LManejo.Free;
  end;
end;

procedure TManejoController.Excluir(PId: Integer);
begin
  FManejoService.Excluir(PId);
end;

function TManejoController.Listar(POrdenacao: string): TObjectList<TManejo>;
begin
  Result := FManejoService.Listar(POrdenacao);
end;

function TManejoController.Pesquisar(PBusca, POrdenacao: string): TObjectList<TManejo>;
begin
  Result := FManejoService.Pesquisar(PBusca, POrdenacao);
end;

function TManejoController.ObterPorId(PId: Integer): TManejo;
begin
  Result := FManejoService.ObterPorId(PId);
end;

function TManejoController.ListarPorCultura(PIdCultura: Integer): TObjectList<TManejo>;
begin
  Result := FManejoService.ListarPorCultura(PIdCultura);
end;

end.
