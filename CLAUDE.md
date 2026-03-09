# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal blog (maitanloi.github.io) built with Hugo using the PaperMod theme. Content is primarily cybersecurity writeups in Vietnamese. Deployed to GitHub Pages via GitHub Actions on push to `main`.

## Commands

- **Local dev server:** `hugo server -D` (includes drafts)
- **Build:** `hugo --minify`
- **New post:** `hugo new blog/<slug>.md` (uses archetype at `archetypes/default.md`)

## Architecture

- **Config:** `hugo.yaml` — site settings, theme config, menu structure
- **Content:** `content/blog/` — blog posts (Markdown with YAML front matter)
- **Theme:** `themes/PaperMod/` — git submodule, do not edit directly
- **Output:** `public/` — generated static site (committed for Pages, rebuilt by CI)
- **Deployment:** `.github/workflows/hugo.yaml` — builds with Hugo 0.157.0 extended and deploys to GitHub Pages

## Content Conventions

- Posts use YAML front matter with `title`, `date`, `tags`, `categories`, `draft`
- Blog posts get clean permalink via `permalinks.blog: "/:slug/"` in config
- Categories used: `writeups`. Tags include: `htb`, `linux`, `writeups`
- Language is Vietnamese (`languageCode: vi`)

## Branches

- `main` — active development branch, triggers deploy
- `master` — legacy default branch
