---
phase: 4
priority: low
status: pending
effort: 10min
---

# Phase 4: Cleanup & Build Verify

## Overview
Remove unused files, rebuild public/, verify site builds and renders correctly.

## Related Files
- `content/blog/Untitled.md` (delete)
- `public/` (rebuild)

## Implementation Steps

### 1. Delete unused files
- Remove `content/blog/Untitled.md` (empty draft)

### 2. Rebuild site
```bash
cd /Volumes/Dev/Projects/maitanloi.github.io
hugo --minify
```

### 3. Test locally
```bash
hugo server -D
```
Verify:
- Homepage shows profile mode
- About page renders correctly
- Blog listing works
- Writeups category page works
- Tags page works
- Existing posts render

### 4. Clean stale public/ directories (optional)
Many stale directories in public/ from previous config changes. Consider:
```bash
rm -rf public/
hugo --minify
```
This regenerates everything clean. Safe because public/ is rebuilt by CI anyway.

## Todo
- [ ] Delete Untitled.md
- [ ] Rebuild public/
- [ ] Test homepage, about, blog, tags
- [ ] Verify no broken links

## Success Criteria
- `hugo --minify` builds without errors
- All pages render correctly
- No stale/orphaned content in public/
