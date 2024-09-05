int countVal = 0; // let's initizlize a count value

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  int sensorValue = analogRead(A0);
  Serial.print(0); // channel
  Serial.print('c');
  Serial.print(sensorValue); // value
  Serial.print('w');  
  delay(100);
  Serial.print(1); // channel
  Serial.print('c');
  Serial.print(countVal); // value
  Serial.print('w');
  countVal++;
  delay(1000);
}
