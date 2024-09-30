#include <stdio.h>

// Write binary search

int binary_search(int *A, int len, int start, int end, int val) {
  if (start > end)
    return -1;
  int mid = (start + end) / 2;
  if (A[mid] == val)
    return mid;
  if (A[mid] < val)
    return binary_search(A, len, mid + 1, end, val);
  return binary_search(A, len, start, mid - 1, val);
}
