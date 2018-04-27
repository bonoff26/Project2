class Timer {
    float lasttimecheck;
    float timeinterval;
      
    Timer(float seconds) {
      this.lasttimecheck = 0;
      this.timeinterval = seconds*1000;
    }
    
    boolean Count() {
      //this.lasttimecheck = millis();
      if (millis() > this.lasttimecheck + this.timeinterval) {
        this.lasttimecheck = millis();
        return true;
      }
      else {
        return false;
      }
    } 
}