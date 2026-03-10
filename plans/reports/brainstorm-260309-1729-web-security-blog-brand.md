# Brainstorm: Web Security Blog Brand & Strategy

**Date:** 2026-03-09
**Status:** Agreed
**Owner:** Mai Tấn Lợi (Tobi)

## Problem Statement
Tobi is a Vietnamese web developer (Next.js + Supabase) transitioning to Web Security Specialist over 12-15 months. Needs blog strategy & personal brand to position as THE Vietnamese web security specialist for modern stacks.

## Decisions Made

### Brand Identity
- **Name:** Mai Tấn Lợi (tên thật, không dùng alias)
- **Tagline:** "Phá để hiểu, viết để nhớ"
- **Bio:** Web Developer chuyển sang Web Security. Chuyên audit Next.js, Supabase & ứng dụng vibe-coded. Chia sẻ hành trình từ builder → breaker.
- **Language:** Mix Việt-Anh (thuật ngữ kỹ thuật giữ nguyên tiếng Anh)
- **Primary goal:** Portfolio cá nhân (jobs/freelance/consulting)

### Content Strategy (3 tầng)

| Tầng | Loại | Mục đích | Tần suất | Bắt đầu |
|------|------|----------|----------|---------|
| Core | Lab write-ups (PortSwigger, HTB) | Proof of work | 2-3/tuần | Phase 1 |
| Authority | "Security cho Dev" guides | Thu hút dev audience | 2/tháng | Phase 2 |
| Niche | Vibe code audit case studies | Own the niche | 1/tháng | Phase 4 |

### Categories & Tags

**Categories:**
- `writeups` — Lab write-ups (PortSwigger, HTB, TryHackMe)
- `guides` — Hướng dẫn bảo mật cho dev
- `tools` — Review/build security tools
- `case-studies` — Audit thực tế, vibe code analysis
- `career` — Hành trình chuyển ngành, cert review

**Tags (mở rộng theo thời gian):**
- Vuln types: sql-injection, xss, ssrf, xxe, csrf, idor, rce, jwt-attack, deserialization, request-smuggling
- Platforms: portswigger, htb, tryhackme, juice-shop
- Tech: nextjs, supabase, burp-suite, kali-linux
- Difficulty: beginner, intermediate, advanced
- Certs: ejpt, bscp, oscp, oswe
- Niche: vibe-code, ai-security, rls-audit

### Differentiation
1. Tiếng Việt chất lượng — gần như không có đối thủ
2. Góc nhìn developer — mỗi bài: "dev viết code sao dễ bị lỗi này + cách phá + cách fix"
3. Focus modern web stack — Next.js, Supabase, serverless (không phải LAMP/PHP)
4. Hướng tới cả dev lẫn pentester
5. "Vibe code security" content hook — plant seeds sớm, own niche ở Phase 4

### Vietnamese Market Gaps
1. Không có blog web security chất lượng bằng tiếng Việt
2. Không ai viết security cho modern stack
3. Không có "builder → breaker" journey
4. OWASP Top 10 giải thích cho dev VN chưa có
5. Vibe coding security awareness = zero

### Phased Content Roadmap

| Phase | Timeline | Content Focus | Brand Action |
|-------|----------|--------------|--------------|
| Pre-start | Now | — | Update branding, about page, config |
| Phase 1 | M1-3 | Lab write-ups 2-3/tuần | Build proof of work |
| Phase 2 | M3-7 | + Security guides cho dev | Expand to dev audience |
| Phase 3 | M7-10 | + Advanced write-ups | Authority signal (BSCP) |
| Phase 4 | M10-13 | + Vibe code case studies + tools | Own the niche |
| Phase 5 | M13-15+ | + Consulting, workshops | Monetize |

### "Vibe Code Security Auditor" Niche Assessment
- **Viable:** Yes — nobody owns it yet, VN or global
- **Risk:** "vibe coding" term may fade; backup positioning = "Modern Stack Security Specialist"
- **Strategy:** Use as content hook, not entire identity. Identity = Web Security Specialist with modern stack expertise

## Implementation Needed
- [ ] Update hugo.yaml: bio, description, social links
- [ ] Rewrite about.md: full brand story + roadmap journey
- [ ] Add categories to config
- [ ] Update archetype template with new categories/tags
- [ ] Create content calendar template
- [ ] Clean up unused files (Untitled.md, stale public/ folders)

## Revenue Streams (Phase 5+)
1. Bug bounty (Next.js/Supabase targets)
2. Security consulting (Vietnamese startups)
3. Content & education (YouTube tiếng Việt)
4. Secure code review (AI-generated code)

## Source
- Roadmap: `docs/web-security/Web_App_Pentest_Roadmap_Tobi.docx`
