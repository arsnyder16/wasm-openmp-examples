#include <omp.h>
#include <stdio.h>

extern void InvokeOther();

int main(int argc, char** argv) {
  int critical_unamed = 0;
  int critical_named = 0;
  int reduction = 0;
#pragma omp parallel num_threads(8) reduction(+ : reduction) 
  {
    printf("Hello World... from thread = %d\n", omp_get_thread_num()); 
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
  printf("example.c critical_unamed: %d\n", critical_unamed); 
  printf("example.c critical_named: %d\n", critical_named); 
  printf("example.c reduction: %d\n", reduction);
  InvokeOther();
}
