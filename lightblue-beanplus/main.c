void setup()
{
   pinMode(5, 1);
   pinMode(6, 1);
   pinMode(7, 1);
   Serial.begin();
}

void loop()
{  
    AccelerationReading accel = Bean.getAcceleration();

    Bean.setScratchNumber(1, accel.xAxis);     
    Bean.setScratchNumber(2, accel.yAxis);
    Bean.setScratchNumber(3, accel.zAxis);

    uint16_t r = (abs(accel.xAxis))/2; 
    uint16_t g = (abs(accel.yAxis))/2; 
    uint16_t b = (abs(accel.zAxis))/2;

    analogWrite(5, r);
    analogWrite(6, g);
    analogWrite(7, b);
    
    Bean.setLed((uint8_t)r, (uint8_t)g, (uint8_t)b);
}