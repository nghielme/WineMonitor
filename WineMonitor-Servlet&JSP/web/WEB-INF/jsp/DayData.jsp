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
    <style type="text/css">
        .loader {
            border: 16px solid #f3f3f3; /* Light grey */
            border-top: 16px solid #3498db; /* Blue */
            border-radius: 50%;
            width: 120px;
            height: 120px;
            animation: spin 2s linear infinite;
            top: 35%;
            left: 45%;
            position: absolute;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
    <script type="text/javascript">

        // Create a client instance
        client = new Paho.MQTT.Client("iot.eclipse.org", Number(80), "/ws", "visualizationClient-" + Date.now());

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
<body onload="printGraph()">
<div class="loader" id="loader"></div>
<div id="graphs">
    <div id="tempGraph"></div>
    <div id="humGraph"></div>
</div>

<script type="text/javascript">

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

        var data = [traceTemp1, traceTemp2, traceTemp3];

        Plotly.newPlot('tempGraph', data, tempView);

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
                color: '#80CAF6',
                shape: 'spline'
            }
        };

        var data2 = [traceHum];

        Plotly.newPlot('humGraph', data2, humView);
    }

    function printFirstGraph(graph,value,timestamp) {

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
    }
</script>
</body>
</html>
