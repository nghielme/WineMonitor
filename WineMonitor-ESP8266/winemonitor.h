#ifndef WineMonitor_h
#define WineMonitor_h

#include <ESP8266WiFi.h>
#include <WiFiUdp.h>
#include <NTPClient.h>
#include <ESP8266HTTPClient.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <config.h>


class WineMonitor
{
    public:
        
        //Initialize all sensors.
        void initSensors();

        //Initialize connection to WiFi AP with @ssid and @wifiKey.
        void initWiFi(const char*& ssid, const char*& wifiKey);

        //Initialize HTTP objects to perform POST request to server which is listening on @port at @url.
        //It also sets credentials for HTTP basic authorization with @username and @password.
        void initHTTP(const char*& url, const int& port, const char*& username, const char*& password);

        //

        //Make the body to send (using JSON) and perform a HTTP POST request.
        //The function return the HTTP code response sent by the server.
        int  sendPostRequest();

        //Initalize NTP packet to get the time syncronized with a NTP server.
        void initNTP();

        //Initialize temperature alarms. Send mail from gmail account when the limits are exceeded.
        void initAlarms();
    private:
        void initUDP();
        void updateIntTemps();
        void updateExtTemp();
        void updateHumidity();
        void updateTimestamp();
        //buffer to hold incoming and outgoing packets
        byte packetBuffer[NTP_PACKET_SIZE];
        IPAddress timeServerIP;
        WiFiUDP udp;
        NTPClient timeClient(udp);
        HTTPClient http;
        OneWire oneWire(oneWireBus;
        DallasTemperature sensors(&oneWire);
        DeviceAddress nebbioloThermometer, cabernetThermometer;
        float tempIntNebbiolo;
        float tempIntCabernet;
        float tempExt;
        float humidity;
        unsigned long int timestamp;

};
#endif