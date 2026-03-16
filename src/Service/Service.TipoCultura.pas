unit Service.TipoCultura;

interface

uses
  System.Generics.Collections, System.SysUtils,
  Model.TipoCultura, Model.Cultura,
  Repository.TipoCultura;

type
  TTipoCulturaService = class
  private
    FTipoCulturaRepository: TTipoCulturaRepository;
  public
    constructor Create(PTipoCulturaRepository: TTipoCulturaRepository);
    destructor Destroy; override;

    procedure Inserir(PTipoCultura: TTipoCultura);
    procedure Atualizar(PTipoCultura: TTipoCultura);
    procedure Excluir(PIdTipoCultura: Integer);

    function Listar(POrdenacao: string): TObjectList<TTipoCultura>;
    function ListarCulturasVinculadas(PId_TipoCultura: Integer): TObjectList<TCultura>;
    function Pesquisar(PBusca, POrdenacao: string): TObjectList<TTipoCultura>;
  end;

implementation
{ TTipoCulturaService }

procedure TTipoCulturaService.Atualizar(PTipoCultura: TTipoCultura);
begin
  if FTipoCulturaRepository.ExisteDescricao(PTipoCultura.Descricao, PTipoCultura.IdTipoCultura) then
    raise Exception.Create('Já existe um tipo de cultura cadastrado com este nome.');

  FTipoCulturaRepository.Atualizar(PTipoCultura);
end;

constructor TTipoCulturaService.Create(PTipoCulturaRepository: TTipoCulturaRepository);
begin
  inherited Create;
  FTipoCulturaRepository := PTipoCulturaRepository;
end;

destructor TTipoCulturaService.Destroy;
begin
  FTipoCulturaRepository.Free;
  inherited;
end;

procedure TTipoCulturaService.Excluir(PIdTipoCultura: Integer);
begin
  if FTipoCulturaRepository.ExisteNaTabelaCultura(PIdTipoCultura) then
    raise Exception.Create('Não é possível excluir o tipo de cultura, ele está sendo usado em alguma cultura');

  FTipoCulturaRepository.Excluir(PIdTipoCultura);
end;

function TTipoCulturaService.Listar(POrdenacao: string): TObjectList<TTipoCultura>;
begin
  Result := FTipoCulturaRepository.Listar(POrdenacao);
end;

function TTipoCulturaService.ListarCulturasVinculadas(PId_TipoCultura: Integer): TObjectList<TCultura>;
begin
  Result := FTipoCulturaRepository.ListarCulturasVinculadas(PId_TipoCultura);
end;

function TTipoCulturaService.Pesquisar(PBusca, POrdenacao: string): TObjectList<TTipoCultura>;
begin
  Result := FTipoCulturaRepository.Pesquisar(PBusca, POrdenacao);
end;

procedure TTipoCulturaService.Inserir(PTipoCultura: TTipoCultura);
begin
  if FTipoCulturaRepository.ExisteDescricao(PTipoCultura.Descricao, PTipoCultura.IdTipoCultura) then
    raise Exception.Create('Já existe um tipo de cultura cadastrado com este nome.');

  FTipoCulturaRepository.Inserir(PTipoCultura);
end;
end.
