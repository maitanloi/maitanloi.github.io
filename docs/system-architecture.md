# System Architecture

## Overview

maitanloi.github.io is a statically-generated blog built with Hugo and deployed to GitHub Pages. The architecture consists of content source → build process → static output → GitHub Pages hosting.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                      Development Flow                        │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  Markdown Files         Hugo Build            Output         │
│  ────────────────────────────────────────────────────────   │
│                                                               │
│  content/blog/          ┌───────────────┐      public/       │
│  ├── post1.md   ──────>│  Hugo + SCSS  │───>  ├── post1/    │
│  ├── post2.md   ──────>│  + PaperMod   │      ├── post2/    │
│  └── ...        ──────>└───────────────┘      ├── index.html│
│                                               └── ...        │
│  archetypes/                                                 │
│  └── default.md (template)                                   │
│                                                               │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│                   GitHub Actions (CI/CD)                     │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  Trigger: push to main branch                                │
│    ↓                                                          │
│  1. Checkout code with git submodules                        │
│  2. Install Hugo 0.157.0 extended                            │
│  3. Install Dart Sass                                        │
│  4. Build: hugo --minify (production)                        │
│  5. Upload public/ artifact                                  │
│  6. Deploy to GitHub Pages                                   │
│                                                               │
└─────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────┐
│              GitHub Pages Hosting (CDN)                      │
├─────────────────────────────────────────────────────────────┤
│                                                               │
│  Static Site: https://maitanloi.github.io/                   │
│  └─ Generated from public/ directory                         │
│                                                               │
└─────────────────────────────────────────────────────────────┘
```

## Component Architecture

### 1. Content Layer

**Location**: `content/blog/`
**Format**: Markdown + YAML front matter
**Language**: Vietnamese

```
content/
└── blog/
    ├── htb-active.md           # Sample writeup
    ├── htb-secondorder.md      # Future posts
    └── ...
```

**Front matter structure**:
```yaml
---
title: "Machine Name"
date: 2026-03-09
tags: ["htb", "linux"]
categories: ["writeups"]
draft: false
---
```

Each file represents one blog post with:
- Title and publication date
- Taxonomies (tags and categories)
- Markdown body with code blocks, headings, links

### 2. Theme Layer

**Location**: `themes/PaperMod/` (git submodule)
**Purpose**: Rendering, styling, responsive design
**Configuration**: `hugo.yaml` params section

**Key features**:
- Dark theme by default
- Responsive mobile design
- Syntax highlighting for code blocks
- Table of contents generation
- Breadcrumb navigation
- Reading time estimation
- Code copy buttons
- Post navigation (prev/next)

**PaperMod structure** (read-only):
```
themes/PaperMod/
├── layouts/              # HTML templates
├── assets/css/           # SCSS stylesheets
├── static/               # Default assets
└── config.yaml           # Theme defaults
```

### 3. Generator Layer

**Hugo 0.157.0 Extended**

**Process**:
1. Parse YAML front matter from Markdown files
2. Render Markdown to HTML
3. Apply PaperMod theme templates
4. Generate static pages with permalink structure
5. Create taxonomy pages (tags, categories)
6. Generate sitemap and feeds
7. Minify CSS/HTML/JS
8. Output to `public/` directory

**URL transformation** (via `permalinks.blog: "/:slug/"`):
- `content/blog/htb-active.md` → `https://maitanloi.github.io/htb-active/`
- `content/blog/privilege-escalation-guide.md` → `https://maitanloi.github.io/privilege-escalation-guide/`

### 4. CI/CD Layer

**Platform**: GitHub Actions
**Trigger**: Push to `main` branch (or manual dispatch)

**Workflow (`.github/workflows/hugo.yaml`)**:

```
trigger: push to main
    ↓
├─ Install Hugo CLI (0.157.0 extended)
├─ Install Dart Sass
├─ Checkout code + git submodules
├─ Setup GitHub Pages environment
├─ Install Node.js deps (optional)
├─ Build with Hugo (minified)
│  └─ hugo --minify --baseURL "https://maitanloi.github.io/"
├─ Upload public/ artifact
├─ Deploy to GitHub Pages
    ↓
Live at: https://maitanloi.github.io/
```

**Key environment variables**:
- `HUGO_VERSION=0.157.0`: Pinned version
- `HUGO_ENVIRONMENT=production`: Production mode
- `HUGO_CACHEDIR`: Runner temp cache for speed

### 5. Hosting Layer

**Platform**: GitHub Pages
**Source**: `/public` directory (committed to repo)
**Domain**: maitanloi.github.io
**HTTPS**: Automatic (GitHub Pages TLS)

**Deployment**:
- GitHub Pages serves static files from `public/` directory
- CDN-backed by GitHub's infrastructure
- Zero-downtime updates
- Automatic cache invalidation on re-deploy

## Data Flow

### Publishing Flow

