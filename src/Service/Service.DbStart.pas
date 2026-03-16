unit Service.DbStart;

interface

uses
  Model.DbStart, Repository.DbStart, System.SysUtils, FireDAC.Comp.Client;

type
  TDbStartService = class
  private
    FDbStartRepository: TDbStartRepository;
  public
    constructor Create(PDbStartRepository: TDbStartRepository);
    destructor Destroy; override;
    function VerificarAmbiente: Boolean;
    procedure InstalarBancoDeDados;
  end;

implementation

{ TDbStartService }

function TDbStartService.VerificarAmbiente: Boolean;
begin
  Result := FDbStartRepository.ExistirBancoDeDados;
end;

constructor TDbStartService.Create(PDbStartRepository: TDbStartRepository);
begin
  inherited Create;
  FDbStartRepository := PDbStartRepository;
end;

destructor TDbStartService.Destroy;
begin
  FDbStartRepository.Free;
  inherited;
end;

procedure TDbStartService.InstalarBancoDeDados;
begin
  if not FDbStartRepository.ExistirBancoDeDados then
    FDbStartRepository.CriarDatabase;

  FDbStartRepository.CriarSchema;
  FDbStartRepository.CriarTabelaTipoCultura;
  FDbStartRepository.CriarTabelaCultura;
  FDbStartRepository.CriarTabelaTipoManejo;
  FDbStartRepository.CriarTabelaManejo;
end;

end.

