include gdrive-sheets
include data-source
include shared-gdrive("dcic-2021","1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep")


ssid = "1RYN0i4Zx_UETVuYacgaGfnFcv4l9zd9toQTTdkQkj7g"
kWh-wealthy-consumer-data =
load-table: komponent, energi
source: load-spreadsheet(ssid).sheet-by-name("kWh", true)
      # sanitize energi using string-sanitizer
    sanitize energi using string-sanitizer
end


distance-travelled-per-day = 47.2 # (km) ToI. Gjennomsnittlig distanse
distance-per-unit-of-fuel = (distance-travelled-per-day / 10) *  0.5  # Vianor. Gjennomsnittlig drivstofforbruk
energy-per-unit-of-fuel = 10


energy-per-day = ( distance-travelled-per-day  / distance-per-unit-of-fuel ) * energy-per-unit-of-fuel


fun energi-to-number(str :: String) -> Number:
# skriv koden her (tips: bruk cases og string-to-number funksjonen)
  cases(Option) string-to-number(str):
    | some(a) => a
    | none => energy-per-day
  end
where:
energi-to-number("") is energy-per-day
  energi-to-number("48") is 48
end


kWh-wealthy-consumer-data-fixed = 
  transform-column(kWh-wealthy-consumer-data, "energi", energi-to-number)


sum(kWh-wealthy-consumer-data-fixed, "energi")


bar-chart(kWh-wealthy-consumer-data-fixed, "komponent", "energi")
