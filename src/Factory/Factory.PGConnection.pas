unit Factory.PGConnection;

interface

uses
  Data.Db, FireDAC.Phys.PG, FireDAC.Comp.Client, FireDAC.Stan.Param,
  FireDAC.Stan.Def, FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Stan.Async, FireDAC.Comp.UI;

var
  GPgDriverL: TFDPhysPgDriverLink;
  GWaitCursor: TFDGUIxWaitCursor;

implementation

initialization
begin
  GPgDriverL := TFDPhysPgDriverLink.Create(nil);
  GPgDriverL.VendorLib := 'C:\Program Files (x86)\PostgreSQL\psqlODBC\bin\libpq.dll';
  GWaitCursor := TFDGUIxWaitCursor.Create(nil);
end;

finalization
begin
  GWaitCursor.Free;
  GPgDriverL.Free;
end;

end.
