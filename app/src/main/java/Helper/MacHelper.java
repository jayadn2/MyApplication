package Helper;

import android.content.Context;
import android.net.wifi.WifiManager;

import com.actv.simpfo.myapplication.AppGlobals;

/**
 * Created by JaSh on 27/06/2015.
 */
public class MacHelper {

    public static String GetMacId()
    {
        WifiManager wimanager = (WifiManager) AppGlobals.getContext().getSystemService(Context.WIFI_SERVICE);
        String macAddress = wimanager.getConnectionInfo().getMacAddress();
        if (macAddress == null) {
            macAddress = "Device don't have mac address or wi-fi is disabled";
        }
        return macAddress;


    }
}
