---
name: weather
description: Weather forecasts and location data. Use when the user wants current, hourly, historical, marine, or severe weather, rain chances, air quality, sunrise, sunset, moon phase, tides, or a city or region lookup.
compatibility: Requires the clor CLI on the PATH and internet access to function. If the clor CLI is missing, install it by running `curl -fsSL https://clor.com/install.sh | bash`
---

## You run clor, the user does not

Run clor commands yourself. Do not hand the user CLI snippets, flag walkthroughs, or syntax explanations unless they ask. The command reference below is the source of truth. When usage is unclear, read the relevant `clor ... --help`; live help wins over anything here. Use only documented subcommands, flags, and values. Never guess a flag, an id, or output, and never simulate a run.

If clor needs something only the user has (a value, a choice, a credential, confirmation of a side effect), ask one plain question, then run the command. If clor is missing, signed out, or blocked, say so and ask before any login or setup step.

On failure, read the error, fix the usage, and retry once when it is safe. Do not loop. Report results, not recipes.


## Weather reference

<help command="clor weather">
<summary>Look up weather forecasts, air quality, astronomy, marine conditions, alerts, and location data</summary>
<description>Get current conditions, multi-day forecasts, historical weather since
2010, air-quality readings, sun and moon times, marine forecasts with
tides, government-issued weather alerts, and location autocomplete.

Subcommands:
  current     Get current conditions at a location
  forecast    Get a multi-day forecast with daily and hourly detail
  history     Get historical weather for a date or date range since 2010
  airquality  Get current air-quality readings at a location
  astronomy   Get sunrise, sunset, moonrise, moonset, and moon phase
  marine      Get a marine forecast with conditions and tide times
  alerts      Get active government-issued weather alerts
  search      Look up matching cities and regions by name

Output: every subcommand supports --stdout-format text|jsonl|json (default
text, logfmt with event= leader).</description>
<usage>clor weather [flags]</usage>

<uses>
- the user wants weather, air-quality, astronomy, marine, or alert data for a location
- the user wants historical weather for a past date
- the user wants to find a city or region by name
</uses>

<subcommands>
- airquality: Get current air-quality readings at a location
- alerts: Get active government-issued weather alerts at a location
- astronomy: Get sunrise, sunset, moonrise, moonset, and moon phase for a date
- current: Get current conditions at a location
- forecast: Get a multi-day forecast with daily and hourly detail
- history: Get historical weather for a date or date range since 2010-01-01
- marine: Get a marine forecast with conditions and tide times
- search: Look up matching cities and regions by name
</subcommands>

<flags>
- --help bool: help for weather
</flags>

<global-flags>
- --clor-dir string: explicit path to the clor home directory holding config, state, and caches (overrides $CLOR_DIR; defaults to ~/.clor)
- --config string: explicit path to the TOML config file (overrides --clor-dir); defaults to <clor-dir>/config.toml
- --impersonate string: run commands as another team member by user id, like sudo (requires team admin, or a delegate grant from that member)
- --profile string: API-key profile to use for this command (overrides CLOR_PROFILE and the persisted default_profile); manage with `clor account profile`
- --stderr-file string: write stderr to this file instead of the terminal
- --stderr-format string: stderr format for progress/diagnostic events: text (logfmt with event= leader), jsonl (one JSON object per line), or json (single pretty-printed object) (default "text")
- --stdout-file string: write stdout to this file instead of the terminal
- --stdout-format string: stdout format: text (logfmt with event= leader), jsonl (one JSON object per line), or json (single pretty-printed object) (default "text")
</global-flags>
</help>


<help command="clor weather airquality">
<summary>Get current air-quality readings at a location</summary>
<description>Returns pollutant concentrations (CO, ozone, NO2, SO2, PM2.5, PM10) plus
the US EPA index (1-6, where 1 is good and 6 is hazardous) and the UK
DEFRA index (1-10).</description>
<usage>clor weather airquality <LOCATION></usage>

<output>json outputs the whole envelope {location, air_quality}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "air_quality": {
    "carbon_monoxide": 261.4,
    "nitrogen_dioxide": 18.3,
    "ozone": 88.7,
    "pm10": 19.8,
    "pm2_5": 12.6,
    "sulphur_dioxide": 4.1,
    "uk_defra_index": 3,
    "us_epa_index": 2
  },
  "location": {
    "country": "United States of America",
    "latitude": 34.05,
    "localtime": "2026-06-18 06:32",
    "longitude": -118.24,
    "name": "Los Angeles",
    "region": "California",
    "timezone": "America/Los_Angeles"
  }
}
</output-example>

