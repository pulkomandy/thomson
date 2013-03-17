#include "effect.h"

#include "../libdemo/trig.h"

uint8_t backbuffer[256];
const uint8_t colors[] __attribute__((section("hibyte"))) = {
	// ICE
	0x00, 0x04, 0x44, 0x4C, 0xCC, 0xC6, 0x66, 0x6E,
	0xEE, 0xE7, 0x77, 0x7D, 0xDD, 0xD5, 0x55, /*0x50,*/

	// RAINBOW
	/*0x55,*/ 0x54, 0x44, 0x46, 0x66, 0x62, 0x22, 0x20,
	0x00, 0x01, 0x11, 0x13, 0x33, 0x37, 0x77, /*0x75,*/

	// WHITE
	/*0x77,*/ 0x7D, 0xDD, 0xDC, 0xCC, 0xCE, 0xEE, 0xEA,
	0xAA, 0xA8, 0x88, 0x89, 0x99, 0x9B, 0xBB, /*0xB7,*/

	// APPLES
	/*0xBB,*/ 0xB7, 0x77, 0x79, 0x99, 0x91, 0x11, 0x10,
	0x00, 0x02, 0x22, 0x23, 0x33, 0x3A, 0xAA, 0xAB,

	0xBB, 0xB3, 0x33, 0x32, 0x22, 0x20,
	// FIRE
	/*
	0x11, 0x1F, 0xFF, 0xFD, 0xDD, 0xD9, 0x99, 0x9B,
	0xBB, 0xB3, 0x33, 0x39, 0x99, 0x9F, 0xFF, 0xF1,*/

	0x00, 0x04, 0x44, 0x4C, 0xCC, 0xC6, 0x66, 0x6E,
	0xEE, 0xE7, 0x77, 0x7D, 0xDD, 0xD5, 0x55, 0x54,
	0x44, 0x46, 0x66, 0x62, 0x22, 0x20, 0x00, 0x01,
	0x11, 0x13, 0x33, 0x37, 0x77, 0x7D, 0xDD, 0xDC,
	0xCC, 0xCE, 0xEE, 0xEA, 0xAA, 0xA8, 0x88, 0x89,
	0x99, 0x9B, 0xBB, 0xB7, 0x77, 0x79, 0x99, 0x91,
	0x11, 0x10, 0x00, 0x02, 0x22, 0x23, 0x33, 0x3A,
	0xAA, 0xAB, 0xBB, 0xB3, 0x33, 0x32, 0x22, 0x20,
	0x00, 0x04, 0x44, 0x4C, 0xCC, 0xC6, 0x66, 0x6E,
	0xEE, 0xE7, 0x77, 0x7D, 0xDD, 0xD5, 0x55, 0x54,
	0x44, 0x46, 0x66, 0x62, 0x22, 0x20, 0x00, 0x01,
	0x11, 0x13, 0x33, 0x37, 0x77, 0x7D, 0xDD, 0xDC,
	0xCC, 0xCE, 0xEE, 0xEA, 0xAA, 0xA8, 0x88, 0x89,
	0x99, 0x9B, 0xBB, 0xB7, 0x77, 0x79, 0x99, 0x91,
	0x11, 0x10, 0x00, 0x02, 0x22, 0x23, 0x33, 0x3A,
	0xAA, 0xAB, 0xBB, 0xB3, 0x33, 0x32, 0x22, 0x20,
	0x00, 0x04, 0x44, 0x4C, 0xCC, 0xC6, 0x66, 0x6E,
	0xEE, 0xE7, 0x77, 0x7D, 0xDD, 0xD5, 0x55, 0x54,
	0x44, 0x46, 0x66, 0x62, 0x22, 0x20, 0x00, 0x01,
	0x11, 0x13, 0x33, 0x37, 0x77, 0x7D, 0xDD, 0xDC,
	0xCC, 0xCE, 0xEE, 0xEA, 0xAA, 0xA8, 0x88, 0x89,
	0x99, 0x9B, 0xBB, 0xB7, 0x77, 0x79, 0x99, 0x91,
	0x11, 0x10, 0x00, 0x02, 0x22, 0x23, 0x33, 0x3A,
	0xAA, 0xAB, 0xBB, 0xB3, 0x33, 0x32, 0x22, 0x20,

	0x00, 0x04, 0x44, 0x4C, 0xCC, 0xC6, 0x66, 0x6E,
	0xEE, 0xE7, 0x77, 0x7D, 0xDD, 0xD5, 0x55, 0x50
};

extern unsigned char SIN[256];

static void decrunch()
{
	asm(
		" LDX #color_plasma-1		\n"
		" LDU #forme_plasma-1		\n"
		" LBSR decrunchpic			\n"
		:::"x","u", "y");
}

void init()
{
	int x,y,v;

// INIT ONCE
	for(y = 0; y < 256; y++)
	{
		backbuffer[y] = (SIN[y] / 32);
	}

	polysine();

// EACHTIME

	decrunch();
	forme();
	v = 0x55;
	for(y = 40 * 40; y < 139 * 40; y+=40)
	{
		for(x = 10; x < 30; x++)
			screen[y + x] = v;
		v ^= 0xFF; // or rotate
	}
	couleur();

	asm(" LDA #_draw/256 \n"
		" TFR A,DP  \n"
		::: "a"
	   );
}
