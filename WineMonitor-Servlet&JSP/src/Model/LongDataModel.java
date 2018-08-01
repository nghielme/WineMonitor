package Model;

import com.mongodb.util.JSON;

import java.io.Serializable;
import java.util.ArrayList;

public class LongDataModel implements Serializable {
    private ArrayList<Long> list;

    public LongDataModel(){
        list = new ArrayList<Long>();
    }

    public ArrayList<Long> getList() {
        return list;
    }

    public void setList(ArrayList<Long> list) {
        this.list = list;
    }

    public void add(Long l){
        list.add(l*1000);
    }

    public void add(long l){
        list.add(l*1000);
    }

    public void add(Number n){
        list.add(n.longValue()*1000);
    }

    @Override
    public String toString() {
        return (JSON.parse(list.toString())).toString();
    }
}
