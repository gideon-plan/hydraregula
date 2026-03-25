## subscriber.nim -- SP SUB receiving events, converting to WMEs.
{.experimental: "strict_funcs".}

import basis/code/choice, adapter
type
  InsertFn* = proc(fact_type: string, fields: WmeFields): Choice[bool] {.raises: [].}
  SpRecvFn* = proc(): Choice[string] {.raises: [].}
proc receive_and_insert*(recv_fn: SpRecvFn, adapt_fn: AdapterFn,
                         insert_fn: InsertFn): Choice[bool] =
  let payload = recv_fn()
  if payload.is_bad: return bad[bool](payload.err)
  let adapted = adapt_fn(payload.val)
  if adapted.is_bad: return bad[bool](adapted.err)
  insert_fn(adapted.val.fact_type, adapted.val.fields)
