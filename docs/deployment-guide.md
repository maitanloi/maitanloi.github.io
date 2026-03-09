# Deployment Guide

## Overview

This guide covers deploying content and managing the maitanloi.github.io blog. The blog uses GitHub Actions for automated CI/CD, so most deployments are automatic on push to `main`.

## Quick Start

### Local Development

Start the development server with draft posts included:

```bash
hugo server -D
```

- Accessible at: `http://localhost:1313/`
- Auto-reloads on file changes
- `-D` flag includes draft posts
- Quit with Ctrl+C

### Creating a New Post

```bash
hugo new blog/post-slug.md
```

This creates `content/blog/post-slug.md` with:
- YAML front matter template
- Draft mode enabled by default
- Date auto-filled

Edit the file, then toggle `draft: false` when ready to publish.

### Publishing

Push to `main` branch to trigger automatic deployment:

```bash
git add content/blog/post-slug.md
git commit -m "feat(blog): add post-slug"
git push origin main
```

GitHub Actions automatically:
1. Builds the site with Hugo
2. Minifies assets
3. Deploys to GitHub Pages
4. Site live in ~30-60 seconds

## Automated Deployment (CI/CD)

### GitHub Actions Workflow

**File**: `.github/workflows/hugo.yaml`

**Trigger**:
- Automatic on push to `main` branch
- Manual via GitHub Actions UI

**Process**:

```
1. Workflow triggered (main branch push or manual dispatch)
   ↓
2. Install dependencies
   ├─ Hugo CLI 0.157.0 extended
   ├─ Dart Sass
   └─ Git submodules (PaperMod theme)
   ↓
3. Build site
   ├─ Parse Markdown content
   ├─ Apply PaperMod theme
   ├─ Generate static HTML/CSS/JS
   └─ Minify for production
   ↓
4. Upload artifacts
   └─ Public directory to GitHub
   ↓
5. Deploy to GitHub Pages
   ├─ Move artifacts to Pages
   ├─ Update live site
   └─ HTTPS served via GitHub's CDN
   ↓
6. Complete
   └─ Site live at https://maitanloi.github.io/
```

### Monitoring CI/CD

**Check deployment status**:

1. Go to GitHub repo: https://github.com/maitanloi/maitanloi.github.io
2. Click "Actions" tab
3. See recent workflow runs:
   - ✅ Green checkmark = success
   - ❌ Red X = failed
   - ⏳ Yellow circle = in progress

**View build logs**:
1. Click on workflow run
2. Click "build" job
3. Expand sections to see:
   - Hugo build output
   - Any errors/warnings
   - Build time

**Common build issues**:

| Error | Cause | Fix |
|-------|-------|-----|
| `ParseError` in Hugo | Invalid YAML front matter | Check syntax: `title:` not `title=` |
| `undefined variable` | Template error | Check if PaperMod is checked out |
| `file not found` | Broken link in markdown | Verify link path in post |
| Build timeout | Large content | Usually passes on retry |

## Manual Build & Testing

### Local Production Build

Test the exact output that will be deployed:

```bash
hugo --minify
```

This generates `public/` directory with minified output. Review before committing.

**Preview production build**:

```bash
hugo server --baseURL=http://localhost:1313/
cd public/
python -m http.server 8000
# Visit http://localhost:8000/ in browser
```

### Clean Build

Remove cached build files and rebuild:

```bash
rm -rf public resources
hugo --minify
```

Use when experiencing unexpected build behavior.

## Deployment Checklist

Before pushing content to `main`:

- [ ] Post markdown file exists: `content/blog/post-name.md`
- [ ] YAML front matter is valid:
  - [ ] `title` is a string (quoted if contains special chars)
  - [ ] `date` is YYYY-MM-DD format
  - [ ] `tags` and `categories` are arrays
  - [ ] `draft: false` (or absent for draft)
- [ ] All code blocks have language specifiers (```bash, ```python, etc.)
- [ ] No broken links or image references
- [ ] Local preview looks correct: `hugo server -D`
- [ ] Local production build succeeds: `hugo --minify`
- [ ] Git status clean: `git status` shows only intended changes
- [ ] Commit message follows conventions: `feat(blog): ...`

## Rollback

If a deployment introduces issues:

### Immediate Rollback

Revert the problematic commit and push:

```bash
git revert HEAD
git push origin main
```

GitHub Actions will rebuild without the problematic content. Site reverts in ~30-60 seconds.

### If Submodule Issue

If theme (PaperMod submodule) was updated and causes issues:

```bash
# Check out previous submodule version
git checkout HEAD^ -- themes/PaperMod
git add themes/PaperMod
git commit -m "fix(theme): revert to previous version"
git push origin main
```

## Manual Deployment Steps (Advanced)

If CI/CD fails, manual deployment is possible:

### 1. Local Build

```bash
# Clone repo
git clone https://github.com/maitanloi/maitanloi.github.io.git
cd maitanloi.github.io

# Initialize submodules
git submodule update --init --recursive

# Install Hugo 0.157.0 extended
# (Download from https://github.com/gohugoio/hugo/releases)

# Build
hugo --minify --baseURL="https://maitanloi.github.io/"
```

### 2. Verify Output

