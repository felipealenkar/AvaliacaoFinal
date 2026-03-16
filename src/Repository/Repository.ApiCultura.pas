unit Repository.ApiCultura;

interface

uses
  Repository.Base, Model.DbStart,
  REST.Client, REST.Types, System.JSON, System.Net.HttpClient, System.Net.HttpClientComponent,
  System.Classes, System.SysUtils, System.Generics.Collections,

  Data.Db, FireDAC.Phys.PG, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.Stan.Def, FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Stan.Async, FireDAC.Comp.UI;

type
  TCulturaApiRepository = class(TBaseRepository)
    private
    public
      function ObterRespostaDoGemini(PPrompt: string): string;
      function ObterNomeCientifico(PNomePT: String): string;
      function ObterUrlFotoPorApiTrefle(const PNomeCientifico: string): String;
      function ObterUrlFotoPorApiGBIF(const PNomeCientifico: string): String;
      function ObterImagemComTNetHttp(PUrlImagem: string): TMemoryStream;
      procedure AtualizarChaveGemini(PChave: string; PTipo: Boolean);
      function ObterChaveGemini: String;
      function VerificarTipoChave: Boolean;
  end;

implementation

{ TApiCulturaRepository }

function TCulturaApiRepository.ObterNomeCientifico(PNomePT: String): string;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
  JSONObj: TJSONObject;
  LValue: TJSONValue;
begin
  var URLBASE_GEMINI: string := 'https://generativelanguage.googleapis.com/v1beta';
  var KEY_GEMINI: String := ObterChaveGemini;
  Result := '';
  LClient := TRESTClient.Create(nil);
  LRequest := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  try
    LClient.BaseURL := URLBASE_GEMINI;
    LRequest.Client := LClient;
    LRequest.Response := LResponse;
    LRequest.Method := rmPOST;
    LRequest.Resource := 'models/gemini-3.1-flash-lite-preview:generateContent';
    LRequest.Timeout := 10000;

    LRequest.AddParameter('key', KEY_GEMINI, pkQUERY);
    LRequest.AddBody(
      '{' +
      '  "contents": [' +
      '    {' +
      '      "parts": [' +
      '        {' +
      '          "text": "Você é um botânico especializado em taxonomia vegetal. ' +
      '                   Receba o nome popular de uma planta em português e retorne ' +
      '                   apenas o nome científico da planta aceito atualmente para: ' + PNomePT + '. ' +
      '                   Não use markdown, não use negrito, apenas o texto puro."' +
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
    LResponse.Free;
    LRequest.Free;
    LClient.Free;
  end;
end;

function TCulturaApiRepository.ObterRespostaDoGemini(PPrompt: String): string;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
  JSONObj: TJSONObject;
  LValue: TJSONValue;
begin
  var URLBASE_GEMINI: string := 'https://generativelanguage.googleapis.com/v1beta';
  var KEY_GEMINI: String := ObterChaveGemini;
  Result := '';
  LClient := TRESTClient.Create(nil);
  LRequest := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  try
    LClient.BaseURL := URLBASE_GEMINI;
    LRequest.Client := LClient;
    LRequest.Response := LResponse;
    LRequest.Method := rmPOST;
    LRequest.Resource := 'models/gemini-3.1-flash-lite-preview:generateContent';
    LRequest.Timeout := 10000;

    LRequest.AddParameter('key', KEY_GEMINI, pkQUERY);
    LRequest.AddBody(
      '{' +
      '  "contents": [' +
      '    {' +
      '      "parts": [' +
      '        {' +
      '          "text": "' + PPrompt + '"' +
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
    LResponse.Free;
    LRequest.Free;
    LClient.Free;
  end;
end;

function TCulturaApiRepository.ObterUrlFotoPorApiTrefle(const PNomeCientifico: string): String;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
  LJSON: TJSONObject;
  LData: TJSONArray;
  LImageUrl: string;
const
  URLBASE_FOTO = 'https://trefle.io/api';
  KEY_TREFLE   = 'usr-ZIUEpJhXOFLUwkzjbVpzk-sWWbGiSoBZDDEFpZOayBM';
begin
  LClient  := TRESTClient.Create(nil);
  LRequest := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);
  try
    LRequest.Client := LClient;
    LRequest.Response := LResponse;
    LClient.BaseURL := URLBASE_FOTO;

    LRequest.Resource := '/v1/plants/search';
    LRequest.Method := rmGET;
    LRequest.Params.AddItem('token', KEY_TREFLE, pkQUERY);
    LRequest.Params.AddItem('q', PNomeCientifico, pkQUERY);

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
    LResponse.Free;
    LRequest.Free;
    LClient.Free;
  end;
end;

function TCulturaApiRepository.VerificarTipoChave: Boolean;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  Result := False;
  LQuery := nil;
  LConnection := nil;
  try
    LConnection := CriarConexao(TDBStart.NomeDatabase);
    LQuery := TFDQuery.Create(nil);
    LQuery.Connection := LConnection;
    LQuery.SQL.Text :=
    Format(('SELECT chave_personalizada from %s.apicultura where id_gemini = 1'), [TDBStart.NomeSchema]);
    LQuery.Open;

    if not LQuery.Eof then
      Result := LQuery.FieldByName('chave_personalizada').AsBoolean;
  finally
    LQuery.Free;
    LConnection.Free;
  end;
end;

function TCulturaApiRepository.ObterUrlFotoPorApiGBIF(const PNomeCientifico: string): string;
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
  LRequest := TRESTRequest.Create(nil);
  LResponse := TRESTResponse.Create(nil);

  try
    LRequest.Client := LClient;
    LRequest.Response := LResponse;
    LRequest.Method := rmGET;

    LRequest.Params.AddItem('scientificName', Trim(PNomeCientifico), pkQUERY);
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
    LResponse.Free;
    LRequest.Free;
    LClient.Free;
  end;
end;

procedure TCulturaApiRepository.AtualizarChaveGemini(PChave: string; PTipo: Boolean);
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
                              'SET chave_gemini = :PChave, ' +
                              '    chave_personalizada = :PTipo ' +
                              'WHERE id_gemini = 1', [TDBStart.NomeSchema]);

                            LQuery.ParamByName('PChave').AsString := PChave;
                            LQuery.ParamByName('PTipo').AsBoolean := PTipo;
                            LQuery.ExecSQL;
      LQuery.ExecSQL;
    except
      on E:Exception do
        raise Exception.Create(Format('Erro ao inserir dados na tabela %s.cultura', [TDBStart.NomeSchema])
                              + sLineBreak + sLineBreak + E.ToString);
    end;
  finally
    LQuery.Free;
    LConnection.Free;
  end;
end;

function TCulturaApiRepository.ObterChaveGemini: string;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  LQuery := nil;
  LConnection := nil;
  try
    LConnection := CriarConexao(TDBStart.NomeDatabase);
    LQuery := TFDQuery.Create(nil);
    LQuery.Connection := LConnection;
    LQuery.SQL.Text :=
    Format(('SELECT chave_gemini from %s.apicultura where id_gemini = 1'), [TDBStart.NomeSchema]);
    LQuery.Open;

    if not LQuery.Eof then
      Result := LQuery.FieldByName('chave_gemini').AsString;
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
