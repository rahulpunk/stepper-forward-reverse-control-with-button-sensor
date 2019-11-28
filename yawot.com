

#include <Stepper.h>
// defines pins numbers
const int stepPin = 8;
const int dirPin = 9;
const int enPin = 10;
const int LimitSwitch_LEFT_Pin  = 11;
const int LimitSwitch_RIGHT_Pin = 12;


const int stepsPerRevolution = 3200;  // change this to fit the number of steps per revolution
// for your motor


// initialize the stepper library on pins 8 through 11:
Stepper myStepper(stepsPerRevolution, 5, 5, 2, 2);

int stepCount = 0;  // number of steps the motor has taken

void setup() {
  // nothing to do inside the setup
 
  pinMode(LimitSwitch_LEFT_Pin , INPUT);
  pinMode(LimitSwitch_RIGHT_Pin , INPUT);
 
  // Sets the two pins as Outputs
  pinMode(stepPin,OUTPUT);
  pinMode(dirPin,OUTPUT);

  pinMode(enPin,OUTPUT);
  digitalWrite(enPin,LOW);

  // Set Dir to Home switch
  digitalWrite(dirPin,HIGH); // Enables the motor to move in a particular direction


}

void loop() {




 
  // read the sensor value:
  int sensorReading = analogRead(A0);
  // map it to a range from 0 to 100:
  int motorSpeed = map(sensorReading, 0,1023,1,100);
  // set the motor speed:
  if (motorSpeed > 0) {
    myStepper.setSpeed(motorSpeed);
    // step 1/100 of a revolution:
    myStepper.step(stepsPerRevolution /400);
  }

 int leftSw  = digitalRead( LimitSwitch_LEFT_Pin);
    int rightSw = digitalRead( LimitSwitch_RIGHT_Pin);
   
    if( (leftSw  == HIGH && (digitalRead(dirPin) == HIGH)) ||
        (rightSw == HIGH && (digitalRead(dirPin) == LOW)) ){
   
        motorStep(1);

    }
    else if( leftSw == LOW && (digitalRead(dirPin) == HIGH) ){
          digitalWrite(dirPin,LOW);
         
    }
    else if( rightSw == LOW && (digitalRead(dirPin) == LOW ) ){
          digitalWrite(dirPin,HIGH);
        ///


    }
 
}

void motorStep( int MAX){

   for(int x = 0; x < MAX; x++) {
        digitalWrite(stepPin,HIGH);
        delayMicroseconds(20);
        digitalWrite(stepPin,LOW);
        delayMicroseconds(20);
      }
     
}
