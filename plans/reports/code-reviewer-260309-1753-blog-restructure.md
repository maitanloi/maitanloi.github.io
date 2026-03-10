# Code Review: Blog Restructure for Web Security Specialist Branding

## Scope
- Files: `hugo.yaml`, `content/about.md`, `archetypes/default.md`, `content/blog/ung-dung-python-cho-cong-viec.md`, `content/blog/Untitled.md` (deleted)
- LOC: ~160 changed
- Focus: Hugo config correctness, PaperMod compatibility, SEO, content quality
- Build: passes cleanly (`hugo --minify`, 68ms, no warnings)

## Overall Assessment

Solid restructuring. The branding pivot from generic blog to Web Security Specialist is well-executed. Config changes are syntactically correct and the build passes. However, there is one **critical** PaperMod config key mismatch that will cause social icons to silently not render.

---

## Critical Issues

### 1. `socialLinks` should be `socialIcons` (PaperMod key mismatch)

**File:** `hugo.yaml` line 36-39

PaperMod's `social_icons.html` partial iterates over `site.Params.socialIcons`, not `site.Params.socialLinks`. The current config uses `socialLinks`, which means the X/Twitter icon on the profile page will **not render at all** -- silently ignored, no build error.

**Current:**
```yaml
socialLinks:
  - name: X (Twitter)
    url: https://x.com/maitanloi
    icon: '<svg ...>'
```

**Fix:**
```yaml
socialIcons:
  - name: X (Twitter)
    url: https://x.com/maitanloi
```

Additionally, PaperMod has built-in SVG icons for "x" (Twitter/X). You can drop the custom `icon` field entirely and just use `name: x` -- PaperMod will auto-resolve the SVG from its `svg.html` partial. This is cleaner and ensures consistent styling:

```yaml
socialIcons:
  - name: x
    url: https://x.com/maitanloi
```

**Severity:** Critical -- feature is completely broken with no visible error.

---

## High Priority

### 2. `author` param structure: `bio` is not used by PaperMod

**File:** `hugo.yaml` line 32-34

PaperMod's `author.html` expects `site.Params.author` to be either a string or a list of strings. The nested object with `name` + `bio` will cause the author display to render as a map literal (e.g., `map[bio:... name:...]`) instead of just the name.

**Fix -- choose one:**

Option A (simple string, recommended):
```yaml
author: "Mai Tấn Lợi"
```

Option B (keep bio as site description or subtitle, which is where PaperMod actually uses it):
```yaml
author: "Mai Tấn Lợi"
# Bio is already captured in profileMode.subtitle and params.description
```

The `bio` field has no consumer in PaperMod templates. The tagline "Pha de hieu, viet de nho" is already in `profileMode.subtitle` where it renders correctly.

### 3. Permalink token: `contentbasename` should be `contentBaseName`

**File:** `hugo.yaml` line 7

Hugo permalink tokens are **case-sensitive**. The correct token is `:contentBaseName` (camelCase), not `:contentbasename`. While Hugo 0.157.0 appears to accept it without error, this could break in future versions or behave unexpectedly.

**Current:** `blog: "/:contentbasename/"`
**Fix:** `blog: "/:contentBaseName/"`

Note: The build passes and URLs look correct currently, so this may be handled case-insensitively in 0.157.0. Still worth fixing for correctness.

### 4. `profileMode` sets `imageHeight`/`imageWidth` but no `imageUrl`

**File:** `hugo.yaml` lines 24-25

Setting `imageHeight: 120` and `imageWidth: 120` without `imageUrl` is harmless (the template guards with `{{- if .imageUrl -}}`), but it is dead config. Either add a profile image or remove the height/width lines to reduce noise.

---

## Medium Priority

### 5. About page missing `url` in front matter

**File:** `content/about.md`

The about page relies on Hugo's default path resolution (`/about/`). This works because the file is `content/about.md`, but adding `url: /about/` explicitly would make it resilient to file moves. Low risk, optional.

### 6. SEO: Missing `description` in post front matter

Both `htb-machine-name.md` and `ung-dung-python-cho-cong-viec.md` lack a `description` field in front matter. PaperMod uses this for meta tags and social card previews. Without it, Hugo falls back to auto-summary (first 70 words), which may not be optimal for SEO.

**Recommendation:** Add to archetype template:
```yaml
description: ""
```

### 7. `htb-machine-name.md` is a placeholder with `draft: false`

**File:** `content/blog/htb-machine-name.md`

This file has `draft: false` but contains only a stub ("Bat dau voi nmap scan..."). It will be published to production. Either set `draft: true` or flesh it out.

### 8. Content fit: Python automation guide vs. Web Security brand

**File:** `content/blog/ung-dung-python-cho-cong-viec.md`

The Python guide is categorized as `guides` and tagged `python, automation, productivity`. While Python is relevant to security, this post is a general-purpose automation guide (Excel, email, web scraping). It does not connect to the web security brand. Consider:
- Adding a security angle (e.g., "Python for security automation")
- Or keeping it as-is, acknowledging it is a legacy post from the developer era

---

## Low Priority

### 9. Archetype comments are inside front matter block

**File:** `archetypes/default.md`

The `#` comments between `categories: []` and `---` are inside the YAML front matter block. Hugo/YAML treats them as comments (fine), but some Markdown linters flag this. Functionally correct.

### 10. Menu item "Write-ups" links to `/categories/writeups/`

This works but depends on having posts with `categories: ["writeups"]`. Currently only `htb-machine-name.md` has this. The menu item will show an empty or near-empty page. Not a bug, just worth knowing.

---

## Positive Observations

- Clean YAML syntax throughout, no indentation issues
- `profileMode` setup is well-structured with clear CTA buttons
- Archetype tag/category guidance comments are a good DX improvement
- Deletion of `Untitled.md` is good housekeeping
- `ShowCodeCopyButtons: true` and `ShowToc: true` are good defaults for technical content
- The `:filename:` to `:contentBaseName:` permalink fix addresses a real Hugo deprecation

## Recommended Actions (Priority Order)

1. **[CRITICAL]** Rename `socialLinks` to `socialIcons` in `hugo.yaml` and use PaperMod's built-in `x` icon name
2. **[HIGH]** Simplify `author` param from nested object to plain string
3. **[HIGH]** Fix permalink token casing to `:contentBaseName`
4. **[HIGH]** Remove orphan `imageHeight`/`imageWidth` or add a profile image
5. **[MEDIUM]** Set `htb-machine-name.md` to `draft: true`
6. **[MEDIUM]** Add `description` field to archetype and existing posts
7. **[LOW]** Consider adding `url: /about/` to about page front matter

## Metrics
- Type Coverage: N/A (Hugo/Markdown project)
- Test Coverage: N/A (static site)
- Linting Issues: 1 critical (socialLinks key), 2 high (author structure, permalink casing)
- Build Status: PASS

## Unresolved Questions

1. Is there a profile image planned? If so, `imageUrl` should be added to `profileMode`.
2. Should the site add `params.social.facebook_admin` or `params.social.twitter` for OpenGraph/Twitter card metadata? PaperMod supports these in `opengraph.html` and `twitter_cards.html`.
3. The `Untitled.md` deletion was mentioned but the file already does not exist on disk -- was it deleted in a prior commit or never committed?
