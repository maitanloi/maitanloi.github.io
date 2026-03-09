# Project Overview & PDR

## Project Summary

**maitanloi.github.io** is a personal cybersecurity blog showcasing HackTheBox writeups and penetration testing walkthroughs. Built with Hugo and deployed to GitHub Pages via automated CI/CD.

## Purpose & Audience

| Aspect | Details |
|--------|---------|
| **Purpose** | Document and share cybersecurity learning journey, particularly HTB machine solutions |
| **Target Audience** | Cybersecurity enthusiasts, HTB players, Vietnamese-speaking security community |
| **Language** | Vietnamese |
| **Content Type** | Technical writeups, penetration testing walkthroughs |

## Key Goals

1. **Documentation**: Create comprehensive HTB writeup archive with clear methodology
2. **Community**: Share knowledge with Vietnamese cybersecurity community
3. **Portfolio**: Demonstrate security skills and problem-solving approach
4. **Learning**: Document discoveries and techniques for future reference

## Current State (v1.0)

| Component | Status | Details |
|-----------|--------|---------|
| **Platform** | Live | GitHub Pages deployment |
| **Content** | Minimal | 1 sample writeup (htb-machine-name.md) |
| **Theme** | Active | PaperMod (dark mode default) |
| **Navigation** | Configured | Menu: Blog, Tags, About |
| **CI/CD** | Operational | GitHub Actions (Hugo 0.157.0) |
| **Repository** | Public | main branch triggers deploy |

## Product Requirements

### Functional Requirements

| Req ID | Requirement | Priority | Status |
|--------|-------------|----------|--------|
| FR-01 | Display blog posts with clean URLs (`/:slug/`) | High | Done |
| FR-02 | Organize posts by category (writeups) and tags (htb, linux, writeups) | High | Done |
| FR-03 | Show table of contents in posts | High | Done |
| FR-04 | Display code snippets with syntax highlighting | High | Done |
| FR-05 | Provide reading time estimate | Medium | Done |
| FR-06 | Enable post navigation (prev/next) | Medium | Done |
| FR-07 | Display breadcrumb navigation | Medium | Done |
| FR-08 | Support code copy buttons | Medium | Done |

### Non-Functional Requirements

| Req ID | Requirement | Priority | Status |
|--------|-------------|----------|--------|
| NR-01 | Dark theme by default for cybersecurity audience | High | Done |
| NR-02 | Fast static site generation (< 1min for build) | High | Done |
| NR-03 | Responsive design for mobile/tablet | High | Theme coverage |
| NR-04 | Vietnamese language support | High | Done |
| NR-05 | SEO-friendly URLs and metadata | Medium | Done |
| NR-06 | Zero-downtime deployment to Pages | High | Done |

## Success Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Build time | < 1 minute | GitHub Actions logs |
| Deployment | Automatic on push | main branch triggers |
| Content searchability | Full text indexable | Google Search Console |
| Mobile compatibility | > 90% | Lighthouse scores |

## Technical Constraints

- **Hugo Version**: Fixed at 0.157.0 extended (in CI)
- **Node.js**: Optional (for Dart Sass if needed)
- **Theme**: PaperMod (git submodule, immutable)
- **Hosting**: GitHub Pages only
- **Repository**: Public, tracked in version control
- **Language**: Vietnamese content

## Roadmap & Timeline

### Phase 1: Foundation (Current)
- Initial blog setup with Hugo + PaperMod
- Sample content structure established
- CI/CD pipeline operational
- **Timeline**: Week 1-2
- **Status**: In Progress

### Phase 2: Content Growth
- Write 5-10 HTB writeups
- Establish content style guide
- Build tag taxonomy
- **Timeline**: Week 3-8
- **Target**: Live by end of Q1 2026

### Phase 3: Enhanced Experience (Future)
- Create About page
- Add search functionality
- Implement social sharing
- Set up analytics
- **Timeline**: Q2 2026

### Phase 4: Advanced Features (Backlog)
- Comment system (Disqus/giscus)
- Newsletter subscription
- Advanced taxonomy (difficulty levels)
- Custom layouts for specific post types
- **Timeline**: Q3+ 2026

## Risk Assessment

| Risk | Impact | Likelihood | Mitigation |
|------|--------|-----------|-----------|
| PaperMod theme maintenance | Medium | Low | Monitor upstream; fork if critical |
| GitHub Pages service outage | High | Very Low | DNS failover ready if needed |
| Content quality degradation | Medium | Low | Review process for each post |
| SEO/discovery | Low | Medium | Monitor search console metrics |

## Dependencies

- **Hugo**: 0.157.0 extended
- **Git**: Version control and deployment trigger
- **GitHub Pages**: Hosting platform
- **GitHub Actions**: CI/CD orchestration
- **PaperMod Theme**: Rendering and styling (git submodule)

## Success Criteria

- Production blog accessible at maitanloi.github.io
- Automated deployment on push to main
- Minimum 3 published writeups by end of March 2026
- All posts have reading time, TOC, code formatting
- Mobile-responsive on all major devices
- Build time < 1 minute consistently
