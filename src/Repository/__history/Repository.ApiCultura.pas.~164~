unit Repository.ApiCultura;

interface

uses
  Repository.Base, Model.DbStart, Model.ApiCultura,
  REST.Client, REST.Types, System.JSON, System.Net.HttpClient, System.Net.HttpClientComponent,
  System.Classes, System.SysUtils, System.Generics.Collections,

  Data.Db, FireDAC.Phys.PG, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.Stan.Def, FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Stan.Async, FireDAC.Comp.UI;

type
  TCulturaApiRepository = class(TBaseRepository)
    private
    public
      function ObterRespostaDoGemini(PCulturaApi: TCulturaApi): string;
      function ObterUrlFotoPorApiTrefle(PCulturaApi: TCulturaApi): String;
      function ObterUrlFotoPorApiGBIF(PCulturaApi: TCulturaApi): String;
      function ObterImagemComTNetHttp(PUrlImagem: string): TMemoryStream;
      procedure AtualizarChaves(PCulturaApi: TCulturaApi);
      function ObterChaves: TCulturaApi;
  end;

implementation

{ TApiCulturaRepository }

function TCulturaApiRepository.ObterRespostaDoGemini(PCulturaApi: TCulturaApi): string;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
  JSONObj: TJSONObject;
  LValue: TJSONValue;
begin
  var URLBASE_GEMINI: string := 'https://generativelanguage.googleapis.com/v1beta';
  var KEY_GEMINI: String := PCulturaApi.ChaveGemini;
  Result := '';
  LClient := TRESTClient.Create(nil);
  try
    LRequest := TRESTRequest.Create(LClient);
    LResponse := TRESTResponse.Create(LClient);
    LClient.BaseURL := URLBASE_GEMINI;
    LRequest.Client := LClient;
    LRequest.Response := LResponse;
    LRequest.Method := rmPOST;
    LRequest.Resource := 'models/gemini-3.1-flash-lite-preview:generateContent';

    LClient.ConnectTimeout := 5000;
    LRequest.ReadTimeout := 10000;

    LRequest.AddParameter('key', KEY_GEMINI, pkQUERY);
    LRequest.AddBody(
      '{' +
      '  "contents": [' +
      '    {' +
      '      "parts": [' +
      '        {' +
      '          "text": "' + PCulturaApi.Prompt + '"' +
      '        }' +
      '      ]' +
      '    }' +
      '  ]' +
      '}',
      ctAPPLICATION_JSON
    );

    try
      LRequest.Execute;
    except
      on E: Exception do
        raise Exception.Create('Falha de conexão com a IA: ' + E.Message);
    end;

    if LResponse.StatusCode <> 200 then
      raise Exception.CreateFmt('Erro na API Gemini (%d): %s', [LResponse.StatusCode, LResponse.Content]);

    LValue := TJSONObject.ParseJSONValue(LResponse.Content);
    if Assigned(LValue) and (LValue is TJSONObject) then
    begin
      JSONObj := TJSONObject(LValue);
      try
        try
          Result := JSONObj.GetValue<TJSONArray>('candidates')
                           .Items[0].GetValue<TJSONObject>('content')
                           .GetValue<TJSONArray>('parts')
                           .Items[0].GetValue<string>('text').Trim;

          // Limpeza extra: o Gemini as vezes coloca caracteres de controle ou aspas
          Result := Result.Replace('"', '').Replace('*', '');
        except
          raise Exception.Create('A IA retornou um formato inesperado.');
        end;
      finally
        JSONObj.Free;
      end;
    end;
  finally
    LClient.Free;
  end;
end;

function TCulturaApiRepository.ObterUrlFotoPorApiTrefle(PCulturaApi: TCulturaApi): String;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
  LJSON: TJSONObject;
  LData: TJSONArray;
  LImageUrl: string;
begin
  var URLBASE_FOTO: string := 'https://trefle.io/api';
  var KEY_TREFLE: string := PCulturaApi.ChaveTrefle;
  LClient  := TRESTClient.Create(nil);
  try
    LRequest := TRESTRequest.Create(LClient);
    LResponse := TRESTResponse.Create(LClient);
    LRequest.Client := LClient;
    LRequest.Response := LResponse;
    LClient.BaseURL := URLBASE_FOTO;

    LRequest.Resource := '/v1/plants/search';
    LRequest.Method := rmGET;
    LRequest.Params.AddItem('token', KEY_TREFLE, pkQUERY);
    LRequest.Params.AddItem('q', PCulturaApi.NomeCientifico, pkQUERY);

    LRequest.Execute;

    if LResponse.StatusCode <> 200 then
      raise Exception.CreateFmt('Erro na API Gemini (%d): %s', [LResponse.StatusCode, LResponse.Content]);

    if LResponse.Content = '' then
      raise Exception.Create('Imagem não encontrada');

    LJSON := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONObject;
    try
      if Assigned(LJSON) and LJSON.TryGetValue('data', LData) then
      begin
        if (LData.Count > 0) and TJSONObject(LData.Items[0]).TryGetValue('image_url', LImageUrl) then
          if (LImageUrl <> '') and (LImageUrl <> 'null') then
            Result := LImageUrl;
      end;
    finally
      LJSON.Free;
    end;
  finally
    LClient.Free;
  end;
