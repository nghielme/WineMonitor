package com.nicolo.Entity;

import org.bson.types.ObjectId;
import org.springframework.data.annotation.Id;


public class Entry {
    @Id
    private ObjectId _id;

    private Long timestamp;
    private Double tempIntNebbiolo;
    private Double tempIntCabernet;
    private Double tempExt;
    private Double humidity;

    public Entry(ObjectId _id, double tempIntNebbiolo, double tempIntCabernet, double tempExt, double humidity,
                 long timestamp) {
        this._id = _id;
        this.tempIntNebbiolo = tempIntNebbiolo;
        this.tempIntCabernet = tempIntCabernet;
        this.tempExt = tempExt;
        this.humidity = humidity;
        this.timestamp = timestamp;
    }

    public Entry(){}

    public void setTempIntNebbiolo(Double tempInt) {
        this.tempIntNebbiolo = tempInt;
    }

    public void setTempIntCabernet(Double tempInt) {
        this.tempIntCabernet = tempInt;
    }

    public void setTempExt(Double tempExt) {
        this.tempExt = tempExt;
    }

    public void setHumidity(Double humidity) {
        this.humidity = humidity;
    }

    public void setTimestamp(Long timestamp){this.timestamp = timestamp;}

    public void set_id(ObjectId _id){this._id = _id;}

    public Double getTempIntNebbiolo() {
        return tempIntNebbiolo;
    }

    public Double getTempIntCabernet() {
        return tempIntCabernet;
    }

    public Double getTempExt() {
        return tempExt;
    }

    public Double getHumidity() {
        return humidity;
    }

    public Long getTimestamp(){return timestamp;}

    public ObjectId get_id() {
        return _id;
    }

}
