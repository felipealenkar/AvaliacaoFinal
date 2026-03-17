unit Service.ApiCultura;

interface

uses
  Vcl.Dialogs, Model.ApiCultura,
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
    procedure AtualizarChaveTrefle(PChave: string);
    function ObterChaveGemini: String;
    function ObterCuriosidade: string;
  end;

implementation

function TCulturaApiService.ObterChaveGemini: String;
var
  LCulturaApi: TCulturaApi;
begin
  LCulturaApi := FCulturaApiRepository.ObterChaves;
  Result := LCulturaApi.ChaveGemini;
  LCulturaApi.Free;
end;

function TCulturaApiService.ObterCuriosidade: string;
var
  LCulturaApi: TCulturaApi;
begin
  LCulturaApi := FCulturaApiRepository.ObterChaves;
  LCulturaApi.Prompt := 'Aja como um bot botânico especializado. Forneça uma curiosidade única, ' +
             'curta e impactante sobre uma planta (escolha entre: horta, pomar, medicinal ' + 'ou decorativa).' +
             ' ' +
             'REGRAS ESTRITAS DE FORMATO: ' +
             '1. Responda APENAS o texto da curiosidade. ' +
             '2. Proibido usar saudações (ex: -Olá-, -Aqui está-). ' +
             '3. Proibido usar aspas no início ou fim. ' +
             '4. Proibido usar introduções ou explicações (ex: -Você sabia que...-). ' +
             '5. O texto deve ter no máximo 200 caracteres para caber na tela. ' +
             '6. A gramática do português deve ser respeitada e com toda a acentuação. ' +
             ' ' +
             'Exemplo de saída esperada: A hortelã-pimenta pode ajudar a repelir formigas e ' +
             'outros insetos devido ao seu forte aroma de mentol. ' +
             'Não use markdown, não use negrito, apenas o texto puro.';

  Result := FCulturaApiRepository.ObterRespostaDoGemini(LCulturaApi);
  LCulturaApi.Free;
end;

function TCulturaApiService.ObterUrlFotoPorApi(PNome, PNomeApi: String): TMemoryStream;
var
  LNome, LUrlImagem: string;
  LCulturaApi: TCulturaApi;
begin
  LCulturaApi := FCulturaApiRepository.ObterChaves;
  LCulturaApi.Prompt := 'Você é um botânico especializado em taxonomia vegetal. ' +
             'Receba o nome popular de uma planta em português e retorne ' +
             'apenas o nome científico da planta aceito atualmente para: ' + PNome + '. ' +
             'Não use markdown, não use negrito, apenas o texto puro.';

  LCulturaApi.NomeCientifico := FCulturaApiRepository.ObterRespostaDoGemini(LCulturaApi);
  //Showmessage(LNome);
  if PNomeApi = 'GBIF (Sem chave)' then
    LUrlImagem := FCulturaApiRepository.ObterUrlFotoPorApiGBIF(LCulturaApi);
  if PNomeApi = 'Trefle' then
    LUrlImagem := FCulturaApiRepository.ObterUrlFotoPorApiTrefle(LCulturaApi);
  //Showmessage(LUrlImagem);
   if LUrlImagem.Trim.IsEmpty then
     raise Exception.CreateFmt('A planta "%s" (%s) foi localizada, mas não possui foto disponível.', [PNome, LNome]);

  Result := FCulturaApiRepository.ObterImagemComTNetHttp(LUrlImagem);
  LCulturaApi.Free;
end;

procedure TCulturaApiService.AtualizarChaveGemini(PChave: string);
var
  LCulturaApi: TCulturaApi;
begin
  LCulturaApi := FCulturaApiRepository.ObterChaves;
  LCulturaApi.ChaveGemini := PChave;
  FCulturaApiRepository.AtualizarChaves(LCulturaApi);
  LCulturaApi.Free;
end;

procedure TCulturaApiService.AtualizarChaveTrefle(PChave: string);
var
  LCulturaApi: TCulturaApi;
begin
  LCulturaApi := FCulturaApiRepository.ObterChaves;
  LCulturaApi.ChaveTrefle := PChave;
  FCulturaApiRepository.AtualizarChaves(LCulturaApi);
  LCulturaApi.Free;
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