```bash
ls -la public/
# Should see: index.html, sitemap.xml, posts/, categories/, tags/, etc.
```

### 3. Push Public Directory

GitHub Pages reads from `public/` directory:

```bash
git add public/
git commit -m "chore: rebuild site"
git push origin main
```

**Note**: This is normally done by GitHub Actions. Only do this if CI/CD is broken.

## Performance & Optimization

### Build Time

Current stats:
- Clean build: ~5-10 seconds
- Incremental: ~1-2 seconds
- Deployment: ~30-60 seconds total

**Optimize if slow**:

```bash
# Check which step is slow
time hugo --minify

# Clear Hugo cache
rm -rf resources

# Rebuild
hugo --minify
```

### Site Performance

The static site is very fast:

- **HTML generation**: < 100ms per page
- **CSS serving**: Minified, cached by CDN
- **Image serving**: GitHub CDN (no server processing)

**Tips**:
- Keep images under 1MB for web (compress before uploading)
- Use relative links within site: `[text](post-name/)`
- Reference external resources by full URL

## Environment Configuration

### GitHub Pages Settings

**Repository Settings** → **Pages**:

- ✅ Source: Deploy from a branch
- ✅ Branch: main
- ✅ Folder: / (root)
- ✅ HTTPS: Enabled (automatic)
- ✅ Custom domain: maitanloi.github.io (configured in DNS)

**Do not manually change these.** They're set up for auto-deploy.

### CI/CD Environment

GitHub Actions runs with:
- **OS**: Ubuntu latest
- **Hugo**: 0.157.0 extended
- **Dart Sass**: Latest from snap
- **Git**: Pre-installed
- **Node.js**: Optional (not used unless package.json exists)

These are defined in `.github/workflows/hugo.yaml`.

## Troubleshooting

### Site doesn't update after push

**Check**:
1. Verify push was successful: `git log` shows your commit
2. Go to Actions tab and check if workflow ran
3. If workflow didn't run, check:
   - Was it pushed to `main` branch? (not master or feature branch)
   - Are there any workflow syntax errors?
4. Manually trigger workflow:
   - Go to Actions → Deploy Hugo site to Pages
   - Click "Run workflow"

### Content looks wrong after deploy

**Check**:
1. Local preview matches deployed version: `hugo server -D`
2. Hard refresh browser: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)
3. Clear browser cache and retry
4. Check GitHub Pages status: github.com/status

### Build fails in CI/CD

**Check**:
1. Read the GitHub Actions log for error message
2. Common causes:
   - Invalid YAML in front matter
   - Broken internal links
   - Theme not checked out (submodule issue)
3. Test locally first: `hugo --minify`
4. Fix the issue and push again

**Submodule problems**:

```bash
# Verify submodule is initialized
git submodule status
# Should see: themes/PaperMod (with a commit hash)

# If not, initialize
git submodule update --init --recursive
```

### Manual cache clear

If Pages shows old content:

```bash
# Force GitHub Pages to rebuild
git commit --allow-empty -m "chore: trigger rebuild"
git push origin main
```

## Deployment Frequency

**Recommended**:
- **Daily**: Review and test new posts locally before pushing
- **Per post**: Publish when content is ready
- **Emergency**: Rollback if critical issues within 1 hour

**Monitoring**:
- Check Actions logs for each deploy
- Verify links work on live site
- Monitor Google Search Console for indexing

## DNS & Domain Setup

**Current setup**:
- Domain: maitanloi.github.io (GitHub Pages default domain)
- HTTPS: Automatic via GitHub's certificates
- DNS: Managed by GitHub

**Custom domain** (if needed in future):
- DNS provider: Point A/CNAME record to GitHub Pages IP
- GitHub Pages settings: Add custom domain
- HTTPS: Auto-provisioned

See: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site

## Backups & Recovery

### Backup Strategy

The repository itself is the backup:
- All content in `content/blog/` is in git history
- Clone any old version: `git checkout <commit-hash>`
- Remote backup: GitHub servers (with redundancy)

### Restore Old Version

```bash
# View history
git log --oneline

# Go back to specific commit
git checkout <commit-hash>
hugo --minify
git push origin main

# Or use revert to stay in history
git revert <commit-hash>
git push origin main
```

## Secrets & Security

**No secrets needed** for this deployment:

- ✅ No API keys stored
- ✅ No database credentials
- ✅ No access tokens in repo
- ✅ GitHub manages Pages deployment auth

If adding external services in future (analytics, comments):
- Use GitHub Secrets for sensitive config
- Never commit `.env` files
- Reference from Actions workflow, not in code

## Next Steps

### For Content Creators
- Learn [Code Standards](./code-standards.md) for writing posts
- Read [System Architecture](./system-architecture.md) to understand the build process

### For Site Maintainers
- Monitor GitHub Actions for build failures
- Update PaperMod theme periodically: `git submodule update`
- Archive old builds: GitHub automatically keeps deploy history

### For Troubleshooting
- Check [GitHub Actions Docs](https://docs.github.com/en/actions)
- See [Hugo Docs](https://gohugo.io/documentation/)
- Review [PaperMod Docs](https://github.com/adityatelange/hugo-PaperMod)
