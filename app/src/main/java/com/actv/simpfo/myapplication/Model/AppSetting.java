package com.actv.simpfo.myapplication.Model;

/**
 * Created by JaSh on 11/08/2015.
 */
public class AppSetting {

    private int id;
    private String server;
    private String pname;
    private String pmac;

    private int printerMaxChar;

    public AppSetting()
    {    }

    public AppSetting(String server, String pname, String pmac) {
        this.setServer(server);
        this.setPname(pname);
        this.setPmac(pmac);
        this.setPrinterMaxChar(38); //Default setting
    }

    public AppSetting(String server, String pname, String pmac, int printMaxChar) {
        this.setServer(server);
        this.setPname(pname);
        this.setPmac(pmac);
        this.setPrinterMaxChar(printMaxChar);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getServer() {
        return server;
    }

    public void setServer(String server) {
        this.server = server;
    }

    public String getPname() {
        return pname;
    }

    public void setPname(String pname) {
        this.pname = pname;
    }

    public String getPmac() {
        return pmac;
    }

    public void setPmac(String pmac) {
        this.pmac = pmac;
    }

    public int getPrinterMaxChar() {
        return printerMaxChar;
    }

    public void setPrinterMaxChar(int printerMaxChar) {
        this.printerMaxChar = printerMaxChar;
    }
}
