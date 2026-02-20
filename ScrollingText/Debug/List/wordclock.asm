
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font_alphabet:
	.DB  0x0,0x3C,0x66,0x66,0x7E,0x66,0x66,0x66
	.DB  0x0,0x3E,0x66,0x66,0x3E,0x66,0x66,0x3E
	.DB  0x0,0x3C,0x66,0x6,0x6,0x6,0x66,0x3C
	.DB  0x0,0x3E,0x66,0x66,0x66,0x66,0x66,0x3E
	.DB  0x0,0x7E,0x6,0x6,0x3E,0x6,0x6,0x7E
	.DB  0x0,0x7E,0x6,0x6,0x3E,0x6,0x6,0x6
	.DB  0x0,0x3C,0x66,0x6,0x6,0x76,0x66,0x3C
	.DB  0x0,0x66,0x66,0x66,0x7E,0x66,0x66,0x66
	.DB  0x0,0x3C,0x18,0x18,0x18,0x18,0x18,0x3C
	.DB  0x0,0x78,0x30,0x30,0x30,0x36,0x36,0x1C
	.DB  0x0,0x66,0x36,0x1E,0xE,0x1E,0x36,0x66
	.DB  0x0,0x6,0x6,0x6,0x6,0x6,0x6,0x7E
	.DB  0x0,0xC6,0xEE,0xFE,0xD6,0xC6,0xC6,0xC6
	.DB  0x0,0xC6,0xCE,0xDE,0xF6,0xE6,0xC6,0xC6
	.DB  0x0,0x3C,0x66,0x66,0x66,0x66,0x66,0x3C
	.DB  0x0,0x3E,0x6,0x6,0x3E,0x66,0x66,0x3E
	.DB  0x0,0x3C,0x66,0x66,0x66,0x76,0x3C,0x60
	.DB  0x0,0x3E,0x66,0x66,0x3E,0x1E,0x36,0x66
	.DB  0x0,0x3C,0x66,0x6,0x3C,0x60,0x66,0x3C
	.DB  0x0,0x7E,0x5A,0x18,0x18,0x18,0x18,0x18
	.DB  0x0,0x66,0x66,0x66,0x66,0x66,0x66,0x7C
	.DB  0x0,0x66,0x66,0x66,0x66,0x66,0x3C,0x18
	.DB  0x0,0xC6,0xC6,0xC6,0xD6,0xFE,0xEE,0xC6
	.DB  0x0,0xC6,0xC6,0x6C,0x38,0x6C,0xC6,0xC6
	.DB  0x0,0x66,0x66,0x66,0x3C,0x18,0x18,0x18
	.DB  0x0,0x7E,0x60,0x30,0x18,0xC,0x6,0x7E
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x3C,0x60,0x7C,0x66,0x7C
	.DB  0x0,0x6,0x6,0x6,0x3E,0x66,0x66,0x3E
	.DB  0x0,0x0,0x0,0x3C,0x66,0x6,0x66,0x3C
	.DB  0x0,0x60,0x60,0x60,0x7C,0x66,0x66,0x7C
	.DB  0x0,0x0,0x0,0x3C,0x66,0x7E,0x6,0x3C
	.DB  0x0,0x38,0x6C,0xC,0xC,0x3E,0xC,0xC
	.DB  0x0,0x0,0x7C,0x66,0x66,0x7C,0x60,0x3C
	.DB  0x0,0x6,0x6,0x6,0x3E,0x66,0x66,0x66
	.DB  0x0,0x0,0x30,0x0,0x30,0x18,0x18,0x3C
	.DB  0x0,0x30,0x0,0x30,0x30,0x36,0x36,0x1C
	.DB  0x0,0x6,0x6,0x66,0x36,0x1E,0x36,0x66
	.DB  0x0,0x18,0x18,0x18,0x18,0x18,0x18,0x18
	.DB  0x0,0x0,0x0,0xC6,0xEE,0xFE,0xD6,0xD6
	.DB  0x0,0x0,0x0,0x3E,0x7E,0x66,0x66,0x66
	.DB  0x0,0x0,0x0,0x3C,0x66,0x66,0x66,0x3C
	.DB  0x0,0x0,0x3E,0x66,0x66,0x3E,0x6,0x6
	.DB  0x0,0x0,0x3C,0x36,0x36,0x3C,0xB0,0xF0
	.DB  0x0,0x0,0x0,0x3E,0x66,0x66,0x6,0x6
	.DB  0x0,0x0,0x0,0x7C,0x2,0x3C,0x40,0x3E
	.DB  0x0,0x0,0x18,0x18,0x7E,0x18,0x18,0x18
	.DB  0x0,0x0,0x0,0x66,0x66,0x66,0x66,0x7C
	.DB  0x0,0x0,0x0,0x0,0x66,0x66,0x3C,0x18
	.DB  0x0,0x0,0x0,0xC6,0xD6,0xD6,0xD6,0x7C
	.DB  0x0,0x0,0x0,0x66,0x3C,0x18,0x3C,0x66
	.DB  0x0,0x0,0x0,0x66,0x66,0x7C,0x60,0x3C
	.DB  0x0,0x0,0x0,0x3C,0x30,0x18,0xC,0x3C

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x300

	.CSEG
