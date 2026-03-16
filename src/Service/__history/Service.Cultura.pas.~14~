unit Service.Cultura;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Classes,
  Model.Cultura,
  Repository.Cultura;

type
  TCulturaService = class
  private
    FCulturaRepository: TCulturaRepository;
  public
    constructor Create(PCulturaRepository: TCulturaRepository);
    destructor Destroy; override;

    procedure Inserir(PCultura: TCultura);
    procedure Atualizar(PCultura: TCultura);
    procedure Excluir(PId: Integer);

    function Listar(POrdenacao: string): TObjectList<TCultura>;
    function Pesquisar(PBusca, POrdenacao: string): TObjectList<TCultura>;
    function ObterPorId(PId: Integer): TCultura;
  end;

implementation

{ TCulturaService }

constructor TCulturaService.Create(PCulturaRepository: TCulturaRepository);
begin
  inherited Create;
  FCulturaRepository := PCulturaRepository;
end;

destructor TCulturaService.Destroy;
begin
  FCulturaRepository.Free;
  inherited;
end;

procedure TCulturaService.Inserir(PCultura: TCultura);
begin
  if FCulturaRepository.ExisteNome(PCultura.Nome, PCultura.IdCultura) then
    raise Exception.Create('Já existe uma cultura cadastrado com este nome.');

  FCulturaRepository.Inserir(PCultura);
end;

procedure TCulturaService.Atualizar(PCultura: TCultura);
begin
  FCulturaRepository.Atualizar(PCultura);
end;

procedure TCulturaService.Excluir(PId: Integer);
begin
  FCulturaRepository.Excluir(PId);
end;

function TCulturaService.Listar(POrdenacao: string): TObjectList<TCultura>;
begin
  Result := FCulturaRepository.Listar(POrdenacao);
end;

function TCulturaService.ObterPorId(PId: Integer): TCultura;
begin
  Result := FCulturaRepository.ObterPorId(PId);
end;

function TCulturaService.Pesquisar(PBusca, POrdenacao: string): TObjectList<TCultura>;
begin
  Result := FCulturaRepository.Pesquisar(PBusca, POrdenacao);
end;

end.
