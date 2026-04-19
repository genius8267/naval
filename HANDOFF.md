# Handoff — Brain of Naval skill build

**Audience**: another LLM (or future-you) picking this project up cold.
**Status** (2026-04-19): v1.0.0 published to https://github.com/genius8267/naval. Skill installed locally. Brain live in the vault. Env vars set.

---

## What this is

A Claude Code skill (`naval`) that runs a user's question through an AI-synthesized Naval Ravikant persona via an Opus sub-agent. The persona ("Brain of Naval") was distilled from 34 public long-form Naval interviews via 6 parallel extraction agents and one synthesis pass. The skill has 8 modes (default / quick / kapil / debate / pushback / retro / eval / context), saves consultations with a Follow-up field for learning-loop tracking, and includes a regression-test harness.

Two copies of the brain exist:

| Copy | Path | Author frontmatter | Purpose |
|---|---|---|---|
| Live (vault) | `~/Library/CloudStorage/GoogleDrive-jwlee8267@intunelabs.ai/My Drive/40_Obsidian/40. Reference/Naval/_brain/` | `[[Joowon Lee]]` | The user's working copy — edited in Obsidian, used by the installed skill via `$NAVAL_BRAIN_PATH` |
| Bundled (repo) | `~/DEV/naval-skill/skill/brain/` → `~/.claude/skills/naval/brain/` on install | `Brain of Naval` | Portable snapshot — ships with the skill package so strangers don't need a vault |

---

## File locations (authoritative map)

### Personal (in user's vault, MBP path)
```
~/Library/CloudStorage/GoogleDrive-jwlee8267@intunelabs.ai/My Drive/40_Obsidian/
├── 40. Reference/Naval/
│   ├── _brain/                                  # LIVE brain (edit here to change persona)
│   │   ├── 00-brain-of-naval.md                # Master persona (~7K words)
│   │   ├── 01-wealth.md … 06-tech-future.md    # 6 domain extractions (~3K words each)
│   │   └── _evals/
│   │       ├── canonical.md                    # 8 regression-test Q&A pairs
│   │       └── reports/                         # Populated by `naval --eval` runs
│   ├── _consultations/                          # Saved consultations + auto INDEX.md
│   └── 2026-04-19 <transcript>.md × 34         # Original source transcripts (stay in vault, not distributed)
└── 00. Inbox/
    └── 2026-04-19-naval-skill-package.md       # Vault tracking note (points to ~/DEV/)
```

### Public / distributable (outside vault)
```
~/DEV/naval-skill/                              # Git repo root, pushed to github.com/genius8267/naval
├── README.md                                   # Install + usage + disclaimer + FAQ
├── LICENSE                                     # MIT + non-endorsement clause
├── VERSION                                     # 1.0.0
├── CHANGELOG.md
├── HANDOFF.md                                  # This file
├── .gitignore
├── install.sh                                  # Idempotent installer (backs up existing installs)
├── uninstall.sh
└── skill/
    ├── SKILL.md                                # 8-mode dispatcher (portable paths)
    └── brain/                                  # Bundled brain (scrubbed, author = "Brain of Naval")
        ├── 00-brain-of-naval.md
        ├── 01-wealth.md … 06-tech-future.md
        └── _evals/canonical.md

~/DEV/naval-skill-1.0.0.tar.gz                  # Built tarball (96 KB), git-ignored
```

### Installed (on user's machine)
```
~/.claude/skills/naval/                         # Installed skill — Claude Code reads this
├── SKILL.md                                    # Copy of ~/DEV/naval-skill/skill/SKILL.md
└── brain/                                      # Copy of ~/DEV/naval-skill/skill/brain/

~/.naval/consultations/                         # DEFAULT save location (unused because vault wins)
```

### Env vars (in `~/.zshrc`)
```bash
export NAVAL_BRAIN_PATH="/Users/joowonlee/Library/CloudStorage/GoogleDrive-jwlee8267@intunelabs.ai/My Drive/40_Obsidian/40. Reference/Naval/_brain"
export NAVAL_USER_LINK='[[Joowon Lee]]'
```