<examples-good>
- clor weather airquality "Los Angeles"    # current air-quality readings in logfmt
- clor weather airquality 10001 --stdout-format json | jq '.air_quality.us_epa_index'    # EPA index via jq
- clor weather airquality "Delhi" | grep '^event=air_quality '    # keep only the air-quality line
</examples-good>

<examples-bad>
- clor weather airquality    # missing required <LOCATION>
</examples-bad>
</help>

<help command="clor weather alerts">
<summary>Get active government-issued weather alerts at a location</summary>
<usage>clor weather alerts <LOCATION></usage>

<output>json outputs the whole envelope {location, alerts[]}. jsonl outputs each record from alerts on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "alerts": [
    {
      "areas": "Oklahoma; Cleveland",
      "category": "Met",
      "certainty": "Observed",
      "description": "Quarter size hail and 60 mph wind gusts expected with this storm.",
      "effective": "2026-06-18T20:30:00-05:00",
      "event": "Severe Thunderstorm Warning",
      "expires": "2026-06-18T21:15:00-05:00",
      "headline": "Severe Thunderstorm Warning issued for Oklahoma County until 9:15 PM CDT",
      "instruction": "Move to an interior room on the lowest floor of a building.",
      "message_type": "Alert",
      "severity": "Moderate",
      "urgency": "Immediate"
    }
  ],
  "location": {
    "country": "United States of America",
    "latitude": 35.47,
    "localtime": "2026-06-18 08:32",
    "longitude": -97.52,
    "name": "Oklahoma City",
    "region": "Oklahoma",
    "timezone": "America/Chicago"
  }
}
</output-example>

<examples-good>
- clor weather alerts "Oklahoma City"    # active alerts for a city
- clor weather alerts "Miami" --stdout-format json | jq '.alerts | length'    # count active alerts via jq
- clor weather alerts "Houston" | grep '^event=alert '    # keep only alert lines
</examples-good>

<examples-bad>
- clor weather alerts    # missing required <LOCATION>
</examples-bad>
</help>

<help command="clor weather astronomy">
<summary>Get sunrise, sunset, moonrise, moonset, and moon phase for a date</summary>
<usage>clor weather astronomy <LOCATION> [flags]</usage>

<flags>
- --date string: date in YYYY-MM-DD format (default today at the location)
</flags>

<output>json outputs the whole envelope {location, date, astronomy}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "astronomy": {
    "is_moon_up": true,
    "is_sun_up": false,
    "moon_illumination": 28,
    "moon_phase": "Waning Crescent",
    "moonrise": "01:48 AM",
    "moonset": "03:12 PM",
    "sunrise": "04:25 AM",
    "sunset": "07:00 PM"
  },
  "date": "2026-06-21",
  "location": {
    "country": "Japan",
    "latitude": 35.69,
    "localtime": "2026-06-21 23:32",
    "longitude": 139.69,
    "name": "Tokyo",
    "region": "Tokyo",
    "timezone": "Asia/Tokyo"
  }
}
</output-example>

<examples-good>
- clor weather astronomy London    # sun and moon times for today
- clor weather astronomy "40.7,-74" --date 2026-06-21    # summer solstice in New York
- clor weather astronomy Tokyo --stdout-format json | jq '.astro.moon_phase'    # moon phase via jq
</examples-good>

<examples-bad>
- clor weather astronomy    # missing required <LOCATION>
- clor weather astronomy London --date 06/21/2026    # --date must be YYYY-MM-DD
</examples-bad>
</help>

<help command="clor weather current">
<summary>Get current conditions at a location</summary>
<description><LOCATION> accepts a city name, "lat,lon", US zipcode, UK postcode,
an IP address, or "id:N" returned by 'clor weather search'.</description>
<usage>clor weather current <LOCATION> [flags]</usage>

<flags>
- --language string: two-letter language code for condition text (e.g. fr, de, es, ja)
</flags>

<output>json outputs the whole envelope {location, current}. jsonl outputs the same object on one line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "current": {
    "cloud": 50,
    "condition": {
      "code": 1003,
      "icon": "https://cdn.weather.example.com/icons/116.png",
      "text": "Partly cloudy"
    },
    "dewpoint_celsius": 12.1,
    "dewpoint_fahrenheit": 53.8,
    "feels_like_celsius": 19,
    "feels_like_fahrenheit": 66.2,
    "gust_kph": 22.3,
    "gust_mph": 13.9,
    "humidity": 62,
    "is_day": true,
    "last_updated": "2026-06-18 14:30",
    "precipitation_in": 0,
    "precipitation_mm": 0.1,
    "pressure_in": 29.94,
    "pressure_mb": 1014,
    "temperature_celsius": 19.4,
    "temperature_fahrenheit": 66.9,
    "uv": 4,
    "visibility_km": 10,
    "visibility_miles": 6,
    "wind_degree": 230,
    "wind_direction": "SW",
    "wind_kph": 14.8,
    "wind_mph": 9.2
  },
  "location": {
    "country": "United Kingdom",
    "latitude": 51.52,
    "localtime": "2026-06-18 14:32",
    "longitude": -0.11,
    "name": "London",
    "region": "City of London, Greater London",
    "timezone": "Europe/London"
  }
}
</output-example>

