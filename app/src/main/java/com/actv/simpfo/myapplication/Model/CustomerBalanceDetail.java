package com.actv.simpfo.myapplication.Model;
import java.util.Date;

/**
 * Created by JaSh on 11/06/2015.
 */
public class CustomerBalanceDetail {
    private String CustId;
    private String CustName;
    private String Adress;
    private String LastPaidAmt;
    private String LastPaidDate;
    private String TotalBalance;
    private String CurrentPayment;
    private String CurrentPaymentDate;
    private String EmpId;
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

    public String getCustId() {
        return CustId;
    }

    public void setCustId(String custId) {
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

    public String getLastPaidAmt() {
        return LastPaidAmt;
    }

    public void setLastPaidAmt(String lastPaidAmt) {
        LastPaidAmt = lastPaidAmt;
    }

    public String getLastPaidDate() {
        return LastPaidDate;
    }

    public void setLastPaidDate(String lastPaidDate) {
        LastPaidDate = lastPaidDate;
    }

    public String getTotalBalance() {
        return TotalBalance;
    }

    public void setTotalBalance(String totalBalance) {
        TotalBalance = totalBalance;
    }

    public String getCurrentPayment() {
        return CurrentPayment;
    }

    public void setCurrentPayment(String currentPayment) {
        CurrentPayment = currentPayment;
    }

    public String getCurrentPaymentDate() {
        return CurrentPaymentDate;
    }

    public void setCurrentPaymentDate(String currentPaymentDate) {
        CurrentPaymentDate = currentPaymentDate;
    }

    public String getEmpId() {
        return EmpId;
    }

    public void setEmpId(String empId) {
        EmpId = empId;
    }

    public String getGpsLocation() {
        return GpsLocation;
    }

    public void setGpsLocation(String gpsLocation) {
        GpsLocation = gpsLocation;
    }
}
