unit Model.ApiCultura;

interface

type
  TCulturaApi = class
  private
    FIdGemini: Integer;
    FChaveGemini: string;
    FIdTrefle: Integer;
    FChaveTrefle: string;
    FNomeCientifico: string;
    FPrompt: string;
  public
    property IdGemini: Integer read FIdGemini write FIdGemini;
    property ChaveGemini: string read FChaveGemini write FChaveGemini;
    property IdTrefle: Integer read FIdTrefle write FIdTrefle;
    property ChaveTrefle: string read FChaveTrefle write FChaveTrefle;
    property NomeCientifico: string read FNomeCientifico write FNomeCientifico;
    property Prompt: string read FPrompt write FPrompt;
  end;


implementation

end.
