# Brain of Naval — a Claude Code skill

An unofficial, AI-synthesized persona of **Naval Ravikant** (optionally **Kapil Gupta**) that you can consult before making a decision.

Built as a [Claude Code skill](https://docs.claude.com/claude-code/skills). Works anywhere Claude Code runs: any project, any repo, any directory.

> ⚠️ **Unofficial.** Not affiliated with, authorized by, or endorsed by Naval Ravikant or Kapil Gupta. This is an AI synthesis of their public interviews. Use for personal reference only.

---

## What this is

```
You: naval should I quit my job to start a company?

Naval (via Opus sub-agent):
## Reframe
Question stands.

## Verdict
If you have to ask, don't. The people who should start companies are already
doing it in their evenings. Join a small team with specific knowledge first,
compound for 3-5 years, then decide.

## Why — axioms and models
- Specific Knowledge: you build it at the smaller startup, not from scratch.
- If You Can't Not Do It test: your hesitation is the answer.
- Long-term games with long-term people: a first company built from fear fails by year 2.

## Heuristics triggered
- IF you're asking permission THEN you're not ready. (Wealth)
- IF you lack specific knowledge THEN build it before founding. (Wealth)
- IF the decision is reversible THEN decide quickly; this one is. (Judgement)

## Next move
This Monday: list 5 small companies whose product you'd use daily. Apply to three
by Friday.

Play long-term games with long-term people.

Saved to ~/.naval/consultations/2026-04-19-should-i-quit-my-job.md
```

The skill reads a pre-built "brain" — axioms, mental models, decision heuristics, signature phrasings — distilled from 34 long-form Naval interviews, then dispatches an Opus sub-agent to answer in his voice.

## Install

```bash
git clone https://github.com/YOUR_USERNAME/naval-skill.git
cd naval-skill
./install.sh
```

Or from a tarball:

```bash
tar -xzf naval-skill-1.0.0.tar.gz
cd naval-skill-1.0.0
./install.sh
```

The installer:
- Copies `skill/` → `~/.claude/skills/naval/` (brain bundled inside)
- Creates `~/.naval/consultations/` for your decision history
- Safe to re-run — backs up existing installs

**Requirements:** [Claude Code](https://docs.claude.com/claude-code) installed. That's it.

## Usage

### Modes

| Command | Purpose |
|---|---|
| `naval <question>` | Full consultation — 4-question clarity gate → structured verdict → saved |
| `naval --quick <q>` | Compact verdict, no save, fast |
| `naval --kapil <q>` | Ask Kapil Gupta instead (spiritual, surgical) |
| `naval --debate <q>` | Naval + Kapil in parallel, then synthesis |
| `naval --pushback <slug>` | Contest a prior verdict (Naval defends, never flips) |
| `naval --retro` | Fill in follow-ups on past consultations |
| `naval --eval` | Regression-test voice against 8 canonical Q&A pairs |
| `naval --context <path> <q>` | Attach a file (MD/TXT/PDF/JSON/YAML) |

### Triggers

Any of these fire the skill in Claude Code:

- `ask naval ...`, `consult naval ...`, `what would naval say ...`, `naval check`, `naval take`
- `naval --debate`, `ask kapil`, `naval vs kapil`
- Korean: `네이벌`, `네이벌한테 물어`, `카필`, `카필한테 물어`

Or just `/naval` + your question.

### When to use

Use when:
- Making a career / life / business / investment decision
- Feeling stuck or rationalizing
- About to commit to something irreversible
- Suspecting a status game
- You want a sanity check before a hard call

**Do not** use for:
- Pure technical questions (code, API, infra, medical, legal)
- Venting — listen, don't consult
- Post-hoc validation — if you've decided, stop asking

## Configuration

Optional environment variables (set in `~/.zshrc` or `~/.bashrc`):

```bash
# Point to a custom brain location (e.g., your own curated version)
export NAVAL_BRAIN_PATH="/path/to/brain"

# Custom save location for consultations
export NAVAL_CONSULTATIONS="$HOME/Documents/naval-logs"

# Your name/wikilink in saved consultation frontmatter (for Obsidian users)
export NAVAL_USER_LINK='[[Your Name]]'
```

If none are set, defaults are:
- Brain: bundled at `~/.claude/skills/naval/brain/`
- Consultations: `~/.naval/consultations/`
- Author: system username

## How the brain was built

34 public long-form Naval interviews (and his conversations with Kapil Gupta, David Deutsch, Tim Ferriss, Eric Jorgenson, Joe Rogan, and others) were processed by 6 parallel Opus agents, each extracting one thematic slice:

1. **Wealth** — leverage, specific knowledge, angel investing, hiring
2. **Happiness** — desire, peace, 5 chimps, Kapil's prescriptions
3. **Philosophy** — Popper/Deutsch epistemology, hard-to-vary explanations
4. **Judgement** — reading, decisions, compound knowledge, clarity
5. **Life** — relationships, harsh truths, meaning, death
6. **Technology** — AI, crypto, permissionless innovation

A synthesis pass produced `00-brain-of-naval.md` — the master persona document (~7,000 words) containing: 7 prime axioms, 24 mental models, ~90 decision heuristics, 9 rhetorical moves, 25 verbatim signature phrases, 40 anti-patterns, a 9-step meta-algorithm, and a system-prompt block.

The sub-agent reads the master + 1-2 relevant domain files per consultation.

## Verify voice purity

The skill includes a regression-test harness. Run after any brain edit:

```
naval --eval
```

This runs 8 canonical questions (hustle culture, toxic coworkers, MBA, startups, anxiety, marriage, politics, etc.) through the skill. Each answer is checked against:

- **Must contain** — Naval-vocabulary markers (e.g., `leverage`, `specific knowledge`, `long-term games`)
- **Must NOT contain** — generic self-help phrases (e.g., `grind it out`, `trust your gut`, `stay informed`)
- **Judge score** — a second Opus agent rates position-match 1-5

Drift score of 0-1 fails = healthy. 2 fails = degraded. 3+ = regressed.

## Customize the brain

You can edit the brain files in `~/.claude/skills/naval/brain/` directly. After edits, run `naval --eval` to check for drift.

To fork the brain and build your own persona (e.g., "Brain of Charlie Munger"):

1. Copy this repo
2. Replace transcripts with your subject's public interviews
3. Re-run the 6-agent extraction + synthesis (see `/docs/HOW-THE-BRAIN-WAS-BUILT.md` — TODO)
4. Rename the skill in `SKILL.md` frontmatter
5. `./install.sh`

## Architecture

```
~/.claude/skills/naval/          # Installed skill (global, invokable anywhere)
├── SKILL.md                     # Dispatcher: 8 modes, path resolution, prompts
└── brain/
    ├── 00-brain-of-naval.md     # Master persona (~7K words)
    ├── 01-wealth.md             # Domain extractions
    ├── 02-happiness.md
    ├── 03-philosophy.md
    ├── 04-judgement.md
    ├── 05-life.md
    ├── 06-tech-future.md
    └── _evals/
        ├── canonical.md         # 8 regression-test Q&A pairs
        └── reports/             # Eval run outputs (YYYY-MM-DD-eval.md)

~/.naval/consultations/          # Your saved decisions (git-ignorable)
├── INDEX.md                     # Auto-maintained index
├── 2026-04-19-<slug>.md         # Each consultation, with Follow-up section
└── ...
```

## FAQ

**Q: Does this replicate Naval exactly?**
No. It's an AI persona that *reasons* like Naval — same axioms, vocabulary, heuristics, voice — but it can still produce outputs Naval would disagree with. The `--eval` harness is there to detect drift; it's not a guarantee of fidelity.

**Q: Why Kapil Gupta?**
Kapil is Naval's closest interlocutor on the inner-life side. Where Naval gives pragmatic leverage-math, Kapil makes surgical spiritual observations. For personal decisions, the dual lens is often more useful than either alone.

**Q: Can I use this in production?**
You can run it in any Claude Code context. But the outputs are AI-generated opinions about personal decisions. Don't outsource real decisions to it. Use as a *lens*, not a *verdict*.

**Q: Is the brain static?**
Yes — v1.0.0 is a frozen snapshot as of April 2026. Future versions will retrain on new interviews. You can also override with `$NAVAL_BRAIN_PATH` to point at your own curated version.

**Q: Does it work offline?**
The skill runs locally, but Claude Code requires a Claude API connection for the sub-agent. No internet = no consultation.

**Q: Privacy?**
Consultations save to `~/.naval/consultations/` on your machine. Nothing is uploaded unless you do it yourself.

## License

MIT — see [LICENSE](./LICENSE).

The brain content (synthesis of public interviews) is provided under the same license with the explicit caveat that it is unofficial and not endorsed by Naval Ravikant or Kapil Gupta.

## Credits

- **Naval Ravikant** — the source of the thought process being synthesized. All original ideas are his. Find his actual work at [nav.al](https://nav.al/) and via *The Almanack of Naval Ravikant* by Eric Jorgenson.
- **Kapil Gupta** — [kapilgupta.com](https://kapilgupta.com/). Author of *Atmamun*.
- **David Deutsch, Tim Ferriss, Joe Rogan, Eric Jorgenson, Arjun Khemani, Cory Levy, Brett Hall** — interviewers whose long-form conversations with Naval were sources.
- **Claude (Anthropic)** — ran the 6-agent parallel extraction and synthesis.

## Contributing

This is a personal tool, not a maintained library. Fork freely. PRs that fix bugs or improve the install UX are welcome. PRs that change Naval's "positions" in the brain will be rejected — the brain is a snapshot of public interviews, not a debate club.

---

Play long-term games with long-term people.
