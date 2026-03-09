# Code & Content Standards

## Overview

Standards for creating and maintaining content, configuration, and code in the maitanloi.github.io project. All contributors follow these conventions.

## Content Conventions

### Blog Post Front Matter

All blog posts use **YAML front matter** (not TOML). Standard fields:

```yaml
---
title: "HackTheBox - Machine Name"
date: 2026-03-09
tags: ["htb", "linux", "writeups"]
categories: ["writeups"]
draft: false
---
```

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `title` | String | Yes | Full post title, sentence case |
| `date` | YYYY-MM-DD | Yes | Publication date in ISO format |
| `tags` | Array | Yes | Lowercase, kebab-case, comma-separated |
| `categories` | Array | Yes | Use: writeups (singular or plural) |
| `draft` | Boolean | No | Default: true. Set false to publish |

### File Naming

- **Filename format**: `kebab-case.md` (lowercase, hyphens, no spaces)
- **Examples**:
  - ✅ `htb-machine-name.md`
  - ✅ `htb-active-directory-setup.md`
  - ✅ `linux-privilege-escalation-techniques.md`
  - ❌ `HTB_MachineName.md` (wrong case, underscore)
  - ❌ `HackTheBox Machine.md` (spaces, wrong case)

### Content Structure

Standard writeup structure:

```markdown
---
title: "HackTheBox - Machine Name"
date: 2026-03-DD
tags: ["htb", "linux", "writeups"]
categories: ["writeups"]
draft: false
---

## Reconnaissance

Initial reconnaissance section describing nmap scans, enumeration...

```bash
nmap -sC -sV target-ip
```

## Service Enumeration

Details about discovered services...

## Exploitation

Steps taken to compromise the system...

## Post-Exploitation / Privilege Escalation

Steps to escalate privileges...

## Lessons Learned

Key takeaways from the box...
```

### Tag Standards

**Recommended tags** (lowercase, dash-separated):

| Tag | Usage |
|-----|-------|
| `htb` | HackTheBox machines |
| `linux` | Linux-based machines |
| `windows` | Windows-based machines |
| `active-directory` | AD/Kerberos exploits |
| `privilege-escalation` | Privesc techniques |
| `web-exploitation` | Web vulnerabilities |
| `cryptography` | Crypto challenges |
| `reverse-engineering` | RE/binary analysis |
| `writeups` | Content type (always use) |

Add custom tags as needed. Keep tags lowercase and use hyphens for multi-word tags.

### Category Standards

**Categories** (should match directory structure):

| Category | Purpose |
|----------|---------|
| `writeups` | HTB machine/challenge writeups (primary) |

Future categories: `guides`, `tutorials`, `tools` (as content grows).

### Code Blocks

Format code blocks with language specifiers:

```markdown
\`\`\`bash
# Bash command
nmap -sC -sV 10.10.10.x
\`\`\`

\`\`\`python
# Python exploit
def exploit():
    pass
\`\`\`

\`\`\`sql
-- SQL query
SELECT * FROM users;
\`\`\`
```

Supported languages: bash, python, javascript, go, rust, sql, c, java, etc.

## Configuration Standards

### hugo.yaml Structure

```yaml
# 1. Basic site config
baseURL: "https://maitanloi.github.io/"
languageCode: vi
title: Mai Tấn Lợi
theme: PaperMod

# 2. URL structure
permalinks:
  blog: "/:slug/"

# 3. Theme params
params:
  defaultTheme: dark
  # Reading UI
  ShowReadingTime: true
  ShowShareButtons: false
  ShowPostNavLinks: true
  ShowBreadCrumbs: true
  ShowCodeCopyButtons: true
  # Table of contents
  ShowToc: true
  TocOpen: true

# 4. Navigation menu
menu:
  main:
    - name: Blog
      url: /categories/writeups/
      weight: 1
    - name: Tags
      url: /tags/
      weight: 2
    - name: About
      url: /about/
      weight: 3
```

**Guidelines**:
- Maintain YAML indentation (2 spaces, not tabs)
- Keep boolean params in camelCase (PaperMod convention)
- Menu weight determines nav order (lower = first)
- Do not add unnecessary params; only customize what's shown

## Hugo Conventions

### Command Line Usage

```bash
# Local development (includes drafts)
hugo server -D

# Production build (minified)
hugo --minify

# Create new post
hugo new blog/slug-name.md
```

**Note**: Archetype at `archetypes/default.md` auto-fills YAML frontmatter.

