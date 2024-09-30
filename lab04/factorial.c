#include <stdio.h>

int factorial(int n) {
  if (n == 0) {
    return 1;
  }
  return n * factorial(n - 1);
}

int main() {
  int x = 10;
  int y = factorial(x);
  printf("Factorial of %d is %d\n", x, y);
  return 0;
}
