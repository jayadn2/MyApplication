package com.actv.simpfo.myapplication;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.actv.simpfo.myapplication.Model.MobileCollectionJson;
import com.actv.simpfo.myapplication.R;

/**
 * Created by JaSh on 09/07/2015.
 */
public class CustomerBillPrintDialogFragment extends DialogFragment {
    private TextView customerCustIdTextView;
    private TextView customerCustNameTextView;
    private TextView receiptNumberTextView;
    private TextView amountTextView;
    private TextView billDateTextView;
    private TextView lastBalanceTextView;
    private TextView currentBalanceTextView;

    private   MobileCollectionJson selectedCollectionEntry;
    private View view;
    PrintLine printLine;
    @Override
    public Dialog onCreateDialog(Bundle savedInstanceState) {

        AlertDialog.Builder builder = new AlertDialog.Builder(getActivity());
        // Get the layout inflater
        LayoutInflater inflater = getActivity().getLayoutInflater();
        view = inflater.inflate(R.layout.customer_bill_print_dialog, null);
        // Inflate and set the layout for the dialog
        // Pass null as the parent view because its going in the dialog layout
        builder.setView(view)
                // Add action buttons
                .setPositiveButton(R.string.print, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int id) {
                        // Print the bill here ...
                        PrintHelper.PrintLines.clear();
                        printLine = new PrintLine();
                        printLine.Header = "Customer ID";
                        printLine.Value = customerCustIdTextView.getText().toString();
                        PrintHelper.PrintLines.add(printLine);

                        printLine = new PrintLine();
                        printLine.Header = "Customer Name";
                        printLine.Value = customerCustNameTextView.getText().toString();
                        PrintHelper.PrintLines.add(printLine);

                        printLine = new PrintLine();
                        printLine.Header = "Last Balance";
                        printLine.Value = lastBalanceTextView.getText().toString();
                        PrintHelper.PrintLines.add(printLine);

                        printLine = new PrintLine();
                        printLine.Header = "Receipt No.";
                        printLine.Value = receiptNumberTextView.getText().toString();
                        PrintHelper.PrintLines.add(printLine);

                        printLine = new PrintLine();
                        printLine.Header = "Amount";
                        printLine.Value = amountTextView.getText().toString();
                        PrintHelper.PrintLines.add(printLine);

                        printLine = new PrintLine();
                        printLine.Header = "Date";
                        printLine.Value = billDateTextView.getText().toString();
                        PrintHelper.PrintLines.add(printLine);

                        printLine = new PrintLine();
                        printLine.Header = "Current Balance";
                        printLine.Value = currentBalanceTextView.getText().toString();
                        PrintHelper.PrintLines.add(printLine);
                        PrintHelper.Print();
                    }
                });
        FindAllViewsById();
        return builder.create();
    }

    private void FindAllViewsById() {
        customerCustIdTextView =(TextView) view.findViewById(R.id.customerCustIdTextView);
        customerCustNameTextView = (TextView) view.findViewById(R.id.customerCustNameTextView);
        receiptNumberTextView = (TextView) view.findViewById(R.id.receiptNumberTextView);
        amountTextView = (TextView) view.findViewById(R.id.amountTextView);
        billDateTextView = (TextView) view.findViewById(R.id.billDateTextView);
        lastBalanceTextView = (TextView) view.findViewById(R.id.lastBalanceTextView);
        currentBalanceTextView = (TextView) view.findViewById(R.id.currentBalanceTextView);

        selectedCollectionEntry = AppGlobals.SelectedCollectionEntry;
        if(selectedCollectionEntry != null) {
            if (customerCustIdTextView != null)
                customerCustIdTextView.setText(selectedCollectionEntry.CustomerId);

            if (customerCustNameTextView != null)
                customerCustNameTextView.setText(AppGlobals.SelectedCustomerBalanceDetail.getCustName());

            if (receiptNumberTextView != null)
                receiptNumberTextView.setText(selectedCollectionEntry.RecieptNo);

            if (amountTextView != null)
                amountTextView.setText(selectedCollectionEntry.Amount);

            if (billDateTextView != null)
                billDateTextView.setText(selectedCollectionEntry.CollectionDate);

            if (lastBalanceTextView != null)
                lastBalanceTextView.setText(selectedCollectionEntry.LastBalance);

            int amountEntered = HelperClass.stringToInt(selectedCollectionEntry.Amount, 0);
            int lastBalance = HelperClass.stringToInt(selectedCollectionEntry.LastBalance, 0);
            int currentBalance = lastBalance - amountEntered;

            if(currentBalanceTextView != null)
            currentBalanceTextView.setText(String.valueOf(currentBalance));

        }
    }


}
