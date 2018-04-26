package Controller;

import com.mongodb.BasicDBObject;
import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.util.JSON;
import org.bson.BsonDocument;
import org.bson.Document;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

@WebServlet(name = "DayDataController", urlPatterns = "/DayData")
public class DayDataController extends HttpServlet {

    private MongoClient client;

    @Override
    public void init() throws ServletException {
        client = new MongoClient();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        MongoDatabase database = client.getDatabase("test");
        MongoCollection<Document> collection = database.getCollection("entry");

        /*PrintWriter out = response.getWriter();
        for (Document cur : collection.find()) {
            out.println(cur.toJson());
        }
        out.close();*/


        ArrayList<Double> tempIntNebbiolo = new ArrayList<Double>();
        ArrayList<Double> tempIntCabernet = new ArrayList<Double>();
        ArrayList<Double> tempExt = new ArrayList<Double>();
        ArrayList<Double> humidity = new ArrayList<Double>();
        ArrayList<Long> timestamp = new ArrayList<Long>();

        for (Document cur : collection.find()) {
            Object obj = cur.get("tempIntNebbiolo");
            if(obj instanceof Double)
                tempIntNebbiolo.add((Double) obj);
            else
                tempIntNebbiolo.add(((Integer)obj).doubleValue());

            obj = cur.get("tempIntCabernet");
            if(obj instanceof Double)
                tempIntCabernet.add((Double) obj);
            else
                tempIntCabernet.add(((Integer)obj).doubleValue());

            obj = cur.get("tempExt");
            if(obj instanceof Double)
                tempExt.add((Double) obj);
            else
                tempExt.add(((Integer)obj).doubleValue());

            obj = cur.get("humidity");
            if(obj instanceof Double)
                humidity.add((Double) obj);
            else
                humidity.add(((Integer)obj).doubleValue());
            obj = cur.get("timestamp");
            if(obj instanceof Integer)
                timestamp.add(((Integer) obj).longValue());
            else
                timestamp.add((Long)obj);
        }
        /*PrintWriter out = response.getWriter();
        out.println(tempIntNebbiolo.toString());*/

        Object jsonNebbiolo = JSON.parse(tempIntNebbiolo.toString());
        Object jsonCabernet = JSON.parse(tempIntCabernet.toString());
        Object jsonExt = JSON.parse(tempExt.toString());
        Object jsonHum = JSON.parse(humidity.toString());
        Object jsonTime = JSON.parse(timestamp.toString());

        request.setAttribute("tempIntNebbiolo", jsonNebbiolo);
        request.setAttribute("tempIntCabernet", jsonCabernet);
        request.setAttribute("tempExt", jsonExt);
        request.setAttribute("humidity", jsonHum);
        request.setAttribute("timestamp", jsonTime);
        getServletContext().getRequestDispatcher("/WEB-INF/jsp/DayData.jsp").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }

    @Override
    public void destroy() {
        if(client != null)
            client.close();
    }
}