<examples-good>
- clor weather current London    # current conditions in logfmt
- clor weather current "40.7,-74"    # lookup by latitude,longitude
- clor weather current 10001 --stdout-format json | jq '.current.temperature_celsius'    # extract temperature via jq
</examples-good>

<examples-bad>
- clor weather current    # missing required <LOCATION>
- clor weather current London --language e    # language code must be at least 2 letters
</examples-bad>
</help>

<help command="clor weather forecast">
<summary>Get a multi-day forecast with daily and hourly detail</summary>
<usage>clor weather forecast <LOCATION> [flags]</usage>

<flags>
- --days int: number of forecast days (1-14) (default "3")
- --hour int: restrict hourly output to one hour (0-23, 24-hour clock)
- --language string: two-letter language code for condition text (e.g. fr, de, es, ja)
</flags>

<output>json outputs the whole envelope {location, current, days[]}. jsonl outputs each record from days on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "current": {
    "cloud": 5,
    "condition": {
      "code": 1000,
      "icon": "https://cdn.weather.example.com/icons/113.png",
      "text": "Sunny"
    },
    "feels_like_celsius": 24.8,
    "feels_like_fahrenheit": 76.6,
    "gust_kph": 16.9,
    "gust_mph": 10.5,
    "humidity": 45,
    "is_day": true,
    "last_updated": "2026-06-18 15:30",
    "precipitation_in": 0,
    "precipitation_mm": 0,
    "pressure_in": 30.06,
    "pressure_mb": 1018,
    "temperature_celsius": 24.1,
    "temperature_fahrenheit": 75.4,
    "uv": 6,
    "visibility_km": 10,
    "visibility_miles": 6,
    "wind_degree": 200,
    "wind_direction": "SSW",
    "wind_kph": 11.5,
    "wind_mph": 7.2
  },
  "days": [
    {
      "astronomy": {
        "is_moon_up": false,
        "is_sun_up": true,
        "moon_illumination": 31,
        "moon_phase": "Waning Crescent",
        "moonrise": "01:05 AM",
        "moonset": "02:48 PM",
        "sunrise": "05:47 AM",
        "sunset": "09:57 PM"
      },
      "date": "2026-06-18",
      "day": {
        "average_humidity": 52,
        "average_temperature_celsius": 20.8,
        "average_temperature_fahrenheit": 69.4,
        "average_visibility_km": 10,
        "average_visibility_miles": 6,
        "chance_of_rain": 0,
        "chance_of_snow": 0,
        "condition": {
          "code": 1000,
          "icon": "https://cdn.weather.example.com/icons/113.png",
          "text": "Sunny"
        },
        "max_temperature_celsius": 26.3,
        "max_temperature_fahrenheit": 79.3,
        "max_wind_kph": 18.4,
        "max_wind_mph": 11.4,
        "min_temperature_celsius": 15.1,
        "min_temperature_fahrenheit": 59.2,
        "total_precipitation_in": 0,
        "total_precipitation_mm": 0,
        "uv": 6
      },
      "hours": [
        {
          "chance_of_rain": 0,
          "chance_of_snow": 0,
          "cloud": 5,
          "condition": {
            "code": 1000,
            "text": "Sunny"
          },
          "feels_like_celsius": 24.8,
          "feels_like_fahrenheit": 76.6,
          "humidity": 45,
          "is_day": true,
          "precipitation_in": 0,
          "precipitation_mm": 0,
          "temperature_celsius": 24.1,
          "temperature_fahrenheit": 75.4,
          "time": "2026-06-18 15:00",
          "wind_degree": 200,
          "wind_direction": "SSW",
          "wind_kph": 11.5,
          "wind_mph": 7.2
        }
      ]
    }
  ],
  "location": {
    "country": "France",
    "latitude": 48.87,
    "localtime": "2026-06-18 15:32",
    "longitude": 2.33,
    "name": "Paris",
    "region": "Ile-de-France",
    "timezone": "Europe/Paris"
  }
}
</output-example>

