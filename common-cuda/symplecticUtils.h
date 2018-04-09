
#ifndef SYMPLECTIC_UTILS_H
#define SYMPLECTIC_UTILS_H

/****
 * In C++11, in-class member initializers are allowed,
 * but basically act the same as initializing in a member initialization list. 
 * Therefore, the size of the array must be explicitly stated.
 ****/

namespace SymplecticUtils {

  // from J. Chem. Phys. 104, 7099 (1996)
  struct {
    const double a[6] = { 0.2167979108466032, -0.0283101143283301, 0.3901418904713324,
			 -0.2414087476423302,  0.5908564573813148, 0.0719226032714098 };
    
    const double b[6] = { 0.0719226032714098,  0.5908564573813148, -0.2414087476423302, 
			  0.3901418904713324, -0.0283101143283301,  0.2167979108466032 };
    
  } coeffients_m6_n4;
  
  inline int size()
  { return MatlabData::si_coefficients() ?
      MatlabData::si_coefficients()->m :
      sizeof(coeffients_m6_n4.a)/sizeof(double);
  }
  
  inline const double *a()
  { return MatlabData::si_coefficients() ?
      (const double *) MatlabData::si_coefficients()->a :
      coeffients_m6_n4.a;
  }
  
  inline const double *b()
  { return MatlabData::si_coefficients() ?
      (const double *) MatlabData::si_coefficients()->b :
      coeffients_m6_n4.b;
  }
}

#endif /* SYMPLECTIC_UTILS_H */
