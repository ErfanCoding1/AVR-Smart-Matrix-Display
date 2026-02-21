
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
_font_numbers:
	.DB  0x0,0x18,0x18,0x1C,0x18,0x18,0x18,0x7E
	.DB  0x0,0x3C,0x66,0x60,0x30,0xC,0x6,0x7E
	.DB  0x0,0x3C,0x66,0x60,0x38,0x60,0x66,0x3C
	.DB  0x0,0x30,0x38,0x34,0x32,0x7E,0x30,0x30
	.DB  0x0,0x7E,0x6,0x3E,0x60,0x60,0x66,0x3C
	.DB  0x0,0x3C,0x66,0x6,0x3E,0x66,0x66,0x3C
	.DB  0x0,0x7E,0x66,0x30,0x30,0x18,0x18,0x18
	.DB  0x0,0x3C,0x66,0x66,0x3C,0x66,0x66,0x3C
	.DB  0x0,0x3C,0x66,0x66,0x7C,0x60,0x66,0x3C
	.DB  0x0,0x3C,0x66,0x76,0x6E,0x66,0x66,0x3C

_0x0:
	.DB  0x45,0x72,0x66,0x61,0x6E,0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  _0x6
	.DW  _0x0*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

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
;void ScrollMessage(char* str);
;void ShiftLeft(unsigned char new_column[8]);
;unsigned char GetMatrixByte(unsigned char row, unsigned char start_col);
;
;
;unsigned char scroll_buffer[8][64];
;void ScrollBlank(int count);
;
;void main(void)
; 0000 0020 {

	.CSEG
_main:
; .FSTART _main
; 0000 0021 // Declare your local variables here
; 0000 0022 
; 0000 0023 SPI_MasterInit();
	RCALL _SPI_MasterInit
; 0000 0024 Max7219_init();
	RCALL _Max7219_init
; 0000 0025 MAX7219_clear();
	RCALL _MAX7219_clear
; 0000 0026 ClearBuffer();
	RCALL _ClearBuffer
; 0000 0027 
; 0000 0028 while (1)
_0x3:
; 0000 0029       {
; 0000 002A 
; 0000 002B     //Show(4, 0);
; 0000 002C     //Show(17, 1);
; 0000 002D     //Show(5, 2);
; 0000 002E    // Show(0, 3);
; 0000 002F     //Show(13, 4)
; 0000 0030 
; 0000 0031     ScrollMessage("Erfan");
	__POINTW2MN _0x6,0
	RCALL _ScrollMessage
; 0000 0032     ScrollBlank(64);
	LDI  R26,LOW(64)
	LDI  R27,0
	RCALL _ScrollBlank
; 0000 0033     delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0034 
; 0000 0035       }
	RJMP _0x3
; 0000 0036 }
_0x7:
	RJMP _0x7
; .FEND

	.DSEG
_0x6:
	.BYTE 0x6
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
; 0000 009C                  unsigned char add2, unsigned char data2,
; 0000 009D                  unsigned char add3, unsigned char data3,
; 0000 009E                  unsigned char add4, unsigned char data4,
; 0000 009F                  unsigned char add5, unsigned char data5,
; 0000 00A0                  unsigned char add6, unsigned char data6,
; 0000 00A1                  unsigned char add7, unsigned char data7,
; 0000 00A2                  unsigned char add8, unsigned char data8
; 0000 00A3                 )
; 0000 00A4 {

	.CSEG
_Write:
; .FSTART _Write
; 0000 00A5     //Load = 0
; 0000 00A6     PORTB &= ~(1 << PORTB2);
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
; 0000 00A7 
; 0000 00A8     delay_us(1);
	__DELAY_USB 3
; 0000 00A9 
; 0000 00AA     //send address and data for each matrix | same data
; 0000 00AB     SPI_Send(add8);  SPI_Send(data8);
	LDD  R26,Y+1
	RCALL _SPI_Send
	LD   R26,Y
	RCALL _SPI_Send
; 0000 00AC     SPI_Send(add7);  SPI_Send(data7);
	LDD  R26,Y+3
	RCALL _SPI_Send
	LDD  R26,Y+2
	RCALL _SPI_Send
; 0000 00AD     SPI_Send(add6);  SPI_Send(data6);
	LDD  R26,Y+5
	RCALL _SPI_Send
	LDD  R26,Y+4
	RCALL _SPI_Send
; 0000 00AE     SPI_Send(add5);  SPI_Send(data5);
	LDD  R26,Y+7
	RCALL _SPI_Send
	LDD  R26,Y+6
	RCALL _SPI_Send
; 0000 00AF     SPI_Send(add4);  SPI_Send(data4);
	LDD  R26,Y+9
	RCALL _SPI_Send
	LDD  R26,Y+8
	RCALL _SPI_Send
; 0000 00B0     SPI_Send(add3);  SPI_Send(data3);
	LDD  R26,Y+11
	RCALL _SPI_Send
	LDD  R26,Y+10
	RCALL _SPI_Send
; 0000 00B1     SPI_Send(add2);  SPI_Send(data2);
	LDD  R26,Y+13
	RCALL _SPI_Send
	LDD  R26,Y+12
	RCALL _SPI_Send
; 0000 00B2     SPI_Send(add1);  SPI_Send(data1);
	LDD  R26,Y+15
	RCALL _SPI_Send
	LDD  R26,Y+14
	RCALL _SPI_Send
; 0000 00B3 
; 0000 00B4 
; 0000 00B5     delay_us(1);
	__DELAY_USB 3
; 0000 00B6 
; 0000 00B7 
; 0000 00B8     //Load=1
; 0000 00B9     PORTB |= (1 << PORTB2);
	SBI  0x5,2
; 0000 00BA 
; 0000 00BB     delay_us(1);
	__DELAY_USB 3
; 0000 00BC }
	ADIW R28,16
	RET
