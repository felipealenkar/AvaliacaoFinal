unit Controller.DbStart;

interface

uses
  Service.DbStart;

type
  TDBStartController = class
  private
    FDbStartService: TDbStartService;
  public
    constructor Create(PDbStartService: TDbStartService);
    destructor Destroy; override;
    function VerificarAmbiente: Boolean;
    procedure IniciarAmbiente;
  end;
implementation

{ TDBStartController }

constructor TDBStartController.Create(PDbStartService: TDbStartService);
begin
  inherited Create;
  FDbStartService := PDbStartService;
end;

destructor TDBStartController.Destroy;
begin
  FDbStartService.Free;
  inherited;
end;

procedure TDBStartController.IniciarAmbiente;
begin
  FDbStartService.InstalarBancoDeDados;
end;

function TDBStartController.VerificarAmbiente: Boolean;
begin
  Result := FDbStartService.VerificarAmbiente;
end;

end.
