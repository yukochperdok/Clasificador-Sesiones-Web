#define _CRTDBG_MAP_ALLOC  
#include <stdlib.h>  
#include <crtdbg.h> 

#include <Rcpp.h> 
#include <vector>
#include <algorithm>
// En R hacemos 
// require(Rcpp) 
// setwd("C:\\Users\\Alvaro\\OneDrive\\Proyecto MBIT\\Proyecto - Codere\\Datos\\Estudio_datos\\Pruebas parciales en curso")
// sourceCpp("fibonacci.cpp")
// mat<-unname(t(apply(matrizClicks[1:1000,], 1, as.numeric)))
/*
void imprime(std::vector<int>& vectu) {
  for(std::size_t i=0; i<vectu.size(); ++i)
    std::cout << vectu[i] << ' ';
  std::cout << '\n';
}

std::vector<int>& quitaDobles(std::vector<int>& vecto) {
  sort( vecto.begin(), vecto.end() );
  vecto.erase( unique( vecto.begin(), vecto.end()), vecto.end());
  imprime(vecto);
  return(vecto);
}
*/
using namespace Rcpp;
// [[Rcpp::export]] 

void imprime(std::vector<int>& vectu) {
  for(std::size_t i=0; i<vectu.size(); ++i)
    std::cout << vectu[i] << ' ';
  std::cout << '\n';
}

std::vector<int>& quitaDobles(std::vector<int>& vecto) {
  sort( vecto.begin(), vecto.end() );
  vecto.erase( unique( vecto.begin(), vecto.end()), vecto.end());
  return(vecto);
}

double distJaccard(std::vector<int>& vect1,
                std::vector<int>& vect2) {

  double une, intersec, distancia;
  std::vector<int>::iterator it;
  std::vector<int> vectUnion((int) vect1.size());
  std::vector<int> vectIntersec((int) vect1.size());
  
  imprime(vect1);
  vect1 = quitaDobles(vect1);
  imprime(vect1);
  imprime(vect2);
  vect2 = quitaDobles(vect2);
  imprime(vect2);
  
  it=std::set_union (vect1.begin(), vect1.end(), 
                     vect2.begin(), vect2.end(), 
                     vectUnion.begin());

  vectUnion.resize(it-vectUnion.begin());
  une = vectUnion.size();

  it=std::set_intersection (vect1.begin(), vect1.end(), 
                            vect2.begin(), vect2.end(), 
                            vectIntersec.begin());
  
  vectIntersec.resize(it-vectIntersec.begin());  
  intersec = vectIntersec.size();
  //delete(une);
  //delete(intersec);
  vect1.clear();
  vect2.clear();
  distancia = 1.0 - intersec / une;
  return(distancia);
}



