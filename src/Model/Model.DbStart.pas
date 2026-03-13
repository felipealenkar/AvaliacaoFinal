unit Model.DbStart;

interface

type
  TDBStart = class sealed
    public
      const NomeDatabase: string = 'HORTISYSDB';
      const NomeSchema: string = 'hortisys';
      const Porta: string = '5433';
      const SenhaPg: string = '#abc123#';
  end;
implementation
end.
