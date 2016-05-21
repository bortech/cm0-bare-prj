#include "lpc1114.h"

#define BIT(n) (1ul << (n))

const int global_variable[] = {BIT(2), 0, BIT(2), 0};

int main() {
  // Turn on clock for GPIO, IOCON
  SYSAHBCLKCTRL |= BIT(6) | BIT(16);

  IOCON_R_PIO1_2 |= 0x01;
  GPIO1DIR |= BIT(2);
  GPIO1DATA = 0;

  int n;
	int i = 0;
  while(1)
  {
    GPIO1DATA = global_variable[i++];
		i &= 0x3;

    n=1000000; while(--n);
  }
}
