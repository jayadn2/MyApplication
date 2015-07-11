package com.actv.simpfo.myapplication;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.DialogFragment;
import android.content.DialogInterface;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.actv.simpfo.myapplication.R;

/**
 * Created by JaSh on 09/07/2015.
 */
public class CustomerBillPrintDialogFragment extends DialogFragment {
    private TextView customerCustIdTextView;
    private TextView customerCustNameTextView;
    View view;
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
                    }
                });
        FindAllViewsById();
        return builder.create();
    }

    private void FindAllViewsById() {
        customerCustIdTextView =(TextView) view.findViewById(R.id.custid_bill_print_text_view);
        customerCustNameTextView = (TextView) view.findViewById(R.id.name_bill_print_text_view);
        if(customerCustIdTextView != null)
            customerCustIdTextView.setText("Hi");
        if(customerCustNameTextView != null)
            customerCustNameTextView.setText("Hello");
    }


}
