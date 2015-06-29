package Helper;

/**
 * Created by JaSh on 19/06/2015.
 */
import com.actv.simpfo.myapplication.Model.CustomerJson;

import java.util.Comparator;

public class SortBasedOnName implements Comparator
{

    public int compare(Object o1, Object o2)
    {

        CustomerJson dd1 = (CustomerJson)o1;
        CustomerJson dd2 = (CustomerJson)o2;
        return dd1.getCustomerName().compareToIgnoreCase(dd2.getCustomerName());
    }

}
