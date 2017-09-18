unit DownloadObj;

interface

type TDownload=class
  private
    FUrl: string;
    FTimeOut: integer;
    FName: string;
    FExtension: string;
    FDirectory: string;
  published
    property url: string read FUrl write FUrl;
    property timeOut: integer read FTimeOut write FTimeOut;
    property name: string read FName write FName;
    property extension: string read FExtension write FExtension;
    property directory: string read FDirectory write FDirectory;
  public
    constructor Create; overload;
    constructor Create(const aUrl: string;
                       const aTimeOut: integer;
                       const aName: string;
                       const aExtension: string;
                       const aDirectory: string); overload;
    destructor Destroy; override;
end;


implementation

{ TDownload }

constructor TDownload.Create;
begin
  url := '';
  timeout := 10000;
  name := '';
  extension := '';
  directory := '';
end;

constructor TDownload.Create(
  const aUrl: string;
  const aTimeOut: integer;
  const aName, aExtension, aDirectory: string);
begin
  url := aUrl;
  timeout := aTimeOut;
  name := aName;
  extension := aExtension;
  directory := aDirectory;
end;

destructor TDownload.Destroy;
begin

  inherited;
end;

end.
