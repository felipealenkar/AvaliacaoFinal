unit Model.Cultura;

interface

uses
  System.SysUtils, System.Classes;

type
  TCultura = class
  private
    FIdCultura: Integer;
    FNome: string;
    FIdTipoCultura: Integer;
    FDescricaoTipoCultura: string;
    FDataPlantio: TDateTime;
    FAtiva: Boolean;
    FFoto: TMemoryStream;

    procedure SetNome(const PNome: string);
    procedure SetFoto(PFoto: TMemoryStream);
  public
    constructor Create;
    destructor Destroy; override;

    property IdCultura: Integer read FIdCultura write FIdCultura;
    property Nome: string read FNome write SetNome;
    property IdTipoCultura: Integer read FIdTipoCultura write FIdTipoCultura;
    property DescricaoTipoCultura: string read FDescricaoTipoCultura write FDescricaoTipoCultura;
    property DataPlantio: TDateTime read FDataPlantio write FDataPlantio;
    property Ativo: Boolean read FAtiva write FAtiva;
    property Foto: TMemoryStream read FFoto write SetFoto;
  end;

implementation

{ TCultura }

constructor TCultura.Create;
begin
  inherited;
  FAtiva := True;
  FDataPlantio := Date;
  FFoto := TMemoryStream.Create;
end;

destructor TCultura.Destroy;
begin
  FFoto.Free;
  inherited;
end;

procedure TCultura.SetFoto(PFoto: TMemoryStream);
begin
  if not Assigned(FFoto) then
    FFoto := TMemoryStream.Create;

  FFoto.Clear;
  FFoto.CopyFrom(PFoto, 0);
  FFoto.Position := 0;
end;

procedure TCultura.SetNome(const PNome: string);
begin
  if Trim(PNome).IsEmpty then
    raise Exception.Create('Nome da cultura não pode estar vazio');

  FNome := PNome;
end;

end.
