# DrawPoker Logic Engine

A framework-agnostic, open-source 5-card draw poker engine featuring an automated computer opponent with dynamic discard strategy engines. 

This repository serves as a dedicated architectural sandbox. It was originally built to explore raw algorithmic game logic in Ruby and was later used as an exercise in **dependency modernization, successfully upgrading the core framework environment from Rails 5 to Rails 7**.

## 🏗️ Architectural Overview

The core domain logic is entirely decoupled from the web and database layers, isolated cleanly inside `lib/draw_poker_logic.rb`. 

* **Procedural AI Engine:** Computes optimal discard strategies based on current hand strengths (e.g., calculating a "four-flush" vs breaking a low pair).
* **Zero-Dependency Evaluator:** Analyzes, scores, and resolves tiebreakers across all traditional poker hand hierarchies using pure, vanilla Ruby.

## 🛠️ Self-Refactoring & Future Roadmap

As a senior-level technical exercise, I treat this codebase as a living legacy project. If I were executing a full modernization sprint on this module today, my structural focus areas would include:

1. **Primitive Obsession & Type Refactoring:** 
   * *Current State:* Cards are represented as strings, requiring brittle lookups like `card.split(' ')[2]` to evaluate suits.
   * *Target State:* Refactoring cards into immutable value objects using modern Ruby `Data.define(:rank, :suit)` or lightweight `Struct` components to turn `card.split(' ')[2]` into a clean, explicit `card.suit`.

2. **Decoupling State via Domain Objects:**
   * *Current State:* Array-heavy manipulation passing state context variables deep through procedural helpers.
   * *Target State:* Migrating the module into isolated domain classes (`Hand`, `Deck`, `AIPlayer`) to encapsulate rulesets cleanly and introduce better polymorphic design patterns.

3. **Constant Optimization:**
   * Extracting hardcoded logic maps (like card score values and ranks) into frozen top-level constants (`RANK_VALUES.freeze`) to maximize memory efficiency and eliminate redundant hash allocations at runtime.
