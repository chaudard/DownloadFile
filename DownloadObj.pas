unit DownloadObj;

interface

type TDownload=class
  private
    FUrl: string;
    FTimeOut: integer;
    FGuid: string;
    FFileExt: string;
  published
    property url: string read FUrl write FUrl;
    property timeOut: integer read FTimeOut write FTimeOut;
    property guid: string read FGuid write FGuid;
    property fileExt: string read FFileExt write FFileExt;
  public
    constructor Create; overload;
    constructor Create(const aUrl: string; const aTimeOut: integer; const aGuid: string; const aFileExt: string); overload;
    destructor Destroy; override;
end;


implementation

{ TUpload }

constructor TDownload.Create;
begin
  url := '';
  timeout := 10000;
  guid := '';
  fileExt := '';
end;

constructor TDownload.Create(const aUrl: string; const aTimeOut: integer;
  const aGuid, aFileExt: string);
begin
  url := aUrl;
  timeout := aTimeOut;
  guid := aGuid;
  fileExt := aFileExt;
end;

destructor TDownload.Destroy;
begin

  inherited;
end;

end.
