unit Controller.ApiCultura;

interface

uses
  Service.ApiCultura,
  System.SysUtils,
  System.Generics.Collections,
  System.Classes;

type
  TCulturaApiController = class
  private
    FCulturaApiService: TCulturaApiService;
  public
    constructor Create(PCulturaApiService: TCulturaApiService);
    destructor Destroy; override;
  function ObterUrlFotoPorApi(PNome, PNomeApi: String): TMemoryStream;
  end;

implementation

{ TCulturaService }

function TCulturaApiController.ObterUrlFotoPorApi(PNome, PNomeApi: String): TMemoryStream;
begin
  Result := FCulturaApiService.ObterUrlFotoPorApi(PNome, PNomeApi);
end;

constructor TCulturaApiController.Create(PCulturaApiService: TCulturaApiService);
begin
  inherited Create;
  FCulturaApiService := PCulturaApiService;
end;

destructor TCulturaApiController.Destroy;
begin
  FCulturaApiService.Free;
  inherited;
end;

end.
