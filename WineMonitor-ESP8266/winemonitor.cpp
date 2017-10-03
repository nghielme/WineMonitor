#include "winemonitor.h"

#include <ArduinoJson.h>


/*-------------PRIVATE METHODS-----------*/


void WineMonitor::initUDP(){
  udp.begin(localPort);
  udp.localPort();
}

void WineMonitor::updateIntTemps(){

}

void WineMonitor::updateExtTemp(){
  
}

void WineMonitor::updateHumidity(){

}

void WineMonitor::updateTimestamp(){

}

//temperature alarm handler
void alarmHandler(uint8_t* deviceAddress){
  
}

/*-------------PUBLIC METHODS-----------*/

void WineMonitor::initSensors(){
  sensors.begin();
}

void WineMonitor::initWiFi(const char&* ssid, const char&* wifiKey){
	Serial.print("Connecting to ");
  Serial.println(ssid);
	WiFi.begin(ssid, wifiKey);
	while (WiFi.status() != WL_CONNECTED) {
    	delay(250);
    	Serial.print(".");
    }
    Serial.println("");
  	Serial.println("WiFi connected");
  	Serial.print("IP address: ");
  	Serial.println(WiFi.localIP());
}

void WineMonitor::initHTTP(const char*& url, const int& port, const char*& username, const char*& password){
  http.begin(url,port);
  http.setAuthorization(username, password);
  http.addHeader("Content-Type","application/json");
}

void WineMonitor::updateDataFromSensors(){
  updateTimestamp();
  updateIntTemps();
  updateExtTemp();
  updateHumidity();
}

int WineMonitor::sendPostRequest(){
  StaticJsonBuffer<JSON_OBJECT_SIZE(5)> jsonBuffer;
  JsonObject& root = jsonBuffer.createObject();
  String body;

  updateDataFromSensors();

  root["timestamp"] = timestamp;
  root["tempIntNebbiolo"] = tempIntNebbiolo;
  root["tempIntCabernet"] = tempIntCabernet;
  root["tempExt"] = tempExt;
  root["humidity"] = humidity;

  root.printTo(body);
  return http.POST(body);
}

void WineMonitor::initNTP(){
  timeClient.begin();
  timeClient.setTimeOffset(7200);
}

void WineMonitor::initAlarms(){
  
}