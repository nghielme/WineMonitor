package Model;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import org.bson.Document;

import static com.mongodb.client.model.Sorts.descending;
import static com.mongodb.client.model.Sorts.orderBy;

public class LastValuesFactory {

    private MongoClient client;

    public LastValuesFactory(MongoClient client){
        this.client = client;
    }

    public LastValues obtainLastValues(){
        MongoCollection<Document > collection = client.getDatabase("test").getCollection("entry");
        Document lastDoc = collection.find().sort(orderBy(descending("timestamp"))).first();
        return new LastValues(lastDoc.get("timestamp", Number.class).longValue(),
                lastDoc.get("tempIntNebbiolo", Number.class).doubleValue(),
                lastDoc.get("tempIntCabernet", Number.class).doubleValue(),
                lastDoc.get("tempExt", Number.class).doubleValue(),
                lastDoc.get("humidity", Number.class).doubleValue());
    }
}
