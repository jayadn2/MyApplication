package com.actv.simpfo.myapplication;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Intent;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import android.os.Handler;

/**
 * Created by JaSh on 12/07/2015.
 */
public class PrintHelper {

    public static String Header;
    public List<PrintLine> PrintLines  = new ArrayList<PrintLine>();
    private static boolean isConnected = false;
    public static String PrinterName = "BTP-B00955";

    // android built in classes for bluetooth operations
    private static BluetoothAdapter mBluetoothAdapter;
    private static BluetoothSocket mmSocket;
    private static BluetoothDevice mmDevice;

    private static OutputStream mmOutputStream;
    private static InputStream mmInputStream;
    private static Thread workerThread;

    private static byte[] readBuffer;
    private static int readBufferPosition;
    private static int counter;
    private static volatile boolean stopWorker;
    private static String statusMessage;

    public PrintHelper()    {    }

    public void Print()
    {
        if(isConnected)
        {
            //Print to the printer
            try {
                sendData();
            } catch (IOException ex) {
            }
        }
    }

    public static boolean ConnectToPrinter()
    {
        try {
            findBT();
            openBT();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return isConnected;
    }

    public static boolean IsConnected()
    {
        return isConnected;
    }

    public static void CloseConnection()
    {
        try {
            closeBT();
        } catch (IOException ex) {
        }
    }

    // This will find a bluetooth printer device
    private static void findBT() {

        try {
            mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

            if (mBluetoothAdapter == null) {
                isConnected = false;
                //myLabel.setText("No bluetooth adapter available");
            }

            if (!mBluetoothAdapter.isEnabled()) {
                Intent enableBluetooth = new Intent(
                        BluetoothAdapter.ACTION_REQUEST_ENABLE);
                AppGlobals.MainActivity.startActivityForResult(enableBluetooth, 0);
            }

            Set<BluetoothDevice> pairedDevices = mBluetoothAdapter
                    .getBondedDevices();
            if (pairedDevices.size() > 0) {
                for (BluetoothDevice device : pairedDevices) {

                    // PrinterName is the name of the bluetooth printer device
                    if (device.getName().equals(PrinterName)) {
                        mmDevice = device;
                        break;
                    }
                }
            }
            //myLabel.setText("Bluetooth Device Found");
        } catch (NullPointerException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Tries to open a connection to the bluetooth printer device
    private static void openBT() throws IOException {
        try {
            // Standard SerialPortService ID
            UUID uuid = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb");
            mmSocket = mmDevice.createRfcommSocketToServiceRecord(uuid);
            mmSocket.connect();
            mmOutputStream = mmSocket.getOutputStream();
            mmInputStream = mmSocket.getInputStream();

            beginListenForData();

            //myLabel.setText("Bluetooth Opened");
            isConnected = true;
        } catch (NullPointerException e) {
            e.printStackTrace();
            isConnected = false;
        } catch (Exception e) {
            e.printStackTrace();
            isConnected = false;
        }
    }

    // After opening a connection to bluetooth printer device,
    // we have to listen and check if a data were sent to be printed.
    private static void beginListenForData() {
        try {
            final Handler handler = new Handler();

            // This is the ASCII code for a newline character
            final byte delimiter = 10;

            stopWorker = false;
            readBufferPosition = 0;
            readBuffer = new byte[1024];

            workerThread = new Thread(new Runnable() {
                public void run() {
                    while (!Thread.currentThread().isInterrupted()
                            && !stopWorker) {

                        try {

                            int bytesAvailable = mmInputStream.available();
                            if (bytesAvailable > 0) {
                                byte[] packetBytes = new byte[bytesAvailable];
                                mmInputStream.read(packetBytes);
                                for (int i = 0; i < bytesAvailable; i++) {
                                    byte b = packetBytes[i];
                                    if (b == delimiter) {
                                        byte[] encodedBytes = new byte[readBufferPosition];
                                        System.arraycopy(readBuffer, 0,
                                                encodedBytes, 0,
                                                encodedBytes.length);
                                        final String data = new String(
                                                encodedBytes, "US-ASCII");
                                        readBufferPosition = 0;

                                        handler.post(new Runnable() {
                                            public void run() {
                                                statusMessage = data;
                                            }
                                        });
                                    } else {
                                        readBuffer[readBufferPosition++] = b;
                                    }
                                }
                            }

                        } catch (IOException ex) {
                            stopWorker = true;
                        }

                    }
                }
            });

            workerThread.start();
        } catch (NullPointerException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /*
     * This will send data to be printed by the bluetooth printer
     */
    private static void sendData() throws IOException {
        try {

            // the text typed by the user
            String msg = Header;
            msg += "\n";

            mmOutputStream.write(msg.getBytes());

            // tell the user data were sent
            statusMessage = "Data Sent";

        } catch (NullPointerException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Close the connection to bluetooth printer.
    private static void closeBT() throws IOException {
        try {
            stopWorker = true;
            mmOutputStream.close();
            mmInputStream.close();
            mmSocket.close();
            isConnected = false;
            //myLabel.setText("Bluetooth Closed");
        } catch (NullPointerException e) {
            e.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
