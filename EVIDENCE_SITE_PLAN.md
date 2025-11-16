# Evidence Site Completion Plan

## Project Overview
Build an Evidence.dev visualization site to showcase UT Dallas Rugby statistics (2014-2024) preserved from usarugbystats.com.

---

## Phase 1: Evidence.dev Setup & Data Preparation

- [ ] Initialize Evidence.dev project
  - [ ] Install Evidence.dev framework (`npx degit evidence-dev/template evidence-site`)
  - [ ] Review project structure and configuration
  - [ ] Install dependencies

- [ ] Prepare data for Evidence
  - [ ] Convert JSON data to Parquet format (Evidence's preferred format)
  - [ ] OR set up DuckDB database that Evidence can query directly
  - [ ] Test data queries work in Evidence environment
  - [ ] Migrate existing SQL queries to Evidence format

---

## Phase 2: Core Pages & Visualizations

- [ ] Create Homepage (`pages/index.md`)
  - [ ] Write project overview and introduction
  - [ ] Add key statistics at a glance (total players, seasons, games)
  - [ ] Create navigation to other sections
  - [ ] Add context about preservation effort

- [ ] Create All-Time Leaders page (`pages/all-time-leaders.md`)
  - [ ] All-time points leaders table (top 10+)
  - [ ] All-time try scorers table (top 10+)
  - [ ] All-time conversions leaders
  - [ ] All-time penalty kicks leaders
  - [ ] All-time drop goals leaders
  - [ ] Add interactive sorting/filtering

- [ ] Create Season-by-Season Analysis (`pages/seasons.md`)
  - [ ] Season navigation/selector
  - [ ] Top 5 scorers per season
  - [ ] Top 5 try scorers per season
  - [ ] Team performance metrics by season
  - [ ] Games played statistics

- [ ] Create Player Profiles section
  - [ ] Players overview page (`pages/players.md`)
  - [ ] Individual player detail pages (if feasible)
  - [ ] Edmund Miller feature profile
  - [ ] Career progression visualizations
  - [ ] Season-by-season player breakdowns

- [ ] Create Team Statistics page (`pages/team-stats.md`)
  - [ ] Games played per season
  - [ ] Scoring trends over time (line charts)
  - [ ] Disciplinary records (yellow/red cards)
  - [ ] Participation statistics
  - [ ] Team totals by category

---

## Phase 3: Advanced Features & Visualizations

- [ ] Add data visualizations
  - [ ] Line charts: points scored trends over seasons
  - [ ] Bar charts: top scorers comparisons
  - [ ] Line charts: tries scored over time
  - [ ] Tables: detailed statistics breakdowns
  - [ ] Participation heat maps by season

- [ ] Create About page (`pages/about.md`)
  - [ ] Explain why this site exists (data preservation)
  - [ ] Document data sources and methodology
  - [ ] USA Rugby bankruptcy context
  - [ ] Links to original sources (usarugbystats.com)
  - [ ] Acknowledgments and credits

- [ ] Enhance user experience
  - [ ] Add search/filter functionality
  - [ ] Implement responsive design for mobile
  - [ ] Add dark mode support (if Evidence supports it)
  - [ ] Create table of contents/navigation menu

---

## Phase 4: Deployment & Documentation

- [ ] Prepare for deployment
  - [ ] Test all pages and queries
  - [ ] Optimize performance
  - [ ] Check mobile responsiveness
  - [ ] Verify all links work

- [ ] Deploy site
  - [ ] Build static site (`npm run build`)
  - [ ] Choose hosting platform (GitHub Pages, Netlify, or Vercel)
  - [ ] Deploy to hosting platform
  - [ ] Set up custom domain (optional)
  - [ ] Configure SSL certificate

- [ ] Update project documentation
  - [ ] Update README.md with site information
  - [ ] Add link to live site
  - [ ] Document how to update the site with new data
  - [ ] Add instructions for local development

---

## Future Enhancements (Optional)

- [ ] Add more detailed game-by-game data (if available)
- [ ] Implement player profile photos (from pictures spider)
- [ ] Add schedule/calendar views
- [ ] Create downloadable data exports
- [ ] Add standings tables by season
- [ ] Integrate match stream links (from embed URLs)

---

## Notes

- Data already collected: 7 seasons (2014-2024)
- Existing SQL analysis can be adapted for Evidence
- Focus on clean, simple visualizations
- Prioritize data preservation and accessibility