;#include <mega328p.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;#include <io.h>
;#include <delay.h>
;#include <font.h>
;
;// Declare your global variables here
;void SPI_MasterInit(void);
;void SPI_Send(unsigned char data);
;void Write(unsigned char add1, unsigned char data1,
; 0000 000A                  unsigned char add2, unsigned char data2,
; 0000 000B                  unsigned char add3, unsigned char data3,
; 0000 000C                  unsigned char add4, unsigned char data4,
; 0000 000D                  unsigned char add5, unsigned char data5,
; 0000 000E                  unsigned char add6, unsigned char data6,
; 0000 000F                  unsigned char add7, unsigned char data7,
; 0000 0010                  unsigned char add8, unsigned char data8
; 0000 0011                 );
;void Max7219_init(void);
;void MAX7219_clear(void);
;void Show(int char_index, int matrix_num);
;void UpdateDisplay();
;void ClearBuffer(void);
;
;unsigned char display_matrix[8][8];
;
;void main(void)
; 0000 001B {

	.CSEG
_main:
; .FSTART _main
; 0000 001C // Declare your local variables here
; 0000 001D 
; 0000 001E SPI_MasterInit();
	RCALL _SPI_MasterInit
; 0000 001F Max7219_init();
	RCALL _Max7219_init
; 0000 0020 MAX7219_clear();
	RCALL _MAX7219_clear
; 0000 0021 ClearBuffer();
	RCALL _ClearBuffer
; 0000 0022 
; 0000 0023 while (1)
_0x3:
; 0000 0024       {
; 0000 0025 
; 0000 0026     Show(4, 0);
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _Show
; 0000 0027     Show(17, 1);
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _Show
; 0000 0028     Show(5, 2);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _Show
; 0000 0029     Show(0, 3);
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _Show
; 0000 002A     Show(13, 4);
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(4)
	LDI  R27,0
	RCALL _Show
; 0000 002B 
; 0000 002C     UpdateDisplay();
	RCALL _UpdateDisplay
; 0000 002D 
; 0000 002E     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 002F 
; 0000 0030       }
	RJMP _0x3
; 0000 0031 }
_0x6:
	RJMP _0x6
