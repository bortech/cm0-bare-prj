#include "lpc1114.h"

#define BIT(n) (1ul << (n))

int main() {
  // Turn on clock for GPIO, IOCON
  SYSAHBCLKCTRL |= BIT(6) | BIT(16);

  IOCON_R_PIO1_2 |= 0x01;
  GPIO1DIR |= BIT(2);
  GPIO1DATA = 0;

  int n;
  while(1)
  {
    GPIO1DATA = BIT(2);
    n=1000000; while(--n);
    GPIO1DATA = 0;
    n=1000000; while(--n);
  }
}
