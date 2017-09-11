unit GetRequest;

interface

uses
    IdHTTP
  , DownloadObj
  , classes
  , sysUtils
  ;

type TGetRequest=class
  private
    FHttp: TIdHTTP;
    FDownload: TDownload;
    FResponseCode: integer;
    FErrorMessage: string;
    procedure iniResponse;
  published
    property http: TIdHTTP read FHttp write FHttp;
    property download: TDownload read FDownload write FDownload;
    property responseCode: integer read FResponseCode write FResponseCode;
    property errorMessage: string read FErrorMessage write FErrorMessage;
  public
    constructor Create; overload;
    constructor Create(const aHttp: TIdHTTP; const aDownload: TDownload); overload;
    destructor Destroy; override;
    function Execute(const aFileStream: TFileStream): boolean;
end;

implementation

{ TGetRequest }

constructor TGetRequest.Create;
begin
  http := nil;
  download := nil;
  iniResponse;
end;

constructor TGetRequest.Create(const aHttp: TIdHTTP;
  const aDownload: TDownload);
begin
  http := aHttp;
  download := aDownload;
  iniResponse;
end;

destructor TGetRequest.Destroy;
begin

  inherited;
end;

function TGetRequest.Execute(const aFileStream: TFileStream): boolean;
var
  vUrl: string;
begin
  result := false;
  iniResponse;
  if assigned(FHttp) and assigned(FDownload) then
  begin
    vUrl := format('%s/%s/%s',[FDownload.url, FDownload.guid, FDownload.fileExt]);
    try
      FHTTP.Get(vUrl, aFileStream);
      result := true;
    except
      on E: EIDHttpProtocolException do
      begin
        errorMessage := format('Error encountered during GET: code %d , message %s', [E.ErrorCode, E.Message]);
      end;
      on E: Exception do
        errorMessage := format('Error encountered during GET: %s', [E.Message]);
    end;
    responseCode := FHttp.ResponseCode;
  end;
end;

procedure TGetRequest.iniResponse;
begin
  responseCode := 0;
  errorMessage := '';
end;

end.
