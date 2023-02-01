#include "pic32mx795f521l.c"

void main() {

 AD1PCFG = 0xFFFF;

 DDPCON.JTAGEN = 0; // disable JTAG

 TRISA = 0x0000;  //portA is output to turn on DC motor
 TRISE = 0XFFFF;  //portE is inputs to read push-buttons.


 while(1)
 {
     if(portEbits.RE1 == 0 && portEbits.RE0 == 1 ) }
         portA = 0x01; // when it is, 1/0 counter clock-wise
     }
     else if( portEbits.RE1 == 1 && portEbits.RE0 == 0) {
         portA = 0x02; // when it is, 0/1 clock-wise
     }
     else {
         portA = 0x00; // when it is, 0/0 stop motor
     }
 }

}//main