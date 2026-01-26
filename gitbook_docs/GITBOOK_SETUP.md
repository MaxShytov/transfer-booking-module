# GitBook Setup Instructions for 8Move Transfer Documentation

This file contains step-by-step instructions for setting up your documentation on GitBook.

## Option 1: Import via Git (Recommended)

### Step 1: Create a Git Repository

1. Create a new repository on GitHub/GitLab/Bitbucket
2. Upload all documentation files maintaining the folder structure
3. Push to your repository

### Step 2: Connect to GitBook

1. Log in to GitBook (gitbook.com)
2. Create new Space → Select "Import from Git"
3. Choose your Git provider
4. Authorize GitBook to access your repository
5. Select the repository with your documentation
6. GitBook will automatically detect `SUMMARY.md` and build navigation

### Benefits of Git Integration:
- ✅ Version control
- ✅ Automatic updates on git push
- ✅ Team collaboration via pull requests
- ✅ Edit in your preferred IDE
- ✅ Backup in Git

---

## Option 2: Manual Upload

### Step 1: Create New Space

1. Log in to GitBook
2. Click "New Space"
3. Choose "Documentation"
4. Name it "8Move Transfer Documentation"
5. Select visibility (Public or Private)

### Step 2: Manual File Upload

**Upload files in this order:**

1. **Root Level:**
   - README.md (becomes home page)

2. **Getting Started folder:**
   - Create "Getting Started" group
   - Upload:
     - what-is-8move-transfer.md
     - key-features.md

3. **User Guides folder:**
   - Create "User Guides" group
   
   **Mobile App sub-folder:**
   - Create "Mobile App" page group
   - Upload:
     - README.md (section home)
     - authentication.md
     - home-screen.md
     - booking-wizard.md
     - my-bookings.md
     - user-profile.md
     - troubleshooting.md
   
   **Admin Panel sub-folder:**
   - Create "Admin Panel" page group
   - Upload:
     - README.md (section home)
     - FULL_GUIDE.md

4. **Business Operations folder:**
   - Create "Business Operations" group
   - Upload:
     - pricing-model.md

5. **Support folder:**
   - Create "Support" group
   - Upload:
     - faq.md

---

## Folder Structure Overview

```
📁 8move-docs/
├── 📄 README.md (Home page)
├── 📄 SUMMARY.md (Navigation structure)
│
├── 📁 getting-started/
│   ├── 📄 what-is-8move-transfer.md
│   └── 📄 key-features.md
│
├── 📁 user-guides/
│   ├── 📁 mobile-app/
│   │   ├── 📄 README.md
│   │   ├── 📄 authentication.md
│   │   ├── 📄 home-screen.md
│   │   ├── 📄 booking-wizard.md
│   │   ├── 📄 my-bookings.md
│   │   ├── 📄 user-profile.md
│   │   └── 📄 troubleshooting.md
│   │
│   └── 📁 admin-panel/
│       ├── 📄 README.md
│       └── 📄 FULL_GUIDE.md
│
├── 📁 business-operations/
│   └── 📄 pricing-model.md
│
└── 📁 support/
    └── 📄 faq.md
```

---

## Step 3: Customize Appearance

### Brand Settings

1. Go to Space Settings → Customize
2. Upload **Logo**:
   - Recommended: 200x50px PNG with transparency
   - 8Move Transfer logo
3. Upload **Favicon**:
   - 32x32px or 64x64px PNG
   - Shows in browser tab
4. Set **Primary Color**:
   - Use your brand color
   - Affects links and highlights
   - Example: #0066CC (blue)
5. Upload **Cover Image** (optional):
   - 1920x400px recommended
   - Hero image for documentation home

### Social & SEO

1. Settings → Share
2. Configure:
   - **Title:** "8Move Transfer Documentation"
   - **Description:** "Complete guide to 8Move Transfer platform - mobile app, admin panel, and pricing"
   - **Social Preview Image:** Upload 1200x630px image

---

## Step 4: Configure Publishing

### Custom Domain (Optional)

1. Settings → Domain
2. Options:
   - Free subdomain: `8move-transfer.gitbook.io`
   - Custom domain: `docs.8move-transfer.com`
     - Add CNAME record in DNS
     - Point to GitBook
     - Add custom domain in GitBook
     - Enable HTTPS (automatic)

### Visibility Settings

1. Settings → Share
2. Choose:
   - **Public** - Anyone can view
   - **Unlisted** - Only people with link
   - **Private** - Only invited members

---

## Step 5: Navigation & Structure

### Automatic Navigation

If using Git integration:
- `SUMMARY.md` defines structure
- Automatically builds sidebar
- Updates with each git push

### Manual Navigation

If uploading manually:
1. Drag and drop pages in sidebar
2. Create page groups
3. Nest pages under groups
4. Reorder as needed

### Recommended Structure

