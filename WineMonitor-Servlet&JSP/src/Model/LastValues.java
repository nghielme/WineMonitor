package Model;

public class LastValues{
    private Long timestamp;
    private Double tempNebbiolo;
    private Double tempCabernet;
    private Double tempExt;
    private Double humidity;

    public Double getHumidity() {
        return humidity;
    }

    public void setHumidity(Double humidity) {
        this.humidity = humidity;
    }

    public Long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Long timestamp) {
        this.timestamp = timestamp*1000;
    }

    public Double getTempNebbiolo() {
        return tempNebbiolo;
    }

    public void setTempNebbiolo(Double tempNebbiolo) {
        this.tempNebbiolo = tempNebbiolo;
    }

    public Double getTempCabernet() {
        return tempCabernet;
    }

    public void setTempCabernet(Double tempCabernet) {
        this.tempCabernet = tempCabernet;
    }

    public Double getTempExt() {
        return tempExt;
    }

    public void setTempExt(Double tempExt) {
        this.tempExt = tempExt;
    }

    public Double getAvg(){
        return (tempNebbiolo + tempCabernet + tempExt) / 3;
    }

    public LastValues(Long timestamp, Double tempNebbiolo, Double tempCabernet, Double tempExt, Double humidity) {
        this.timestamp = timestamp*1000;
        this.tempNebbiolo = tempNebbiolo;
        this.tempCabernet = tempCabernet;
        this.tempExt = tempExt;
        this.humidity = humidity;
    }
}
