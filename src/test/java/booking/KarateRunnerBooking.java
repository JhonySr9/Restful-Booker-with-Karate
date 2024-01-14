package booking;

import com.intuit.karate.junit5.Karate;

public class KarateRunnerBooking {

    @Karate.Test
    Karate Booking (){
        return Karate.run().relativeTo(getClass());
    }
}