<examples-good>
- clor weather forecast London --days 3    # three day forecast in logfmt
- clor weather forecast Paris --days 7 --stdout-format json | jq '.days[].day.max_temperature_celsius'    # extract daily highs via jq
- clor weather forecast "40.7,-74" --days 5 | grep '^event=day '    # keep only day summary lines
- clor weather forecast Tokyo --days 1 --hour 14    # only the 2pm hour
</examples-good>

<examples-bad>
- clor weather forecast    # missing required <LOCATION>
- clor weather forecast London --days 20    # max --days is 14
- clor weather forecast London --hour 25    # --hour must be 0-23
</examples-bad>
</help>

<help command="clor weather history">
<summary>Get historical weather for a date or date range since 2010-01-01</summary>
<usage>clor weather history <LOCATION> [flags]</usage>

<flags>
- --date string: start date in YYYY-MM-DD format (required, on or after 2010-01-01)
- --end-date string: end date in YYYY-MM-DD format (max 30 days after --date)
- --hour int: restrict hourly output to one hour (0-23, 24-hour clock)
- --language string: two-letter language code for condition text
</flags>

<output>json outputs the whole envelope {location, days[]}. jsonl outputs each record from days on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "days": [
    {
      "astronomy": {
        "is_moon_up": true,
        "is_sun_up": false,
        "moon_illumination": 71,
        "moon_phase": "Waning Gibbous",
        "moonrise": "09:32 PM",
        "moonset": "10:18 AM",
        "sunrise": "06:51 AM",
        "sunset": "04:39 PM"
      },
      "date": "2024-01-01",
      "day": {
        "average_humidity": 48,
        "average_temperature_celsius": 6.9,
        "average_temperature_fahrenheit": 44.4,
        "average_visibility_km": 10,
        "average_visibility_miles": 6,
        "chance_of_rain": 0,
        "chance_of_snow": 0,
        "condition": {
          "code": 1000,
          "icon": "https://cdn.weather.example.com/icons/113.png",
          "text": "Sunny"
        },
        "max_temperature_celsius": 11.2,
        "max_temperature_fahrenheit": 52.2,
        "max_wind_kph": 15.1,
        "max_wind_mph": 9.4,
        "min_temperature_celsius": 2.8,
        "min_temperature_fahrenheit": 37,
        "total_precipitation_in": 0,
        "total_precipitation_mm": 0,
        "uv": 3
      },
      "hours": [
        {
          "chance_of_rain": 0,
          "chance_of_snow": 0,
          "cloud": 0,
          "condition": {
            "code": 1000,
            "text": "Sunny"
          },
          "feels_like_celsius": 8.9,
          "feels_like_fahrenheit": 48,
          "humidity": 44,
          "is_day": true,
          "precipitation_in": 0,
          "precipitation_mm": 0,
          "temperature_celsius": 10.4,
          "temperature_fahrenheit": 50.7,
          "time": "2024-01-01 12:00",
          "wind_degree": 320,
          "wind_direction": "NW",
          "wind_kph": 12.6,
          "wind_mph": 7.8
        }
      ]
    }
  ],
  "location": {
    "country": "Japan",
    "latitude": 35.69,
    "localtime": "2024-01-01 09:00",
    "longitude": 139.69,
    "name": "Tokyo",
    "region": "Tokyo",
    "timezone": "Asia/Tokyo"
  }
}
</output-example>

<examples-good>
- clor weather history London --date 2024-06-15    # single day in logfmt
- clor weather history Tokyo --date 2024-01-01 --end-date 2024-01-07 --stdout-format json | jq '.days[].day.average_temperature_celsius'    # weekly average via jq
- clor weather history "40.7,-74" --date 2023-12-25 | grep '^event=day '    # summary line for Christmas 2023
</examples-good>

<examples-bad>
- clor weather history London    # missing --date
- clor weather history London --date 2009-12-31    # --date must be on or after 2010-01-01
- clor weather history London --date 2024-06-15 --end-date 2024-08-01    # --end-date must be within 30 days
</examples-bad>
</help>

<help command="clor weather marine">
<summary>Get a marine forecast with conditions and tide times</summary>
<description><LOCATION> must be a sea or ocean point (coastal city or "lat,lon"
over water). Returns daily summaries, hourly sea-state, and tide
events.</description>
<usage>clor weather marine <LOCATION> [flags]</usage>

<flags>
- --days int: number of marine forecast days (1-7) (default "3")
</flags>

