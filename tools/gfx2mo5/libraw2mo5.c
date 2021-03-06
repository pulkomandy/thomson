/* GFX2mo5 - libraw2mo5.c
 * CloudStrife - 20080921
 * Copyright 2011, 2013, 2019 Adrien Destugues <pulkomandy@pulkomandy.tk>
 * Diffus� sous licence libre CeCILL v2
 * Voir LICENCE
 */

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned char *raw2mo5(unsigned char *input, int height, int fixup, bool to)
{
  unsigned char *tmpBuffer;
  int x,y;
  int previous = 0;
  bool lfo = false;
  uint8_t val;
  static const int width = 320;

  tmpBuffer = (unsigned char*)calloc(0x4000,1);
  if (tmpBuffer == NULL)
  {
    printf("Allocation tmpBuffer rat�\n");
    exit(4);
  }

  for (y = 0; y < height; y++)
	for (x = 0; x < 320; x+=8) {
		int fore = 255;
		int back = 255;
		int pix;
		bool oldlfo = lfo;

		for(pix = 0; pix < 8; pix++) {
			int nc = input[y*width+x+pix];
			if (nc > 15) printf("Color over limit!\n");
			if (back == nc) {
				// Pixel is in backcolor, set FORME to 0
				lfo = false;
			} else if (fore == nc) {
				// Pixel is in forecolor, set FORME to 1
	  			tmpBuffer[(y*320+x)/8] |= 0x80>>pix;
				lfo = true;
			} else if (back==255) {
				// Pixel is in unknown color, back is free : allocate backcolor
				back = nc;
				lfo = false;
			} else if (fore == 255) {
				// Pixel is unknown color, back is allocated : allocate front and set FORME
				fore = nc;
	  			tmpBuffer[(y*320+x)/8] |= 0x80>>pix;
				lfo = true;
			} else {
				printf("Color clash at %d %d : %d %d %d\n",x+pix,y,fore, back,
					input[y*width+x+pix]);
			}
		}

		if (fore == 255)
			fore = fixup;
		else if ((fixup < 0) && ((back == 1) || (fore == 0))) {
			// In normal mode, try to keep the lowest color as background.
			// Males it easier to manipulate (and likely, compress) the image
	  		tmpBuffer[(y*320+x)/8] ^= 0xFF;
			pix = fore;
			fore = back;
			back = pix;
		}

		if (fore != 255) {
			previous &= 0xF;
			previous |= fore << 4;
		}
		if (back != 255) {
			previous &= 0xF0;
			previous |= back;
		}

		// Make sure the last pixel of this GPL and the first of the next GPL
		// are both FORME or both FOND, else we get an ugly glitch on the
		// EFGJ033 Gate Array MO5!
		val = tmpBuffer[(y*320+x)/8];
		if(fixup > 0 && ((oldlfo == !(val & 0x80) && val != 0) || val == 0xFF))
		{
			previous = 7 | (previous << 4);
	  		tmpBuffer[(y*320+x)/8] ^= 0xFF;

			lfo = !lfo;
		} 
		
		// TO8 mode
		if(to)
		{
			previous = (previous & 0x7) | ((previous & 0xF0) >> 1) | ((previous & 0x8) << 4);
			previous ^= 0xC0;
		}

		tmpBuffer[0x2000+(y*320+x)/8] = previous;
  }

  return tmpBuffer;
}


unsigned char *raw2bm16(unsigned char *input, int height)
{
  unsigned char *tmpBuffer;
  int x,y;
  int p1 = 0;
  int p2 = 0x2000;
  static const int width = 160;

  tmpBuffer = (unsigned char*)calloc(0x4000,1);
  if (tmpBuffer == NULL)
  {
    printf("Allocation tmpBuffer rat�\n");
    exit(4);
  }

  for (y = 0; y < height; y++)
	for (x = 0; x < width; x+=4) {
		int pix;

		for(pix = 0; pix < 4; pix++) {
			int nc = input[y*width+x+pix];
			if (nc > 15) printf("Color over limit!\n");

			switch(pix) {
				case 0:
					tmpBuffer[p1] = nc << 4;
					break;
				case 1:
					tmpBuffer[p1++] |= nc;
					break;
				case 2:
					tmpBuffer[p2] = nc << 4;
					break;
				case 3:
					tmpBuffer[p2++] |= nc;
					break;
			}
		}
  }

  return tmpBuffer;
}


unsigned char *raw2bm4(unsigned char *input, int height)
{
  unsigned char *tmpBuffer;
  int x,y;
  int p1 = 0;
  int p2 = 0x2000;
  static const int width = 320;

  tmpBuffer = (unsigned char*)calloc(0x4000,1);
  if (tmpBuffer == NULL)
  {
    printf("Allocation tmpBuffer rat�\n");
    exit(4);
  }

  for (y = 0; y < height; y++)
	for (x = 0; x < width; x+=8) {
		int pix, a, b;

		for(pix = 0; pix < 8; pix++) {
			int nc = input[y*width+x+pix];
			if (nc > 3) printf("Color over limit!\n");

			a = nc >> 1;
			b = nc & 1;

			tmpBuffer[p1] |= a << (7 - pix);
			tmpBuffer[p2] |= b << (7 - pix);
		}

		p1++; p2++;
  }

  return tmpBuffer;
}
