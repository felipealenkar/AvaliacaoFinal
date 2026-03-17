program HortiSys;

uses
  Winapi.Windows,
  System.SysUtils,
  Vcl.Forms,
  Model.DbStart in 'src\Model\Model.DbStart.pas',
  Model.TipoCultura in 'src\Model\Model.TipoCultura.pas',
  Model.Cultura in 'src\Model\Model.Cultura.pas',
  Model.Manejo in 'src\Model\Model.Manejo.pas',
  Controller.TipoCultura in 'src\Controller\Controller.TipoCultura.pas',
  Controller.DbStart in 'src\Controller\Controller.DbStart.pas',
  Service.DbStart in 'src\Service\Service.DbStart.pas',
  Service.TipoCultura in 'src\Service\Service.TipoCultura.pas',
  Repository.TipoCultura in 'src\Repository\Repository.TipoCultura.pas',
  Repository.DbStart in 'src\Repository\Repository.DbStart.pas',
  View.Principal in 'src\View\View.Principal.pas' {FrmPrincipal},
  Factory.Provider in 'src\Factory\Factory.Provider.pas',
  Repository.Base in 'src\Repository\Repository.Base.pas',
  Factory.PGConnection in 'src\Factory\Factory.PGConnection.pas',
  DataModule.Icons in 'src\DataModule\DataModule.Icons.pas' {DmIcons: TDataModule},
  Service.Cultura in 'src\Service\Service.Cultura.pas',
  Controller.Cultura in 'src\Controller\Controller.Cultura.pas',
  Repository.Cultura in 'src\Repository\Repository.Cultura.pas',
  View.Manejo in 'src\View\View.Manejo.pas' {FrmManejo},
  View.EditarManejo in 'src\View\View.EditarManejo.pas' {FrmEditarManejo},
  Repository.ApiCultura in 'src\Repository\Repository.ApiCultura.pas',
  Service.ApiCultura in 'src\Service\Service.ApiCultura.pas',
  Controller.ApiCultura in 'src\Controller\Controller.ApiCultura.pas',
  View.RelatorioManejo in 'src\View\View.RelatorioManejo.pas' {FrmRelatorioManejo},
  Model.TipoManejo in 'src\Model\Model.TipoManejo.pas',
  Repository.TipoManejo in 'src\Repository\Repository.TipoManejo.pas',
  Repository.Manejo in 'src\Repository\Repository.Manejo.pas',
  Service.TipoManejo in 'src\Service\Service.TipoManejo.pas',
  Service.Manejo in 'src\Service\Service.Manejo.pas',
  Controller.TipoManejo in 'src\Controller\Controller.TipoManejo.pas',
  Controller.Manejo in 'src\Controller\Controller.Manejo.pas',
  View.TipoManejo in 'src\View\View.TipoManejo.pas' {FrmTipoManejo},
  View.TipoCultura in 'src\View\View.TipoCultura.pas' {FrmTipoCultura},
  View.RelatorioTipoManejo in 'src\View\View.RelatorioTipoManejo.pas' {FrmRelatorioTipoManejo},
  View.RelatorioTipoCultura in 'src\View\View.RelatorioTipoCultura.pas' {FrmRelatorioTipoCultura},
  View.Cultura in 'src\View\View.Cultura.pas' {FrmCultura},
  View.EditarCultura in 'src\View\View.EditarCultura.pas' {FrmEditarCultura},
  View.RelatorioCultura in 'src\View\View.RelatorioCultura.pas' {FrmRelatorioCultura},
  View.LocalizarCultura in 'src\View\View.LocalizarCultura.pas' {FrmLocalizarCultura};

{$R *.res}

var
  LDBStartController: TDBStartController;
begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  LDBStartController := nil;
  try
    LDBStartController := TProviderFactory.NewDbStartController;
    try
      if not LDBStartController.VerificarAmbiente then
        MessageBox(0, PChar('!!!Bem vindo ao HortiSys!!!, ' + sLineBreak + sLineBreak +
                        Format('Não foi encontrado o database %s', [TDBStart.NomeDatabase]) + ', ele será criado.'),
                        'HortiSys', MB_OK or MB_ICONINFORMATION or MB_TASKMODAL);

      LDBStartController.IniciarAmbiente;
      Application.CreateForm(TDmIcons, DmIcons);
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.Run;
    except
      on E:Exception do
        MessageBox(0, PChar(E.ToString), 'HortiSys', MB_OK or MB_ICONERROR or MB_TASKMODAL);
    end;
  finally
    LDBStartController.Free;
  end;
end.
