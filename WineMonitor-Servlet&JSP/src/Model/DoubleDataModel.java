package Model;

import com.mongodb.util.JSON;

import java.io.Serializable;
import java.util.ArrayList;

public class DoubleDataModel implements Serializable {
    private ArrayList<Double> list;

    public DoubleDataModel(){
        list = new ArrayList<Double>();
    }

    public void setList(ArrayList<Double> list) {
        this.list = list;
    }

    public ArrayList<Double> getList() {
        return list;
    }

    public void add(Double d){
        list.add(d);
    }

    public void add(double d){
        list.add(d);
    }

    public void add(Number n){
        list.add(n.doubleValue());
    }

    @Override
    public String toString() {
        return JSON.parse(list.toString()).toString();
    }
}
