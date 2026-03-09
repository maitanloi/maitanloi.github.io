# Codebase Summary

## Project Structure

```
maitanloi.github.io/
├── .github/
│   └── workflows/
│       └── hugo.yaml                 # CI/CD pipeline (64 lines)
├── .claude/                          # Claude workspace rules
├── archetypes/
│   └── default.md                    # Content template (6 lines)
├── assets/                           # CSS/JS preprocessing (empty)
├── content/
│   └── blog/
│       └── htb-machine-name.md       # Sample writeup (13 lines)
├── data/                             # Data files (empty)
├── i18n/                             # Internationalization (empty)
├── layouts/                          # Custom templates (empty)
├── public/                           # Generated static site (committed)
├── static/                           # Static assets (empty)
├── themes/
│   └── PaperMod/                     # Theme submodule (do not edit)
├── docs/                             # Documentation
├── hugo.yaml                         # Site configuration (29 lines)
├── CLAUDE.md                         # Development guidance
└── .gitignore                        # Minimal ignores
```

## Key Files

### Configuration

**hugo.yaml** (29 lines)
- Base URL: https://maitanloi.github.io/
- Language: Vietnamese (vi)
- Theme: PaperMod (git submodule)
- Theme config: Dark mode default, reading time, breadcrumbs, code copy buttons, TOC
- Clean permalinks: `blog: "/:slug/"`
- Navigation menu: Blog (writeups), Tags, About
- Site title: "Mai Tấn Lợi"

### Content

**content/blog/htb-machine-name.md** (13 lines)
- YAML front matter template for writeups
- Fields: title, date, tags (array), categories (array), draft flag
- Sample content shows Reconnaissance section structure

### Deployment

**.github/workflows/hugo.yaml** (64 lines)
- Trigger: Push to main branch + manual trigger
- Hugo version: 0.157.0 extended (pinned)
- Steps:
  1. Install Hugo CLI from GitHub releases
  2. Install Dart Sass (for SCSS)
  3. Checkout code with git submodules
  4. Configure GitHub Pages
  5. Install Node.js deps (optional)
  6. Build with Hugo (minified, production env)
  7. Upload artifact to Pages
  8. Deploy to GitHub Pages
- Permissions: read contents, write pages, write id-token
- Caching: Hugo cache in runner temp directory

### Theme

**themes/PaperMod/** (git submodule)
- Read-only integration via git submodule
- Custom config via `params` section in hugo.yaml
- Not to be modified directly
- Provides responsive design, syntax highlighting, dark mode

### Templates

**archetypes/default.md** (6 lines)
- YAML front matter template for new posts
- Auto-fills title from filename, date, draft=true by default
- Used by: `hugo new blog/<slug>.md`

## Dependencies

### Runtime
- **Hugo 0.157.0 extended**: Static site generator
  - Handles Markdown processing, template rendering, asset pipeline
  - Extended version includes SCSS support
- **Dart Sass**: SCSS compilation (installed in CI)
- **Git**: Submodule management (PaperMod theme)

### Development
- **Git**: Version control, submodule management
- **GitHub Actions**: CI/CD orchestration
- **GitHub Pages**: Hosting platform

### Optional
- **Node.js**: Only if using npm-based asset pipeline (not currently configured)

## File Size Analysis

| File/Directory | Type | Size | Purpose |
|--------|------|------|---------|
| hugo.yaml | Config | 500 B | Main site configuration |
| .github/workflows/hugo.yaml | CI/CD | 2 KB | Build & deploy script |
| archetypes/default.md | Template | 150 B | Post template |
| content/blog/ | Content | - | Blog posts (markdown) |
| themes/PaperMod/ | Theme | - | Git submodule (not counted) |
| public/ | Output | - | Generated site (rebuilt on deploy) |

## Content Organization

### Blog Posts
- Location: `content/blog/`
- Format: Markdown with YAML front matter
- Naming: kebab-case slugs (e.g., `htb-machine-name.md`)
- Fields:
  - `title`: Post title (string)
  - `date`: Publication date (YYYY-MM-DD format)
  - `tags`: Array of tags (recommended: htb, linux, writeups, etc.)
  - `categories`: Array of categories (recommended: writeups)
  - `draft`: Draft status (boolean, default true)

### URL Structure
- Posts: `https://maitanloi.github.io/{slug}/`
- Categories: `https://maitanloi.github.io/categories/{category}/`
- Tags: `https://maitanloi.github.io/tags/{tag}/`
- About: `https://maitanloi.github.io/about/`

## Build Pipeline

1. **Source**: Markdown files in `content/blog/`
2. **Processing**: Hugo processes YAML frontmatter + Markdown
3. **Theme**: PaperMod applies templates, styling, responsive design
4. **Output**: Static HTML/CSS/JS generated to `public/`
5. **Deployment**: GitHub Actions uploads `public/` to GitHub Pages
6. **CDN**: GitHub Pages serves via GitHub's CDN

## Technology Stack Summary

| Layer | Technology |
|-------|-----------|
| **Generator** | Hugo 0.157.0 extended |
| **Content Format** | Markdown + YAML |
| **Theme** | PaperMod (git submodule) |
| **Styling** | CSS (PaperMod) + SCSS support |
| **Hosting** | GitHub Pages |
| **CI/CD** | GitHub Actions |
| **Version Control** | Git |
| **Language** | Vietnamese |

## Extensibility Points

- **Custom Layouts**: Place in `layouts/` to override theme templates
- **Styled Assets**: Use `assets/` for SCSS/CSS preprocessing
- **Static Files**: Place in `static/` for raw file serving (robots.txt, favicon, etc.)
- **Data Files**: Use `data/` for YAML/JSON data structures
- **i18n**: Add Vietnamese translation files in `i18n/` if multilingual
- **Shortcodes**: Create custom markdown shortcodes in `layouts/shortcodes/`

## Current Limitations

1. **No custom pages yet**: About page menu item exists but no content
2. **No search functionality**: Would require custom implementation
3. **No comments system**: Not configured
4. **No analytics**: No tracking setup
5. **Minimal content**: Only sample writeup present
6. **No custom styling**: Using PaperMod defaults only
