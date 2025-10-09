# Copyright (c) 2025 zenywallet

import std/os
import std/json

let envDir = getHomeDir() / ".emsdkenv"
let emsdkDir = envDir / "emsdk"
let tagFile = emsdkDir / "emscripten-releases-tags.json"
let gitClone = "git clone https://github.com/emscripten-core/emsdk.git"

when defined(nimscript):
  #mode = ScriptMode.Verbose

  proc verCheck(ver: string): tuple[ret: bool, ver: string] =
    var ver = ver
    if fileExists(tagFile):
      let tags = parseJson(staticRead(tagFile))
      for k, v in tags["aliases"]:
        if k == ver:
          ver = v.getStr
          break
      for k, v in tags["aliases"]:
        if k == ver:
          return (true, v.getStr)
      for k, v in tags["releases"]:
        if k == ver:
          return (true, k)
    return (false, "")

  proc emsdkEnv*(cmd: string, ver: string = "latest") =
    if not dirExists(emsdkDir):
      exec "mkdir -p " & envDir
      withDir envDir:
        exec gitClone
    else:
      withDir emsdkDir:
        exec "git pull"

    let (ret, emsdkVer) = verCheck(ver)
    if ret:
      let verDir = emsdkDir & "_" & emsdkVer
      if not dirExists(verDir):
        exec "cp -ar " & emsdkDir & " " & verDir
        withDir verDir:
          exec "./emsdk install " & emsdkVer
          exec "./emsdk activate " & emsdkVer
      let curDir = getCurrentDir()
      exec "cd " & verDir & " && . ./emsdk_env.sh && cd " & curDir & " && " & cmd
      echo "---"
    else:
      echo "error: emsdk version [", ver, "] is not found"

else:
  import std/osproc

  proc verCheck(ver: string): tuple[ret: bool, ver: string] =
    var ver = ver
    try:
      let tags = parseFile(tagFile)
      for k, v in tags["aliases"]:
        if k == ver:
          ver = v.getStr
          break
      for k, v in tags["aliases"]:
        if k == ver:
          return (true, v.getStr)
      for k, v in tags["releases"]:
        if k == ver:
          return (true, k)
      return (false, "")
    except:
      return (false, "")

  proc errCheck(errCode: int) =
    if errCode != 0:
      raise

  proc emsdkEnv*(cmd: string, ver: string = "latest") =
    let curDir = getCurrentDir()
    if not dirExists(emsdkDir):
      errCheck execCmd("mkdir -p " & envDir)
      setCurrentDir(envDir)
      errCheck execCmd(gitClone)
    else:
      setCurrentDir(emsdkDir)
      errCheck execCmd("git pull")

    let (ret, emsdkVer) = verCheck(ver)
    if ret:
      let verDir = emsdkDir & "_" & emsdkVer
      if not dirExists(verDir):
        errCheck execCmd("cp -ar " & emsdkDir & " " & verDir)
        setCurrentDir(verDir)
        errCheck execCmd("./emsdk install " & emsdkVer)
        errCheck execCmd("./emsdk activate " & emsdkVer)
      else:
        setCurrentDir(verDir)
      errCheck execCmd(". ./emsdk_env.sh && cd " & curDir & " && " & cmd)
    else:
      echo "error: emsdk version [", ver, "] is not found"