Effect: skill reads **live vault brain** (not bundled). Consultations save to vault `_consultations/` (auto-detected via sibling-folder rule). Frontmatter author = `[[Joowon Lee]]` wikilink.

---

## Chronological build log

### Phase 1 — Brain synthesis (ultrawork)

**Input**: 34 Naval transcript markdown files in `40. Reference/Naval/`, ~3.3 MB total.

**Process**: dispatched 6 parallel Opus sub-agents, each reading a thematic slice:

| Agent | Files | Output |
|---|---|---|
| Wealth (Opus) | 6 transcripts on money/leverage/angel/hiring/Kokonas | `01-wealth.md` (~3.4K words) |
| Happiness (Opus) | 7 transcripts on mind/anxiety/Kapil Gupta | `02-happiness.md` (~3.8K words) |
| Philosophy (Opus) | 9 transcripts on Deutsch/Popper/epistemology | `03-philosophy.md` (~3.1K words) |
| Judgement (Opus) | 5 transcripts on reading/decisions/clarity | `04-judgement.md` (~2.9K words) |
| Life (Opus) | 4 transcripts on meaning/harsh-truths/JRE/Megasode | `05-life.md` (~4.2K words) |
| Tech (Opus) | 3 transcripts on AI/crypto/network-state | `06-tech-future.md` (~2.4K words) |

Each extraction followed a fixed schema:
- Core Axioms (non-negotiable beliefs)
- Mental Models (named reasoning frames)
- Decision Heuristics (IF/THEN rules)
- Signature Phrases (10-25 verbatim quotes)
- Contrarian Takes
- Anti-Patterns
- Domain-specific subsections

**Synthesis pass**: one more Opus sub-agent read all 6 extractions and produced `00-brain-of-naval.md` — the master persona (~6,977 words). Structure:
- 7 prime axioms (with "Generates →" dependency chains to downstream models)
- 24 mental models (de-duplicated across domains)
- ~90 decision heuristics (grouped into 6 domain subsections)
- 9 rhetorical moves + 25 verbatim calibration phrases
- 6 condensed domain syntheses
- 40 anti-patterns (the "Naval NO list")
- 9-step meta-algorithm with a worked example
- First-person "I am Naval" system-prompt block at the end

**Output location**: initially `00. Inbox/2026-04-19-brain-of-naval/` (per vault drop-folder rule), later moved to `40. Reference/Naval/_brain/`.

### Phase 2 — Skill v1 (single-mode)

User asked for a skill like `/gstack-office-hours`. Read that skill for pattern reference.

**Design decisions** (via AskUserQuestion):
- A. Persistence: save consultations as vault files (YES)
- B. Forcing questions before answering: YES (like office-hours)
- C. Sub-agent: Opus with brain loaded

**Initial v1 SKILL.md** at `~/.claude/skills/naval/SKILL.md`:
- Hardcoded vault path for brain
- Single mode: full consultation
- 4 forcing questions from a pool of 6
- Opus sub-agent reads master brain + 1-2 domain files
- Structured 6-section output (Reframe / Verdict / Why / Heuristics / Next move / Anti-patterns)
- Saves to `40. Reference/Naval/_consultations/YYYY-MM-DD-<slug>.md`

### Phase 3 — Skill v2 (8 modes) via deep-interview self-audit

User invoked `/deep-interview "is this the best version"`.

**Self-audit identified 10 gaps**, ranked by severity. User approved 3 improvement bundles (all):

**Bundle 1 — Fix real breaks**
- Path detection: `$NAVAL_BRAIN_PATH` → vault paths → fallback error
- `--quick` mode: reads only master brain, outputs compact 3-section verdict, no save
- `--eval` harness + `_evals/canonical.md` with 8 canonical regression tests

**Bundle 2 — Learning loop**
- `--retro` mode: walk unfilled Follow-up sections, prompt via AskUserQuestion, auto-close stale (>90d) ones
- `--pushback <slug>` mode: re-consult — **Naval defends, never flips** (user's explicit decision: only new verifiable facts can move the verdict; feelings and reframes don't count)
- `_consultations/INDEX.md` — auto-regenerated from scratch on every save (idempotent)

