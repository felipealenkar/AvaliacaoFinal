unit Factory.Provider;

interface

uses
  System.SysUtils, System.Classes,

  // Views
  View.EditarCultura, View.Cultura, View.TipoCultura, View.RelatorioTipoCultura,
  // Controllers
  Controller.DbStart, Controller.TipoCultura, Controller.Cultura, Controller.ApiCultura,
  // Services
  Service.DbStart, Service.TipoCultura, Service.Cultura, Service.ApiCultura,
  // Repositories
  Repository.DbStart, Repository.TipoCultura, Repository.Cultura, Repository.ApiCultura;

type
  TProviderFactory = class
  private
  public
    class function NewDbStartController: TDBStartController;
    class function NewTipoCulturaController: TTipoCulturaController;
    class function NewCulturaController: TCulturaController;
    class function NewCulturaApiController: TCulturaApiController;

    class function NewTipoCulturaView(POwner: TComponent): TFrmTipoCultura;
    class function NewCulturaView(POwner:TComponent):TFrmCultura;
    class function NewRelatorioTipoCulturaView(POwner: TComponent): TFrmRelatorioTipoCultura;
  end;

implementation

{ TProviderFactory }

class function TProviderFactory.NewCulturaApiController: TCulturaApiController;
begin
  Result := TCulturaApiController.Create(TCulturaApiService.Create(TCulturaApiRepository.Create));
end;

class function TProviderFactory.NewCulturaController: TCulturaController;
begin
  Result := TCulturaController.Create(TCulturaService.Create(TCulturaRepository.Create));
end;

class function TProviderFactory.NewCulturaView(POwner: TComponent): TFrmCultura;
begin
  Result := TFrmCultura.Create(POwner, NewCulturaController, NewTipoCulturaController);
end;

class function TProviderFactory.NewDbStartController: TDBStartController;
begin
  Result := TDBStartController.Create(TDbStartService.Create(TDbStartRepository.Create));
end;

class function TProviderFactory.NewRelatorioTipoCulturaView(
  POwner: TComponent): TFrmRelatorioTipoCultura;
begin
  Result := TFrmRelatorioTipoCultura.Create(POwner, NewTipoCulturaController);
end;

class function TProviderFactory.NewTipoCulturaController: TTipoCulturaController;
begin
  Result := TTipoCulturaController.Create(TTipoCulturaService.Create(TTipoCulturaRepository.Create));
end;

class function TProviderFactory.NewTipoCulturaView(POwner: TComponent): TFrmTipoCultura;
begin
  Result := TFrmTipoCultura.Create(POwner, NewTipoCulturaController);
end;

end.
