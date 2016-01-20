package Helper;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;

/**
 * Created by JaSh on 07-Nov-15.
 */
public class GmailSender {

    public static void sendGmail(Activity activity, String subject, String text) {
        Intent gmailIntent = new Intent();
        gmailIntent.setClassName("com.google.android.gm", "com.google.android.gm.ComposeActivityGmail");
        gmailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, subject);
        gmailIntent.putExtra(android.content.Intent.EXTRA_TEXT, text);
        try {
            activity.startActivity(gmailIntent);
        } catch(ActivityNotFoundException ex) {
            // handle error
        }
    }
}
