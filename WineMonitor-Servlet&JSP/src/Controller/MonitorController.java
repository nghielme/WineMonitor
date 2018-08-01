package Controller;

import Model.DoubleDataModel;
import Model.LastValues;
import Model.LastValuesFactory;
import Model.LongDataModel;
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

@WebServlet(name = "MonitorControllerMonitorController", urlPatterns = "/")
public class MonitorController extends HttpServlet {

    private MongoClient client;

    @Override
    public void init() throws ServletException {
        client = new MongoClient();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        MongoDatabase database = client.getDatabase("test");
        MongoCollection<Document> collection = database.getCollection("entry");
        DoubleDataModel tempIntNebbiolo = new DoubleDataModel();
        DoubleDataModel tempIntCabernet = new DoubleDataModel();
        DoubleDataModel tempExt = new DoubleDataModel();
        DoubleDataModel humidity = new DoubleDataModel();
        LongDataModel timestamp = new LongDataModel();
        for (Document cur : collection.find()) {
            tempIntNebbiolo.add(cur.get("tempIntNebbiolo", Number.class));
            tempIntCabernet.add(cur.get("tempIntCabernet", Number.class));
            tempExt.add(cur.get("tempExt", Number.class));
            humidity.add(cur.get("humidity", Number.class));
            timestamp.add(cur.get("timestamp", Number.class));
        }
        LastValues lastValues = new LastValuesFactory(client).obtainLastValues();

        request.setAttribute("lastAvg", lastValues.getAvg());
        request.setAttribute("lastHumidity", lastValues.getHumidity());
        request.setAttribute("lastTimestamp", lastValues.getTimestamp());

        request.setAttribute("tempIntNebbiolo", tempIntNebbiolo);
        request.setAttribute("tempIntCabernet", tempIntCabernet);
        request.setAttribute("tempExt", tempExt);
        request.setAttribute("humidity", humidity);
        request.setAttribute("timestamp", timestamp);
        getServletContext().getRequestDispatcher("/WEB-INF/jsp/monitor.jsp").forward(request,response);
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
