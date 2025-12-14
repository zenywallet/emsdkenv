# Copyright (c) 2025 zenywallet

import emsdkenv/emsdkenv
export emsdkenv


when isMainModule:
  import std/os
  import std/osproc

  if paramCount() == 1:
    emsdkEnv("emcc -v", paramStr(1))
  else:
    emsdkEnv("emcc -v")
  discard execCmd("ls ~/.emsdkenv/emsdk_*/emsdk_env.sh | sed \"s|^$HOME|~|\" | sed 's/^/source /'")
