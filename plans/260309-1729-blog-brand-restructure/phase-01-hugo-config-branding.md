---
phase: 1
priority: high
status: pending
effort: 15min
---

# Phase 1: Hugo Config & Homepage Branding

## Overview
Update hugo.yaml with new brand identity and enable PaperMod profile mode for homepage.

## Related Files
- `hugo.yaml` (modify)

## Implementation Steps

### 1. Update author section
```yaml
author:
  name: Mai Tấn Lợi
  bio: "Web Developer → Web Security | Phá để hiểu, viết để nhớ"
```

### 2. Enable profile mode on homepage
```yaml
params:
  profileMode:
    enabled: true
    title: "Mai Tấn Lợi"
    subtitle: "Phá để hiểu, viết để nhớ"
    imageUrl: ""  # Add avatar later
    imageHeight: 120
    imageWidth: 120
    buttons:
      - name: "Blog"
        url: "/blog/"
      - name: "About"
        url: "/about/"
```

### 3. Update menu to reflect new categories
```yaml
menu:
  main:
    - name: Blog
      url: /blog/
      weight: 1
    - name: Writeups
      url: /categories/writeups/
      weight: 2
    - name: Tags
      url: /tags/
      weight: 3
    - name: About
      url: /about/
      weight: 4
```

### 4. Add site description for SEO
```yaml
params:
  description: "Blog về Web Security bằng tiếng Việt. Hành trình từ Web Developer đến Web Security Specialist."
```

## Todo
- [ ] Update author bio
- [ ] Enable profileMode
- [ ] Update menu structure
- [ ] Add site description
- [ ] Test `hugo server -D` renders correctly

## Success Criteria
- Homepage shows profile mode with tagline
- Navigation menu has Blog, Writeups, Tags, About
- SEO description visible in page source
