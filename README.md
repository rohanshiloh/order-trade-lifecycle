# The Order & Trade Lifecycle

**[Read it →](https://rohanshiloh.github.io/order-trade-lifecycle/)**

How an intention becomes a settled trade: through the OMS, the EMS, and the FIX wire to clearing and
finality — then rebuilt as software, on Chronicle's microsecond queues and a real-time q/kdb+ tickerplant.

A single-file HTML paper in the Tufte style — justified serif prose, numbered sidenotes and key-concept
boxes in the right margin, nine inline SVG diagrams, dark mode throughout. No build step, no dependencies,
nothing fetched at runtime.

## Contents

| § | | |
|---|---|---|
| 1 | [The lifecycle at a glance](https://rohanshiloh.github.io/order-trade-lifecycle/#overview) | The two lifecycles, and the seam between them |
| 2 | [Market structure](https://rohanshiloh.github.io/order-trade-lifecycle/#structure) | Big Bang to T+1 — why the lifecycle has the shape it does |
| 3 | [The OMS](https://rohanshiloh.github.io/order-trade-lifecycle/#oms) | Parent orders, compliance, allocation, attribution |
| 4 | [The EMS](https://rohanshiloh.github.io/order-trade-lifecycle/#ems) | [Execution stack](https://rohanshiloh.github.io/order-trade-lifecycle/#execution-stack) · [routing](https://rohanshiloh.github.io/order-trade-lifecycle/#routing) · [benchmarks](https://rohanshiloh.github.io/order-trade-lifecycle/#benchmarks) · [markouts](https://rohanshiloh.github.io/order-trade-lifecycle/#markouts) |
| 5 | [FIX](https://rohanshiloh.github.io/order-trade-lifecycle/#fix) | The protocol fabric, and the [order state machine](https://rohanshiloh.github.io/order-trade-lifecycle/#state-machine) |
| 6 | [Post-trade](https://rohanshiloh.github.io/order-trade-lifecycle/#post-trade) | Allocation, affirmation, clearing, settlement finality |
| 7 | [Chronicle](https://rohanshiloh.github.io/order-trade-lifecycle/#chronicle) | The in-band path at wire speed |
| 8 | [The kdb+ view](https://rohanshiloh.github.io/order-trade-lifecycle/#kdb) | Lifecycle as event stream; the [shared schema](https://rohanshiloh.github.io/order-trade-lifecycle/#schema) |

### Figures

[Lifecycle end to end](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-lifecycle) ·
[Slicing](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-slicing) ·
[Order hierarchy](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-hierarchy) ·
[Sharding and affinity](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-sharding) ·
[Sweep timing](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-sweep) ·
[Markout curves](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-markouts) ·
[FIX state machine](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-state-machine) ·
[Chronicle pipeline](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-chronicle) ·
[Tickerplant architecture](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-tickerplant)

## Companion volume

This paper is the map; **[Anatomy of a Fill](https://rohanshiloh.github.io/exec-tca-stack/)** is the
territory. Where this document explains *what* the lifecycle is and *why* it has that shape, the companion
builds a running tick stack in q/kdb+ that measures it — a tickerplant, a chained TP isolating the CEP, and
every benchmark derived from raw events by one `aj` or one `select … by`.

Start there with [Ten Ways to Get This Wrong](https://rohanshiloh.github.io/exec-tca-stack/#mistakes) and
[Five Rules](https://rohanshiloh.github.io/exec-tca-stack/#rules).

The two documents share an anchor vocabulary, so `#markouts`, `#benchmarks` and `#fig-markouts` land on the
same subject in either one.

## Local

```sh
open index.html
```

That is the whole build. Everything — CSS, SVG, type — is inline.
