# Copyright (c) 2025 zenywallet

import emsdkenv/emsdkenv
export emsdkenv


when isMainModule:
  import os

  if paramCount() == 1:
    emsdkEnv("emcc -v", paramStr(1))
  else:
    emsdkEnv("emcc -v")
