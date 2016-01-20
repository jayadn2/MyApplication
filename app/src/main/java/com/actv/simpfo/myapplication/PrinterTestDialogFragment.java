package com.actv.simpfo.myapplication;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

/**
 * Created by JaSh on 05/08/2015.
 */
public class PrinterTestDialogFragment extends DialogFragment {
    private View view;
    private Button connectButton;
    private Button printTestButton;
    private TextView printerStatusTextView;
    private TextView printerNameTextView;

    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {

        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        // Get the layout inflater
        LayoutInflater inflater = getActivity().getLayoutInflater();
        view = inflater.inflate(R.layout.printer_test_dialog, null);

        // Inflate and set the layout for the dialog
        // Pass null as the parent view because its going in the dialog layout
        builder.setView(view)
                // Add action buttons
                .setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {

                    }
                });

        FindAllViewsById();
        return builder.create();
    }

    private void FindAllViewsById() {
        printerStatusTextView = (TextView) view.findViewById(R.id.printerStatusTextView);
        printerNameTextView = (TextView) view.findViewById(R.id.printerNameTextView);
        connectButton = (Button) view.findViewById(R.id.connectButton);
        printTestButton = (Button) view.findViewById(R.id.printTestButton);

        SetPrinterStatus();
        connectButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Connect to the Bluetooth Printer
                PrintHelper.ConnectToPrinter();
                SetPrinterStatus();
            }
        });
        printTestButton.setOnClickListener(new View.OnClickListener() {
                                               @Override
                                               public void onClick(View v) {
                                                   SetPrinterStatus();
                                                   //Test print
                                                   //PrintHelper.TestPrint("Siti");
                                                   //PrintHelper.TestPrint("Hi..", "This is test print..");
                                                   //PrintHelper.FeedLine();
                                                   PrintHelper.TestBillPrint();
                                               }
                                           });
    }

    public void SetPrinterStatus()
    {
        if(PrintHelper.IsConnected())
        {
            printerStatusTextView.setText("Connected.");
        }
        else {
            printerStatusTextView.setText("Disconnected.");
        }
        printerNameTextView.setText(AppGlobals.PrinterName);
    }
}
