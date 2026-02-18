#include <mega328p.h>
#include <io.h>
#include <delay.h>


// Declare your global variables here
void SPI_MasterInit(void);
void SPI_Send(unsigned char data);
void Write(unsigned char add, unsigned char data);
void Max7219_init(void);
void MAX7219_clear(void);

unsigned char i;
unsigned char row;


void main(void)
{
// Declare your local variables here

SPI_MasterInit();   
Max7219_init();     
MAX7219_clear();


while (1)
      {
     
      }
}


/*
void select_row(int num){

    //set rows to 0 each round
    PORTB &= ~((1<<0) | (1<<1) | (1<<6) | (1<<7)); 
    
    PORTD &= ~((1<<5) | (1<<7) | (1<<4) | (1<<3));
    
    
    switch(num){
        case 0: 
            PORTD |= (1<<5); 
            break;
        case 1:
            PORTD |= (1<<7); 
            break;
       
        case 2:
            PORTB |= (1<<0); 
            break;
        
        case 3: 
            PORTB |= (1<<1); 
            break;
 
        case 4:
            PORTB |= (1<<6); 
            break;  
        case 5:
            PORTD |= (1<<4); 
            break;  
        case 6:
            PORTD |= (1<<3); 
            break;
        case 7:
            PORTB |= (1<<7); 
            break;          
    }

}


void set_columns(unsigned char data){

    if (data & (1<<0)) { 
        // row is 1 so column should be 0 to have current
        PORTC &= ~(1<<2); 
    } else {
        // we want led off
        PORTC |= (1<<2);
    }
    
    if (data & (1<<1)) { 
        PORTC &= ~(1<<3); 
    } else {
        PORTC |= (1<<3);
    }
    
    if (data & (1<<2)) { 
        PORTD &= ~(1<<0); 
    } else {
        PORTD |= (1<<0);
    }
    
    if (data & (1<<3)) { 
        PORTD &= ~(1<<1); 
    } else {
        PORTD |= (1<<1);
    }
    
    if (data & (1<<4)) { 
        PORTD &= ~(1<<2); 
    } else {
        PORTD |= (1<<2);
    } 
    
    if (data & (1<<5)) { 
        PORTB &= ~(1<<2); 
    } else {
        PORTB |= (1<<2);
    }
    
    if (data & (1<<6)) { 
        PORTB &= ~(1<<3); 
    } else {
        PORTB |= (1<<3);
    }
    
    if (data & (1<<7)) { 
        PORTB &= ~(1<<4); 
    } else {
        PORTB |= (1<<4);
    }

}
   */
   

void Write(unsigned char add, unsigned char data)
{
    //Load = 0
    PORTB &= ~(1 << PORTB2);
     
    delay_us(1);
    
    //send address and data for each matrix | same data
    for (i = 0; i < 8; i++) {
        SPI_Send(add); 
        SPI_Send(data);    
    } 
    
    delay_us(1);
    
     
    //Load=1
    PORTB |= (1 << PORTB2);  
    
    delay_us(1);   
}


void SPI_MasterInit(void){
    // Set MOSI and SCK output
    DDRB |= (1<<DDB2) | (1<<DDB3) | (1<<DDB5);
    /* Enable SPI, Master, set clock rate fck/16 */ 
    SPCR = (1<<SPE) | (1<<MSTR) | (1<<SPR1) | (1<<SPR0);
    // make LOAD high to make ICs wait
    PORTB |= (1<<PORTB2);
    delay_ms(100); 
} 


void SPI_Send(unsigned char data){

    SPDR = data; 
    while(!(SPSR & (1 << SPIF)));

}


void Max7219_init(){

    Write(0x0C, 0x00); //shutdown
    delay_ms(50);  
    
    Write(0x0F, 0x00); //  (Display Test Off) 
    Write(0x09, 0x00); //  (No Decode for LED Matrix)
    Write(0x0B, 0x07); //  (Scan Limit)
    Write(0x0A, 0x01);   //Intenstity
    
    Write(0x0C, 0x01); //wake up      
    delay_ms(50);   
}

void MAX7219_clear(){
    for (row = 1; row <= 8; row++) {
        Write(row, 0x00);  // set all rows to 0
        delay_ms(10);
    }
}