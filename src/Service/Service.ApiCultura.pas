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
    procedure AtualizarChaveGemini(PChave: string; PTipo: Boolean);
    function ObterChaveGemini: String;
    function ObterCuriosidade: string;
    function VerificarTipoChave: Boolean;
  end;

implementation

function TCulturaApiService.ObterChaveGemini: String;
begin
  Result := FCulturaApiRepository.ObterChaveGemini;
end;

function TCulturaApiService.ObterCuriosidade: string;
var
  LPrompt: string;
begin
  LPrompt := 'Aja como um bot botânico especializado. Forneça uma curiosidade única, ' +
             'curta e impactante sobre uma planta (escolha entre: horta, pomar, medicinal ' + 'ou decorativa).' +
             ' ' +
             'REGRAS ESTRITAS DE FORMATO: ' +
             '1. Responda APENAS o texto da curiosidade. ' +
             '2. Proibido usar saudações (ex: -Olá-, -Aqui está-). ' +
             '3. Proibido usar aspas no início ou fim. ' +
             '4. Proibido usar introduções ou explicações (ex: -Você sabia que...-). ' +
             '5. O texto deve ter no máximo 200 caracteres para caber na tela. ' +
             ' ' +
             'Exemplo de saída esperada: A hortelã-pimenta pode ajudar a repelir formigas e ' +
             'outros insetos devido ao seu forte aroma de mentol. ' +
             'Não use markdown, não use negrito, apenas o texto puro.';

  Result := FCulturaApiRepository.ObterRespostaDoGemini(LPrompt);
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

function TCulturaApiService.VerificarTipoChave: Boolean;
begin
  Result := FCulturaApiRepository.VerificarTipoChave;
end;

procedure TCulturaApiService.AtualizarChaveGemini(PChave: string; PTipo: Boolean);
begin
  FCulturaApiRepository.AtualizarChaveGemini(PChave, PTipo);
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
