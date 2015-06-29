package com.actv.simpfo.myapplication.Model;

/**
 * Created by JaSh on 07/06/2015.
 */
public class CustomerJson {
    private String CustomerName;
    private int ID;
    CustomerJson() {
    }

    public CustomerJson(String customerName, int id)
    {
        setCustomerName(customerName);
        setID(id);
    }

    public String getCustomerName() {
        return CustomerName;
    }

    public void setCustomerName(String customerName) {
        CustomerName = customerName;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }
}
