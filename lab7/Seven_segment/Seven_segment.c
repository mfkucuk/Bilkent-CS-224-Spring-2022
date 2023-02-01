#include "pic32mx795f521l.c"

// Hexadecimal values for digits in 7 segment
unsigned char binary_pattern[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 0x7F, 0x6F};

void main()
{

    AD1PCFG = 0xFFFF; // Configure AN pins as digital I/O
    JTAGEN_bit = 0;   // Disable JTAG

    TRISA = 0x00; // portA is output to D
    TRISE = 0X00; // portE is output to AN

    int segments[4];
    for(int i = 0; i < 4; i++){
    segments[i] = i + 1;
    }

    while (1)
    {

        // Digit 1
        PORTA = binary_pattern[segments[0]];
        PORTE = 0x01;
        Delay_ms(1);

        // Digit 2
        PORTA = binary_pattern[segments[1]]; // Put 2 to the second digit
        PORTE = 0x02;              // Open second digit
        Delay_ms(1);

        // Digit 3
        PORTA = binary_pattern[segments[2]];
        PORTE = 0x04;
        Delay_ms(1);

        // Digit 4
        PORTA = binary_pattern[segments[3]];
        PORTE = 0x08;
        Delay_ms(1);

        int zero = 0;
        int i = 0;
        while(i < 4) {
                i++;
                segments[i] = segments[i] + 1;
                if(segments[i] == zero)
                    segments[i] = segments[i] + 1;
        }
        Delay_ms(1000);
    }

} // main