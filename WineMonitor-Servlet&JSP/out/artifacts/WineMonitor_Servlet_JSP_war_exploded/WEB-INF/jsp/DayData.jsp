<%@ page import="java.util.ArrayList" %><%--
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

        Object tempIntNebbiolo = request.getAttribute("tempIntNebbiolo");
        Object tempIntCabernet = request.getAttribute("tempIntCabernet");
        Object tempExt = request.getAttribute("tempExt");
        Object humidity = request.getAttribute("humidity");
        Object timestamp = request.getAttribute("timestamp");
        %>

        var tempIntNebbiolo = <%= tempIntNebbiolo %>;
        var tempIntCabernet = <%= tempIntCabernet %>;
        var tempExt = <%= tempExt %>;
        var humidity = <%= humidity %>;
        var timestamp = <%= timestamp %>;

        /*for (var i = 0; i < json.length; i++) {
            timestamp.push((json[i].timestamp)*1000);
            tempIntNebbiolo.push(json[i].tempIntNebbiolo);
            tempIntCabernet.push(json[i].tempIntCabernet);
            tempExt.push(json[i].tempExt);
            humidity.push(json[i].humidity);
        }*/

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
                type: 'date',
            },
            yaxis: {range: [0,35]}
        };

        var data = [traceTemp1, traceTemp2, traceTemp3];

        Plotly.newPlot('tempGraph', data, tempView);

        var humView = {
            title: 'Umidit\u00E0',
            xaxis: {
                type: 'date',
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
</script>
</body>
</html>
