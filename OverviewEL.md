**Notes for an English Literal programming language and interpreter**
=====================================================================

([Dijkstra](http://dl.acm.org/citation.cfm?id=647639.760596) notwithstanding.)

**Basic notions**
-----------------

### Philosophy
  - All operations are mediated by uncompressed English literals. The documentation is the program.
  - Agent/object differentiation.
  - Sacrifice efficiency in time and memory for offline and runtime understandability.
  - Minimal possible allowable grammatical constructs.
  - Low default inter-agent trust levels.
  - Real user / artificial agent agnosticism.

### Applications
  - personal organization system; enhanced shell
  - social dynamics, narrative modelling
  - general or special purpose "expert systems"
  - distributed computing (for collaborative indirection, not efficiency)

### Use existing parsers and verbalizers
  - UNL
  - ACE
  - link-grammar

### Use existing ontology systems
  - UNL
  - OWL

### Agent identity file
  - Stipulates overall behavioral properties of this agent (or instances of this agent type).
  - Allows "I" subject statements, for low-skepticism initialization/augmentation of internal ontology and reasoner meta properties.
  - Stipulates organizations it will join, under what conditions.
  - Stipulates which runtime modifications are permanent (written to this file).

### Organizations
A role-relation pattern. Roles specified like "templates", and occupied by active agents at runtime. These are first-class agents, with actions and information-gathering coordinated by the pattern; inspired by Ehresmann and Vanbremeersch.

Can probably replace a class hierachy (as in most OOP languages) for agent instances.

### REPL input types
  - Function definition. "To verb a this, a that, and/or another thing is to (*single clause definition*, *or* do the following). [Continuation until scope loss]"
  - Document or object definitions. "A this thing is a thing, another thing, ... ."
  - Belief assertions, for conditional incorporation into listener's internal ontology.
  - Function call or command; conditionally obeyed!
  - Query or answer. "Why?" to trigger reasoner trace ("double cruxing"). "What is...?" to trigger revelation of other's definitions.
  - Control structures. If, then, for each.

### Context stacks
Backreferences as in ordinary conversation. Limited, predictable functionality of "the", "that", "this".

### Pre-defined communicative functions
  - *Tell* an agent something. Pass primitives by value.
  - *Give* or *send* an agent something. Pass reference to a documentary object, and grant exclusive access privileges.
  - *Share* something with an agent. Same as *give* or *send*, but without exclusive access grant.

**Implementation modules**
--------------------------

### 1. IRC layer

IRC is an already well-established protocol for plain text communication between processes or across a network, for which the messages typically have the interpretation as meaningful communication in a human user's spoken language. This makes it a good candidate for our basic communication protocol


#### Server
A slightly repurposed minimal open source IRC server, running locally, maintaining
  - 1 "ambient" or "global" channel (all agents listed)
  - 1 additional channel for each active organization
  - pairwise private messaging

Virtually no metadata should be passed between agents. All should be visible in plain sentences.

#### Client
  - A forked minimal open source IRC client, with super-user (operator?) privileges on the server.
  - Streamlined channel showing and hiding (showing listener of listener, etc., equivalent to a stack trace).
  - No real IRC commands are input. No real IRC behavior is displayed... all functionality related to ordinary IRC networks is stripped or hidden.
  - Added functions for directing the operation of the server (itself modified to permit this); meta-commands (still in English).
  - Optional (use emacs?): An editing pane for the identity files of the agents and organizations.


### 2. Parser

### 3. Verbalizer

### 4. Reasoner


