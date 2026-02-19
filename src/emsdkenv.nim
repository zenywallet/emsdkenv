# Copyright (c) 2025 zenywallet

import emsdkenv/emsdkenv
export emsdkenv


when isMainModule:
  import std/os
  import std/osproc
  import std/posix

  let ver: string = if paramCount() == 1: paramStr(1) else: "latest"
  let (ret, emsdkVer) = installEmsdk(ver)
  if ret:
    var shell = getEnv("SHELL")
    if shell.len == 0:
      shell = "/bin/sh"
    var command = ". ~/.emsdkenv/emsdk_" & emsdkVer & "/emsdk_env.sh && emcc -v && " & shell
    discard execl(shell, "sh", "-c", command, nil)
  else:
    echo "error: emsdk version [", ver, "] is not found"
    discard execCmd("ls ~/.emsdkenv/emsdk_*/emsdk_env.sh | sed \"s|^$HOME|~|\" | sed 's/^/source /'")
