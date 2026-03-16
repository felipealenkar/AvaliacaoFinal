unit Service.ApiCultura;

interface

uses
Vcl.Dialogs,
  Repository.ApiCultura,
  System.SysUtils,
  System.Generics.Collections,
  System.Classes;

type
  TCulturaApiService = class
  private
    FCulturaApiRepository: TCulturaApiRepository;
  public
    constructor Create(PCulturaApiRepository: TCulturaApiRepository);
    destructor Destroy; override;

    function ObterUrlFotoPorApi(PNome, PNomeApi: String): TMemoryStream;
    procedure AtualizarChaveGemini(PChave: string);
    function ObterChaveGemini: String;
  end;

implementation

function TCulturaApiService.ObterChaveGemini: String;
begin
  Result := FCulturaApiRepository.ObterChaveGemini;
end;

function TCulturaApiService.ObterUrlFotoPorApi(PNome, PNomeApi: String): TMemoryStream;
var
  LNome, LUrlImagem: string;
begin
  LNome := FCulturaApiRepository.ObterNomeCientifico(PNome, FCulturaApiRepository.ObterChaveGemini);
  //Showmessage(LNome);
  if PNomeApi = 'GBIF' then
    LUrlImagem := FCulturaApiRepository.ObterUrlFotoPorApiGBIF(LNome);
  if PNomeApi = 'Trefle' then
    LUrlImagem := FCulturaApiRepository.ObterUrlFotoPorApiTrefle(LNome);
  //Showmessage(LUrlImagem);
   if LUrlImagem.Trim.IsEmpty then
     raise Exception.CreateFmt('A planta "%s" (%s) foi localizada, mas não possui foto disponível.', [PNome, LNome]);

  Result := FCulturaApiRepository.ObterImagemComTNetHttp(LUrlImagem);
end;

procedure TCulturaApiService.AtualizarChaveGemini(PChave: string);
begin
  FCulturaApiRepository.AtualizarChaveGemini(PChave);
end;

{ TCulturaService }

constructor TCulturaApiService.Create(PCulturaApiRepository: TCulturaApiRepository);
begin
  inherited Create;
  FCulturaApiRepository := PCulturaApiRepository;
end;

destructor TCulturaApiService.Destroy;
begin
  FCulturaApiRepository.Free;
  inherited;
end;
end.