; .FEND
;
;
;/*
;void select_row(int num){
;
;    //set rows to 0 each round
;    PORTB &= ~((1<<0) | (1<<1) | (1<<6) | (1<<7));
;
;    PORTD &= ~((1<<5) | (1<<7) | (1<<4) | (1<<3));
;
;
;    switch(num){
;        case 0:
;            PORTD |= (1<<5);
;            break;
;        case 1:
;            PORTD |= (1<<7);
;            break;
;
;        case 2:
;            PORTB |= (1<<0);
;            break;
;
;        case 3:
;            PORTB |= (1<<1);
;            break;
;
;        case 4:
;            PORTB |= (1<<6);
;            break;
;        case 5:
;            PORTD |= (1<<4);
;            break;
;        case 6:
;            PORTD |= (1<<3);
;            break;
;        case 7:
;            PORTB |= (1<<7);
;            break;
;    }
;
;}
;
;
;void set_columns(unsigned char data){
;
;    if (data & (1<<0)) {
;        // row is 1 so column should be 0 to have current
;        PORTC &= ~(1<<2);
;    } else {
;        // we want led off
;        PORTC |= (1<<2);
;    }
;
;    if (data & (1<<1)) {
;        PORTC &= ~(1<<3);
;    } else {
;        PORTC |= (1<<3);
;    }
;
;    if (data & (1<<2)) {
;        PORTD &= ~(1<<0);
;    } else {
;        PORTD |= (1<<0);
;    }
;
;    if (data & (1<<3)) {
;        PORTD &= ~(1<<1);
;    } else {
;        PORTD |= (1<<1);
;    }
;
;    if (data & (1<<4)) {
;        PORTD &= ~(1<<2);
;    } else {
;        PORTD |= (1<<2);
;    }
;
;    if (data & (1<<5)) {
;        PORTB &= ~(1<<2);
;    } else {
;        PORTB |= (1<<2);
;    }
;
;    if (data & (1<<6)) {
;        PORTB &= ~(1<<3);
;    } else {
;        PORTB |= (1<<3);
;    }
;
;    if (data & (1<<7)) {
;        PORTB &= ~(1<<4);
;    } else {
;        PORTB |= (1<<4);
;    }
;
;}
;   */
;
;
;void Write(unsigned char add1, unsigned char data1,
; 0000 0097                  unsigned char add2, unsigned char data2,
; 0000 0098                  unsigned char add3, unsigned char data3,
; 0000 0099                  unsigned char add4, unsigned char data4,
; 0000 009A                  unsigned char add5, unsigned char data5,
; 0000 009B                  unsigned char add6, unsigned char data6,
; 0000 009C                  unsigned char add7, unsigned char data7,
; 0000 009D                  unsigned char add8, unsigned char data8
; 0000 009E                 )
; 0000 009F {
_Write:
; .FSTART _Write
; 0000 00A0     //Load = 0
; 0000 00A1     PORTB &= ~(1 << PORTB2);
	ST   -Y,R26
;	add1 -> Y+15
;	data1 -> Y+14
;	add2 -> Y+13
;	data2 -> Y+12
;	add3 -> Y+11
;	data3 -> Y+10
;	add4 -> Y+9
;	data4 -> Y+8
;	add5 -> Y+7
;	data5 -> Y+6
;	add6 -> Y+5
;	data6 -> Y+4
;	add7 -> Y+3
;	data7 -> Y+2
;	add8 -> Y+1
;	data8 -> Y+0
	CBI  0x5,2
; 0000 00A2 
; 0000 00A3     delay_us(1);
	__DELAY_USB 3
; 0000 00A4 
; 0000 00A5     //send address and data for each matrix | same data
; 0000 00A6     SPI_Send(add8);  SPI_Send(data8);
	LDD  R26,Y+1
	RCALL _SPI_Send
	LD   R26,Y
	RCALL _SPI_Send
; 0000 00A7     SPI_Send(add7);  SPI_Send(data7);
	LDD  R26,Y+3
	RCALL _SPI_Send
	LDD  R26,Y+2
	RCALL _SPI_Send
; 0000 00A8     SPI_Send(add6);  SPI_Send(data6);
	LDD  R26,Y+5
	RCALL _SPI_Send
	LDD  R26,Y+4
	RCALL _SPI_Send
; 0000 00A9     SPI_Send(add5);  SPI_Send(data5);
	LDD  R26,Y+7
	RCALL _SPI_Send
	LDD  R26,Y+6
	RCALL _SPI_Send
; 0000 00AA     SPI_Send(add4);  SPI_Send(data4);
	LDD  R26,Y+9
	RCALL _SPI_Send
	LDD  R26,Y+8
	RCALL _SPI_Send
; 0000 00AB     SPI_Send(add3);  SPI_Send(data3);
	LDD  R26,Y+11
	RCALL _SPI_Send
	LDD  R26,Y+10
	RCALL _SPI_Send
; 0000 00AC     SPI_Send(add2);  SPI_Send(data2);
	LDD  R26,Y+13
	RCALL _SPI_Send
	LDD  R26,Y+12
	RCALL _SPI_Send
; 0000 00AD     SPI_Send(add1);  SPI_Send(data1);
	LDD  R26,Y+15
	RCALL _SPI_Send
	LDD  R26,Y+14
	RCALL _SPI_Send
; 0000 00AE 
; 0000 00AF 
; 0000 00B0     delay_us(1);
	__DELAY_USB 3
; 0000 00B1 
; 0000 00B2 
; 0000 00B3     //Load=1
; 0000 00B4     PORTB |= (1 << PORTB2);
	SBI  0x5,2
; 0000 00B5 
; 0000 00B6     delay_us(1);
	__DELAY_USB 3
; 0000 00B7 }
	ADIW R28,16
	RET
