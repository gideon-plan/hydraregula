## adapter.nim -- SP message -> regula WME conversion.
{.experimental: "strict_funcs".}
import std/[strutils, tables]

type
  BridgeError* = object of CatchableError

import basis/code/choice
type
  WmeFields* = Table[string, string]
  AdapterFn* = proc(payload: string): Choice[tuple[fact_type: string, fields: WmeFields]] {.raises: [].}
proc kv_adapter*(payload: string): Choice[tuple[fact_type: string, fields: WmeFields]] =
  var fields: WmeFields
  var fact_type = "event"
  for line in payload.splitLines():
    let trimmed = line.strip()
    if trimmed.len == 0: continue
    let eq = trimmed.find('=')
    if eq > 0:
      let k = trimmed[0 ..< eq].strip()
      let v = trimmed[eq + 1 ..< trimmed.len].strip()
      if k == "type": fact_type = v
      else: fields[k] = v
  good((fact_type: fact_type, fields: fields))
