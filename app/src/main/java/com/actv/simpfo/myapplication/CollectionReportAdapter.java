package com.actv.simpfo.myapplication;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Filter;
import android.widget.Filterable;
import android.widget.TextView;

import com.actv.simpfo.myapplication.Model.MobileCollectionResponseModel;

import java.util.ArrayList;

/**
 * Created by JaSh on 31/07/2015.
 */
public class CollectionReportAdapter extends ArrayAdapter<MobileCollectionResponseModel> implements Filterable {

    private HttpRetriever httpRetriever = new HttpRetriever();
    private ArrayList<MobileCollectionResponseModel> collectionDataItems;
    private Activity context;
    private MobileCollectionResponseModel mobileCollectionResponseModel;
    //Two data sources, the original data and filtered data
    private ArrayList<MobileCollectionResponseModel> originalData;
    private ArrayList<MobileCollectionResponseModel> filteredData;

    public CollectionReportAdapter(Activity context, int textViewResourceId, ArrayList<MobileCollectionResponseModel> _collectionDataItems) {
        super(context, textViewResourceId, _collectionDataItems);
        this.context = context;
        this.collectionDataItems = _collectionDataItems;
        //To start, set both data sources to the incoming data
        originalData = _collectionDataItems;
        filteredData = _collectionDataItems;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        final CollectionReportViewHolder mHolder;
        View view = convertView;
        MobileCollectionResponseModel mobileCollectionResponseModel = filteredData.get(position);
        if (view == null) {
            LayoutInflater vi = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            view = vi.inflate(R.layout.collection_report_row, null);
            mHolder = new CollectionReportViewHolder();

            if (mobileCollectionResponseModel != null) {
                mHolder.nameTextView = (TextView) view.findViewById(R.id.name_text_view);
                mHolder.custIdTextView = (TextView) view.findViewById(R.id.cusid_text_view);
                mHolder.receiptNoTextView = (TextView) view.findViewById(R.id.receipt_no_text_view);
                mHolder.collectionDateTextView = (TextView) view.findViewById(R.id.collection_date_text_view);
                mHolder.amountTextView = (TextView) view.findViewById(R.id.amount_text_view);
                view.setTag(mHolder);

            }
        }
        else {
            mHolder = (CollectionReportViewHolder) view.getTag();

        }

        mHolder.nameTextView.setText(mobileCollectionResponseModel.CustomerName);
        mHolder.custIdTextView.setText("Cust ID: " + mobileCollectionResponseModel.CustomerId);
        mHolder.receiptNoTextView.setText(mobileCollectionResponseModel.RecieptNo);
        mHolder.collectionDateTextView.setText(mobileCollectionResponseModel.CollectionDate);
        mHolder.amountTextView.setText(mobileCollectionResponseModel.Amount);

        return view;
    }

    //For this helper method, return based on filteredData
    public int getCount()
    {
        return filteredData.size();
    }

    //This should return a data object, not an int
    public MobileCollectionResponseModel getItem(int position)
    {
        return filteredData.get(position);
    }

    public long getItemId(int position)
    {
        return position;
    }

    @Override
    public Filter getFilter() {
        return new Filter()
        {
            @Override
            protected FilterResults performFiltering(CharSequence charSequence)
            {
                FilterResults results = new FilterResults();

                //If there's nothing to filter on, return the original data for your list
                if(charSequence == null || charSequence.length() == 0)
                {
                    results.values = originalData;
                    results.count = originalData.size();
                }
                else
                {
                    ArrayList<MobileCollectionResponseModel> filterResultsData = new ArrayList<MobileCollectionResponseModel>();

                    for(MobileCollectionResponseModel data : originalData)
                    {
                        //In this loop, you'll filter through originalData and compare each item to charSequence.
                        //If you find a match, add it to your new ArrayList
                        //I'm not sure how you're going to do comparison, so you'll need to fill out this conditional
                        String custId = String.valueOf(data.CustomerId);
                        if(data.CustomerName.toLowerCase().contains(charSequence.toString()) || custId.toLowerCase().contains(charSequence))
                        {
                            filterResultsData.add(data);
                        }
                    }

                    results.values = filterResultsData;
                    results.count = filterResultsData.size();
                }

                return results;
            }

            @Override
            protected void publishResults(CharSequence charSequence, FilterResults filterResults)
            {
                filteredData = (ArrayList<MobileCollectionResponseModel>)filterResults.values;
                notifyDataSetChanged();
            }
        };
    }
}

class CollectionReportViewHolder {
    TextView nameTextView;
    TextView custIdTextView;
    TextView receiptNoTextView;
    TextView collectionDateTextView;
    TextView amountTextView;
}
