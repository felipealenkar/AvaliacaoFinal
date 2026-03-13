unit Model.TipoCultura;

interface

uses
  System.SysUtils;

type
  TTipoCultura = class
  private
    FIdTipoCultura: Integer;
    FDescricao: string;

    procedure SetDescricao(const PDescricao: string);
  public
    constructor Create;
    property IdTipoCultura: Integer read FIdTipoCultura write FIdTipoCultura;
    property Descricao: string read FDescricao write SetDescricao;
  end;

implementation

{ TTipoCultura }

constructor TTipoCultura.Create;
begin
  inherited;
  FIdTipoCultura := 0;
  FDescricao := '';
end;

procedure TTipoCultura.SetDescricao(const PDescricao: string);
begin
  if Trim(PDescricao).IsEmpty then
    raise Exception.Create('Descrição do tipo de cultura não pode estar vazia');

  if Length(PDescricao) > 50 then
    raise Exception.Create('Descrição do tipo de cultura deve ter no máximo 50 caracteres');

  FDescricao := PDescricao;
end;

end.
