# The Order & Trade Lifecycle — The Map

*The Execution Trilogy, Part One.*

**[Read it →](https://rohanshiloh.github.io/order-trade-lifecycle/)**

| | | |
|---|---|---|
| **Part One** | **The Order & Trade Lifecycle** — the map | *what the machine is* |
| Part Two | [Anatomy of a Fill](https://rohanshiloh.github.io/exec-tca-stack/) — the territory | *how we measure it* |
| Part Three | [Sharded Ticks](https://rohanshiloh.github.io/tickerplant.ai/) — the machine | *building it to scale* |

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
| 6 | [Post-trade](https://rohanshiloh.github.io/order-trade-lifecycle/#post-trade) | [Allocation](https://rohanshiloh.github.io/order-trade-lifecycle/#allocation) · [affirmation](https://rohanshiloh.github.io/order-trade-lifecycle/#affirmation) · [clearing](https://rohanshiloh.github.io/order-trade-lifecycle/#clearing) · [settlement](https://rohanshiloh.github.io/order-trade-lifecycle/#settlement) |
| 7 | [Chronicle](https://rohanshiloh.github.io/order-trade-lifecycle/#chronicle) | The in-band path at wire speed |
| 8 | [The kdb+ view](https://rohanshiloh.github.io/order-trade-lifecycle/#kdb) | Lifecycle as event stream; the [shared schema](https://rohanshiloh.github.io/order-trade-lifecycle/#schema) |

### Figures

[Lifecycle end to end](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-lifecycle) ·
[Slicing](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-slicing) ·
[Order hierarchy](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-hierarchy) ·
[Sharding and affinity](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-sharding) ·
[Sweep timing](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-sweep) ·
[Markout curves](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-markouts) ·
**[Ownership and metric attachment](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-attachment)** ·
[FIX state machine](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-state-machine) ·
[ClOrdID chain](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-clordid) ·
[Novation and netting](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-netting) ·
[Chronicle Queue](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-queue) ·
[Chronicle pipeline](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-chronicle) ·
[kdb+ adapter](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-adapter) ·
[The five clocks](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-clocks) ·
[Tickerplant architecture](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-tickerplant)

If you read one figure, read
**[ownership and metric attachment](https://rohanshiloh.github.io/order-trade-lifecycle/#fig-attachment)** —
it is the bridge between this paper and the companion: which TCA metric belongs to which lifecycle object, and
who owns it when it is wrong.

## The rest of the trilogy

**[Part Two — Anatomy of a Fill](https://rohanshiloh.github.io/exec-tca-stack/)** is the territory. Where this
paper explains *what* the lifecycle is and *why* it has that shape, Part Two builds a running tick stack in
q/kdb+ that measures it — a tickerplant, a chained TP isolating the CEP, and every benchmark derived from raw
events by one `aj` or one `select … by`.

**[Part Three — Sharded Ticks](https://rohanshiloh.github.io/tickerplant.ai/)** is the machine: taking that
stack to scale.

Start there with [Ten Ways to Get This Wrong](https://rohanshiloh.github.io/exec-tca-stack/#mistakes) and
[Five Rules](https://rohanshiloh.github.io/exec-tca-stack/#rules).

The two documents share an anchor vocabulary, so `#markouts`, `#benchmarks` and `#fig-markouts` land on the
same subject in either one.

## Local

```sh
open index.html
```

That is the whole build. Everything — CSS, SVG, type — is inline.
