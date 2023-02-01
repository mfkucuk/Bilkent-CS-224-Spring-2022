#include <math.h>
#include "pic32mx795f521l.c"

void main() {
    AD1PCFG = 0xFFFF;

    DDPCON.JTAGEN = 0; // disable JTAG

    TRISA = 0x0000;
    TRISE = 0xFFFF;
    int leftToRight = 0;
    int count = 0;
    int countTemp = 0;
    unsigned int temp = 0;
    int power = 7;

    while (1) {
        // RE0 starts counting from right to left.
        // RE1 starts counting from left to right.
        // RE2 is the reset button.

	// If RE2 is pressed reset the counter and the port.
        if (PORTEbits.RE2 == 1) {
            PORTA = 0x0000;
            count = 0;
        }

	// If RE0 is pressed port is normal count.
        if (PORTEbits.RE0 == 1 || leftToRight == 0) {
            leftToRight = 0;
            PORTA = count;
        }

	// If RE1 is pressed reverse the bits of the counter and set the ports to that value.
        if (PORTEbits.RE1 == 1 || leftToRight == 1) {
            countTemp = count;
            leftToRight = 1;
            power = 7;
            temp = 0;

            while (countTemp > 0) {
            	if (countTemp % 2 == 1) {
            	    temp += pow(2, power);
		}

		countTemp /= 2;
		power--;
	    }
	    PORTA = temp;
        }

        count += 1

        Delay_ms(500);
    } // while
} // main