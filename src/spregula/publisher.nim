## publisher.nim -- Regula rule actions publishing SP messages.
{.experimental: "strict_funcs".}
import std/[strutils, tables]
import basis/code/choice
type
  SpSendFn* = proc(payload: string): Choice[bool] {.raises: [].}
proc publish_kv*(send_fn: SpSendFn, fields: Table[string, string]): Choice[bool] =
  var lines: seq[string]
  for k, v in fields: lines.add(k & "=" & v)
  send_fn(lines.join("\n"))