**Bundle 3 — Voice expansion**
- `--kapil` mode: Kapil Gupta persona (clinical, surgical, environment prescriptions)
- `--debate` mode: parallel Naval + Kapil sub-agents + synthesis sub-agent
- Korean triggers added (`네이벌`, `카필`, etc.)
- `--context <path>` mode: attach MD/TXT/PDF/JSON/YAML to consultation

**Canonical evals** (`_brain/_evals/canonical.md`): 8 questions covering Naval's load-bearing positions — hustle culture, toxic coworkers, save-vs-invest, MBA, startups, anxiety, marriage, political drama. Each has:
- `expected_position` (prose)
- `must_contain` (vocabulary markers — any one = pass)
- `must_not_contain` (anti-phrases — none allowed)
- Judge pass via second Opus sub-agent scoring 1-5

SKILL.md grew to 786 lines with a dispatch table routing flags → modes, shared save routine at the bottom, and a self-check before dispatch.

### Phase 4 — Distribution package

User asked for portable distribution.

**Key changes from local-only skill**:
- Brain path priority: `$NAVAL_BRAIN_PATH` → `~/.claude/skills/naval/brain/` (bundled) → vault auto-discovery (opt-in)
- Save path priority: `$NAVAL_CONSULTATIONS` → vault sibling `_consultations/` if brain from vault → `~/.naval/consultations/`
- Frontmatter author: `$NAVAL_USER_LINK` override → `$NAVAL_USER` → `whoami` default
- Personal info scrubbed: `[[Joowon Lee]]` → `"Brain of Naval"` in 6 brain files; added matching frontmatter to 2 files that had none (01-wealth, 03-philosophy)

**Package at `~/DEV/naval-skill/`**:
- `install.sh`: copies `skill/` → `~/.claude/skills/naval/`, creates `~/.naval/consultations/`, backs up existing installs with timestamped suffix
- `uninstall.sh`: removes skill, preserves consultations with a manual-rm hint
- `README.md`: install, 8-mode usage table, env vars, architecture, FAQ, credits, disclaimer
- `LICENSE`: MIT + explicit non-endorsement clause (not affiliated with Naval or Kapil)
- `VERSION`, `CHANGELOG.md`, `.gitignore`

**Tested locally**: ran `install.sh` on MBP; verified skill registered; deleted backup folder to keep skill list clean.

**Built tarball**: `~/DEV/naval-skill-1.0.0.tar.gz` (96 KB), excludes `.DS_Store`, `*.tar.gz`, `.git`, `reports/`.

**Published to GitHub**: https://github.com/genius8267/naval
- Empty public repo pre-created by user
- `git init -b main && git add . && git commit && git push -u origin main`
- Set description + 5 topics: `claude-code`, `skill`, `naval-ravikant`, `ai-persona`, `decision-making`
- 1 commit on `main`: `feat: initial release 1.0.0`

**Personal env vars set** (in `~/.zshrc`):
```bash
export NAVAL_BRAIN_PATH="/Users/joowonlee/Library/CloudStorage/GoogleDrive-jwlee8267@intunelabs.ai/My Drive/40_Obsidian/40. Reference/Naval/_brain"
export NAVAL_USER_LINK='[[Joowon Lee]]'
```

So for the user personally: live vault brain + vault consultations + `[[Joowon Lee]]` wikilinks.
For everyone else who installs: bundled brain + `~/.naval/consultations/` + system-username author.

---

## Key design decisions (with rationale)

| Decision | Chose | Rejected | Why |
|---|---|---|---|
| Skill location | Global (`~/.claude/skills/`) | Vault-local (`.claude/skills/`) | Life decisions are universal, not project-scoped |
| Sub-agent model | Opus | Sonnet/Haiku | Naval's voice needs depth; drift risk at lower tiers |
| Clarity gate | Up to 4 forcing questions | Ambiguity scoring (deep-interview style) | Math overkill for life decisions; Naval doesn't interview |
| Pushback behavior | Defends only; flips only on new verifiable FACTS | Two-verdicts-side-by-side; always-may-update | Keeps Naval uncorruptible by feelings; user's explicit call |
| Brain loading | Master + 1-2 routed domain files | Always all 7 | Cost; explicit routing table in SKILL.md prompt |
| Save on `--quick`? | NO | YES | User asked quick; respect that |
| Kapil persona | Separate prompt, same brain | Separate brain file | Kapil content lives in 02-happiness.md already |
| Author in bundled brain | `"Brain of Naval"` (plain string) | `[[Joowon Lee]]`, empty array, `[[Naval Ravikant]]` | User picked option C: skill-branded, no broken wikilinks |
| Consultations default | `~/.naval/consultations/` (home) | Always vault | Vault-assumption wouldn't work for non-Obsidian users |
| Distribution | GitHub public + tarball | Single-file, gist | 8 files needed; repo is clean |
| License | MIT + non-endorsement | Creative Commons, Proprietary | Standard permissive; disclaimer covers the persona-ethics question |
| Initial commit | Direct push to `main` | PR workflow | Empty repo initialization; no history to protect yet |

