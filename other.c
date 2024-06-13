#include <omp.h>
#include <stdio.h>

void InvokeOther() {
  int critical_unamed = 0;
  int critical_named = 0;
  int reduction = 0;
#pragma omp parallel num_threads(8) reduction(+ : reduction)
  {
    #pragma omp critical 
    {
      ++critical_unamed;
    }
    #pragma omp critical (NAME)
    {
      ++critical_named;
    }
    ++reduction;
  }
  printf("other.c critical_unamed: %d\n", critical_unamed); 
  printf("other.c critical_named: %d\n", critical_named); 
  printf("other.c reduction: %d\n", reduction); 
}