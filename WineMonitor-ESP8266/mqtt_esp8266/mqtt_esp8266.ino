/*
 Basic ESP8266 MQTT example

 This sketch demonstrates the capabilities of the pubsub library in combination
 with the ESP8266 board/library.

 It connects to an MQTT server then:
  - publishes "hello world" to the topic "outTopic" every two seconds
  - subscribes to the topic "inTopic", printing out any messages
    it receives. NB - it assumes the received payloads are strings not binary
  - If the first character of the topic "inTopic" is an 1, switch ON the ESP Led,
    else switch it off

 It will reconnect to the server if the connection is lost using a blocking
 reconnect function. See the 'mqtt_reconnect_nonblocking' example for how to
 achieve the same result without blocking the main loop.

 To install the ESP8266 board, (using Arduino 1.6.4+):
  - Add the following 3rd party board manager under "File -> Preferences -> Additional Boards Manager URLs":
       http://arduino.esp8266.com/stable/package_esp8266com_index.json
  - Open the "Tools -> Board -> Board Manager" and click install for the ESP8266"
  - Select your ESP8266 in "Tools -> Board"

*/

#define ARDUINOJSON_USE_DOUBLE 0

#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <ArduinoJson.h>
#include <WiFiUdp.h>
#include <NTPClient.h>
#include <DHT.h>
#include <AsyncDelay.h>

#define DHTPIN D6     // what digital pin we're connected to
#define ONE_WIRE_BUS D3
#define TEMPERATURE_PRECISION 10

// Uncomment whatever type you're using!
//#define DHTTYPE DHT11   // DHT 11
#define DHTTYPE DHT22   // DHT 22  (AM2302), AM2321
//#define DHTTYPE DHT21   // DHT 21 (AM2301)
const char* ssid = "ssid";
const char* password = "wpakey";
const char* mqtt_server = "mqttserveraddress";
float tempIntNebbiolo = -1000;
float tempIntCabernet = -1000;
float tempExt = -1000;
float humidity = -1000;

WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg[150];
int value = 0;
StaticJsonBuffer<JSON_OBJECT_SIZE(6)> jsonBuffer;
//StaticJsonBuffer<500> jsonBuffer;
JsonObject& root = jsonBuffer.createObject();
String body;
WiFiUDP ntpUDP;
NTPClient timeClient(ntpUDP);
DHT dht(DHTPIN, DHTTYPE);
AsyncDelay twoSecDelay, tenSecDelay;

// Setup a oneWire instance to communicate with any OneWire devices (not just Maxim/Dallas temperature ICs)
OneWire oneWire(ONE_WIRE_BUS);

// Pass our oneWire reference to Dallas Temperature. 
DallasTemperature sensors(&oneWire);

// arrays to hold device addresses
DeviceAddress insideThermometer, outsideThermometer;


void setup_wifi() {

  delay(10);
  // We start by connecting to a WiFi network
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    Serial.print((char)payload[i]);
  }
  Serial.println();

  // Switch on the LED if an 1 was received as first character
  if ((char)payload[0] == '1') {
    digitalWrite(BUILTIN_LED, LOW);   // Turn the LED on (Note that LOW is the voltage level
    // but actually the LED is on; this is because
    // it is acive low on the ESP-01)
  } else {
    digitalWrite(BUILTIN_LED, HIGH);  // Turn the LED off by making the voltage HIGH
  }

}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Attempt to connect
    if (client.connect("ESP8266Client")) {
      Serial.println("connected");
      // Once connected, publish an announcement...
      client.publish("intro", "connected");
      // ... and resubscribe
      client.subscribe("led");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}

void updateData(){
  timeClient.update();
  sensors.requestTemperatures();
  root.set("tempIntNebbiolo",sensors.getTempC(insideThermometer));
  root.set("tempIntCabernet",sensors.getTempC(outsideThermometer));
  root.set("tempExt",dht.readTemperature(false));
  root.set("humidity",dht.readHumidity(false));
}

void sendDataMQTT(const bool& mustSave){
  root["mustSave"] = mustSave;
  root["timestamp"] = timeClient.getEpochTime();
  root.printTo(body);
  body.toCharArray(msg,150);
  body = "";
  Serial.print("Publish message: ");
  Serial.println(msg);
  client.publish("data", msg , body.length());
  tempIntNebbiolo = root["tempIntNebbiolo"];
  tempIntCabernet = root["tempIntCabernet"];
  tempExt = root["tempExt"];
  humidity = root["humidity"];
}

void setup() {
  pinMode(BUILTIN_LED, OUTPUT);
  Serial.begin(115200);
  setup_wifi();
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
  timeClient.begin();
  timeClient.setUpdateInterval(3600);
  timeClient.update();
  sensors.setWaitForConversion(true);
  dht.begin();
  sensors.begin();
  if (!sensors.getAddress(insideThermometer, 0)) Serial.println("Unable to find address for Device 0"); 
  if (!sensors.getAddress(outsideThermometer, 1)) Serial.println("Unable to find address for Device 1"); 
  sensors.setResolution(insideThermometer, TEMPERATURE_PRECISION);
  sensors.setResolution(outsideThermometer, TEMPERATURE_PRECISION);
  twoSecDelay.start(2000, AsyncDelay::MILLIS);
  timeClient.update();
}

void loop() {
  
  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  if(!twoSecDelay.isExpired()) return;
  updateData();
  if(isnan(root["tempIntNebbiolo"]) || isnan(root["tempIntCabernet"]) || isnan(root["tempExt"]) || isnan(root["humidity"])) return;
  if(root["tempIntNebbiolo"] != tempIntNebbiolo || root["tempIntCabernet"] != tempIntCabernet || root["tempExt"] != tempExt || root["humidity"] != humidity)
    sendDataMQTT(true);
  else
    sendDataMQTT(false);
  twoSecDelay.repeat();
}
