<%@ page import="Model.DoubleDataModel" %>
<%@ page import="Model.LongDataModel" %>
<%--
  Created by IntelliJ IDEA.
  User: nicologhielmetti
  Date: 25/04/2018
  Time: 23:54
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.js"></script>
    <script src="http://malsup.github.com/jquery.form.js"></script>
    <script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/paho-mqtt/1.0.1/mqttws31.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/style.css">
    <script type="text/javascript">
        // Create a client instance
        client = new Paho.MQTT.Client("broker.hivemq.com", Number(8000), "visualizationClient-" + Date.now());
        // set callback handlers
        client.onConnectionLost = onConnectionLost;
        client.onMessageArrived = onMessageArrived;

        // connect the client
        client.connect({onSuccess:onConnect});

        // called when the client connects
        function onConnect() {
            // Once a connection has been made, make a subscription and send a message.
            //console.log("onConnect");
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
            try {
                var json = JSON.parse(message.payloadString);
            } catch (e){
                return;
            }
            avg = (json.tempIntNebbiolo + json.tempIntCabernet + json.tempExt) / 3;
            hum = json.humidity;
            time = json.timestamp*1000;
        }
    </script>
</head>
<body onload="printGraph()">
<div class="loader" id="loader"></div>
<div id="realTime" style="height: 50%;"></div>
<div id="graphs">
    <div id="tempGraph"></div>
    <div id="humGraph"></div>
</div>

<script type="text/javascript">
    var avg = <%= request.getAttribute("lastAvg")%>;
    var hum = <%= request.getAttribute("lastHumidity")%>;
    var time = new Date();

    function printGraph(){

        <%
        DoubleDataModel tempIntNebbiolo = (DoubleDataModel) request.getAttribute("tempIntNebbiolo");
        DoubleDataModel tempIntCabernet = (DoubleDataModel) request.getAttribute("tempIntCabernet");
        DoubleDataModel tempExt = (DoubleDataModel) request.getAttribute("tempExt");
        DoubleDataModel humidity = (DoubleDataModel) request.getAttribute("humidity");
        LongDataModel timestamp = (LongDataModel) request.getAttribute("timestamp");
        %>

        var tempIntNebbiolo = <%= tempIntNebbiolo.toString() %>;
        var tempIntCabernet = <%= tempIntCabernet.toString() %>;
        var tempExt = <%= tempExt.toString() %>;
        var humidity = <%= humidity.toString() %>;
        var timestamp = <%= timestamp.toString() %>;

        var traceTemp1 = {
            x: timestamp,
            y: tempIntNebbiolo,
            mode: 'lines',
            name: 'Nebbiolo',
            line: {
                color: '#f44141',
                shape: 'spline'
            }
        };

        var traceTemp2 = {
            x: timestamp,
            y: tempIntCabernet,
            mode: 'lines',
            name: 'Cabernet',
            line: {
                color: '#f4d341',
                shape: 'spline'
            }
        };

        var traceTemp3 = {
            x: timestamp,
            y: tempExt,
            mode: 'lines',
            name: 'Ambiente',
            line: {
                color: '#426bf4',
                shape: 'spline'
            }
        };

        var tempView = {
            title: 'Temperature',
            xaxis: {
                type: 'date'
            },
            yaxis: {range: [0,35]}
        };

        var data0 = [traceTemp1, traceTemp2, traceTemp3];

        Plotly.newPlot('tempGraph', data0, tempView);

        var humView = {
            title: 'Umidit\u00E0',
            xaxis: {
                type: 'date'
            },
            yaxis: {range: [0,100]}
        };
        var traceHum = {
            x: timestamp,
            y: humidity,
            mode: 'lines',
            line: {
                color: '#47acf1',
                shape: 'spline'
            }
        };

        var data2 = [traceHum];

        Plotly.newPlot('humGraph', data2, humView);

        var traceReal1 = {
            x: [],
            y: [],
            mode: 'lines',
            name: 'Temperatura media',
            line: {
                color: '#f69e46',
                shape: 'spline'
            }
        };

        var traceReal2 = {
            x: [],
            y: [],
            xaxis: 'x2',
            yaxis: 'y2',
            mode: 'lines',
            name: 'Umidità',
            line: {
                color: '#47acf1',
                shape: 'spline'
            }
        };

        var layout = {
            title:'Dati in tempo reale',
            xaxis: {
                type: 'date',
                domain: [0, 1],
                showticklabels: false
            },
            yaxis: {domain: [0.55,1]},
            xaxis2: {
                type: 'date',
                anchor: 'y2',
                domain: [0, 1]
            },
            yaxis2: {
                anchor: 'x2',
                domain: [0, 0.45]}
        };

        var data = [traceReal1,traceReal2];

        Plotly.plot('realTime', data, layout);
    }

    /*function printFirstGraph(graph,value,timestamp) {

        var time = new Date(timestamp*1000);
        console.log(value + " - " + graph);
        var update = {
            x:  [[time]],
            y:  [[value]]
        };
        var olderTime  = time.setMinutes(time.getMinutes() - 2);
        var futureTime = time.setMinutes(time.getMinutes() + 2);
        var minuteView = {
            xaxis: {
                type: 'date',
                range: [olderTime,futureTime]
            }
        };
        Plotly.relayout(graph, minuteView);
        Plotly.extendTraces(graph, update, [0]);

        if(cnt === 100) clearInterval(interval);
    }*/
    var interval = setInterval(function() {

        var time = new Date();

        var update = {
            x: [[time], [time]],
            y: [[avg], [hum]]
        };

        Plotly.extendTraces('realTime', update, [0,1]);

        //if(cnt === 100) clearInterval(interval);
    }, 100);

</script>
</body>
</html>