```
📘 8Move Transfer Documentation
├── 🏠 Welcome (README.md)
├── 📁 Getting Started
│   ├── What is 8Move Transfer?
│   └── Key Features
├── 📁 User Guides
│   ├── 📱 Mobile App
│   │   ├── Overview
│   │   ├── Authentication
│   │   ├── Home Screen
│   │   ├── Booking Wizard
│   │   ├── My Bookings
│   │   ├── User Profile
│   │   └── Troubleshooting
│   └── 🖥️ Admin Panel
│       ├── Overview
│       └── Complete Guide
├── 📁 Business Operations
│   └── Pricing Model
└── 📁 Support
    └── FAQ
```

---

## Step 6: Team Access

### Invite Team Members

1. Settings → Members
2. Click "Invite"
3. Enter email addresses
4. Assign roles:
   - **Admin** - Full access
   - **Editor** - Can edit content
   - **Reviewer** - Can comment
   - **Reader** - View only

### Permissions

Configure what each role can do:
- Edit pages
- Publish changes
- Manage settings
- Invite members

---

## Step 7: Additional Features

### Search

- Automatically enabled
- Indexes all content
- Full-text search
- Instant results

### Versions (Git Integration)

1. Create git branches for versions
2. Example:
   - `main` → Latest version
   - `v1.0` → Version 1.0 docs
   - `v2.0` → Version 2.0 docs
3. GitBook shows version selector
4. Users can switch between versions

### Analytics

1. Settings → Integrations
2. Connect Google Analytics
3. Or use built-in GitBook analytics
4. Track:
   - Page views
   - Popular content
   - Search queries
   - User flow

### Integrations

Available integrations:
- **Slack** - Notifications
- **Google Analytics** - Tracking
- **Intercom** - Customer support
- **Segment** - Data collection

---

## Maintenance

### Regular Updates

**Weekly:**
- Review and update FAQ
- Check for broken links
- Update screenshots if UI changed

**Monthly:**
- Update feature documentation
- Add new features
- Review analytics
- Improve popular pages

**Quarterly:**
- Major version updates
- Restructure if needed
- Add new sections
- Archive old content

### Version Control (Git)

If using Git integration:

```bash
# Clone repository
git clone your-repo-url

# Make changes locally
edit documentation/file.md

# Commit and push
git add .
git commit -m "Update pricing documentation"
git push origin main

# GitBook auto-updates in 1-2 minutes
```

---

## Tips for Success

### Content Quality

✅ **Do:**
- Use clear headings
- Add lots of screenshots
- Include step-by-step guides
- Link between related pages
- Use tables for comparisons
- Add code examples in blocks
- Keep pages focused

❌ **Don't:**
- Create overly long pages (split them)
- Use too many nested levels
- Forget to update outdated info
- Use unclear terminology
- Skip examples

### Navigation

✅ **Best Practices:**
- Logical grouping
- Clear hierarchy
- Descriptive page names
- Breadcrumb-friendly structure
- Max 3-4 nesting levels

### Search Optimization

Make content searchable:
- Use keywords in headings
- Include common terms
- Add synonyms
- Descriptive alt text for images
- Clear anchor links

---

## Troubleshooting

### Images Not Showing

- Use relative paths: `./images/screenshot.png`
- Or upload to GitBook directly
- Ensure images in Git repository
- Check file extensions (lowercase)

### Broken Links

- Use relative links: `[Page](../section/page.md)`
- Test all internal links
- Update when moving pages
- Use GitBook's link checker

### Navigation Not Updating

**Git Integration:**
- Check `SUMMARY.md` syntax
- Ensure proper indentation
- Commit and push changes
- Wait 1-2 minutes for sync

**Manual:**
- Refresh page
- Check page order in sidebar
- Drag and drop to reorder

---

## Support Resources

### GitBook Documentation
- https://docs.gitbook.com
- Comprehensive guides
- Video tutorials
- Community forum

### Markdown Guide
- https://www.markdownguide.org
- Syntax reference
- Best practices
- Cheat sheets

### Trident Software Support
- Email: support@trident-software.ch
- For documentation updates
- Custom configuration help
- Training available

---

## Next Steps

1. ✅ Choose setup method (Git or Manual)
2. ✅ Create GitBook space
3. ✅ Upload/connect documentation
4. ✅ Customize appearance
5. ✅ Configure domain and visibility
6. ✅ Invite team members
7. ✅ Enable analytics
8. ✅ Publish and share!

**Your documentation URL will be:**
- Free: `8move-transfer.gitbook.io`
- Custom: `docs.8move-transfer.com`

---

## Questions?

Contact Maksym at Trident Software for assistance with:
- GitBook setup
- Documentation structure
- Content updates
- Custom features
- Training sessions

**Email:** maksym@trident-software.ch
**Company:** Trident Software Sàrl, Sion, Switzerland