; .FEND
;
;
;void SPI_MasterInit(void){
; 0000 00BA void SPI_MasterInit(void){
_SPI_MasterInit:
; .FSTART _SPI_MasterInit
; 0000 00BB     // Set MOSI and SCK output
; 0000 00BC     DDRB |= (1<<DDB2) | (1<<DDB3) | (1<<DDB5);
	IN   R30,0x4
	ORI  R30,LOW(0x2C)
	OUT  0x4,R30
; 0000 00BD     /* Enable SPI, Master, set clock rate fck/16 */
; 0000 00BE     SPCR = (1<<SPE) | (1<<MSTR) | (1<<SPR1) | (1<<SPR0);
	LDI  R30,LOW(83)
	OUT  0x2C,R30
; 0000 00BF     // make LOAD high to make ICs wait
; 0000 00C0     PORTB |= (1<<PORTB2);
	SBI  0x5,2
; 0000 00C1     delay_ms(100);
	LDI  R26,LOW(100)
	RJMP _0x2000002
; 0000 00C2 }
; .FEND
;
;
;void SPI_Send(unsigned char data){
; 0000 00C5 void SPI_Send(unsigned char data){
_SPI_Send:
; .FSTART _SPI_Send
; 0000 00C6 
; 0000 00C7     SPDR = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0x2E,R30
; 0000 00C8     while(!(SPSR & (1 << SPIF)));
_0x7:
	IN   R30,0x2D
	ANDI R30,LOW(0x80)
	BREQ _0x7
; 0000 00C9 
; 0000 00CA }
	ADIW R28,1
	RET
; .FEND
;
;
;void Max7219_init(){
; 0000 00CD void Max7219_init(){
_Max7219_init:
; .FSTART _Max7219_init
; 0000 00CE 
; 0000 00CF     Write(0x0C, 0x00,0x0C, 0x00,0x0C, 0x00,0x0C, 0x00,0x0C, 0x00,0x0C, 0x00,0x0C, 0x00,0x0C, 0x00); //shutdown
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x1
; 0000 00D0     delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 00D1 
; 0000 00D2     Write(0x0F, 0x00,0x0F, 0x00,0x0F, 0x00,0x0F, 0x00,0x0F, 0x00,0x0F, 0x00,0x0F, 0x00,0x0F, 0x00); //  (Display Test Of ...
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	LDI  R30,LOW(15)
	RCALL SUBOPT_0x1
; 0000 00D3     Write(0x09, 0x00,0x09, 0x00,0x09, 0x00,0x09, 0x00,0x09, 0x00,0x09, 0x00,0x09, 0x00,0x09, 0x00); //  (No Decode for L ...
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x1
; 0000 00D4     Write(0x0B, 0x07,0x0B, 0x07,0x0B, 0x07,0x0B, 0x07,0x0B, 0x07,0x0B, 0x07,0x0B, 0x07,0x0B, 0x07); //  (Scan Limit)
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x4
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R26,LOW(7)
	RCALL _Write
; 0000 00D5     Write(0x0A, 0x0F,0x0A, 0x0F,0x0A, 0x0F,0x0A, 0x0F,0x0A, 0x0F,0x0A, 0x0F,0x0A, 0x0F,0x0A, 0x0F);   //Intenstity
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R26,LOW(15)
	RCALL _Write
; 0000 00D6 
; 0000 00D7     Write(0x0C, 0x01,0x0C, 0x01,0x0C, 0x01,0x0C, 0x01,0x0C, 0x01,0x0C, 0x01,0x0C, 0x01,0x0C, 0x01); //wake up
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x6
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _Write
; 0000 00D8     delay_ms(50);
	LDI  R26,LOW(50)
_0x2000002:
	LDI  R27,0
	CALL _delay_ms
; 0000 00D9 }
	RET
; .FEND
;
;void MAX7219_clear(){
; 0000 00DB void MAX7219_clear(){
_MAX7219_clear:
; .FSTART _MAX7219_clear
; 0000 00DC 
; 0000 00DD     unsigned char row;
; 0000 00DE 
; 0000 00DF     for (row = 1; row <= 8; row++) {
	ST   -Y,R17
;	row -> R17
	LDI  R17,LOW(1)
_0xB:
	CPI  R17,9
	BRSH _0xC
; 0000 00E0         Write(row, 0x00,row, 0x00,row, 0x00,row, 0x00,row, 0x00,row, 0x00,row, 0x00,row, 0x00);  // set all rows to 0
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	ST   -Y,R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R17
	LDI  R26,LOW(0)
	RCALL _Write
; 0000 00E1         delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 00E2     }
	SUBI R17,-1
	RJMP _0xB
_0xC:
; 0000 00E3 }
	RJMP _0x2000001
; .FEND
;
;//show dislpay matrix values
;void UpdateDisplay(){
; 0000 00E6 void UpdateDisplay(){
_UpdateDisplay:
; .FSTART _UpdateDisplay
; 0000 00E7 
; 0000 00E8     unsigned char r;
; 0000 00E9 
; 0000 00EA     for(r=1; r<=8; r++){
	ST   -Y,R17
;	r -> R17
	LDI  R17,LOW(1)
_0xE:
	CPI  R17,9
	BRSH _0xF
; 0000 00EB 
; 0000 00EC         Write(
; 0000 00ED         r, display_matrix[r-1][0],    //Matrix 1
; 0000 00EE         r, display_matrix[r-1][1],    //Matrix 2
; 0000 00EF         r, display_matrix[r-1][2],    //Matrix 3
; 0000 00F0         r, display_matrix[r-1][3],    //Matrix 4
; 0000 00F1         r, display_matrix[r-1][4],    //Matrix 5
; 0000 00F2         r, display_matrix[r-1][5],    //Matrix 6
; 0000 00F3         r, display_matrix[r-1][6],    //Matrix 7
; 0000 00F4         r, display_matrix[r-1][7]     //Matrix 8
; 0000 00F5         );
	RCALL SUBOPT_0x8
	SUBI R30,LOW(-_display_matrix)
	SBCI R31,HIGH(-_display_matrix)
	RCALL SUBOPT_0x9
	__ADDW1MN _display_matrix,1
	RCALL SUBOPT_0x9
	__ADDW1MN _display_matrix,2
	RCALL SUBOPT_0x9
	__ADDW1MN _display_matrix,3
	RCALL SUBOPT_0x9
	__ADDW1MN _display_matrix,4
	RCALL SUBOPT_0x9
	__ADDW1MN _display_matrix,5
	RCALL SUBOPT_0x9
	__ADDW1MN _display_matrix,6
	RCALL SUBOPT_0x9
	__ADDW1MN _display_matrix,7
	LD   R26,Z
	RCALL _Write
; 0000 00F6 
; 0000 00F7 
; 0000 00F8     }
	SUBI R17,-1
	RJMP _0xE
_0xF:
; 0000 00F9 
; 0000 00FA 
; 0000 00FB }
_0x2000001:
	LD   R17,Y+
	RET
; .FEND
;
;/*
;//put values in display matrix
;void Show(int char_index, int matrix_num){
;
;    unsigned char s;
;
;    for(s=0; s<8; s++){
;
;        display_matrix[s][matrix_num] = font_alphabet[char_index][s];
;
;    }
;
;}
;*/
;
;void Show(int char_index, int matrix_num){
; 0000 010C void Show(int char_index, int matrix_num){
_Show:
; .FSTART _Show
; 0000 010D     unsigned char s, b;
; 0000 010E     unsigned char original_byte;
; 0000 010F     unsigned char mirrored_byte;
; 0000 0110 
; 0000 0111     for(s=0; s<8; s++){
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	char_index -> Y+6
;	matrix_num -> Y+4
;	s -> R17
;	b -> R16
;	original_byte -> R19
;	mirrored_byte -> R18
	LDI  R17,LOW(0)
_0x11:
	CPI  R17,8
	BRSH _0x12
; 0000 0112         original_byte = font_alphabet[char_index][s];
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __LSLW3
	SUBI R30,LOW(-_font_alphabet*2)
	SBCI R31,HIGH(-_font_alphabet*2)
	MOVW R26,R30
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R19,Z
; 0000 0113         mirrored_byte = 0;
	LDI  R18,LOW(0)
; 0000 0114 
; 0000 0115 
; 0000 0116         for(b=0; b<8; b++) {
	LDI  R16,LOW(0)
_0x14:
	CPI  R16,8
	BRSH _0x15
; 0000 0117             if(original_byte & (1 << b)) {
	MOV  R30,R16
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R19
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x16
; 0000 0118                 mirrored_byte |= (1 << (7 - b));
	LDI  R30,LOW(7)
	SUB  R30,R16
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R18,R30
; 0000 0119             }
; 0000 011A         }
_0x16:
	SUBI R16,-1
	RJMP _0x14
_0x15:
; 0000 011B 
; 0000 011C 
; 0000 011D         display_matrix[s][matrix_num] = mirrored_byte;
	RCALL SUBOPT_0xA
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R18
; 0000 011E     }
	SUBI R17,-1
	RJMP _0x11
_0x12:
; 0000 011F }
	CALL __LOADLOCR4
	ADIW R28,8
	RET
; .FEND
;
;void ClearBuffer(void) {
; 0000 0121 void ClearBuffer(void) {
_ClearBuffer:
; .FSTART _ClearBuffer
; 0000 0122     unsigned char r, m;
; 0000 0123 
; 0000 0124 
; 0000 0125     for (r = 0; r < 8; r++) {
	ST   -Y,R17
	ST   -Y,R16
;	r -> R17
;	m -> R16
	LDI  R17,LOW(0)
_0x18:
	CPI  R17,8
	BRSH _0x19
; 0000 0126 
; 0000 0127         for (m = 0; m < 8; m++) {
	LDI  R16,LOW(0)
_0x1B:
	CPI  R16,8
	BRSH _0x1C
; 0000 0128 
; 0000 0129             display_matrix[r][m] = 0x00;
	RCALL SUBOPT_0xA
	MOVW R26,R30
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	ST   X,R30
; 0000 012A         }
	SUBI R16,-1
	RJMP _0x1B
_0x1C:
; 0000 012B     }
	SUBI R17,-1
	RJMP _0x18
_0x19:
; 0000 012C 
; 0000 012D     UpdateDisplay();
	RCALL _UpdateDisplay
; 0000 012E }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_display_matrix:
	.BYTE 0x40

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _Write

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	ST   -Y,R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x8:
	ST   -Y,R17
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,1
	CALL __LSLW3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LD   R30,Z
	ST   -Y,R30
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	MOV  R30,R17
	LDI  R31,0
	CALL __LSLW3
	SUBI R30,LOW(-_display_matrix)
	SBCI R31,HIGH(-_display_matrix)
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
