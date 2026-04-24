[//]: # (Documentation reviewed: April 24, 2025)
# Role Selection Flow Chart

```
┌─────────────────────────────────────────────────────────────┐
│                    WEBSITE ENTRY POINT                      │
│                    (Landing Page / Home)                    │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
              ┌───────────────────────────┐
              │   ROLE SELECTION SCREEN    │
              │   (Before Login/Register)   │
              └───────────────────────────┘
                          │
        ┌─────────────────┴─────────────────┐
        │                                   │
        ▼                                   ▼
┌──────────────┐                  ┌──────────────┐
│  I AM A USER │                  │ I AM A      │
│  (Customer)  │                  │ TECHNICIAN   │
└──────────────┘                  └──────────────┘
        │                                   │
        ▼                                   ▼
┌──────────────────┐            ┌──────────────────┐
│ USER FLOW        │            │ TECHNICIAN FLOW  │
├──────────────────┤            ├──────────────────┤
│                  │            │                  │
│ Login/Register   │            │ Login/Register   │
│ → User Dashboard │            │ → Tech Dashboard │
│                  │            │                  │
│ Features:        │            │ Features:        │
│ • Book Services  │            │ • Accept Jobs    │
│ • Track Jobs     │            │ • Manage Schedule│
│ • Find Techs     │            │ • View Earnings  │
│ • Payments       │            │ • Withdraw Funds │
└──────────────────┘            └──────────────────┘
```

## Implementation Flow:

```
┌─────────────────────────────────────────────────────────────┐
│                    ROOT ROUTE (/)                           │
└─────────────────────────────────────────────────────────────┘
                          │
                          ▼
              ┌───────────────────────────┐
              │   ROLE SELECTION PAGE      │
              │   (New Component)           │
              └───────────────────────────┘
                          │
        ┌─────────────────┴─────────────────┐
        │                                   │
        ▼                                   ▼
┌──────────────────┐            ┌──────────────────┐
│ [USER BUTTON]    │            │ [TECHNICIAN BTN] │
│                  │            │                  │
│ Icon: User       │            │ Icon: Wrench     │
│ Text: "I need    │            │ Text: "I provide │
│  services"       │            │  services"       │
└──────────────────┘            └──────────────────┘
        │                                   │
        │ Store in:                         │
        │ localStorage/sessionStorage       │
        │ or URL param                      │
        │                                   │
        ▼                                   ▼
┌──────────────────┐            ┌──────────────────┐
│ Navigate to:      │            │ Navigate to:      │
│ /user-login      │            │ /technician-     │
│ or                │            │ onboarding       │
│ /user-registration│           │ (Info Page)      │
└──────────────────┘            └──────────────────┘
        │                                   │
        ▼                          ┌────────┴────────┐
┌──────────────────┐               │                 │
│ USER DASHBOARD   │               ▼                 ▼
│                  │      ┌──────────────┐  ┌──────────────┐
└──────────────────┘      │ Already Tech?│  │ New Applicant│
                           │ (Logged in)  │  │ (Not logged) │
                           └──────────────┘  └──────────────┘
                                  │                 │
                                  │ YES             │ NO
                                  │                 │
                                  ▼                 ▼
                           ┌──────────────┐  ┌──────────────┐
                           │ Redirect to: │  │ Show Info + │
                           │ /technician- │  │ "Start App" │
                           │ dashboard    │  └──────────────┘
                           └──────────────┘          │
                                               ┌──────┴──────┐
                                               │             │
                                               ▼             ▼
                                      ┌──────────────┐  ┌──────────────┐
                                      │ Registration │  │ After Reg    │
                                      │ Form         │  │ → Dashboard  │
                                      └──────────────┘  └──────────────┘
```

## Route Structure:

```
┌─────────────────────────────────────────────────────────────┐
│                    ROUTE CONFIGURATION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  / (Root)                                                    │
│    └─> RoleSelectionPage (NEW)                              │
│         ├─> Button: "I'm a Customer"                        │
│         │    └─> Navigate to /user-login                    │
│         │                                                     │
│         └─> Button: "I'm a Technician"                       │
│              └─> Navigate to /technician-onboarding         │
│                   └─> Shows onboarding info                 │
│                        └─> "Start Application" → Registration│
│                                                              │
│  /user-login                                                │
│    └─> UserLogin (Existing)                                 │
│         └─> After login → /user-dashboard                  │
│                                                              │
│  /technician-onboarding (EXISTING)                          │
│    └─> TechnicianOnboarding                                 │
│         ├─> If already technician → Redirect to dashboard   │
│         └─> If not → Show info + "Start Application"       │
│                                                              │
│  /user-registration                                         │
│    └─> UserRegistration (role: 'user')                      │
│                                                              │
│  /user-registration (with role: 'technician')               │
│    └─> UserRegistration (role: 'technician')              │
│         └─> After registration → /technician-dashboard     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Component Structure:

```
┌─────────────────────────────────────────────────────────────┐
│              ROLE SELECTION PAGE COMPONENT                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │  Welcome to SmartTech Connect                     │    │
│  │  "How would you like to use our platform?"         │    │
│  └────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌──────────────────────┐    ┌──────────────────────┐      │
│  │   [USER CARD]        │    │  [TECHNICIAN CARD]   │      │
│  │                      │    │                      │      │
│  │  👤 Icon             │    │  🔧 Icon              │      │
│  │  "I'm a Customer"     │    │  "I'm a Technician"    │      │
│  │                      │    │                      │      │
│  │  Description:        │    │  Description:        │      │
│  │  "Find and book      │    │  "Accept jobs and     │      │
│  │   technicians"       │    │   earn money"         │      │
│  │                      │    │                      │      │
│  │  [Continue as User]  │    │  [Continue as Tech]   │      │
│  └──────────────────────┘    └──────────────────────┘      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow:

```
┌─────────────────────────────────────────────────────────────┐
│                    ROLE SELECTION → STORAGE                 │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  User clicks "I'm a Customer"                               │
│    │                                                         │
│    ├─> localStorage.setItem('selectedRole', 'user')         │
│    │                                                         │
│    └─> navigate('/user-login')                              │
│                                                              │
│  User clicks "I'm a Technician"                              │
│    │                                                         │
│    ├─> localStorage.setItem('selectedRole', 'technician')  │
│    │                                                         │
│    └─> navigate('/technician-onboarding')                  │
│         │                                                     │
│         ├─> If already logged in as technician              │
│         │    └─> Auto-redirect to /technician-dashboard    │
│         │                                                     │
│         └─> If not logged in                                │
│              └─> Show onboarding info                        │
│                   └─> "Start Application" button            │
│                        └─> navigate('/user-registration')   │
│                             with role: 'technician'          │
│                                                              │
│  Login/Registration uses stored role:                        │
│    const selectedRole = localStorage.getItem('selectedRole')│
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Benefits:

```
┌─────────────────────────────────────────────────────────────┐
│                    WHY SEPARATE FLOWS?                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ✅ CLEAR USER EXPERIENCE                                    │
│     • Users know what they're signing up for               │
│     • Different UI/features for each role                    │
│                                                              │
│  ✅ BETTER SECURITY                                          │
│     • Role-based routing                                    │
│     • Prevents unauthorized access                          │
│                                                              │
│  ✅ SIMPLIFIED ONBOARDING                                    │
│     • Role-specific registration forms                      │
│     • Relevant information only                             │
│                                                              │
│  ✅ EASIER MAINTENANCE                                       │
│     • Separate login/register pages                          │
│     • Clear separation of concerns                          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

