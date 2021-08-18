unit OWM.API;

interface

uses
  System.Classes, System.Net.HttpClient, OWM.Classes;

{$SCOPEDENUMS ON}

type
  TOWMLang = (None, AF, AL, AR, AZ, BG, CA, CZ, DA, DE, EL, EN, EU, FA, FI, FR, GL, //
    HE, HI, HR, HU, ID, IT, JA, KR, LA, LT, MK, NO, NL, PL, PT, PT_BR, RO,    //
    RU, SE, SV, SK, SL, ES, SP, SR, TH, TR, UK, UA, VI, ZH_CN, ZH_TW, ZU);

  TOWMUnit = (None, Standard, Metric, Imperial);

  TOWMAPI = class(TComponent)
  private
    const
      ABaseUrl = 'https://api.openweathermap.org/data/2.5/';
  private
    FBaseUrl: string;
    procedure SetBaseUrl(const Value: string);
  protected
    FAppKey: string;
    FClient: THTTPClient;
    procedure SetAppKey(const Value: string);
    function CurrentGet(out Weather: TOWMCurrent; const Params: string): Boolean; overload;
    function ExecuteGet<T: class, constructor>(const Query: string; out Response: T): Boolean;
  public
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; const AAppKey: string); reintroduce; overload;
    destructor Destroy; override;
    /// <summary>
    /// Query - City name, state code and country code divided by comma, Please, refer to ISO 3166 for the state codes or country codes.
    /// You can specify the parameter not only in English. In this case, the API response should be returned in the same language
    /// as the language of requested location name if the location is in our predefined list of more than 200,000 locations.
    /// </summary>
    function Current(out Weather: TOWMCurrent; const Query: string; Units: TOWMUnit = TOWMUnit.None): Boolean; overload;
    property AppKey: string read FAppKey write SetAppKey;
    property Client: THTTPClient read FClient;
    property BaseUrl: string read FBaseUrl write SetBaseUrl;
  end;

const
  OWMLangStr: array[TOWMLang] of string = ('', 'AF', 'AL', 'AR', 'AZ', 'BG', 'CA',
    'CZ', 'DA', 'DE', 'EL', 'EN', 'EU', 'FA', 'FI', 'FR', 'GL', 'HE', 'HI',
    'HR', 'HU', 'ID', 'IT', 'JA', 'KR', 'LA', 'LT', 'MK', 'NO', 'NL', 'PL',
    'PT', 'PT_BR', 'RO', 'RU', 'SE', 'SV', 'SK', 'SL', 'ES', 'SP', 'SR', 'TH',
    'TR', 'UK', 'UA', 'VI', 'ZH_CN', 'ZH_TW', 'ZU');
  OWMUnitStr: array[TOWMUnit] of string = ('', 'standard', 'metric', 'imperial');

implementation

uses
  REST.Json;

{ TOWMAPI }

constructor TOWMAPI.Create(AOwner: TComponent);
begin
  inherited;
  FBaseUrl := ABaseUrl;
  FClient := THTTPClient.Create;
  FClient.ResponseTimeout := 5;
end;

constructor TOWMAPI.Create(AOwner: TComponent; const AAppKey: string);
begin
  Create(AOwner);
  FAppKey := AAppKey;
end;

function TOWMAPI.CurrentGet(out Weather: TOWMCurrent; const Params: string): Boolean;
begin
  Result := ExecuteGet<TOWMCurrent>(FBaseUrl + '/weather?appid=' + FAppKey + Params, Weather);
end;

destructor TOWMAPI.Destroy;
begin
  FClient.Free;
  inherited;
end;

function TOWMAPI.Current(out Weather: TOWMCurrent; const Query: string; Units: TOWMUnit): Boolean;
begin
  Result := CurrentGet(Weather, '&q=' + Query + '&units=' + OWMUnitStr[Units]);
end;

function TOWMAPI.ExecuteGet<T>(const Query: string; out Response: T): Boolean;
var
  Mem: TStringStream;
begin
  Mem := TStringStream.Create;
  try
    Result := FClient.Get(Query, Mem).StatusCode = 200;
    Response := TJson.JsonToObject<T>(Mem.DataString, [TJsonOption.joDateFormatUnix, TJsonOption.joIgnoreEmptyArrays, TJsonOption.joIgnoreEmptyStrings]);
  finally
    Mem.Free;
  end;
end;

procedure TOWMAPI.SetAppKey(const Value: string);
begin
  FAppKey := Value;
end;

procedure TOWMAPI.SetBaseUrl(const Value: string);
begin
  FBaseUrl := Value;
end;

end.

