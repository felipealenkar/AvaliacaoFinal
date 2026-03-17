unit Repository.DbStart;

interface

uses
  Repository.Base, Model.DbStart,
  System.SysUtils,
  Data.Db, FireDAC.Phys.PG, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.Stan.Def, FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Stan.Async, FireDAC.Comp.UI;

type
  TDbStartRepository = class(TBaseRepository)
  private
  public
    procedure CriarDatabase;
    procedure CriarSchema;
    procedure CriarTabelaTipoCultura;
    procedure CriarTabelaTipoManejo;
    procedure CriarTabelaCultura;
    procedure CriarTabelaManejo;
    procedure CriarTabelaApiCultura;
    function ExistirBancoDeDados: Boolean;
  end;

implementation

{ TDatabaseInitialize }


procedure TDbStartRepository.CriarDatabase;
begin
  ExecSQL('postgres',
       Format('CREATE DATABASE "%s" '
             + 'ENCODING = ''UTF8'' '
             + 'TABLESPACE pg_default '
             + 'LC_COLLATE = ''Portuguese_Brazil.1252'' '
             + 'LC_CTYPE = ''Portuguese_Brazil.1252'' '
             + 'CONNECTION LIMIT = -1', [TDBStart.NomeDatabase]));
end;

procedure TDbStartRepository.CriarSchema;
begin
  ExecSQL(TDBStart.NomeDatabase,
          Format('CREATE SCHEMA IF NOT EXISTS %s', [TDBStart.NomeSchema]));
  ExecSQL(TDBStart.NomeDatabase, Format('CREATE OR REPLACE FUNCTION %s.sem_acento(text) '
                                        + 'RETURNS text AS $$ '
                                        + 'SELECT translate($1, '
                                        + '''·‡‚„‰Â¡¿¬√ƒ≈ÈËÍÎ…» ÀÌÏÓÔÕÃŒœÛÚÙıˆ¯”“‘’÷ÿ˙˘˚¸⁄Ÿ€‹Á«Ò—˝›ˇ'','
                                        + '''aaaaaaAAAAAAeeeeEEEEiiiiIIIIooooooOOOOOOuuuuUUUUcCnNyYy'''
                                        + ') $$ LANGUAGE sql IMMUTABLE;', [TDBStart.NomeSchema]));
end;

procedure TDbStartRepository.CriarTabelaApiCultura;
begin
  ExecSQL(TDBStart.NomeDatabase,
  Format('CREATE TABLE IF NOT EXISTS %s.apicultura ('
        + 'id_gemini INTEGER PRIMARY KEY,'
        + 'chave_gemini VARCHAR(60) NOT NULL)',
         [TDBStart.NomeSchema]));

   ExecSQL(TDBStart.NomeDatabase,
            Format('INSERT INTO %s.apicultura ' +
          '(id_gemini, chave_gemini) ' +
          'VALUES (1, '''') ' +
          'ON CONFLICT (id_gemini) DO NOTHING',
          [TDBStart.NomeSchema]));
end;

procedure TDbStartRepository.CriarTabelaCultura;
begin
  ExecSQL(TDBStart.NomeDatabase,
          Format('CREATE TABLE IF NOT EXISTS %s.cultura ('
                + 'id_cultura SERIAL PRIMARY KEY,'
                + 'nome VARCHAR(60) NOT NULL UNIQUE,'
                + 'id_tipocultura INTEGER NOT NULL,'
                + 'data_plantio TIMESTAMP NOT NULL,'
                + 'ativo BOOLEAN NOT NULL DEFAULT TRUE,'
                + 'foto BYTEA,'
                + 'CONSTRAINT fk_tipocultura FOREIGN KEY (id_tipocultura) '
                + 'REFERENCES %s.tipocultura(id_tipocultura))'
                , [TDBStart.NomeSchema, TDBStart.NomeSchema]));
end;

procedure TDbStartRepository.CriarTabelaManejo;
begin
  ExecSQL(TDBStart.NomeDatabase,
          Format('CREATE TABLE IF NOT EXISTS %s.manejo ('
                + 'id_manejo SERIAL PRIMARY KEY,'
                + 'descricao VARCHAR(50) NOT NULL,'
                + 'id_tipomanejo INTEGER NOT NULL,'
                + 'id_cultura INTEGER NOT NULL,'
                + 'data_manejo TIMESTAMP NOT NULL,'
                + 'quantidade NUMERIC(10,3),'
                + 'unidade VARCHAR(10),'
                + 'observacao TEXT,'
                + 'CONSTRAINT fk_tipomanejo FOREIGN KEY (id_tipomanejo) '
                + 'REFERENCES %s.tipomanejo(id_tipomanejo),'
                + 'CONSTRAINT fk_cultura FOREIGN KEY (id_cultura) '
                + 'REFERENCES %s.cultura(id_cultura)'
                + ')', [TDBStart.NomeSchema, TDBStart.NomeSchema, TDBStart.NomeSchema]));
end;

procedure TDbStartRepository.CriarTabelaTipoCultura;
begin
  ExecSQL(TDBStart.NomeDatabase,
          Format('CREATE TABLE IF NOT EXISTS %s.tipocultura'
                + '(id_tipocultura SERIAL PRIMARY KEY,'
                + 'descricao VARCHAR(50) NOT NULL UNIQUE)', [TDBStart.NomeSchema]));
end;

procedure TDbStartRepository.CriarTabelaTipoManejo;
begin
  ExecSQL(TDBStart.NomeDatabase,
          Format('CREATE TABLE IF NOT EXISTS %s.tipomanejo'
                + '(id_tipomanejo SERIAL PRIMARY KEY,'
                + 'descricao VARCHAR(50) NOT NULL UNIQUE, '
                + 'utiliza_unidade BOOLEAN DEFAULT FALSE)', [TDBStart.NomeSchema]));
end;

function TDbStartRepository.ExistirBancoDeDados: Boolean;
var
  LQuery: TFDQuery;
  LConnection: TFDConnection;
begin
  LConnection := nil;
  LQuery := nil;
  try
    LConnection := CriarConexao('postgres');
    LQuery := TFDQuery.Create(nil);
    LQuery.Connection := LConnection;
    LQuery.SQL.Text := 'SELECT 1 FROM pg_database WHERE datname = :dbname';
    LQuery.ParamByName('dbname').AsString := TDBStart.NomeDatabase;
    LQuery.Open;
    Result := not LQuery.IsEmpty;
  finally
    LQuery.Free;
    LConnection.Free;
  end;
end;
end.
