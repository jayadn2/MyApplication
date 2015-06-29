package com.actv.simpfo.myapplication.Model;
import java.util.Date;

/**
 * Created by JaSh on 11/06/2015.
 */
public class CustomerBalanceDetail {
    private int CustId;
    private String CustName;
    private String Adress;
    private int LastPaidAmt;
    private String LastPaidDate;
    private int TotalBalance;
    private int CurrentPayment;
    private String CurrentPaymentDate;
    private int EmpId;
    private String GpsLocation;

    public CustomerBalanceDetail() {
    }

    public CustomerBalanceDetail(CustomerBalanceDetail _customerBalanceDetail) {
        CustId = _customerBalanceDetail.getCustId();
        CustName = _customerBalanceDetail.getCustName();
        Adress = _customerBalanceDetail.getAdress();
        LastPaidAmt = _customerBalanceDetail.getLastPaidAmt();
        LastPaidDate = _customerBalanceDetail.getLastPaidDate();
        TotalBalance = _customerBalanceDetail.getTotalBalance();
        CurrentPayment = _customerBalanceDetail.getCurrentPayment();
        CurrentPaymentDate = _customerBalanceDetail.getCurrentPaymentDate();
        EmpId = _customerBalanceDetail.getEmpId();
        GpsLocation = _customerBalanceDetail.getGpsLocation();
    }

    public int getCustId() {
        return CustId;
    }

    public void setCustId(int custId) {
        CustId = custId;
    }

    public String getCustName() {
        return CustName;
    }

    public void setCustName(String custName) {
        CustName = custName;
    }

    public String getAdress() {
        return Adress;
    }

    public void setAdress(String adress) {
        Adress = adress;
    }

    public int getLastPaidAmt() {
        return LastPaidAmt;
    }

    public void setLastPaidAmt(int lastPaidAmt) {
        LastPaidAmt = lastPaidAmt;
    }

    public String getLastPaidDate() {
        return LastPaidDate;
    }

    public void setLastPaidDate(String lastPaidDate) {
        LastPaidDate = lastPaidDate;
    }

    public int getTotalBalance() {
        return TotalBalance;
    }

    public void setTotalBalance(int totalBalance) {
        TotalBalance = totalBalance;
    }

    public int getCurrentPayment() {
        return CurrentPayment;
    }

    public void setCurrentPayment(int currentPayment) {
        CurrentPayment = currentPayment;
    }

    public String getCurrentPaymentDate() {
        return CurrentPaymentDate;
    }

    public void setCurrentPaymentDate(String currentPaymentDate) {
        CurrentPaymentDate = currentPaymentDate;
    }

    public int getEmpId() {
        return EmpId;
    }

    public void setEmpId(int empId) {
        EmpId = empId;
    }

    public String getGpsLocation() {
        return GpsLocation;
    }

    public void setGpsLocation(String gpsLocation) {
        GpsLocation = gpsLocation;
    }
}
