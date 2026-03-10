---
phase: 3
priority: medium
status: pending
effort: 10min
---

# Phase 3: Content Structure & Archetype

## Overview
Update archetype template with category/tag guidance. Recategorize existing posts.

## Related Files
- `archetypes/default.md` (modify)
- `content/blog/ung-dung-python-cho-cong-viec.md` (modify — recategorize)

## Implementation Steps

### 1. Update archetype template
```yaml
---
title: "{{ replace .File.ContentBaseName "-" " " | title }}"
date: {{ .Date }}
draft: true
tags: []
categories: []
# Categories: writeups | guides | tools | case-studies | career
# Tags (examples):
#   Vuln: sql-injection, xss, ssrf, xxe, csrf, idor, rce
#   Platform: portswigger, htb, tryhackme
#   Tech: nextjs, supabase, burp-suite, kali-linux
#   Level: beginner, intermediate, advanced
---
```

### 2. Recategorize existing posts
- `htb-machine-name.md`: categories: ["writeups"] ✓ (already correct)
- `ung-dung-python-cho-cong-viec.md`: change categories from ["blog"] → ["guides"]

## Todo
- [ ] Update archetype with category/tag comments
- [ ] Recategorize python post to "guides"

## Success Criteria
- New posts created with `hugo new` show category/tag guidance
- Existing posts have correct categories
