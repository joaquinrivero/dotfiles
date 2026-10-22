---
description: Review a GitHub PR for real blockers, validate with evidence, post inline after approval
argument-hint: "<pr-number> <owner/repo>"
---
Review PR #$1 in $2 as me. Read these skills first and follow them: ponytail-review, gh-pr-suggest, git-accounts. Where they conflict with this prompt, this prompt wins.

## 1. Context, and what is already said
- `gh pr view $1 -R $2 --json title,body,author,headRefOid,baseRefName,files,reviews,comments`
- Inline comments: `gh api repos/$2/pulls/$1/comments --paginate`
- Read every existing comment and review first. Do not repeat a point already made, do not re-raise a resolved thread. If someone already flagged a blocker, you may add evidence to it. Do not duplicate it.

## 2. Find blockers
- `gh pr diff $1 -R $2`, skip `dist/` paths. Read the callers and surrounding code, not only the diff.
- A blocker is: wrong behavior, a regression for existing callers, a security hole, data loss, or risky logic with no test. Drop everything else: style, naming, preferences, nits.

## 3. Validate each blocker with evidence
- Prefer the cheapest proof: read the callers, run the existing test, run a small script.
- If the blocker is visible in a browser, reproduce it with the agent-browser skill and AEM Sidekick (`aem-browser.sh`, profile `~/.agent-browser/profiles/aem`). Use the PR branch preview `https://<branch>--<repo>--<owner>.aem.page`. For MAS + Milo changes, use the mas-milo-verify skill.
- On a "This site is protected" dialog (Sidekick), run `agent-browser snapshot -i`, click the "Sign in" button, wait about 6 seconds, and reload the page. The saved profile signs in without help. Do not tick "Don't show this dialog again".
- If it still shows "Account not authorized for this site" or a 401: stop validating, tell me which site, and mark the finding unverified. Do not guess.
- Each blocker ends as one of: reproduced (note the steps or a screenshot path), or unverified (write it as a question, never as a claim).
- Drop any finding you cannot support.

## 4. Draft in the terminal. Do not post yet.
Show me, per blocker: `file:line`, the comment text, and the evidence. Then ask whether to post.

Comment style:
- Simple English, written like a person. One or two short lines: cause, then consequence. Example: "`x` is undefined here, so this throws and the price never gets inserted."
- Add a ```suggestion block only when the fix is concrete. If unsure, ask a short question.
- No praise, no filler, no "consider" or "I think". Critique the code, not the author.
- Every blocker with a line gets an inline comment. The review summary only holds the verdict and points with no line. Never restate or announce the inline comments in it.
- No blockers: say so in one line and stop.

## 5. Post only after I say so
Post inline comments with the gh-pr-suggest method, using the gh account that has access (git-accounts). Never approve, request changes, merge, push, or edit files.
