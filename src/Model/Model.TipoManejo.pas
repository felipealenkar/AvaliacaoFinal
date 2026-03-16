unit Model.TipoManejo;

interface

uses
  System.SysUtils;

type
  TTipoManejo = class
  private
    FIdTipoManejo: Integer;
    FDescricao: string;
    FUtilizaUnidade: Boolean;

    procedure SetDescricao(const PDescricao: string);
  public
    constructor Create;
    property IdTipoManejo: Integer read FIdTipoManejo write FIdTipoManejo;
    property Descricao: string read FDescricao write SetDescricao;
    property UtilizaUnidade: Boolean read FUtilizaUnidade write FUtilizaUnidade;
  end;

implementation

{ TTipoManejo }

constructor TTipoManejo.Create;
begin
  inherited;
  FIdTipoManejo := 0;
  FDescricao := '';
end;

procedure TTipoManejo.SetDescricao(const PDescricao: string);
begin
  if Trim(PDescricao).IsEmpty then
    raise Exception.Create('Descrição do tipo de manejo não pode estar vazia');

  if Length(PDescricao) > 50 then
    raise Exception.Create('Descrição do tipo de manejo deve ter no máximo 50 caracteres');

  FDescricao := PDescricao;
end;

end.
