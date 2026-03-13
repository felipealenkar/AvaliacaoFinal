unit DataModule.Icons;

interface

uses
  System.SysUtils, System.Classes, Vcl.BaseImageCollection, Vcl.ImageCollection;

type
  TDmIcons = class(TDataModule)
    ImgCltIcons: TImageCollection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmIcons: TDmIcons;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
