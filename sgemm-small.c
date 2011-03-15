#include <emmintrin.h>

void sgemm( int m, int n, float *A, float *C )
{
  __m128 a, b; 
  /*handle fringe cases as slowly as I damn well please*/
  if (n != 64 || m != 64) {
    for(int k = 0; k < n; k++)
      for(int j = 0; j < m; j++) 
	for(int i = 0; i < m; i++) 
	  C[i+j*m] += A[i+k*m] * A[j+k*m];
    return;
  }

  for (int k  = 0; k < n; k++) {
      for (int j = 0; j < m; j++) {
	  b = _mm_load1_ps(A+j+k*m);
	  for (int i = 0; i < m; i+=4) {
	      a = _mm_load_ps(A+i+k*m);
	      _mm_store_ps((C+i+j*m), _mm_add_ps(_mm_mul_ps(a, b), _mm_load_ps(C+i+j*m)));
	  }
      }
  }	
}