### Directory Structure

```
content/blog/       # All blog posts
public/             # Generated output (committed to Pages)
themes/PaperMod/    # Theme (git submodule, read-only)
layouts/            # Custom overrides (not used yet)
static/             # Raw assets (robots.txt, favicon)
assets/             # SCSS/CSS (not used yet)
```

## Git Conventions

### Commit Messages

Use conventional commit format:

```
type(scope): description

Optional body with details.
```

**Types**:
- `feat:` New feature or blog post
- `fix:` Bug fix
- `docs:` Documentation updates
- `style:` Formatting (no logic change)
- `refactor:` Code reorganization
- `chore:` Build, config, or dependencies

**Examples**:
- ✅ `feat(blog): add htb-active-writeup`
- ✅ `docs(readme): update setup instructions`
- ✅ `fix(config): correct baseURL for github pages`
- ❌ `update stuff` (too vague)
- ❌ `AI generated content` (no AI references)

### Branches

| Branch | Purpose | Deployment |
|--------|---------|-----------|
| `main` | Active development | Auto-deploys on push |
| `master` | Legacy default | Not used for deploy |

Push to `main` to trigger GitHub Actions build and deployment.

## Writing Style

### Technical Writing Standards

- **Language**: Vietnamese (default) or English (when applicable)
- **Audience**: Cybersecurity professionals and HTB enthusiasts
- **Tone**: Technical, clear, educational
- **Structure**: Logical flow from reconnaissance → exploitation → lessons learned
- **References**: Include resources, CVEs, GitHub links where relevant

### Markdown Style

- **Headings**: Use `##` for major sections (H2), `###` for subsections (H3)
- **Code**: Inline code with backticks, code blocks with language specifiers
- **Lists**: Use bullet points (`-`) or numbered lists (`1.`) as appropriate
- **Emphasis**: Use `**bold**` for emphasis, `*italic*` for citations
- **Links**: Use descriptive link text: `[resource](url)` not bare URLs

## Version Control Standards

### What Gets Committed

✅ **Do commit**:
- Blog posts (Markdown in `content/blog/`)
- Configuration changes (`hugo.yaml`)
- GitHub Actions workflows
- Documentation
- Theme submodule references

❌ **Do NOT commit**:
- `public/` directory (except it is committed in this project for GitHub Pages)
- `.DS_Store` or system files
- IDE settings
- API keys or secrets
- Dependencies (if using package managers)

### Workflow

1. Create feature branch (optional): `git checkout -b feat/post-name`
2. Create/modify content
3. Test locally: `hugo server -D`
4. Commit with clear message
5. Push to `main` (or submit PR if on feature branch)
6. GitHub Actions auto-deploys on push to `main`

## Quality Checklist

Before publishing a blog post:

- [ ] Front matter is complete (title, date, tags, categories)
- [ ] Filename is kebab-case
- [ ] `draft: false` is set
- [ ] All code blocks have language specifiers
- [ ] Links are tested and working
- [ ] Headings follow H2/H3 hierarchy
- [ ] No typos or grammar errors
- [ ] Images/resources are properly referenced
- [ ] Post built successfully: `hugo --minify`
- [ ] Local preview looks good: `hugo server -D`

## Extensibility

### Adding Custom Features

When extending the blog:

1. **Custom layouts**: Create in `layouts/` (overrides PaperMod)
2. **Styling**: Add SCSS to `assets/css/` (compiled by Hugo)
3. **Shortcodes**: Create in `layouts/shortcodes/` for reusable elements
4. **Data**: Add YAML/JSON to `data/` for structured content
5. **Static files**: Place in `static/` (favicon, robots.txt, etc.)

### Theme Updates

PaperMod is integrated as a git submodule. To update:

```bash
cd themes/PaperMod
git pull origin master
cd ../..
git add themes/PaperMod
git commit -m "chore(theme): update PaperMod to latest"
```

## Maintenance

### Regular Reviews

| Frequency | Task |
|-----------|------|
| **Per post** | Verify all links, test commands |
| **Monthly** | Check for broken links, outdated info |
| **Quarterly** | Review and update standards, archetype |
| **Annually** | Major content audit, theme review |

### Deprecation

When retiring or significantly updating old posts:

1. Add deprecation notice at the top:
   ```markdown
   > **Deprecated**: This post is outdated. See [newer post](url) instead.
   ```
2. Update tags/categories to reflect status
3. Keep post published for historical reference
4. Add timestamp of when it was deprecated
