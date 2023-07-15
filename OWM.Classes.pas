unit OWM.Classes;

interface

type
  TOWMSys = class
  private
    FCountry: string;
    FId: Integer;
    FSunrise: TDateTime;
    FSunset: TDateTime;
    FType: Integer;
  public
    property Country: string read FCountry write FCountry;
    property Id: Integer read FId write FId;
    property Sunrise: TDateTime read FSunrise write FSunrise;
    property Sunset: TDateTime read FSunset write FSunset;
    property &Type: Integer read FType write FType;
  end;

  TOWMClouds = class
  private
    FAll: Integer;
  public
    property All: Integer read FAll write FAll;
  end;

  TOWMWind = class
  private
    FDeg: Integer;
    FGust: Double;
    FSpeed: Double;
  public
    property Deg: Integer read FDeg write FDeg;
    property Gust: Double read FGust write FGust;
    property Speed: Double read FSpeed write FSpeed;
  end;

  TOWMMain = class
  private
    FFeels_Like: Double;
    FHumidity: Integer;
    FPressure: Integer;
    FTemp: Double;
    FTemp_Max: Double;
    FTemp_Min: Double;
  public
    property FeelsLike: Double read FFeels_Like write FFeels_Like;
    property Humidity: Integer read FHumidity write FHumidity;
    property Pressure: Integer read FPressure write FPressure;
    property Temp: Double read FTemp write FTemp;
    property TempMax: Double read FTemp_Max write FTemp_Max;
    property TempMin: Double read FTemp_Min write FTemp_Min;
  end;

  TOWMWeather = class
  private
    FDescription: string;
    FIcon: string;
    FId: Integer;
    FMain: string;
  public
    property Description: string read FDescription write FDescription;
    property Icon: string read FIcon write FIcon;
    property Id: Integer read FId write FId;
    property Main: string read FMain write FMain;
  end;

  TOWMCoord = class
  private
    FLat: Double;
    FLon: Double;
  public
    property Lat: Double read FLat write FLat;
    property Lon: Double read FLon write FLon;
  end;

  TOWMCurrent = class
  private
    FBase: string;
    FClouds: TOWMClouds;
    FCod: Integer;
    FCoord: TOWMCoord;
    FDt: TDateTime;
    FId: Integer;
    FMain: TOWMMain;
    FName: string;
    FSys: TOWMSys;
    FTimezone: Integer;
    FVisibility: Integer;
    FWeather: TArray<TOWMWeather>;
    FWind: TOWMWind;
  public
    property Base: string read FBase write FBase;
    property Clouds: TOWMClouds read FClouds write FClouds;
    property Cod: Integer read FCod write FCod;
    property Coord: TOWMCoord read FCoord write FCoord;
    property DateTime: TDateTime read FDt write FDt;
    property Id: Integer read FId write FId;
    property Main: TOWMMain read FMain write FMain;
    property Name: string read FName write FName;
    property Sys: TOWMSys read FSys write FSys;
    property Timezone: Integer read FTimezone write FTimezone;
    property Visibility: Integer read FVisibility write FVisibility;
    property Weather: TArray<TOWMWeather> read FWeather write FWeather;
    property Wind: TOWMWind read FWind write FWind;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TOWMCurrent }

constructor TOWMCurrent.Create;
begin
  FCoord := TOWMCoord.Create;
  FMain := TOWMMain.Create;
  FWind := TOWMWind.Create;
  FClouds := TOWMClouds.Create;
  FSys := TOWMSys.Create;
end;

destructor TOWMCurrent.Destroy;
begin
  FCoord.Free;
  FMain.Free;
  FWind.Free;
  FClouds.Free;
  FSys.Free;
  for var Item in FWeather do
    Item.Free;
  inherited;
end;

end.