---

## How to reproduce (if brain needs rebuilding or forking to another persona)

### 1. Gather source material
Collect 20-40 long-form transcripts of the target figure. YouTube auto-transcripts work. Save as markdown in one folder, one file per interview, any naming.

### 2. Cluster by theme
Group transcripts into 5-7 thematic buckets (e.g., for Naval: wealth, happiness, philosophy, judgement, life, tech-future). Balance content: ~3-9 files per bucket, ~1-3 MB total per bucket.

### 3. Dispatch extraction agents
Use `/ultrawork`. For each thematic bucket, dispatch one Opus sub-agent with a prompt like:
```
You are extracting the thought process of <FIGURE> from transcripts. Build a
"Brain of <FIGURE>" — a persona document that could let an LLM reason like them.

READ THESE FILES IN FULL: <list>

EXTRACT AND ORGANIZE under theme "<THEME>":
- Core Axioms
- Mental Models (named frames)
- Decision Heuristics (IF/THEN)
- Signature Phrases (10-25 verbatim)
- Contrarian Takes
- Anti-Patterns

Write to: <output path>. Aim for 2500-4500 words. Preserve voice. No generic
paraphrase. Report back under 100 words.
```

Run in parallel, backgrounded. Expect ~3-5 min per agent.

### 4. Synthesis pass
Once all extractions land, dispatch one Opus synthesis agent that reads all N extractions and produces a master persona document with:
- 5-7 prime axioms (the OS)
- 20-30 mental models (de-duped across domains)
- 60-100 IF/THEN heuristics
- Rhetorical moves + verbatim calibration phrases
- Short domain syntheses
- Anti-patterns list
- A meta-algorithm
- A first-person system-prompt block

Target 5,000-8,000 words. Dense, not bloated.

### 5. Seed canonical evals
Hand-author 6-10 regression-test Q&A pairs. For each:
- The question
- Expected position (prose)
- `must_contain` phrases (vocabulary markers)
- `must_not_contain` phrases (anti-patterns that would indicate drift)

Save at `<brain_root>/_evals/canonical.md`.

### 6. Fork the skill
Copy `~/DEV/naval-skill/` to new name. Edit:
- Skill name/description in frontmatter
- Persona references throughout SKILL.md
- Triggers
- Prompt templates (keep structure; swap persona identity)
- README.md
- LICENSE (update name, keep non-endorsement clause)

### 7. Test & iterate
- Run `./install.sh`
- Try 5-10 real questions, compare outputs to expected persona voice
- Run `<skill-name> --eval` — confirm ≤1 fail out of 6-10 evals
- If voice drifts: tighten SKILL.md prompt constraints, not the brain

---

## Current state — what's done, what isn't

### Done ✅
- Brain synthesized from 34 transcripts
- Master + 6 domain files + 8 canonical evals
- Skill with 8 modes
- Portable path resolution
- Scrubbed distribution package
- Local install tested + working
- GitHub repo published (public, MIT + disclaimer)
- Personal env vars set (vault-integrated for the user)
- Vault tracking note in `00. Inbox/`