; .FEND
;
;
;void SPI_MasterInit(void){
; 0000 00BF void SPI_MasterInit(void){
_SPI_MasterInit:
; .FSTART _SPI_MasterInit
; 0000 00C0     // Set MOSI and SCK output
; 0000 00C1     DDRB |= (1<<DDB2) | (1<<DDB3) | (1<<DDB5);
	IN   R30,0x4
	ORI  R30,LOW(0x2C)
	OUT  0x4,R30
; 0000 00C2     /* Enable SPI, Master, set clock rate fck/16 */
; 0000 00C3     SPCR = (1<<SPE) | (1<<MSTR) | (1<<SPR1) | (1<<SPR0);
	LDI  R30,LOW(83)
	OUT  0x2C,R30
; 0000 00C4     // make LOAD high to make ICs wait
; 0000 00C5     PORTB |= (1<<PORTB2);
	SBI  0x5,2
; 0000 00C6     delay_ms(100);
	LDI  R26,LOW(100)
	RJMP _0x2000003
; 0000 00C7 }
; .FEND
;
;
;void SPI_Send(unsigned char data){
; 0000 00CA void SPI_Send(unsigned char data){
_SPI_Send:
; .FSTART _SPI_Send
; 0000 00CB 
; 0000 00CC     SPDR = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0x2E,R30
; 0000 00CD     while(!(SPSR & (1 << SPIF)));
_0x8:
	IN   R30,0x2D
	ANDI R30,LOW(0x80)
	BREQ _0x8
; 0000 00CE 
; 0000 00CF }
	ADIW R28,1
	RET
; .FEND
;
;
;void Max7219_init(){
; 0000 00D2 void Max7219_init(){
_Max7219_init:
; .FSTART _Max7219_init
; 0000 00D3 
; 0000 00D4     Write(0x0C, 0x00,0x0C, 0x00,0x0C, 0x00,0x0C, 0x00,0x0C, 0x00,0x0C, 0x00,0x0C, 0x00,0x0C, 0x00); //shutdown
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	LDI  R30,LOW(12)
	RCALL SUBOPT_0x1
; 0000 00D5     delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 00D6 
; 0000 00D7     Write(0x0F, 0x00,0x0F, 0x00,0x0F, 0x00,0x0F, 0x00,0x0F, 0x00,0x0F, 0x00,0x0F, 0x00,0x0F, 0x00); //  (Display Test Of ...
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x2
	LDI  R30,LOW(15)
	RCALL SUBOPT_0x1
; 0000 00D8     Write(0x09, 0x00,0x09, 0x00,0x09, 0x00,0x09, 0x00,0x09, 0x00,0x09, 0x00,0x09, 0x00,0x09, 0x00); //  (No Decode for L ...
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x3
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x1
; 0000 00D9     Write(0x0B, 0x07,0x0B, 0x07,0x0B, 0x07,0x0B, 0x07,0x0B, 0x07,0x0B, 0x07,0x0B, 0x07,0x0B, 0x07); //  (Scan Limit)
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
; 0000 00DA     Write(0x0A, 0x0F,0x0A, 0x0F,0x0A, 0x0F,0x0A, 0x0F,0x0A, 0x0F,0x0A, 0x0F,0x0A, 0x0F,0x0A, 0x0F);   //Intenstity
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
; 0000 00DB 
; 0000 00DC     Write(0x0C, 0x01,0x0C, 0x01,0x0C, 0x01,0x0C, 0x01,0x0C, 0x01,0x0C, 0x01,0x0C, 0x01,0x0C, 0x01); //wake up
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
; 0000 00DD     delay_ms(50);
	LDI  R26,LOW(50)
_0x2000003:
	LDI  R27,0
	CALL _delay_ms
; 0000 00DE }
	RET
; .FEND
;
;void MAX7219_clear(){
; 0000 00E0 void MAX7219_clear(){
_MAX7219_clear:
; .FSTART _MAX7219_clear
; 0000 00E1 
; 0000 00E2     unsigned char row;
; 0000 00E3 
; 0000 00E4     for (row = 1; row <= 8; row++) {
	ST   -Y,R17
;	row -> R17
	LDI  R17,LOW(1)
_0xC:
	CPI  R17,9
	BRSH _0xD
; 0000 00E5         Write(row, 0x00,row, 0x00,row, 0x00,row, 0x00,row, 0x00,row, 0x00,row, 0x00,row, 0x00);  // set all rows to 0
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x7
	ST   -Y,R17
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R17
	LDI  R26,LOW(0)
	RCALL _Write
; 0000 00E6         delay_ms(10);
	RCALL SUBOPT_0x8
; 0000 00E7     }
	SUBI R17,-1
	RJMP _0xC
_0xD:
; 0000 00E8 }
	RJMP _0x2000002
; .FEND
;
;//show dislpay matrix values
;void UpdateDisplay() {
; 0000 00EB void UpdateDisplay() {
_UpdateDisplay:
; .FSTART _UpdateDisplay
; 0000 00EC     unsigned char r;
; 0000 00ED     for (r = 1; r <= 8; r++) {
	ST   -Y,R17
;	r -> R17
	LDI  R17,LOW(1)
_0xF:
	CPI  R17,9
	BRSH _0x10
; 0000 00EE         Write(
; 0000 00EF             r, GetMatrixByte(r-1, 0),
; 0000 00F0             r, GetMatrixByte(r-1, 8),
; 0000 00F1             r, GetMatrixByte(r-1, 16),
; 0000 00F2             r, GetMatrixByte(r-1, 24),
; 0000 00F3             r, GetMatrixByte(r-1, 32),
; 0000 00F4             r, GetMatrixByte(r-1, 40),
; 0000 00F5             r, GetMatrixByte(r-1, 48),
; 0000 00F6             r, GetMatrixByte(r-1, 56)
; 0000 00F7         );
	RCALL SUBOPT_0x9
	LDI  R26,LOW(0)
	RCALL SUBOPT_0xA
	LDI  R26,LOW(8)
	RCALL SUBOPT_0xA
	LDI  R26,LOW(16)
	RCALL SUBOPT_0xA
	LDI  R26,LOW(24)
	RCALL SUBOPT_0xA
	LDI  R26,LOW(32)
	RCALL SUBOPT_0xA
	LDI  R26,LOW(40)
	RCALL SUBOPT_0xA
	LDI  R26,LOW(48)
	RCALL SUBOPT_0xA
	LDI  R26,LOW(56)
	RCALL _GetMatrixByte
	MOV  R26,R30
	RCALL _Write
; 0000 00F8     }
	SUBI R17,-1
	RJMP _0xF
_0x10:
; 0000 00F9 }
_0x2000002:
	LD   R17,Y+
	RET
; .FEND
;
;
;unsigned char GetMatrixByte(unsigned char row, unsigned char start_col) {
; 0000 00FC unsigned char GetMatrixByte(unsigned char row, unsigned char start_col) {
_GetMatrixByte:
; .FSTART _GetMatrixByte
; 0000 00FD     unsigned char b, result = 0;
; 0000 00FE     for (b = 0; b < 8; b++) {
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	row -> Y+3
;	start_col -> Y+2
;	b -> R17
;	result -> R16
	LDI  R16,0
	LDI  R17,LOW(0)
_0x12:
	CPI  R17,8
	BRSH _0x13
; 0000 00FF         if (scroll_buffer[row][start_col + b] == 0x01) {
	LDD  R30,Y+3
	RCALL SUBOPT_0xB
	MOVW R0,R30
	LDD  R26,Y+2
	CLR  R27
	MOV  R30,R17
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R26,R0
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x14
; 0000 0100             result |= (1 << (7 - b));
	LDI  R30,LOW(7)
	SUB  R30,R17
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R16,R30
; 0000 0101         }
; 0000 0102     }
_0x14:
	SUBI R17,-1
	RJMP _0x12
_0x13:
; 0000 0103     return result;
	MOV  R30,R16
	RJMP _0x2000001
; 0000 0104 }
; .FEND
;
;/*
;//display matrix initialization
;void Show(int char_index, int matrix_num){
;    unsigned char s, b;
;    unsigned char original_byte;
;    unsigned char mirrored_byte;
;
;    for(s=0; s<8; s++){
;        original_byte = font_alphabet[char_index][s];
;        mirrored_byte = 0;
;
;
;        for(b=0; b<8; b++) {
;            if(original_byte & (1 << b)) {
;                mirrored_byte |= (1 << (7 - b));
;            }
;        }
;
;
;        display_matrix[s][matrix_num] = mirrored_byte;
;    }
;}
;*/
;
;void ClearBuffer(void) {
; 0000 011E void ClearBuffer(void) {
_ClearBuffer:
; .FSTART _ClearBuffer
; 0000 011F    unsigned char r, c;
; 0000 0120 
; 0000 0121 
; 0000 0122     for (r = 0; r < 8; r++) {
	ST   -Y,R17
	ST   -Y,R16
;	r -> R17
;	c -> R16
	LDI  R17,LOW(0)
_0x16:
	CPI  R17,8
	BRSH _0x17
; 0000 0123         for (c = 0; c < 64; c++) {
	LDI  R16,LOW(0)
_0x19:
	CPI  R16,64
	BRSH _0x1A
; 0000 0124             scroll_buffer[r][c] = 0x00;
	MOV  R30,R17
	RCALL SUBOPT_0xB
	MOVW R26,R30
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	ST   X,R30
; 0000 0125         }
	SUBI R16,-1
	RJMP _0x19
_0x1A:
; 0000 0126     }
	SUBI R17,-1
	RJMP _0x16
_0x17:
; 0000 0127 
; 0000 0128     UpdateDisplay();
	RCALL _UpdateDisplay
; 0000 0129 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void ScrollBlank(int count) {
; 0000 012B void ScrollBlank(int count) {
_ScrollBlank:
; .FSTART _ScrollBlank
; 0000 012C     int i;
; 0000 012D     unsigned char row;
; 0000 012E     unsigned char blank_col[8] = {0,0,0,0,0,0,0,0};
; 0000 012F 
; 0000 0130     for(i = 0; i < count; i++) {
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,8
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
	STD  Y+7,R30
	CALL __SAVELOCR4
;	count -> Y+12
;	i -> R16,R17
;	row -> R19
;	blank_col -> Y+4
	__GETWRN 16,17,0
_0x1C:
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x1D
; 0000 0131         ShiftLeft(blank_col);
	MOVW R26,R28
	ADIW R26,4
	RCALL SUBOPT_0xC
; 0000 0132         UpdateDisplay();
; 0000 0133         delay_ms(10);
; 0000 0134     }
	__ADDWRN 16,17,1
	RJMP _0x1C
_0x1D:
; 0000 0135 }
	CALL __LOADLOCR4
	ADIW R28,14
	RET
; .FEND
;
;
;void ShiftLeft(unsigned char new_column[8]) {
; 0000 0138 void ShiftLeft(unsigned char new_column[8]) {
_ShiftLeft:
; .FSTART _ShiftLeft
; 0000 0139     unsigned char r, c;
; 0000 013A 
; 0000 013B     for (r = 0; r < 8; r++) {
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	new_column -> Y+2
;	r -> R17
;	c -> R16
	LDI  R17,LOW(0)
_0x1F:
	CPI  R17,8
	BRSH _0x20
; 0000 013C         // shit all columns to left
; 0000 013D         for (c = 0; c < 63; c++) {
	LDI  R16,LOW(0)
_0x22:
	CPI  R16,63
	BRSH _0x23
; 0000 013E             scroll_buffer[r][c] = scroll_buffer[r][c+1];
	MOV  R30,R17
	RCALL SUBOPT_0xB
	MOVW R22,R30
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R26,R22
	MOV  R30,R16
	LDI  R31,0
	ADIW R30,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 013F         }
	SUBI R16,-1
	RJMP _0x22
_0x23:
; 0000 0140 
; 0000 0141 
; 0000 0142         if (new_column[r] == 1) {
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	CPI  R26,LOW(0x1)
	BRNE _0x24
; 0000 0143             // max7219 only accepts 16 bits
; 0000 0144             scroll_buffer[r][63] = 0x01;
	RCALL SUBOPT_0xD
	LDI  R26,LOW(1)
	RJMP _0x47
; 0000 0145         } else {
_0x24:
; 0000 0146             scroll_buffer[r][63] = 0x00;
	RCALL SUBOPT_0xD
	LDI  R26,LOW(0)
_0x47:
	STD  Z+0,R26
; 0000 0147         }
; 0000 0148 
; 0000 0149 
; 0000 014A     }
	SUBI R17,-1
	RJMP _0x1F
_0x20:
; 0000 014B }
_0x2000001:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;
;
;
;void ScrollMessage(char* str) {
; 0000 014F void ScrollMessage(char* str) {
_ScrollMessage:
; .FSTART _ScrollMessage
; 0000 0150     int i, char_idx;
; 0000 0151     unsigned char col, row, type;
; 0000 0152     unsigned char current_col_data[8];
; 0000 0153     unsigned char row_data;
; 0000 0154 
; 0000 0155     for (i = 0; str[i] != '\0'; i++) {
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,10
	CALL __SAVELOCR6
;	*str -> Y+16
;	i -> R16,R17
;	char_idx -> R18,R19
;	col -> R21
;	row -> R20
;	type -> Y+15
;	current_col_data -> Y+7
;	row_data -> Y+6
	__GETWRN 16,17,0
_0x27:
	MOVW R30,R16
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	CPI  R30,0
	BRNE PC+2
	RJMP _0x28
; 0000 0156         char c = str[i];
; 0000 0157 
; 0000 0158 
; 0000 0159         if (c >= 'A' && c <= 'Z') {
	SBIW R28,1
;	*str -> Y+17
;	type -> Y+16
;	current_col_data -> Y+8
;	row_data -> Y+7
;	c -> Y+0
	MOVW R30,R16
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	ST   Y,R30
	LD   R26,Y
	CPI  R26,LOW(0x41)
	BRLO _0x2A
	CPI  R26,LOW(0x5B)
	BRLO _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
; 0000 015A             type = 0;
	LDI  R30,LOW(0)
	STD  Y+16,R30
; 0000 015B             char_idx = c - 'A';
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(65)
	SBCI R31,HIGH(65)
	MOVW R18,R30
; 0000 015C         }
; 0000 015D         else if (c >= 'a' && c <= 'z') {
	RJMP _0x2C
_0x29:
	LD   R26,Y
	CPI  R26,LOW(0x61)
	BRLO _0x2E
	CPI  R26,LOW(0x7B)
	BRLO _0x2F
_0x2E:
	RJMP _0x2D
_0x2F:
; 0000 015E             type = 0;
	LDI  R30,LOW(0)
	STD  Y+16,R30
; 0000 015F             char_idx = (c - 'a') + 27;
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(97)
	SBCI R31,HIGH(97)
	ADIW R30,27
	MOVW R18,R30
; 0000 0160         }
; 0000 0161         else if (c == ' ') {
	RJMP _0x30
_0x2D:
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BREQ _0x48
; 0000 0162             type = 0;
; 0000 0163             char_idx = 26;
; 0000 0164         }
; 0000 0165         else if (c >= '0' && c <= '9') {
	CPI  R26,LOW(0x30)
	BRLO _0x34
	CPI  R26,LOW(0x3A)
	BRLO _0x35
_0x34:
	RJMP _0x33
_0x35:
; 0000 0166             type = 1;
	LDI  R30,LOW(1)
	STD  Y+16,R30
; 0000 0167             char_idx = (c == '0') ? 9 : (c - '1');
	LD   R26,Y
	LDI  R27,0
	SBIW R26,48
	BRNE _0x36
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0x37
_0x36:
	LD   R30,Y
	LDI  R31,0
	SBIW R30,49
_0x37:
	MOVW R18,R30
; 0000 0168         }
; 0000 0169         else {
	RJMP _0x39
_0x33:
; 0000 016A             type = 0;
_0x48:
	LDI  R30,LOW(0)
	STD  Y+16,R30
; 0000 016B             char_idx = 26;
	__GETWRN 18,19,26
; 0000 016C         }
_0x39:
_0x30:
_0x2C:
; 0000 016D 
; 0000 016E 
; 0000 016F         for (col = 0; col < 8; col++) {
	LDI  R21,LOW(0)
_0x3B:
	CPI  R21,8
	BRSH _0x3C
; 0000 0170             for (row = 0; row < 8; row++) {
	LDI  R20,LOW(0)
_0x3E:
	CPI  R20,8
	BRSH _0x3F
; 0000 0171 
; 0000 0172 
; 0000 0173                 if (type == 0) {
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x40
; 0000 0174                     row_data = font_alphabet[char_idx][row];
	MOVW R30,R18
	CALL __LSLW3
	SUBI R30,LOW(-_font_alphabet*2)
	SBCI R31,HIGH(-_font_alphabet*2)
	RJMP _0x49
; 0000 0175                 } else {
_0x40:
; 0000 0176                     row_data = font_numbers[char_idx][row];
	MOVW R30,R18
	CALL __LSLW3
	SUBI R30,LOW(-_font_numbers*2)
	SBCI R31,HIGH(-_font_numbers*2)
_0x49:
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	LPM  R0,Z
	STD  Y+7,R0
; 0000 0177                 }
; 0000 0178 
; 0000 0179 
; 0000 017A                 if (row_data & (1 << col)) {
	MOV  R30,R21
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	LDD  R26,Y+7
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x42
; 0000 017B                     current_col_data[row] = 1;
	RCALL SUBOPT_0xE
	LDI  R30,LOW(1)
	RJMP _0x4A
; 0000 017C                 } else {
_0x42:
; 0000 017D                     current_col_data[row] = 0;
	RCALL SUBOPT_0xE
	LDI  R30,LOW(0)
_0x4A:
	ST   X,R30
; 0000 017E                 }
; 0000 017F             }
	SUBI R20,-1
	RJMP _0x3E
_0x3F:
; 0000 0180 
; 0000 0181 
; 0000 0182             ShiftLeft(current_col_data);
	MOVW R26,R28
	ADIW R26,8
	RCALL SUBOPT_0xC
; 0000 0183             UpdateDisplay();
; 0000 0184             delay_ms(10);
; 0000 0185         }
	SUBI R21,-1
	RJMP _0x3B
_0x3C:
; 0000 0186 
; 0000 0187 
; 0000 0188         for(row = 0; row < 8; row++) current_col_data[row] = 0;
	LDI  R20,LOW(0)
_0x45:
	CPI  R20,8
	BRSH _0x46
	RCALL SUBOPT_0xE
	LDI  R30,LOW(0)
	ST   X,R30
	SUBI R20,-1
	RJMP _0x45
_0x46:
; 0000 0189 ShiftLeft(current_col_data);
	MOVW R26,R28
	ADIW R26,8
	RCALL SUBOPT_0xC
; 0000 018A         UpdateDisplay();
; 0000 018B         delay_ms(10);
; 0000 018C     }
	ADIW R28,1
	__ADDWRN 16,17,1
	RJMP _0x27
_0x28:
; 0000 018D }
	CALL __LOADLOCR6
	ADIW R28,18
	RET
; .FEND
;
;

	.DSEG
_scroll_buffer:
	.BYTE 0x200

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x9:
	ST   -Y,R17
	MOV  R30,R17
	SUBI R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA:
	RCALL _GetMatrixByte
	ST   -Y,R30
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xB:
	LDI  R31,0
	CALL __LSLW2
	CALL __LSLW4
	SUBI R30,LOW(-_scroll_buffer)
	SBCI R31,HIGH(-_scroll_buffer)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	RCALL _ShiftLeft
	RCALL _UpdateDisplay
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	MOV  R30,R17
	LDI  R31,0
	CALL __LSLW2
	CALL __LSLW4
	__ADDW1MN _scroll_buffer,63
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	MOV  R30,R20
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,8
	ADD  R26,R30
	ADC  R27,R31
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

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
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