<output>json outputs the whole envelope {location, days[]}. jsonl outputs each record from days on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "days": [
    {
      "astronomy": {
        "is_moon_up": false,
        "is_sun_up": true,
        "moon_illumination": 30,
        "moon_phase": "Waning Crescent",
        "moonrise": "01:21 AM",
        "moonset": "03:05 PM",
        "sunrise": "05:42 AM",
        "sunset": "08:07 PM"
      },
      "date": "2026-06-18",
      "day": {
        "average_humidity": 70,
        "average_temperature_celsius": 19.2,
        "average_temperature_fahrenheit": 66.6,
        "average_visibility_km": 10,
        "average_visibility_miles": 6,
        "chance_of_rain": 0,
        "chance_of_snow": 0,
        "condition": {
          "code": 1003,
          "icon": "https://cdn.weather.example.com/icons/116.png",
          "text": "Partly cloudy"
        },
        "max_temperature_celsius": 22.4,
        "max_temperature_fahrenheit": 72.3,
        "max_wind_kph": 24.5,
        "max_wind_mph": 15.2,
        "min_temperature_celsius": 16.1,
        "min_temperature_fahrenheit": 61,
        "total_precipitation_in": 0,
        "total_precipitation_mm": 0,
        "uv": 7
      },
      "hours": [
        {
          "cloud": 40,
          "condition": {
            "code": 1003,
            "text": "Partly cloudy"
          },
          "humidity": 68,
          "is_day": true,
          "significant_wave_height_meters": 1.2,
          "swell_direction_compass": "SW",
          "swell_direction_degrees": 225,
          "swell_height_feet": 3.6,
          "swell_height_meters": 1.1,
          "swell_period_seconds": 9.4,
          "temperature_celsius": 21,
          "temperature_fahrenheit": 69.8,
          "time": "2026-06-18 12:00",
          "water_temperature_celsius": 18.3,
          "water_temperature_fahrenheit": 64.9,
          "wind_degree": 250,
          "wind_direction": "WSW",
          "wind_kph": 20.2,
          "wind_mph": 12.5
        }
      ],
      "tides": [
        {
          "height_meters": 0.21,
          "time": "2026-06-18 03:48 AM",
          "type": "low"
        },
        {
          "height_meters": 1.64,
          "time": "2026-06-18 10:12 AM",
          "type": "high"
        }
      ]
    }
  ],
  "location": {
    "country": "United States of America",
    "latitude": 34.02,
    "localtime": "2026-06-18 06:32",
    "longitude": -118.5,
    "name": "Santa Monica",
    "region": "California",
    "timezone": "America/Los_Angeles"
  }
}
</output-example>

<examples-good>
- clor weather marine "Santa Monica"    # three day marine forecast with tides
- clor weather marine "Monterey" --days 2 --stdout-format json | jq '.days[].tides'    # tide data via jq
- clor weather marine "37.8,-122.5" --days 5 | grep '^event=tide '    # keep only tide lines
</examples-good>

<examples-bad>
- clor weather marine    # missing required <LOCATION>
- clor weather marine "Santa Monica" --days 10    # max --days is 7
</examples-bad>
</help>

<help command="clor weather search">
<summary>Look up matching cities and regions by name</summary>
<description>Returns matches with a stable id that can be passed to other subcommands
as "id:N" (e.g. clor weather current id:2801268).</description>
<usage>clor weather search <QUERY></usage>

<output>json outputs the whole envelope {query, matches[]}. jsonl outputs each record from matches on its own line; text is the logfmt of the same keys.</output>

<output-example format="json">
{
  "matches": [
    {
      "country": "United States of America",
      "id": 2801268,
      "latitude": 39.8,
      "longitude": -89.64,
      "name": "Springfield",
      "region": "Illinois"
    },
    {
      "country": "United States of America",
      "id": 2741329,
      "latitude": 42.1,
      "longitude": -72.55,
      "name": "Springfield",
      "region": "Massachusetts"
    }
  ],
  "query": "Springfield"
}
</output-example>

<examples-good>
- clor weather search "Springfield"    # all matching Springfields
- clor weather search "Lond" --stdout-format json | jq '.matches[].id'    # extract stable ids via jq
- clor weather search "Boston" | grep '^event=match '    # keep only match lines
</examples-good>

<examples-bad>
- clor weather search    # missing required <QUERY>
</examples-bad>
</help>

## Presenting results

Lead with the outcome, then any caveats. Keep it concise and scannable.

- ✓ for completed steps
- bullets for findings or next steps
- a small table only when comparing several things

Do not paste full command transcripts or flag explanations unless they are needed to explain a failure or the user asked. The artifact is the point, not the formatting.

