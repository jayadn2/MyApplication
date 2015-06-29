package com.actv.simpfo.myapplication.Model;

/**
 * Created by JaSh on 15/05/2015.
 */
public class User {

    private String userName;
    private String password;
    private int empId;

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getEmpId() {
        return empId;
    }

    public void setEmpId(int empId) {
        this.empId = empId;
    }
}
