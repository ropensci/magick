/* Normalize font family names to fonts usually available on MacOS/Windows/Linux */

#include <string.h>
#include <string>

std::string normalize_font(const char * family){
  //Alias: "Sans" or "" (default)
  if(!strlen(family) ||
     !strncmp(family, "sans", 4) || !strncmp(family, "Sans", 4))
    return std::string("Arial");

  //Alias: "Mono" or "Monospace"
  if(!strncmp(family, "mono", 4) || !strncmp(family, "Mono", 4))
    return std::string("Courier New");

  //Alias: "Comic Sans"
  if(!strncmp(family, "comic", 5) || !strncmp(family, "Comic", 5))
    return std::string("Comic Sans MS");

  //Alias: "Trebuchet"
  if(!strncmp(family, "trebuchet", 9) || !strncmp(family, "Trebuchet", 9))
    return std::string("Trebuchet MS");

  //Alias: "Georgia Serif"
  if(!strncmp(family, "Georgia", 7) || !strncmp(family, "georgia", 7))
    return std::string("Georgia");

  //Alias "Lucida"
  if(!strncmp(family, "lucida", 6) || !strncmp(family, "Lucida", 6)){
#ifdef _WIN32
    return std::string("Lucida Console");
#elif __APPLE__
    return std::string("Lucida Grande");
#else
    return std::string("Lucida Sans");
#endif
  }

  //Alias "Helvetica" or "Segoe"
  if(!strncmp(family, "helvetica", 9) || !strncmp(family, "Helvetica", 9) ||
     !strncmp(family, "segoe", 5) || !strncmp(family, "Segoe", 5)){
#ifdef _WIN32
    return std::string("Segoe UI");
#elif __APPLE__
    return std::string("Helvetica Neue");
#else
    return std::string("Helvetica");
#endif
  }

  //Alias "Palatino"
  if(!strncmp(family, "palatino", 8) || !strncmp(family, "Palatino", 8)){
#ifdef _WIN32
    return std::string("Palatino Linotype");
#else
    return std::string("Palatino");
#endif
  }

  //Alias: "Times" or "Serif"
  if(!strncmp(family, "serif", 5) || !strncmp(family, "Serif", 5) ||
     !strncmp(family, "Times", 5) || !strncmp(family, "times", 5)){
#ifdef _WIN32
    return std::string("Times New Roman");
#else
    return std::string("Times");
#endif
  }
  //Custom / unknown
  return std::string(family);
}
