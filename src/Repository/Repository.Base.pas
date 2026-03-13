unit Repository.Base;

interface

uses
  Model.DbStart,
  System.SysUtils,
  Data.Db, FireDAC.Phys.PG, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.Stan.Def, FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Stan.Async, FireDAC.Comp.UI;

type
  TBaseRepository = class
  private
    public
      function CriarConexao(const PDatabase: String): TFDConnection;
      procedure ExecSQL(const PDatabase, PSQL: String);
      function OpenSQL(const PDatabase, PSQL: String): TFDQuery;
  end;


implementation

{ TBaseRepository }

function TBaseRepository.CriarConexao(const PDatabase: String): TFDConnection;
var
  LConnection: TFDConnection;
begin
  LConnection := TFDConnection.Create(nil);
  try
    LConnection.Params.Clear;
    LConnection.DriverName := 'PG';
    //FPgDriverL.VendorLib := 'C:\Program Files\PostgreSQL\18\bin\libpq.dll';
    LConnection.Params.Values['Server'] := 'localhost';
    LConnection.Params.Values['Port'] := TDBStart.Porta;
    LConnection.Params.Values['User_Name'] := 'postgres';
    LConnection.Params.Values['Password'] := TDBStart.SenhaPg;
    LConnection.Params.Values['Database'] := PDatabase;
    LConnection.Params.Values['CharacterSet'] := 'UTF8';
    LConnection.LoginPrompt := False;
    LConnection.Params.Values['SSLMode'] := 'disable';
    LConnection.Open;
    Result := LConnection;
  except
    on E:Exception do
    begin
      LConnection.Free;
      raise Exception.Create(Format('Erro de conexão com o banco de dados %s', [TDBStart.NomeDatabase])
                            + sLineBreak + sLineBreak + E.ToString);
    end;
  end;
end;

procedure TBaseRepository.ExecSQL(const PDatabase, PSQL: String);
var
  LConnection: TFDConnection;
begin
  LConnection := nil;
  try
    try
      LConnection := CriarConexao(PDatabase);
      LConnection.ExecSQL(PSQL);
    except
      on E:Exception do
        raise Exception.Create('Erro na execução do SQL'
                              + sLineBreak + sLineBreak + E.ToString);
    end;
  finally
    LConnection.Free;
  end;
end;

function TBaseRepository.OpenSQL(const PDatabase, PSQL: String): TFDQuery;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  LQuery := nil;
  LConnection := nil;
  try
    LConnection := CriarConexao(PDatabase);
    LQuery := TFDQuery.Create(nil);

    Result := LQuery;
    Result.Connection := LConnection;
    Result.SQL.Text := PSQL;
    Result.Open;
  except
    on E:Exception do
    begin
      LQuery.Free;
      LConnection.Free;
      raise Exception.Create('Erro na execução do OpenSQL'
                              + sLineBreak + sLineBreak + E.ToString);
    end;
  end;
end;
end.