end;

function TCulturaApiRepository.ObterUrlFotoPorApiGBIF(PCulturaApi: TCulturaApi): string;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
  LJSON: TJSONObject;
  LResults: TJSONArray;
  LMedia: TJSONArray;
  LImageUrl: string;
begin
  Result := '';

  LClient := TRESTClient.Create('https://api.gbif.org/v1/occurrence/search');

  try
    LRequest := TRESTRequest.Create(LClient);
    LResponse := TRESTResponse.Create(LClient);
    LRequest.Client := LClient;
    LRequest.Response := LResponse;
    LRequest.Method := rmGET;

    LRequest.Params.AddItem('scientificName', Trim(PCulturaApi.NomeCientifico), pkQUERY);
    LRequest.Params.AddItem('mediaType', 'StillImage', pkQUERY);
    LRequest.Params.AddItem('limit', '1', pkQUERY);

    LRequest.Execute;

    if LResponse.StatusCode <> 200 then
      raise Exception.CreateFmt('Erro GBIF (%d): %s',
        [LResponse.StatusCode, LResponse.Content]);

    LJSON := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONObject;

    try
      if not Assigned(LJSON) then Exit;

      if LJSON.TryGetValue('results', LResults) then
      begin
        if LResults.Count > 0 then
        begin
          if TJSONObject(LResults.Items[0]).TryGetValue('media', LMedia) then
          begin
            if LMedia.Count > 0 then
            begin
              LImageUrl :=
                TJSONObject(LMedia.Items[0]).GetValue<string>('identifier');

              Result := LImageUrl;
            end;
          end;
        end;
      end;

    finally
      LJSON.Free;
    end;

  finally
    LClient.Free;
  end;
end;

procedure TCulturaApiRepository.AtualizarChaves(PCulturaApi: TCulturaApi);
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  LQuery := nil;
  LConnection := nil;
  try
    try
      LConnection := CriarConexao(TDBStart.NomeDatabase);
      LQuery := TFDQuery.Create(nil);
      LQuery.Connection := LConnection;
      LQuery.SQL.Text := Format('UPDATE %s.apicultura ' +
                              'SET chave_gemini = :PChaveGemini, ' +
                              'chave_trefle = :PChaveTrefle ' +
                              'WHERE id_gemini = 1', [TDBStart.NomeSchema]);

      LQuery.ParamByName('PChaveGemini').AsString := PCulturaApi.ChaveGemini;
      LQuery.ParamByName('PChaveTrefle').AsString := PCulturaApi.ChaveTrefle;
      LQuery.ExecSQL;
    except
      on E:Exception do
        raise Exception.Create(Format('Erro ao atualizar dados na tabela %s.apicultura', [TDBStart.NomeSchema])
                              + sLineBreak + sLineBreak + E.ToString);
    end;
  finally
    LQuery.Free;
    LConnection.Free;
  end;
end;

function TCulturaApiRepository.ObterChaves: TCulturaApi;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  LQuery := nil;
  LConnection := nil;
  Result := nil;
  try
    try
      LConnection := CriarConexao(TDBStart.NomeDatabase);
      LQuery := TFDQuery.Create(nil);
      LQuery.Connection := LConnection;
      LQuery.SQL.Text :=
      Format(('SELECT * from %s.apicultura where id_gemini = 1'), [TDBStart.NomeSchema]);
      LQuery.Open;

      if not LQuery.Eof then
      begin
        Result := TCulturaApi.Create;
        Result.ChaveGemini := LQuery.FieldByName('chave_gemini').AsString;
        Result.ChaveTrefle := LQuery.FieldByName('chave_trefle').AsString;
      end;
    except
      on E:Exception do
        raise Exception.Create(Format('Erro ao obter dados da tabela %s.apicultura', [TDBStart.NomeSchema])
                              + sLineBreak + sLineBreak + E.ToString);
    end;
  finally
    LQuery.Free;
    LConnection.Free;
  end;
end;

function TCulturaApiRepository.ObterImagemComTNetHttp(PUrlImagem: string): TMemoryStream;
var
  LHttpClient: TNetHTTPClient;
  LIHTTPResp: IHTTPResponse;
  LTempStream: TMemoryStream;
begin
  LTempStream := TMemoryStream.Create;
  LHttpClient := TNetHTTPClient.Create(nil);
  try
    try
      LHttpClient.ConnectionTimeout := 10000;
      LIHTTPResp := LHttpClient.Get(PUrlImagem, LTempStream);

      if LIHTTPResp.StatusCode = 200 then
      begin
        LTempStream.Position := 0;
        Result := LTempStream;
      end
      else
        raise Exception.CreateFmt('Erro ao baixar imagem: Erro %d', [LIHTTPResp.StatusCode]);
    except
      LTempStream.Free;
      raise;
    end;
  finally
    LHttpClient.Free;
  end;
end;

end.
