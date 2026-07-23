# Start New Project

You are initializing a new Flutter project from the riverpod_template. Before writing ANY code, you MUST gather comprehensive requirements by asking the user structured questions.

## Phase 1: Discovery Questions

Ask the user the following questions in a conversational manner. Group related questions together and wait for responses before proceeding.

### 1. Project Overview
- What is the name of this app?
- In 2-3 sentences, what does this app do? Who is it for?
- What problem does it solve for users?
- Are there any existing apps (competitors) I should reference for inspiration?

### 2. Target Platforms & Environments
- Which platforms? (iOS / Android / Web / All)
- Minimum OS versions? (or use defaults: iOS 14+, Android API 24+)
- Will this app need multiple environments? (dev / staging / prod)
- Do you have existing Firebase projects, or should we set them up fresh?

### 3. Authentication & User Management
- How will users authenticate? (Email/Password, Google, Apple, Phone, Anonymous, None)
- Is there a user profile? What information does it contain?
- Are there different user roles/permissions?
- Is there an onboarding flow for new users?

### 4. Core Features
- List the main features/screens of the app (e.g., Home, Profile, Settings, etc.)
- For each major feature, briefly describe what it does
- Which feature is the MVP priority? What can wait for later phases?
- Are there any real-time features? (chat, live updates, notifications)

### 5. Backend & Data
- Is there an existing backend API? If yes:
  - What's the base URL structure?
  - Is there API documentation available?
  - What authentication method does it use? (Bearer token, API key, etc.)
- If no backend exists:
  - Will you use Firebase services? (Firestore, Realtime DB, Cloud Functions)
  - Or will a backend be built separately?
- What data needs to be stored locally? (offline support, caching strategy)

### 6. UI/UX Preferences
- Do you have design mockups/Figma files?
- Color scheme preferences? (provide hex codes if known)
- Light mode, dark mode, or both?
- Any specific fonts to use?
- Should it follow Material Design, Cupertino (iOS-style), or custom?

### 7. Third-Party Integrations
- Push notifications? (Firebase Cloud Messaging)
- Analytics? (Firebase Analytics, Mixpanel, Amplitude, etc.)
- Crash reporting? (Firebase Crashlytics, Sentry)
- Payment processing? (Stripe, RevenueCat, in-app purchases)
- Maps/Location services?
- Social sharing?
- Deep linking?
- Any other SDKs or services?

### 8. Monetization (if applicable)
- Is this a free app, paid app, or freemium?
- In-app purchases? Subscriptions?
- Ads?

### 9. Non-Functional Requirements
- Expected user base size? (affects architecture decisions)
- Any performance requirements? (offline-first, low latency, etc.)
- Accessibility requirements? (screen readers, dynamic text)
- Localization/i18n? Which languages?
- Any compliance requirements? (GDPR, HIPAA, etc.)

### 10. Development Preferences
- Solo developer or team?
- CI/CD preferences? (GitHub Actions, Codemagic, Fastlane)
- Testing requirements? (unit tests, widget tests, integration tests)
- Any specific packages you want to use or avoid?

---

## Phase 2: Generate Project Specification

After gathering answers, create a `docs/PROJECT_SPEC.md` file with the following structure:

```markdown
# [App Name] - Project Specification

Generated: [Date]
Status: Draft

## 1. Overview
- **App Name:** 
- **Description:** 
- **Target Users:** 
- **Problem Solved:** 

## 2. Technical Stack
- **Platforms:** 
- **Minimum Versions:** 
- **Environments:** 
- **State Management:** Riverpod (code-gen)
- **Navigation:** GoRouter
- **Architecture:** Clean Architecture (Presentation → Data → Models → Core)

## 3. Authentication
- **Methods:** 
- **User Profile Fields:** 
- **Roles/Permissions:** 

## 4. Features & Screens

### Phase 1 (MVP)
| Feature | Description | Priority |
|---------|-------------|----------|
| | | |

### Phase 2 (Post-MVP)
| Feature | Description | Priority |
|---------|-------------|----------|
| | | |

## 5. Backend & APIs
- **Type:** [Firebase / Custom API / Both]
- **Base URL:** 
- **Auth Method:** 
- **Key Endpoints:**
  - `GET /endpoint` - Description
  - `POST /endpoint` - Description

## 6. Data Models
List the core domain models needed:
- **User:** id, email, name, ...
- **[Model]:** field1, field2, ...

## 7. UI/UX
- **Design System:** [Material / Cupertino / Custom]
- **Theme:** [Light / Dark / Both]
- **Primary Color:** 
- **Secondary Color:** 
- **Font:** 

## 8. Integrations
- [ ] Push Notifications
- [ ] Analytics
- [ ] Crash Reporting
- [ ] Payments
- [ ] Maps/Location
- [ ] Deep Linking
- [ ] Other: 

## 9. Non-Functional Requirements
- **Offline Support:** 
- **Localization:** 
- **Accessibility:** 
- **Compliance:** 

## 10. Development Plan

### Setup Tasks
- [ ] Rename app package/bundle ID
- [ ] Configure Firebase projects
- [ ] Set up environments (dev/staging/prod)
- [ ] Configure CI/CD
- [ ] Add required dependencies

### Feature Implementation Order
1. 
2. 
3. 

---

## Appendix: Reference Links
- Design Files: 
- API Docs: 
- Competitor Apps: 
```

---

## Phase 3: Generate Implementation Plan

After the spec is approved, create `docs/IMPLEMENTATION_PLAN.md`:

```markdown
# Implementation Plan

## Phase 1: Project Setup
- [ ] Rename package from `riverpod_template` to `[app_name]`
- [ ] Update `pubspec.yaml` (name, description, version)
- [ ] Configure Firebase for each environment
- [ ] Update app icons and splash screen
- [ ] Set up CI/CD pipeline

## Phase 2: Core Infrastructure
- [ ] Define AppRoute constants for all screens
- [ ] Set up authentication flow
- [ ] Configure theme (colors, typography)
- [ ] Set up analytics/crash reporting

## Phase 3: Domain Models
- [ ] Create Freezed models for: [list models]
- [ ] Run build_runner

## Phase 4: Data Layer
- [ ] Create repositories for: [list repositories]
- [ ] Define API endpoints in endpoints.dart
- [ ] Implement repository methods

## Phase 5: Feature Implementation
For each feature:
- [ ] Create view
- [ ] Create controller with @riverpod
- [ ] Wire up navigation
- [ ] Add to manifest

## Phase 6: Polish & Testing
- [ ] Write unit tests for repositories
- [ ] Write unit tests for controllers
- [ ] Widget tests for critical flows
- [ ] Manual QA testing
- [ ] Performance optimization

## Phase 7: Release Preparation
- [ ] App Store assets (screenshots, descriptions)
- [ ] Play Store assets
- [ ] Privacy policy
- [ ] Terms of service
- [ ] Beta testing
```

---

## Instructions

1. **Ask questions conversationally** - Don't dump all questions at once. Group them logically and wait for responses.
2. **Clarify ambiguity** - If answers are vague, ask follow-up questions.
3. **Suggest best practices** - If the user is unsure, recommend standard approaches.
4. **Generate spec when ready** - Once you have enough info, generate `PROJECT_SPEC.md`.
5. **Get approval** - Ask user to review and approve the spec before proceeding.
6. **Generate implementation plan** - Create `IMPLEMENTATION_PLAN.md` with actionable tasks.
7. **Start with setup** - Begin implementation only after spec and plan are approved.

**Remember:** This is a Tier 3 task. Never start implementation without explicit user approval of the spec and plan.