### Not done / deferred
- **README still has `YOUR_USERNAME` placeholder** in the install git-clone line — should be `genius8267/naval`
- **No v1.0.0 GitHub release tag cut** — exists as commit only; no release page with tarball
- **Mac Studio `~/.zshrc`** not yet updated with env vars (user needs to do this manually on their other machine)
- **No `naval --eval` baseline run yet** — the harness exists but hasn't been exercised end-to-end
- **No `naval` consultation yet** — the skill is installed but has never been invoked live
- **No `docs/HOW-THE-BRAIN-WAS-BUILT.md`** — would help anyone who wants to fork the persona (e.g., Brain of Munger)
- **No `naval --regenerate-brain <transcripts>` mode** — could let users rebuild from their own sources without leaving Claude Code
- **Repo is pinned? profile updated?** — not verified

### Open design questions for v1.1
- Does INDEX.md actually update correctly on vault save (different OS path semantics)?
- Does `--retro` scan correctly with vault-synced files (Google Drive Stream may cause phantom files)?
- Does `--context` with a PDF actually work end-to-end via the skill's sub-agent? (The prompt handles it in theory; not tested.)
- Should `--debate` synthesis be Opus or can it drop to Sonnet to cut cost?
- Should `--eval` report a longitudinal drift trend (compare to last N runs)?

---

## If you're continuing this work

### To smoke-test
```bash
# Confirm env vars load
source ~/.zshrc && env | grep NAVAL
# Should print NAVAL_BRAIN_PATH and NAVAL_USER_LINK

# In Claude Code in any project:
ask naval what's one decision I'm avoiding that I shouldn't be?
# — runs Mode A (full) with your vault brain
```

### To run the eval harness
In Claude Code:
```
naval --eval
```
Expected: 8 questions dispatched in parallel, scored on vocabulary + anti-phrase + judge. Report saved to `40. Reference/Naval/_brain/_evals/reports/YYYY-MM-DD-eval.md`.

### To refine the brain
Edit files directly in Obsidian at `40. Reference/Naval/_brain/`. Changes take effect on the next `naval` invocation (no reinstall — `$NAVAL_BRAIN_PATH` reads live). Run `naval --eval` after edits to check drift.

### To ship an update to the public repo
```bash
cd ~/DEV/naval-skill
# Copy latest vault brain back into the bundle (if you want bundled to track your edits):
cp "/Users/joowonlee/Library/CloudStorage/GoogleDrive-jwlee8267@intunelabs.ai/My Drive/40_Obsidian/40. Reference/Naval/_brain/"*.md skill/brain/
cp "/Users/joowonlee/Library/CloudStorage/GoogleDrive-jwlee8267@intunelabs.ai/My Drive/40_Obsidian/40. Reference/Naval/_brain/_evals/canonical.md" skill/brain/_evals/
# Re-scrub any re-introduced [[Joowon Lee]] — grep for it, replace with "Brain of Naval"
grep -rn "Joowon Lee" skill/brain/
# Bump VERSION, update CHANGELOG.md
# Commit + push + tag a release
git add . && git commit -m "feat: brain v1.1 — <what changed>"
git tag v1.1.0 && git push --tags
gh release create v1.1.0 --generate-notes
```

### If the user asks for a new mode
Add a new Mode X section to `~/DEV/naval-skill/skill/SKILL.md` following the pattern of existing modes (A-H). Update:
- The mode dispatch table at top
- The mode description in frontmatter
- The triggers list if needed
- The usage-examples table at the bottom

Don't touch the brain files unless the new mode actually changes the persona's outputs.

---

## References

- Source transcripts (not distributed): `40. Reference/Naval/` × 34 files
- Upstream CMDS vault conventions (frontmatter, drop folder, video-project-workflow): user's `CLAUDE.md` + `.claude/rules/`
- Skill pattern reference: `/gstack-office-hours` (YC office hours — dual-mode startup/builder brainstorming skill)
- Deep-interview pattern: `/deep-interview` (ouroboros Socratic gating)
- Karpathy LLM Wiki concept: informed the idea that persistent persona artifacts can compound across sessions

---

## Disclaimer (applies to persona content only)

The "Brain of Naval" and the "Kapil Gupta" secondary persona are AI-synthesized distillations of public long-form interviews. They are **unofficial**, not affiliated with or endorsed by Naval Ravikant, Kapil Gupta, or any of the interviewers. Intended for personal reference only. Outputs reflect a reconstructed persona model, not the actual views of the source individuals on any specific question.
