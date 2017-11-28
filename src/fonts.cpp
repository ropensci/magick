#include <string.h>
#include <string>

std::string normalize_font(const char * family){
  //Alias: "Sans" or "" (default)
  if(!strlen(family) || !strncmp(family, "sans", 4) || !strncmp(family, "Sans", 4))
    return std::string("Arial");

  //Alias: "Mono" or "Monospace"
  if(!strncmp(family, "mono", 4) || !strncmp(family, "Mono", 4))
    return std::string("Courier New");

  //Alias: "Comic Sans"
  if(!strncmp(family, "comic", 5) || !strncmp(family, "Comic", 5))
    return std::string("Comic Sans MS");

  //Alias: Serif
  if(!strncmp(family, "serif", 5) || !strncmp(family, "Serif", 5)){
#ifdef _WIN32
    return std::string("Times New Roman");
#else
    return std::string("Times");
#endif
  }
  //Custom / unknown
  return std::string(family);
}
