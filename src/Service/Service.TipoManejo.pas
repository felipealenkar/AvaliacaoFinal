unit Service.TipoManejo;

interface

uses
  System.Generics.Collections, System.SysUtils,
  Model.TipoManejo, Model.Manejo,
  Repository.TipoManejo;

type
  TTipoManejoService = class
  private
    FTipoManejoRepository: TTipoManejoRepository;

  public
    constructor Create(PTipoManejoRepository: TTipoManejoRepository);
    destructor Destroy; override;

    procedure Inserir(PTipoManejo: TTipoManejo);
    procedure Atualizar(PTipoManejo: TTipoManejo);
    procedure Excluir(PIdTipoManejo: Integer);

    function Listar(POrdenacao: string): TObjectList<TTipoManejo>;
    function ListarManejosVinculados(PId_TipoManejo: Integer): TObjectList<TManejo>;
    function Pesquisar(PBusca, POrdenacao: string): TObjectList<TTipoManejo>;
  end;

implementation

{ TTipoManejoService }

constructor TTipoManejoService.Create(PTipoManejoRepository: TTipoManejoRepository);
begin
  inherited Create;
  FTipoManejoRepository := PTipoManejoRepository;
end;

destructor TTipoManejoService.Destroy;
begin
  FTipoManejoRepository.Free;
  inherited;
end;

procedure TTipoManejoService.Inserir(PTipoManejo: TTipoManejo);
begin
  if FTipoManejoRepository.ExisteDescricao(PTipoManejo.Descricao, PTipoManejo.IdTipoManejo) then
    raise Exception.Create('Já existe um tipo de manejo cadastrado com este nome.');

  FTipoManejoRepository.Inserir(PTipoManejo);
end;

procedure TTipoManejoService.Atualizar(PTipoManejo: TTipoManejo);
begin
  if FTipoManejoRepository.ExisteDescricao(PTipoManejo.Descricao, PTipoManejo.IdTipoManejo) then
    raise Exception.Create('Já existe um tipo de manejo cadastrado com este nome.');

  FTipoManejoRepository.Atualizar(PTipoManejo);
end;

procedure TTipoManejoService.Excluir(PIdTipoManejo: Integer);
begin
  if FTipoManejoRepository.ExisteNaTabelaManejo(PIdTipoManejo) then
    raise Exception.Create('Não é possível excluir o tipo de manejo, ele está sendo usado em algum manejo');

  FTipoManejoRepository.Excluir(PIdTipoManejo);
end;

function TTipoManejoService.Listar(POrdenacao: string): TObjectList<TTipoManejo>;
begin
  Result := FTipoManejoRepository.Listar(POrdenacao);
end;

function TTipoManejoService.ListarManejosVinculados(PId_TipoManejo: Integer): TObjectList<TManejo>;
begin
  Result := FTipoManejoRepository.ListarManejosVinculados(PId_TipoManejo);
end;

function TTipoManejoService.Pesquisar(PBusca, POrdenacao: string): TObjectList<TTipoManejo>;
begin
  Result := FTipoManejoRepository.Pesquisar(PBusca, POrdenacao);
end;

end.
