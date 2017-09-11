program DownloadFile;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  windows,
  classes,
  IdHTTP,
  IdSSLOpenSSL,
  forms,
  DownloadObj in 'DownloadObj.pas',
  GetRequest in 'GetRequest.pas';

const
  CST_PARAM_POS_URL = 1;
  CST_PARAM_POS_GUID = 2;
  CST_PARAM_POS_FILEEXT = 3;

procedure iniHTTP(const ahttp: TIdHTTP; const aDownload: TDownload);
var
  vIOHandler: TIdSSLIOHandlerSocketOpenSSL;
const
  cTime: integer = 10000;
begin
  if assigned(ahttp) then
  begin
    ahttp.ProtocolVersion := pv1_1;
    vIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(ahttp);
    vIOHandler.SSLOptions.Mode := sslmClient;
    vIOHandler.SSLOptions.Method := sslvTLSv1;
    ahttp.IOHandler := vIOHandler;
    ahttp.HandleRedirects := true;
    ahttp.AllowCookies := false;
    if assigned(aDownload) then
    begin
      ahttp.ConnectTimeout := aDownload.timeOut;
      ahttp.ReadTimeout := aDownload.timeOut;
    end
    else
    begin
      ahttp.ConnectTimeout := cTime;
      ahttp.ReadTimeout := cTime;
    end;
    ahttp.Request.UserAgent := 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:44.0) Gecko/20100101 Firefox/44.0';
  end;
end;

function getUrl(const aDownload: TDownload): string;
begin
  result := '';
  if ParamCount > (CST_PARAM_POS_URL-1) then
  begin
    result := ParamStr(CST_PARAM_POS_URL);
    if assigned(aDownload) then
      aDownload.url := result;
  end
  else
  begin
    if assigned(aDownload) then
    begin
      result := aDownload.url;
    end;
  end;
end;

function getGuid(const aDownload: TDownload): string;
begin
  result := '';
  if ParamCount > (CST_PARAM_POS_GUID-1) then
  begin
    result := ParamStr(CST_PARAM_POS_GUID);
    if assigned(aDownload) then
      aDownload.guid := result;
  end
  else
  begin
    if assigned(aDownload) then
    begin
      result := aDownload.guid;
    end;
  end;
end;

function getFileExt(const aDownload: TDownload): string;
begin
  result := '';
  if ParamCount > (CST_PARAM_POS_FILEEXT-1) then
  begin
    result := ParamStr(CST_PARAM_POS_FILEEXT);
    if assigned(aDownload) then
      aDownload.fileExt := result;
  end
  else
  begin
    if assigned(aDownload) then
    begin
      result := aDownload.fileExt;
    end;
  end;
end;

procedure iniWithApplicationExternalParams(const aDownload: TDownload);
var
  vUrl: string;
  vGuid: string;
  vFileExt: string;
begin
  if assigned(aDownload) then
  begin
    vFileExt := getFileExt(aDownload);
    vUrl := getUrl(aDownload);
    vGuid := getGuid(aDownload);
  end;
end;

function doGetRequest(const ahttp: TIdHTTP; const aDownload: TDownload; const aFileStream: TFileStream): boolean;
var
  vGetRequest: TGetRequest;
begin
  result := false;
  if assigned(ahttp) then
  begin
    iniWithApplicationExternalParams(aDownload);
    vGetRequest := TGetRequest.Create(ahttp, aDownload);
    try
      result := vGetRequest.Execute(aFileStream);
    finally
      vGetRequest.Free;
    end;
  end;
end;

function getDownloadObj: TDownload;
begin
  result := TDownload.Create('http://localhost:8080/download', 10000, '777', 'xmt');
end;

var
  vFileName: string;
  vFileNameTmp: string;
  vFileStream: TFileStream;
  vhttp: TIdHTTP;
  vDownload: TDownload;
  vbDownload: boolean;
const
  cbFailIfExists: boolean = false;
begin
  try
    { TODO -oUtilisateur -cCode du point d'entrée : Placez le code ici }
    vFileName := 'C:\Users\Dany\AppData\Local\Temp\download.dat';
    vFileNameTmp := 'C:\Users\Dany\AppData\Local\Temp\download_tmp.dat';
    vDownload := getDownloadObj;
    vhttp := TIdHTTP.Create;
    try
      iniHTTP(vhttp, vDownload);
      if FileExists(vFileNameTmp) then
        deleteFile(PChar(vFileNameTmp));
      vFileStream := TFileStream.Create(vFileNameTmp, fmCreate);
      try
        vbDownload := doGetRequest(vhttp, vDownload, vFileStream);
      finally
        FreeAndNil(vFileStream);
        if FileExists(vFileNameTmp) then
        begin
          if vbDownload then
          begin
            // copions le fichier temporaire dans le fichier definitif.
            copyFile(PChar(vFileNameTmp),
                     PChar(vFileName),
                     cbFailIfExists);
          end;
          deleteFile(PChar(vFileNameTmp));
        end;
      end;
    finally
    vhttp.Free;
    vDownload.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
