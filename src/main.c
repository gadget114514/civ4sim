#include "common.h"
#include "efdef.h"
#include "conddef.h"
#include "expr.wren"

#include "efdebug.h"
#include "conddebug.h"

class CVInit {
  construct new() {}

  static init(cv) {
    var tech = null
    var building = null
#include "techdef.h"
  }

}

#include "src.wren"

