<%--
  Created by IntelliJ IDEA.
  User: nicologhielmetti
  Date: 25/04/2018
  Time: 15:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dati in tempo reale</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.min.js" type="text/javascript"></script>
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    <script type="text/javascript">

        // Create a client instance
        client = new Paho.MQTT.Client("winemonitoresp.ddns.net", Number(8888), "visualizationClient-" + Date.now());

        // set callback handlers
        client.onConnectionLost = onConnectionLost;
        client.onMessageArrived = onMessageArrived;

        // connect the client
        client.connect({onSuccess:onConnect});


        // called when the client connects
        function onConnect() {
            // Once a connection has been made, make a subscription and send a message.
            console.log("onConnect");
            //client.subscribe("temp");
            client.subscribe("data");
            /*message = new Paho.MQTT.Message("Hello");
            message.destinationName = "World";
            client.send(message);*/
        }

        // called when the client loses its connection
        function onConnectionLost(responseObject) {
            if (responseObject.errorCode !== 0) {
                console.log("onConnectionLost:"+responseObject.errorMessage);
            }
        }

        // called when a message arrives
        function onMessageArrived(message) {
            console.log("onMessageArrived:"+message.destinationName);
            //printGraph(parseInt(message.payloadString));
            var json = JSON.parse(message.payloadString);
            printGraphs(json);
            //printGraphs(json.tempExt,json.timestamp);
        }
    </script>
</head>
<body>
<div id="graph1"></div>
<div id="graph2"></div>
<div id="graph3"></div>
<div id="graph4"></div>
<script type="text/javascript">

    var allGraphs = [
        {
            graphName : 'graph1',
            value : "tempIntNebbiolo"
        },
        {
            graphName : 'graph2',
            value : "tempIntCabernet"
        },
        {
            graphName : 'graph3',
            value : "tempExt"
        },
        {
            graphName : 'graph4',
            value : "humidity"
        }];

    var time;
    var val;
    var data1 = [{
        x: [time],
        y: [val],
        mode: 'lines',
        line: {
            color: '#80CAF6',
            shape: 'hv'
        }
    }]

    var data2 = [{
        x: [time],
        y: [val],
        mode: 'lines',
        line: {
            color: '#80CAF6',
            shape: 'hv'
        }
    }]

    var data3 = [{
        x: [time],
        y: [val],
        mode: 'lines',
        line: {
            color: '#80CAF6',
            shape: 'hv'
        }
    }]

    var data4 = [{
        x: [time],
        y: [val],
        mode: 'lines',
        line: {
            color: '#80CAF6',
            shape: 'hv'
        }
    }]
    Plotly.plot('graph1', data1);
    Plotly.plot('graph2', data2);
    Plotly.plot('graph3', data3);
    Plotly.plot('graph4', data4);
    var cnt = 0;

    function printGraphs(json){
        var time = new Date(json.timestamp*1000);
        console.log(
            time.getFullYear() + "-" + parseInt(time.getMonth() + 1) + "-" + time.getDay() + " " + time.getHours() + ":" + time.getMinutes() + ":" + time.getSeconds()
        );
        for (i = 0; i < allGraphs.length; i++)
            printGraph(allGraphs[i].graphName,json[allGraphs[i].value],json.timestamp);
    }

    window.onload = function (){
        var value;
        var time = new Date();
        console.log(time);
        var update = {
            x:  [[time]],
            y: [[value]]
        }

        var olderTime  = time.setMinutes(time.getMinutes() - 2);
        var futureTime = time.setMinutes(time.getMinutes() + 2);
        var tempView1 = {
            title: 'Temperatura Nebbiolo',
            xaxis: {
                type: 'date',
                range: [olderTime,futureTime]
            },
            yaxis: {range: [0,35]}
        };

        var tempView2 = {
            title: 'Temperatura Cabernet',
            xaxis: {
                type: 'date',
                range: [olderTime,futureTime]
            },
            yaxis: {range: [0,35]}
        };

        var tempView3 = {
            title: 'Temperatura Ambiente',
            xaxis: {
                type: 'date',
                range: [olderTime,futureTime]
            },
            yaxis: {range: [0,35]}
        };

        var humView = {
            title: 'Umidit\u00E0 Ambiente',
            xaxis: {
                type: 'date',
                range: [olderTime,futureTime]
            },
            yaxis: {range: [0,100]}
        };

        Plotly.relayout('graph1', tempView1);
        Plotly.extendTraces('graph1', update, [0])
        Plotly.relayout('graph2', tempView2);
        Plotly.extendTraces('graph2', update, [0])
        Plotly.relayout('graph3', tempView3);
        Plotly.extendTraces('graph3', update, [0])
        Plotly.relayout('graph4', humView);
        Plotly.extendTraces('graph4', update, [0])
    }

    function printGraph(graph,value,timestamp) {

        var time = new Date(timestamp*1000);
        console.log(value + " - " + graph);
        var update = {
            x:  [[time]],
            y:  [[value]]
        }
        var olderTime  = time.setMinutes(time.getMinutes() - 2);
        var futureTime = time.setMinutes(time.getMinutes() + 2);
        var minuteView = {
            xaxis: {
                type: 'date',
                range: [olderTime,futureTime]
            }
        };
        Plotly.relayout(graph, minuteView);
        Plotly.extendTraces(graph, update, [0])

        if(cnt === 100) clearInterval(interval);
    }
</script>
</body>
</html>
