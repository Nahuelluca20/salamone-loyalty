
# Rails-Inspired Web Design System Guide (For LLM Generation)

## Design Intent

Create a website that feels credible, mature, technical, and opinionated. The interface should prioritize clarity over spectacle, substance over persuasion, and confidence over hype.

Core impression:

* Developer-first
* Editorial
* Minimal
* Trustworthy
* Quietly premium
* Functional over decorative

---

## Brand Personality

The product voice should feel like an experienced engineer:

* Calm
* Direct
* Competent
* Precise
* Unimpressed by trends
* Confident without arrogance

Avoid:

* Excessive enthusiasm
* Startup clichés
* Marketing fluff
* Buzzword-heavy copy
* Artificial urgency

---

## Visual Principles

### 1. Simplicity First

Use only necessary elements. Every section must justify its presence.

### 2. Typography as Primary UI

Text hierarchy carries the design more than graphics.
Use spacing, scale, and weight before adding borders, shadows, or color.

### 3. Content Over Decoration

Real examples, code, proof points, and explanations are preferred over abstract visuals.

### 4. Strong Structure

Use clean grids, predictable spacing, and obvious reading flow.

### 5. Quiet Confidence

The product should look established and capable, not desperate for attention.

---

## Layout Rules

### Page Width

* Max content width: 1100–1280px
* Comfortable reading width for text blocks: 60–75 characters

### Spacing Scale

Use generous whitespace.
Recommended scale: 8 / 12 / 16 / 24 / 32 / 48 / 64 / 96

### Section Rhythm

Alternate between:

* Dense informational blocks
* Spacious breathing sections

### Alignment

Prefer left alignment. Center alignment only for hero statements or short callouts.

---

## Typography System

### Font Style

Use modern sans-serif or highly readable system fonts.
Examples:

* Inter
* Geist
* SF Pro
* IBM Plex Sans
* System UI stack

### Heading Style

* Large
* Bold
* Tight and direct
* Few words

### Body Copy

* Medium size
* High readability
* Neutral tone
* Short paragraphs

### Code Typography

Use monospace for snippets:

* JetBrains Mono
* IBM Plex Mono
* SF Mono
* Menlo

---

## Color Direction

Base palette should be restrained.

### Foundation

* White / off-white background OR dark graphite background
* High contrast text
* Neutral grays

### Accent Color

Use one strong brand accent only.

Brand palette:

* Primary: `#09ABE8`
* Secondary: `#70CBF7`
* Primary dark: `#0788BA`

Use Primary for main CTAs and key accents. Use Primary dark for hover/active states and high-contrast emphasis. Use Secondary sparingly for supporting highlights, subtle backgrounds, or secondary accents.

### Rules

* Accent color should guide attention, not dominate the page
* Avoid rainbow gradients
* Avoid neon overload
* Use muted surfaces instead of glossy cards

---

## Components

### Navigation

* Compact
* Few links
* Clear labels
* No crowded mega menus

### Hero Section

Must include:

* Sharp headline
* One sentence value proposition
* Primary CTA
* Optional secondary CTA

Tone: declarative, not exaggerated.

### Feature Sections

Use concise blocks:

* Title
* 1–2 sentence explanation
* Optional real example
* Optional code snippet

### Code Snippets

Important trust element.
Should feel real, readable, and useful.
Never fake complexity.

### Social Proof

Use recognizable logos or short factual credibility statements.
Keep understated.

### Footer

Dense but organized.
Useful links over decorative content.

---

## Motion & Interaction

Use motion sparingly.

Allowed:

* Subtle fades
* Hover state changes
* Gentle transitions
* Small content reveals

Avoid:

* Parallax overload
* Scroll hijacking
* Constant animation loops
* Attention-seeking motion

Interaction should feel fast and frictionless.

---

## Copywriting Rules

Write like an engineer who can explain business value.

### Good Copy

* Specific
* Concise
* Concrete
* Credible
* Useful

### Bad Copy

* Revolutionary platform
  n- Game-changing synergy
* Next-gen innovation
* Best-in-class solution
* Transform your workflow forever

### Preferred Style

Say:

* Build faster.
* Ship reliably.
* Convention over configuration.
* Designed for maintainability.
* Works at scale.

---

## Imagery Rules

If visuals are needed, prefer:

* Product screenshots
  n- Code examples
* Documentation previews
* Diagrams
* Real interfaces

Avoid:

* Generic stock photos
* Smiling office teams
* Abstract 3D blobs
* Meaningless illustrations

---

## UX Standards

* Fast loading
* Strong accessibility contrast
* Keyboard friendly
* Mobile responsive
* Predictable navigation
* Readable on first scan
* Clear CTA hierarchy

---

## Mobile Design

The design must look and work great on mobile. Treat mobile as a first-class target, not an afterthought.

Requirements:

* Layouts adapt fluidly from 320px upward
* Touch targets at least 44×44px
* Single-column flow on small screens; avoid horizontal scroll
* Typography stays readable without zoom (min 16px body)
* Navigation collapses cleanly (compact menu, no crowded bars)
* Spacing and hierarchy preserved across breakpoints
* Test on common widths: 375px, 390px, 414px, 768px

---

## Anti-Patterns to Reject

Do not generate:

* Over-designed SaaS landing pages
* Too many cards in grids
* Giant gradient backgrounds
* Empty buzzword sections
* Excessive emojis
* Forced humor
* Manipulative urgency banners
* Visual clutter

---

## Final Prompt Summary for LLM

Design a website with editorial minimalism for developers. Prioritize typography, whitespace, trust, and technical credibility. Use restrained color, clean structure, subtle interactions, and direct copy. The result should feel mature, capable, opinionated, and free of marketing noise.
