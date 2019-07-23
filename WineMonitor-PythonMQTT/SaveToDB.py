import datetime

import paho.mqtt.client as mqtt
from pymongo import MongoClient
import json
import smtplib
import time
import _thread
import Info


def sendemail(from_addr, to_addr_list, cc_addr_list,
              subject, message,
              login, password,
              smtpserver='smtp.gmail.com:587'):
    header = 'From: %s\n' % from_addr
    header += 'To: %s\n' % ','.join(to_addr_list)
    header += 'Cc: %s\n' % ','.join(cc_addr_list)
    header += 'Subject: %s\n\n' % subject
    message = header + message

    server = smtplib.SMTP(smtpserver)
    server.starttls()
    server.login(login, password)
    problems = server.sendmail(from_addr, to_addr_list, message)
    server.quit()
    return problems


# The callback for when the client receives a CONNACK response from the server.
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    # Subscribing in on_connect() means that if we lose the connection and
    # reconnect then subscriptions will be renewed.
    client.subscribe("winemonitor/data")


# The callback for when a PUBLISH message is received from the server.
def on_message(client, userdata, msg):
    global whenISent
    global mydate
    global mongoClient
    global db
    '''if mydate != datetime.date.today():
        mydate = datetime.date.today()
        mongoClient.drop_database('test')
        db = mongoClient.data
        '''
    # client.publish("debug", msg.payload)
    print("Topic: ", msg.topic+'\nMessage: '+str(msg.payload))
    json_data = json.loads(msg.payload)
    if json_data["mustSave"]:
        del json_data["mustSave"]
        db.data.find_one_and_update({"location": "Valmorea, Ronchetto"}, {"$push": {"data": json_data}})
    print("DateTime: ", datetime.datetime.fromtimestamp(json_data["timestamp"]).strftime('%d-%m-%Y %H:%M:%S'))
    if (time.time() - whenISent > 600) and (json_data["tempIntCabernet"] > 28 or json_data["tempIntNebbiolo"] > 28 or
                                            json_data["tempExt"] > 25):
        whenISent = time.time()
        _thread.start_new_thread(sendemail, (Info.Info.addressFrom,
                                Info.Info.addressesTo,
                                [],
                                'WineMonitor: warning!',
                                'Il sistema di monitoraggio del mosto ha rilevato una temperatura anomala! \n'
                                'Temperatura Nebbiolo: ' + str(json_data["tempIntNebbiolo"]) + 'C \n'
                                'Temperatura Cabernet: ' + str(json_data["tempIntCabernet"]) + 'C \n'
                                'Temperatura ambiente: ' + str(json_data["tempExt"]) + 'C \n',
                                Info.Info.addressFrom,
                                Info.Info.passwordMailFrom))


mongoClient = MongoClient()
db = mongoClient.winemonitor
client = mqtt.Client("pythonDataFilter")
client.on_connect = on_connect
client.on_message = on_message
whenISent = 0
mydate = datetime.date.today()

client.connect("iot.eclipse.org", 1883, 60)

# Blocking call that processes network traffic, dispatches callbacks and
# handles reconnecting.
# Other loop*() functions are available that give a threaded interface and a
# manual interface.
client.loop_forever()
