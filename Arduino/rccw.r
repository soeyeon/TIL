#include <TM1637Display.h>
#define CLK 4
#define DIO 5

int trigPin = 2;
int echoPin = 3;
int pinBlue = 9;
int pinGreen = 10;
int pinRed = 11;
int sirenPin = 7;

TM1637Display display(CLK, DIO);

int R=0;
int G=255;
int B=0;

void setup(){
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  Serial.begin(9600);
}

void setRGB_led(int R, int G, int B)
{
  analogWrite(pinRed, R);
  analogWrite(pinGreen, G);
  analogWrite(pinBlue, B);
}

void led_off(int cm)
{
  setRGB_led(0,0,0);
  delay(cm*10);
  R=R+60;
  G=G-60;
  B=0;
  if(R>255)R=255;
  if(G<0)G=0;
  if(B<0)B=0;
  setRGB_led(R,G,B);
  delay(cm*30);
      tone(sirenPin, 2500, 10);
    delay(cm); 
}

void led_controll(int cm)
{
    if(cm<30)
    {
        led_off(cm);
    }
    else if(cm == 30) {
      G=255; 
      B=0;
      R=0;
    }
    else if(cm>30)
    {
        if(R>=10)B=0;
        R=0;
        G=G-60;
        B=B+60;
        if(G<0)G=0;
        if(B>255)B=255;
        setRGB_led(R,G,B);
        delay(100);
    }
}

void loop(){

  float duration, cm;
  digitalWrite(trigPin, HIGH);
  delayMicroseconds (10);
  digitalWrite(trigPin, LOW);
  display.setBrightness(0x0f);
 
  duration = pulseIn(echoPin, HIGH);
  cm = duration / 58.0;
  display.showNumberDec(cm,true);
  delay(100);

  led_controll(cm);
}