```
1. Author creates content
   ├─ Create markdown file: content/blog/post-name.md
   ├─ Add YAML front matter
   ├─ Write markdown body
   └─ Set draft: false

2. Local testing
   └─ hugo server -D
   └─ Review at http://localhost:1313/

3. Version control
   └─ git add content/blog/post-name.md
   └─ git commit -m "feat(blog): add post-name"
   └─ git push origin main

4. CI/CD automation
   └─ GitHub Actions webhook triggered
   └─ Hugo builds static site
   └─ Artifact uploaded to Pages
   └─ GitHub Pages deploys

5. Live
   └─ Post accessible at:
      https://maitanloi.github.io/post-name/
```

### Build Process Data

**Input**:
- Markdown files + YAML front matter
- PaperMod theme templates
- Static assets

**Processing**:
- Front matter parsed → post metadata
- Markdown converted → HTML
- Templates applied → complete pages
- Taxonomy generated → category/tag pages
- Assets minified → production optimized

**Output**:
- `public/index.html` — Homepage
- `public/{slug}/index.html` — Post pages
- `public/categories/writeups/index.html` — Category page
- `public/tags/{tag}/index.html` — Tag pages
- `public/sitemap.xml` — SEO feed
- CSS/JS assets — Bundled and minified

## Configuration Hierarchy

**Hugo processes config in this order**:

1. **Built-in defaults** (Hugo core)
2. **Theme defaults** (PaperMod/config.yaml)
3. **Project config** (hugo.yaml) ← **Active customizations here**
4. **Command-line flags** (override all)

**Active customizations** in `hugo.yaml`:
- `baseURL`: Deployment domain
- `languageCode`: Content language (vi)
- `title`: Site title
- `permalinks`: URL structure
- `params`: Theme behavior (dark mode, TOC, etc.)
- `menu`: Navigation structure

## Dependency Graph

```
GitHub Actions Workflow
├─ Hugo 0.157.0 extended
│  ├─ Dart Sass (for SCSS)
│  └─ Content files (Markdown)
│
├─ Git
│  └─ PaperMod theme (git submodule)
│
└─ GitHub Pages
   └─ Artifact deployment
```

## Technology Stack

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| Generator | Hugo | 0.157.0 extended | Build static site |
| Markup | Markdown | CommonMark | Content format |
| Frontmatter | YAML | - | Post metadata |
| Styling | SCSS/CSS | PaperMod | Theme styling |
| Theme | PaperMod | git submodule | Responsive design |
| CI/CD | GitHub Actions | latest | Automation |
| Hosting | GitHub Pages | - | Static hosting |
| VCS | Git | - | Version control |

## Scaling Considerations

### Performance

- **Build time**: ~1-2 seconds (incremental), <10s full build
- **Serving**: Extremely fast (static files + CDN)
- **Content limit**: Hugo handles 1000s of posts efficiently
- **Scalability**: No database or server required

### Growth Path

| Phase | Content | Build Time | Action |
|-------|---------|-----------|--------|
| Current | 1-5 posts | <5s | Add content |
| Short-term | 10-50 posts | <10s | No changes needed |
| Medium-term | 50-100 posts | 15-30s | Consider caching |
| Long-term | 100+ posts | 30-60s | Migrate to incremental builds |

### Extensibility

**Without code changes**:
- Add posts (no limit)
- Modify config (hugo.yaml)
- Create custom CSS (assets/)
- Add static files (static/)

**With code changes**:
- Custom layouts (layouts/)
- Hugo shortcodes (layouts/shortcodes/)
- Data structures (data/)
- Advanced automation

## Failure Modes & Recovery

| Failure | Impact | Recovery |
|---------|--------|----------|
| GitHub Pages outage | Site down | Wait for GitHub recovery |
| Hugo build fails | Deploy blocked | Fix markdown syntax, retry |
| Theme broken | Site styling broken | Revert submodule, update theme |
| Git corruption | Repo issues | Clone fresh from GitHub |
| CI/CD stuck | No deployments | Manually re-run workflow in Actions |

## Security Architecture

### No Dynamic Content Risk

Because this is entirely static:
- ✅ No database vulnerabilities
- ✅ No server-side code execution
- ✅ No injection attacks possible
- ✅ No authentication system needed

### Git Submodule Security

- Theme pulled from official PaperMod repo
- Specific commit locked in `.gitmodules`
- Verify before updating: `git diff themes/PaperMod`

### Deployment Security

- GitHub Actions uses official actions
- SSH key for Pages deployment (managed by GitHub)
- HTTPS enforced by GitHub Pages
- No secrets stored in repo

## Monitoring & Observability

**Current monitoring**:
- GitHub Actions logs (success/failure)
- GitHub Pages status page
- Build time in Actions UI

**Potential additions**:
- Google Search Console (SEO)
- CloudFlare Analytics (traffic)
- GitHub alerts (build failures)

## Future Architecture Changes

### Planned
- Custom About page (layouts override)
- Static search (no external dependency)

### Possible
- Comment system (external service)
- Analytics integration
- Advanced taxonomy (difficulty levels)
- Multi-language support (i18n/)

### Not Planned
- Database (would require server)
- Dynamic content (defeats static site purpose)
- Server-side auth (not needed)
