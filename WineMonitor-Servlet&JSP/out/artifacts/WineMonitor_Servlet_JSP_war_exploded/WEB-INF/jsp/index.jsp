<%@ page import="java.util.Date" %><%--
  Created by IntelliJ IDEA.
  User: nicologhielmetti
  Date: 01/05/2018
  Time: 14:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Home page - WineMonitor</title>
</head>
<body>
    <h2>Benvenuto sulla pagina di monitoraggio del vino</h2>
    <h3>Data e ora: <%= (new Date())%></h3>
    <p>
        <ul>
            <li>
                <a href="DayData">Pagina per vedere l'andamento di temperature (ambiente e dei due tini) fino a 24h precedenti</a>
            </li>
            <li>
                <a href="RealTimeData">Pagina per vedere l'andamento di umidità e temperature in tempo reale</a>
            </li>
        </ul>
    </p>
</body>
</html>
