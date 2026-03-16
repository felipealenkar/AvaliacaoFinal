unit Service.Manejo;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Classes,
  Model.Manejo,
  Repository.Manejo;

type
  TManejoService = class
  private
    FManejoRepository: TManejoRepository;
  public
    constructor Create(PManejoRepository: TManejoRepository);
    destructor Destroy; override;

    procedure Inserir(PManejo: TManejo);
    procedure Atualizar(PManejo: TManejo);
    procedure Excluir(PId: Integer);

    function Listar(POrdenacao: string): TObjectList<TManejo>;
    function Pesquisar(PBusca, POrdenacao: string): TObjectList<TManejo>;
    function ObterPorId(PId: Integer): TManejo;

    function ListarPorCultura(PIdCultura: Integer): TObjectList<TManejo>;
  end;

implementation

{ TManejoService }

constructor TManejoService.Create(PManejoRepository: TManejoRepository);
begin
  inherited Create;
  FManejoRepository := PManejoRepository;
end;

destructor TManejoService.Destroy;
begin
  FManejoRepository.Free;
  inherited;
end;

procedure TManejoService.Inserir(PManejo: TManejo);
begin
  FManejoRepository.Inserir(PManejo);
end;

procedure TManejoService.Atualizar(PManejo: TManejo);
begin
  FManejoRepository.Atualizar(PManejo);
end;

procedure TManejoService.Excluir(PId: Integer);
begin
  FManejoRepository.Excluir(PId);
end;

function TManejoService.Listar(POrdenacao: string): TObjectList<TManejo>;
begin
  Result := FManejoRepository.Listar(POrdenacao);
end;

function TManejoService.ObterPorId(PId: Integer): TManejo;
begin
  Result := FManejoRepository.ObterPorId(PId);
end;

function TManejoService.Pesquisar(PBusca, POrdenacao: string): TObjectList<TManejo>;
begin
  Result := FManejoRepository.Pesquisar(PBusca, POrdenacao);
end;

function TManejoService.ListarPorCultura(PIdCultura: Integer): TObjectList<TManejo>;
begin
  Result := FManejoRepository.ListarPorCultura(PIdCultura);
end;

end.
