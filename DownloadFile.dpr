program DownloadFile;

{
Cette application peut prendre 4 paramètres , dans l'ordre suivant :
1. url : adresse à partir de laquelle on télécharge le fichier
2. name: le nom simple du fichier lorsqu'il aura été téléchargé (ex : myFile)
3. ext: l'extension du fichier lorsqu'il aura été téléchargé (ex : xmt)
4. directory: le répertoire dans lequel le fichier sera déposé.

exemple de paramètre à utiliser pour test, dans menu: Exécuter->Paramètres->Paramètres :
"http://localhost:8080/upload" "myFile" "xmt" "C:\Users\Dany\AppData\Local\Temp\" "%1"

en ligne de commande (cmd), il faut écrire par exemple :
DownloadFile.exe "http://localhost:8080/upload" "myFile" "xmt" "C:\Users\Dany\AppData\Local\Temp\"
}


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
  CST_PARAM_POS_NAME = 2;
  CST_PARAM_POS_EXT = 3;
  CST_PARAM_POS_DIRECTORY = 4;

  // pour tester temporairement, sans paramètres en lignes de commande ni paramètres d'execution
  CST_TMP_NAME = '2224';
  CST_TMP_EXT = 'xmt';
  CST_TMP_TIMEOUT = 10000;
  CST_TMP_URL = 'http://localhost:8080/download';

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
    ahttp.Request.UserAgent :=
      'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:44.0) Gecko/20100101 Firefox/44.0';
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

function getName(const aDownload: TDownload): string;
begin
  result := '';
  if ParamCount > (CST_PARAM_POS_NAME-1) then
  begin
    result := ParamStr(CST_PARAM_POS_NAME);
    if assigned(aDownload) then
      aDownload.name := result;
  end
  else
  begin
    if assigned(aDownload) then
    begin
      result := aDownload.name;
    end;
  end;
end;

function getExtension(const aDownload: TDownload): string;
begin
  result := '';
  if ParamCount > (CST_PARAM_POS_EXT-1) then
  begin
    result := ParamStr(CST_PARAM_POS_EXT);
    if assigned(aDownload) then
      aDownload.extension := result;
  end
  else
  begin
    if assigned(aDownload) then
    begin
      result := aDownload.extension;
    end;
  end;
end;

function getDirectory(const aDownload: TDownload): string;
begin
  result := '';
  if ParamCount > (CST_PARAM_POS_DIRECTORY-1) then
  begin
    result := ParamStr(CST_PARAM_POS_DIRECTORY);
    if assigned(aDownload) then
      aDownload.directory := result;
  end
  else
  begin
    if assigned(aDownload) then
    begin
      result := aDownload.directory;
    end;
  end;
end;

procedure iniWithApplicationExternalParams(const aDownload: TDownload);
var
  vUrl: string;
  vName: string;
  vExtension: string;
  vDirectory: string;
begin
  if assigned(aDownload) then
  begin
    vExtension := getExtension(aDownload);
    vUrl := getUrl(aDownload);
    vName := getName(aDownload);
    vDirectory := getDirectory(aDownload);
  end;
end;

function doGetRequest(const ahttp: TIdHTTP; const aDownload: TDownload; const aFileStream: TFileStream): boolean;
var
  vGetRequest: TGetRequest;
begin
  result := false;
  if assigned(ahttp) then
  begin
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
  result := TDownload.Create(CST_TMP_URL,
                             CST_TMP_TIMEOUT,
                             CST_TMP_NAME,
                             CST_TMP_EXT,
                             IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP')));
  iniWithApplicationExternalParams(result);
end;

var
  vFileName: string;
  //vFileNameTmp: string;
  vFileStream: TFileStream;
  vhttp: TIdHTTP;
  vDownload: TDownload;
  vbDownload: boolean;
  //vTempDir: string;
  //vTimeStamp: string;
const
  cbFailIfExists: boolean = false;
begin
  try
    { TODO -oUtilisateur -cCode du point d'entrée : Placez le code ici }
//    vFileName := 'C:\Users\Dany\AppData\Local\Temp\download.dat';
//    vFileNameTmp := 'C:\Users\Dany\AppData\Local\Temp\download_tmp.dat';
    //vTempDir := 'C:\Users\Dany\AppData\Local\Temp\';

{
    vTempDir := IncludeTrailingPathDelimiter(GetEnvironmentVariable('TEMP'));
    vTimeStamp := FormatDateTime('yyyy-mm-dd-hh-nn-ss', Now);
    vFileName := format('%s%s-%s.%s', [vTempDir, CST_TMP_GUID, vTimeStamp, CST_TMP_EXT]);
    vFileNameTmp := format('%s%s-%s_tmp.%s', [vTempDir, CST_TMP_GUID, vTimeStamp, CST_TMP_EXT]);
}


    vDownload := getDownloadObj;

    vFileName := format('%s%s.%s', [IncludeTrailingPathDelimiter(vDownload.directory), vDownload.name, vDownload.extension]);
    //vFileNameTmp := format('%s%s_tmp.%s', [IncludeTrailingPathDelimiter(vDownload.directory), vDownload.name, vDownload.extension]);

    vhttp := TIdHTTP.Create;
    try
      iniHTTP(vhttp, vDownload);
{
      if FileExists(vFileNameTmp) then
        deleteFile(PChar(vFileNameTmp));
      vFileStream := TFileStream.Create(vFileNameTmp, fmCreate);
}

      if FileExists(vFileName) then
        deleteFile(PChar(vFileName));
      vFileStream := TFileStream.Create(vFileName, fmCreate);

      try
        vbDownload := doGetRequest(vhttp, vDownload, vFileStream);
      finally
        FreeAndNil(vFileStream);
{
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
}
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
