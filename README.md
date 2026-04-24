[//]: # (Updated: April 24, 2025 | v2.1.0)
# SmartTech Connect

A full-stack hyperlocal marketplace platform that connects households with verified technicians. Built with React, Node.js, MongoDB, and deployed using Docker, Kubernetes, and Jenkins CI/CD.

![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Ready-326CE5?logo=kubernetes)
![Jenkins](https://img.shields.io/badge/Jenkins-CI/CD-D24939?logo=jenkins)

> **Original Source**: [subodh-001/smarttech_connect-main](https://github.com/subodh-001/smarttech_connect-main.git)

---

## 📋 Table of Contents

1. [Features](#features)
2. [Architecture](#architecture)
3. [Project Flow](#project-flow)
4. [Database Schema & Relations](#database-schema--relations)
5. [Tech Stack](#tech-stack)
6. [Prerequisites](#prerequisites)
7. [Quick Start](#quick-start)
8. [Local Development](#local-development)
9. [Docker Deployment](#docker-deployment)
10. [Kubernetes Deployment](#kubernetes-deployment)
11. [Jenkins CI/CD Setup](#jenkins-cicd-setup)
12. [Environment Variables](#environment-variables)
13. [API Documentation](#api-documentation)
14. [Troubleshooting](#troubleshooting)
15. [Contributing](#contributing)

---

## ✨ Features

### Customer Experience
- **OTP-protected onboarding** – Secure email verification with timeboxed codes
- **Dynamic dashboard** – Real-time stats (active jobs, completed bookings, spending)
- **Service request creation** – Category-based requests with surge pricing
- **Technician discovery** – Specialty filtering, distance/ETA calculation, map view
- **Booking management** – Full CRUD operations, reschedule, cancel, reviews
- **Live chat** – Real-time messaging with technicians
- **Live tracking** – Real-time service tracking with map, route, and ETA
- **Help center** – Searchable knowledge base and support tickets

### Technician Experience
- **KYC workflow** – Government ID and selfie verification
- **Profile management** – Multi-specialty expertise, service radius, certifications
- **Availability control** – Online/offline toggle, location updates
- **Job matching** – Radius-based job recommendations
- **Earnings dashboard** – Daily/weekly/monthly insights with rupee formatting

### Platform & Admin
- **Role-based authentication** – JWT-based access control (user, technician, admin)
- **Admin dashboard** – User/technician/service overview, KYC review queue
- **Technician matching** – Haversine distance calculation, ETA computation
- **Messaging persistence** – Embedded conversation history in service requests

---

## 🏗️ Architecture

```
smarttech_connect-main/
├── frontend/                    # React frontend application
│   ├── src/
│   │   ├── components/          # Reusable UI components
│   │   ├── pages/               # Route-level views
│   │   ├── contexts/            # Auth & global state
│   │   └── utils/               # Helper functions
│   ├── Dockerfile               # Frontend container image
│   └── nginx.conf               # Nginx configuration
├── backend/                     # Node.js backend API
│   ├── src/
│   │   ├── index.js             # Application entry point
│   │   ├── middleware/          # Auth middleware
│   │   ├── models/              # Mongoose schemas
│   │   ├── routes/              # API endpoints
│   │   └── services/            # Business logic
│   └── Dockerfile               # Backend container image
├── kubernetes/                  # Kubernetes manifests
│   ├── backend/                 # Backend deployment & service
│   ├── frontend/                # Frontend deployment & service
│   ├── mongodb/                 # MongoDB StatefulSet & service
│   ├── config/                  # ConfigMaps & secrets
│   ├── ingress.yaml             # Ingress configuration
│   └── hpa.yaml                 # Horizontal Pod Autoscaler
├── scripts/                     # Deployment scripts
├── docker-compose.yml           # Local development setup
├── Jenkinsfile                  # CI/CD pipeline
└── README.md                    # This file
```

---

## 🔄 Project Flow

### User Registration & Authentication Flow

```
┌─────────────┐
│   Landing   │
│    Page     │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│  Role Selection │
│  (User/Tech)    │
└──────┬──────────┘
       │
       ▼
┌─────────────────┐      ┌──────────────┐
│   Registration  │─────▶│  Send OTP    │
│      Form       │      │   (Email)    │
└──────┬──────────┘      └──────┬───────┘
       │                        │
       │                        ▼
       │                 ┌──────────────┐
       │                 │  Verify OTP  │
       │                 └──────┬───────┘
       │                        │
       ▼                        ▼
┌─────────────────┐      ┌──────────────┐
│  Create Account │      │  OTP Valid?  │
│   (User/Admin)  │      └──────┬───────┘
└──────┬──────────┘            │
       │                        │
       ▼                        ▼
┌─────────────────┐      ┌──────────────┐
│  Login Success  │◀─────│  Yes/No     │
│  (JWT Token)    │      └──────────────┘
└─────────────────┘
```

### Customer Booking Flow

```
┌──────────────────┐
│  User Dashboard  │
└────────┬─────────┘
         │
         ▼
┌──────────────────────┐
│ Create Service       │
│ Request              │
│ - Category           │
│ - Description        │
│ - Location           │
│ - Budget             │
│ - Priority           │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Calculate Surge      │
│ Pricing              │
│ (+10% high, +20%     │
│  urgent)             │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Find Technicians     │
│ - Filter by          │
│   specialty          │
│ - Calculate distance │
│ - Calculate ETA      │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Select Technician    │
│ & Request Booking    │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│ Booking Status:      │
│ PENDING              │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐      ┌──────────────────┐
│ Technician Accepts? │─────▶│  Status:         │
│                      │      │  CONFIRMED       │
└──────────┬───────────┘      └────────┬─────────┘
           │                           │
           │ No                        │
           ▼                           ▼
┌──────────────────────┐      ┌──────────────────┐
│ Status: CANCELLED    │      │  Status:         │
│                      │      │  IN_PROGRESS     │
└──────────────────────┘      └────────┬─────────┘
                                        │
                                        ▼
                               ┌──────────────────┐
                               │  Status:         │
                               │  COMPLETED       │
                               └────────┬─────────┘
                                        │
                                        ▼
                               ┌──────────────────┐
                               │  Rate & Review   │
                               │  Technician      │
                               └──────────────────┘
```

### Technician Workflow

```
┌──────────────────┐
│ Tech Onboarding  │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Complete Profile │
│ - Specialties    │
│ - Experience     │
│ - Service Radius │
│ - Hourly Rate    │
└──────────┬───────┘
           │
           ▼
┌──────────────────┐
│ Submit KYC       │
│ - Government ID  │
│ - Selfie         │
└──────────┬───────┘
           │
           ▼
┌──────────────────┐      ┌──────────────┐
│ KYC Status:      │─────▶│  Admin       │
│ UNDER_REVIEW     │      │  Reviews     │
└──────────┬───────┘      └──────┬───────┘
           │                     │
           │                     ▼
           │              ┌──────────────┐
           │              │  Approved?   │
           │              └──────┬───────┘
           │                    │
           │ Yes                │ No
           ▼                    ▼
┌──────────────────┐      ┌──────────────┐
│ KYC: APPROVED    │      │ KYC: REJECTED│
│                  │      │ (with feedback)│
└──────────┬───────┘      └───────────────┘
           │
           ▼
┌──────────────────┐
│ Toggle Online    │
│ Status           │
└──────────┬───────┘
           │
           ▼
┌──────────────────┐
│ View Available   │
│ Job Requests     │
│ (within radius)  │
└──────────┬───────┘
           │
           ▼
┌──────────────────┐
│ Accept/Decline   │
│ Booking Request  │
└──────────┬───────┘
           │
           ▼
┌──────────────────┐
│ Update Job       │
│ Status:          │
│ CONFIRMED →      │
│ IN_PROGRESS →    │
│ COMPLETED        │
└──────────┬───────┘
           │
           ▼
┌──────────────────┐
│ View Earnings    │
│ & Withdraw       │
│ (with PIN)       │
└──────────────────┘
```

### Messaging Flow

```
┌──────────────────┐
│ Service Request  │
│ Created          │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Conversation     │
│ Auto-Created     │
│ (embedded in     │
│  ServiceRequest) │
└──────────┬───────┘
           │
           ▼
┌──────────────────┐
│ User/Technician  │
│ Sends Message    │
│ - Text           │
│ - Image          │
│ - Location       │
│ - Booking Update │
└──────────┬───────┘
           │
           ▼
┌──────────────────┐
│ Message Stored   │
│ in ServiceRequest│
│ messages[] array │
└──────────┬───────┘
           │
           ▼
┌──────────────────┐
│ Delivery Status: │
│ SENT → DELIVERED │
│ → READ           │
└──────────────────┘
```

### Payment & Withdrawal Flow

```
┌──────────────────┐
│ Service          │
│ Completed        │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│ Payment Status:  │
│ AWAITING_PAYMENT │
└──────────┬───────┘
           │
           ▼
┌──────────────────┐
│ Customer Pays    │
│ (UPI/Cash/Card)  │
└──────────┬───────┘
           │
           ▼
┌──────────────────┐
│ Payment Status:  │
│ PAID             │
└──────────┬───────┘
           │
           ▼
┌──────────────────┐
│ Amount Added to  │
│ Technician       │
│ Earnings         │
└──────────┬───────┘
           │
           ▼
┌──────────────────┐
│ Technician       │
│ Requests         │
│ Withdrawal       │
│ (with 4-digit    │
│  PIN)            │
└──────────┬───────┘
           │
           ▼
┌──────────────────┐
│ Withdrawal       │
│ Status:          │
│ PENDING →        │
│ PROCESSING →     │
│ COMPLETED        │
└──────────────────┘
```

---

## 🗄️ Database Schema & Relations

### Entity Relationship Diagram

```
┌─────────────┐
│    User     │
│────────────│
│ _id (PK)    │
│ email (UK)  │
│ fullName    │
│ phone       │
│ role        │
│ addresses[] │
└──────┬──────┘
       │
       │ 1:1
       │
       ▼
┌─────────────┐
│ Technician  │
│────────────│
│ _id (PK)    │
│ userId (FK) │◀────┐
│ specialties │     │
│ kycStatus   │     │
│ hourlyRate  │     │
└──────┬──────┘     │
       │            │
       │ 1:N        │ 1:N
       │            │
       ▼            │
┌─────────────┐     │
│ServiceRequest│    │
│────────────│     │
│ _id (PK)    │     │
│ customerId  │─────┘
│ technicianId│─────┐
│ category    │     │
│ status      │     │
│ messages[]  │     │
│ finalCost   │     │
└──────┬──────┘     │
       │            │
       │ 1:N        │ 1:N
       │            │
       ▼            │
┌─────────────┐     │
│ Withdrawal  │     │
│────────────│     │
│ _id (PK)    │     │
│ technicianId│─────┘
│ userId (FK) │─────┘
│ amount      │
│ status      │
└─────────────┘

┌─────────────┐
│ OtpToken    │
│────────────│
│ _id (PK)    │
│ email (FK)  │
│ otpHash     │
│ expiresAt   │
└─────────────┘

┌─────────────┐
│SupportTicket│
│────────────│
│ _id (PK)    │
│ userId (FK) │─────┐
│ subject     │     │
│ status      │     │
└─────────────┘     │
                    │
                    │ References User
                    │ (optional)
```

### Table/Collection Details

#### 1. **User Collection**
```javascript
{
  _id: ObjectId,
  email: String (unique, indexed),
  passwordHash: String,
  fullName: String,
  phone: String,
  avatarUrl: String,
  role: Enum['user', 'technician', 'admin'],
  isActive: Boolean,
  address: String,
  city: String,
  state: String,
  postalCode: String,
  addresses: [{
    id: String,
    label: String,
    street: String,
    city: String,
    state: String,
    zipCode: String,
    isDefault: Boolean,
    coordinates: { lat: Number, lng: Number }
  }],
  publicId: String (unique, indexed),
  passwordChangedAt: Date,
  createdAt: Date,
  updatedAt: Date
}
```

**Relations:**
- `1:1` with `Technician` (via `userId`)
- `1:N` with `ServiceRequest` (as `customerId`)
- `1:N` with `SupportTicket` (as `userId`)
- `1:N` with `Withdrawal` (as `userId`)

---

#### 2. **Technician Collection**
```javascript
{
  _id: ObjectId,
  userId: ObjectId (FK → User, indexed),
  publicId: String (unique, indexed),
  specialties: [String] (indexed),
  yearsOfExperience: Number,
  hourlyRate: Number,
  averageRating: Number,
  totalJobs: Number,
  bio: String,
  certifications: [String],
  serviceRadius: Number,
  currentStatus: Enum['available', 'busy', 'offline'],
  lastLocation: { lat: Number, lng: Number },
  kycStatus: Enum['not_submitted', 'under_review', 'approved', 'rejected'],
  kycGovernmentDocumentPath: String,
  kycSelfieDocumentPath: String,
  kycSubmittedAt: Date,
  kycReviewedAt: Date,
  kycFeedback: String,
  payoutMethod: Enum['upi', 'bank_transfer', 'none'],
  upiId: String,
  bankAccountName: String,
  bankAccountNumber: String,
  bankIfscCode: String,
  withdrawalPIN: String (hashed),
  createdAt: Date,
  updatedAt: Date
}
```

**Relations:**
- `1:1` with `User` (via `userId`)
- `1:N` with `ServiceRequest` (as `technicianId`)
- `1:N` with `Withdrawal` (as `technicianId`)

---

#### 3. **ServiceRequest Collection**
```javascript
{
  _id: ObjectId,
  customerId: ObjectId (FK → User, required),
  technicianId: ObjectId (FK → User, optional),
  category: Enum['plumbing', 'electrical', 'hvac', ...],
  title: String,
  description: String,
  priority: Enum['low', 'medium', 'high', 'urgent'],
  status: Enum['pending', 'confirmed', 'in_progress', 'completed', 'cancelled'],
  scheduledDate: Date,
  completionDate: Date,
  estimatedDuration: Number,
  budgetMin: Number,
  budgetMax: Number,
  finalCost: Number,
  paymentStatus: Enum['pending', 'awaiting_payment', 'paid', 'failed'],
  paymentMethod: String,
  reviewRating: Number,
  reviewComment: String,
  locationAddress: String,
  locationCoordinates: { lat: Number, lng: Number },
  images: [String],
  requirements: Mixed,
  messages: [{
    senderId: ObjectId (FK → User),
    senderRole: Enum['user', 'technician', 'admin'],
    contentType: Enum['text', 'image', 'location', 'booking_update'],
    content: String,
    metadata: Mixed,
    deliveryStatus: Enum['sent', 'delivered', 'read'],
    createdAt: Date
  }],
  technicianComments: [{
    authorId: ObjectId (FK → User),
    authorRole: Enum['technician', 'admin'],
    body: String,
    attachments: [{ name: String, url: String }],
    createdAt: Date
  }],
  createdAt: Date,
  updatedAt: Date
}
```

**Relations:**
- `N:1` with `User` (as `customerId`)
- `N:1` with `User` (as `technicianId`)
- Embedded `messages[]` array (no separate collection)
- Embedded `technicianComments[]` array (no separate collection)

---

#### 4. **Withdrawal Collection**
```javascript
{
  _id: ObjectId,
  technicianId: ObjectId (FK → Technician, indexed),
  userId: ObjectId (FK → User, indexed),
  amount: Number (min: 0),
  upiId: String,
  status: Enum['pending', 'processing', 'completed', 'failed', 'cancelled'],
  transactionId: String (unique),
  processedAt: Date,
  failureReason: String,
  createdAt: Date,
  updatedAt: Date
}
```

**Relations:**
- `N:1` with `Technician` (via `technicianId`)
- `N:1` with `User` (via `userId`)

---

#### 5. **OtpToken Collection**
```javascript
{
  _id: ObjectId,
  email: String (indexed),
  purpose: String (indexed),
  otpHash: String,
  expiresAt: Date (indexed, TTL),
  attempts: Number,
  verified: Boolean,
  verifiedAt: Date,
  createdAt: Date,
  updatedAt: Date
}
```

**Relations:**
- References `User.email` (not a foreign key, but linked by email)

---

#### 6. **SupportTicket Collection**
```javascript
{
  _id: ObjectId,
  userId: ObjectId (FK → User, optional),
  name: String,
  email: String,
  subject: String,
  category: Enum['technical', 'billing', 'account', 'service', 'feature', 'other'],
  priority: Enum['low', 'medium', 'high', 'critical'],
  message: String,
  channel: Enum['email', 'phone', 'chat'],
  status: Enum['open', 'in_progress', 'resolved', 'closed'],
  metadata: Object,
  lastActivityAt: Date,
  createdAt: Date,
  updatedAt: Date
}
```

**Relations:**
- `N:1` with `User` (via `userId`, optional)

---

#### 7. **HelpArticle Collection**
```javascript
{
  _id: ObjectId,
  title: String,
  content: String,
  category: String,
  tags: [String],
  views: Number,
  helpful: Number,
  createdAt: Date,
  updatedAt: Date
}
```

**Relations:**
- Standalone collection (no foreign keys)

---

#### 8. **UserSettings Collection**
```javascript
{
  _id: ObjectId,
  userId: ObjectId (FK → User),
  notifications: {
    email: Boolean,
    sms: Boolean,
    push: Boolean
  },
  preferences: Mixed,
  createdAt: Date,
  updatedAt: Date
}
```

**Relations:**
- `1:1` with `User` (via `userId`)

---

#### 9. **AdminSetting Collection**
```javascript
{
  _id: ObjectId,
  key: String (unique),
  value: Mixed,
  description: String,
  updatedAt: Date
}
```

**Relations:**
- Standalone collection (no foreign keys)

---

### Key Relationships Summary

| Relationship | Type | Description |
|--------------|------|-------------|
| `User` → `Technician` | 1:1 | One user can have one technician profile |
| `User` → `ServiceRequest` | 1:N | One user can create many service requests |
| `Technician` → `ServiceRequest` | 1:N | One technician can handle many service requests |
| `User` → `Withdrawal` | 1:N | One user (technician) can have many withdrawals |
| `Technician` → `Withdrawal` | 1:N | One technician can have many withdrawals |
| `User` → `SupportTicket` | 1:N | One user can create many support tickets |
| `User` → `UserSettings` | 1:1 | One user has one settings record |
| `ServiceRequest.messages[]` | Embedded | Messages are embedded in ServiceRequest (no separate collection) |
| `ServiceRequest.technicianComments[]` | Embedded | Comments are embedded in ServiceRequest (no separate collection) |

### Indexes

**User Collection:**
- `email` (unique)
- `publicId` (unique)
- `googleId` (sparse)

**Technician Collection:**
- `userId` (indexed)
- `publicId` (unique)
- `specialties` (indexed)

**ServiceRequest Collection:**
- `customerId` (indexed via populate)
- `technicianId` (indexed via populate)
- `status` (for filtering)

**Withdrawal Collection:**
- `technicianId` (indexed)
- `userId` (indexed)
- `status` (indexed)
- `transactionId` (unique)

**OtpToken Collection:**
- `email + purpose` (compound unique)
- `expiresAt` (TTL index for auto-deletion)

---

## 🛠️ Tech Stack

| Layer | Technologies |
|-------|-------------|
| **Frontend** | React 18, Vite, React Router v6, Tailwind CSS, Axios, Leaflet Maps |
| **Backend** | Node.js, Express, Mongoose, MongoDB, JWT, bcrypt, Nodemailer |
| **Database** | MongoDB (Atlas or self-hosted) |
| **Containerization** | Docker, Docker Compose |
| **Orchestration** | Kubernetes |
| **CI/CD** | Jenkins |
| **Web Server** | Nginx (for frontend) |

---

## 📦 Prerequisites

### For Local Development
- **Node.js** 18+ and npm
- **MongoDB** (Atlas account or local installation)
- **Git**

### For Docker Deployment
- **Docker** 20.10+
- **Docker Compose** 2.0+

### For Kubernetes Deployment
- **kubectl** (Kubernetes CLI)
- **Kubernetes cluster** (minikube, kind, or cloud provider)
- **Docker images** pushed to registry (Docker Hub, ECR, GCR, etc.)

### For Jenkins CI/CD
- **Jenkins** 2.400+ (LTS recommended)
- **Jenkins Plugins**: Docker Pipeline, Kubernetes CLI, Git
- **Docker Hub** account (or other container registry)

---

## 🚀 Quick Start

### Option 1: Docker Compose (Recommended for Quick Start)

```bash
# Clone repository
git clone https://github.com/subodh-001/smarttech_connect-main.git
cd smarttech_connect-main

# Start all services
docker-compose up -d

# Access application
# Frontend: http://localhost:3000
# Backend: http://localhost:5000
```

### Option 2: Local Development

```bash
# Install dependencies
cd frontend && npm install
cd ../backend && npm install

# Start backend (Terminal 1)
cd backend
npm run dev

# Start frontend (Terminal 2)
cd frontend
npm run dev
```

---

## 💻 Local Development

### 1. Clone Repository
```bash
git clone https://github.com/subodh-001/smarttech_connect-main.git
cd smarttech_connect-main
```

### 2. Install Dependencies

**Frontend:**
```bash
cd frontend
npm install
```

**Backend:**
```bash
cd backend
npm install
```

### 3. Configure Environment Variables

Create `backend/.env`:
```env
MONGODB_URI=mongodb+srv://<user>:<pass>@cluster.mongodb.net/smarttech_connect
JWT_SECRET=your-secret-key-change-in-production
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password
FRONTEND_URL=http://localhost:5173
PORT=5000
```

### 4. Start Development Servers

**Terminal 1 - Backend:**
```bash
cd backend
npm run dev
```

**Terminal 2 - Frontend:**
```bash
cd frontend
npm run dev
```

- Frontend: http://localhost:5173
- Backend API: http://localhost:5000

### 5. Available Scripts

**Frontend:**
```bash
npm run dev      # Start dev server
npm run build    # Production build
npm run preview  # Preview production build
```

**Backend:**
```bash
npm run dev      # Start with nodemon (auto-reload)
npm start        # Production server
npm run create-admin -- <email> <password> "Name"  # Create admin user
```

---

## 🐳 Docker Deployment

### Building Docker Images

#### Method 1: Using Build Script
```bash
# Make script executable
chmod +x scripts/docker-build.sh

# Build both images
./scripts/docker-build.sh
```

#### Method 2: Manual Build
```bash
# Build backend
docker build -t subodh40/smarttech-backend:latest ./backend

# Build frontend
docker build -t subodh40/smarttech-frontend:latest ./frontend
```

### Pushing to Docker Hub

```bash
# Login to Docker Hub
docker login

# Tag images (if not already tagged)
docker tag smarttech-backend:latest subodh40/smarttech-backend:latest
docker tag smarttech-frontend:latest subodh40/smarttech-frontend:latest

# Push images
docker push subodh40/smarttech-backend:latest
docker push subodh40/smarttech-frontend:latest
```

**Your Docker Hub Profile**: https://hub.docker.com/repositories/subodh40

### Running with Docker Compose

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f backend
docker-compose logs -f frontend

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# Restart services
docker-compose restart

# Check status
docker-compose ps
```

**Access Points:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000
- MongoDB: localhost:27017

### Docker Compose Configuration

The `docker-compose.yml` includes:
- **MongoDB**: Persistent volumes for data
- **Backend**: Environment variables, volume mounts for uploads/logs
- **Frontend**: Nginx serving static files
- **Networking**: Bridge network for service communication
- **Health Checks**: Automatic container health monitoring

---

## ☸️ Kubernetes Deployment

### Prerequisites

1. **Kubernetes Cluster** (choose one):
   - **Local**: minikube, kind, or k3s
   - **Cloud**: AWS EKS, Google GKE, Azure AKS

2. **kubectl** configured to access your cluster

3. **Docker images** pushed to registry (Docker Hub: `subodh40/smarttech-backend:latest`)

### Step-by-Step Deployment

#### Step 1: Create Namespace
```bash
kubectl apply -f kubernetes/namespace.yaml
```

#### Step 2: Create Secrets
```bash
kubectl create secret generic smarttech-secrets \
  --from-literal=mongodb-uri='mongodb://admin:password@mongodb:27017/smarttech_connect?authSource=admin' \
  --from-literal=mongodb-username='admin' \
  --from-literal=mongodb-password='your-secure-password' \
  --from-literal=jwt-secret='your-jwt-secret-key-min-32-chars' \
  --from-literal=email-user='your-email@gmail.com' \
  --from-literal=email-pass='your-app-password' \
  -n smarttech
```

**⚠️ Important**: Replace all placeholder values with your actual credentials!

#### Step 3: Apply ConfigMap
```bash
kubectl apply -f kubernetes/config/configmap.yaml
```

#### Step 4: Deploy MongoDB
```bash
kubectl apply -f kubernetes/mongodb/
```

Wait for MongoDB to be ready:
```bash
kubectl wait --for=condition=ready pod -l app=mongodb -n smarttech --timeout=300s
```

#### Step 5: Deploy Backend
```bash
kubectl apply -f kubernetes/backend/
```

#### Step 6: Deploy Frontend
```bash
kubectl apply -f kubernetes/frontend/
```

#### Step 7: Apply Ingress (Optional)
```bash
kubectl apply -f kubernetes/ingress.yaml
```

**Note**: Requires ingress controller (nginx-ingress, traefik, etc.) and SSL certificate manager.

#### Step 8: Apply Horizontal Pod Autoscaler
```bash
kubectl apply -f kubernetes/hpa.yaml
```

### Verify Deployment

```bash
# Check pods
kubectl get pods -n smarttech

# Check services
kubectl get svc -n smarttech

# Check deployments
kubectl get deployments -n smarttech

# View logs
kubectl logs -f deployment/smarttech-backend -n smarttech
kubectl logs -f deployment/smarttech-frontend -n smarttech

# Describe pod (for troubleshooting)
kubectl describe pod <pod-name> -n smarttech
```

### Update Deployment

```bash
# Update image
kubectl set image deployment/smarttech-backend \
  backend=subodh40/smarttech-backend:new-tag \
  -n smarttech

# Check rollout status
kubectl rollout status deployment/smarttech-backend -n smarttech

# Rollback if needed
kubectl rollout undo deployment/smarttech-backend -n smarttech
```

### Auto-Scaling

The HPA configuration automatically scales:
- **Backend**: 3-10 replicas (based on CPU/memory)
- **Frontend**: 2-5 replicas (based on CPU/memory)

View HPA status:
```bash
kubectl get hpa -n smarttech
```

### Using Deployment Script

```bash
# Make script executable
chmod +x scripts/k8s-deploy.sh

# Run deployment
./scripts/k8s-deploy.sh
```

---

## 🔄 Jenkins CI/CD Setup

### Prerequisites

1. **Jenkins Server** (2.400+ LTS)
2. **Required Plugins**:
   - Docker Pipeline
   - Kubernetes CLI
   - Git
   - Pipeline

### Step 1: Install Jenkins Plugins

1. Go to **Jenkins Dashboard** → **Manage Jenkins** → **Plugins**
2. Install:
   - Docker Pipeline
   - Kubernetes CLI
   - Git
   - Pipeline

### Step 2: Configure Jenkins Credentials

Go to **Jenkins Dashboard** → **Manage Jenkins** → **Credentials** → **System** → **Global credentials**

#### Add Docker Hub Credentials

1. Click **Add Credentials**
2. Kind: **Username with password**
3. ID: `docker-credentials`
4. Username: Your Docker Hub username (`subodh40`)
5. Password: Your Docker Hub password
6. Click **OK**

#### Add Docker Registry URL

1. Click **Add Credentials**
2. Kind: **Secret text**
3. ID: `docker-registry-url`
4. Secret: `subodh40` (your Docker Hub username)
5. Click **OK**

#### Add Kubernetes Config

1. Click **Add Credentials**
2. Kind: **Secret file**
3. ID: `kubeconfig`
4. File: Upload your `~/.kube/config` file
5. Click **OK**

### Step 3: Create Jenkins Pipeline

1. Go to **Jenkins Dashboard** → **New Item**
2. Enter name: `smarttech-connect-pipeline`
3. Select **Pipeline**
4. Click **OK**

#### Configure Pipeline

1. **Pipeline Definition**: Pipeline script from SCM
2. **SCM**: Git
3. **Repository URL**: Your Git repository URL
4. **Credentials**: Add if repository is private
5. **Branch**: `*/main` or `*/master`
6. **Script Path**: `Jenkinsfile`
7. Click **Save**

### Step 4: Run Pipeline

1. Click **Build Now** on the pipeline
2. Monitor build progress in **Console Output**

### Pipeline Stages

The `Jenkinsfile` includes these stages:

1. **Checkout** - Pulls code from Git
2. **Build & Test Backend** - Installs dependencies, runs tests
3. **Build & Test Frontend** - Builds React application
4. **Build Docker Images** - Creates container images
5. **Push Docker Images** - Uploads to Docker Hub
6. **Security Scan** - Scans images for vulnerabilities (optional)
7. **Deploy to Kubernetes** - Applies Kubernetes manifests
8. **Health Check** - Verifies deployment health
9. **Rollback** - Automatic rollback on failure

### Automatic Triggers

Configure webhooks for automatic builds:

1. In your Git repository, add webhook:
   - URL: `http://your-jenkins-url/github-webhook/`
   - Events: Push, Pull Request

2. In Jenkins pipeline, configure:
   - **Build Triggers** → **GitHub hook trigger for GITScm polling**

### Pipeline Environment Variables

The pipeline uses these environment variables (set in Jenkins):
- `DOCKER_REGISTRY`: Docker Hub username (`subodh40`)
- `KUBERNETES_NAMESPACE`: Kubernetes namespace (`smarttech`)

---

## 🔐 Environment Variables

### Backend Environment Variables

Create `backend/.env`:

```env
# Server Configuration
NODE_ENV=production
PORT=5000

# Database
MONGODB_URI=mongodb://admin:password@mongodb:27017/smarttech_connect?authSource=admin

# Authentication
JWT_SECRET=your-secret-key-minimum-32-characters-long

# Frontend URL
FRONTEND_URL=https://app.smarttechconnect.com

# Email Configuration (Optional)
EMAIL_USER=your-email@gmail.com
EMAIL_PASS=your-app-password
EMAIL_FROM="SmartTech Connect <your-email@gmail.com>"
```

### Frontend Environment Variables

For production builds, set:
```env
VITE_API_URL=https://api.smarttechconnect.com
```

### Kubernetes Secrets

Secrets are managed via Kubernetes Secrets (see [Kubernetes Deployment](#-kubernetes-deployment) section).

---

## 📚 API Documentation

### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/send-otp` | Send OTP for registration/reset |
| POST | `/api/auth/verify-otp` | Verify OTP code |
| POST | `/api/auth/register` | Register new user |
| POST | `/api/auth/login` | User login |

### User Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/users/me` | Get current user profile |
| PUT | `/api/users/me` | Update user profile |
| PUT | `/api/users/me/password` | Change password |

### Service Request Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/service-requests` | List service requests |
| POST | `/api/service-requests` | Create service request |
| GET | `/api/service-requests/:id` | Get service request details |
| PATCH | `/api/service-requests/:id/status` | Update request status |

### Technician Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/technicians/available` | Get available technicians |
| GET | `/api/technicians/me/profile` | Get technician profile |
| PUT | `/api/technicians/me/profile` | Update technician profile |
| GET | `/api/technicians/me/kyc` | Get KYC status |
| POST | `/api/technicians/me/kyc` | Upload KYC documents |

### Dashboard Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/dashboard/user` | User dashboard data |
| GET | `/api/dashboard/technician` | Technician dashboard data |

**All protected routes require**: `Authorization: Bearer <token>`

---

## 🐛 Troubleshooting

### Docker Issues

**Problem**: Port already in use
```bash
# Find process using port
lsof -i :5000
# or
netstat -tulpn | grep :5000

# Kill process
kill <PID>

# Or change port in docker-compose.yml
```

**Problem**: Container won't start
```bash
# Check logs
docker-compose logs backend
docker-compose logs frontend

# Check container status
docker-compose ps

# Restart services
docker-compose restart
```

**Problem**: Image pull errors
```bash
# Login to Docker Hub
docker login

# Pull images manually
docker pull subodh40/smarttech-backend:latest
docker pull subodh40/smarttech-frontend:latest
```

### Kubernetes Issues

**Problem**: Pods not starting
```bash
# Check pod status
kubectl get pods -n smarttech

# Describe pod for details
kubectl describe pod <pod-name> -n smarttech

# Check logs
kubectl logs <pod-name> -n smarttech

# Check events
kubectl get events -n smarttech --sort-by='.lastTimestamp'
```

**Problem**: Image pull errors
```bash
# Verify image exists in registry
docker pull subodh40/smarttech-backend:latest

# Check imagePullPolicy in deployment
kubectl get deployment smarttech-backend -n smarttech -o yaml | grep imagePullPolicy

# Create image pull secret if using private registry
kubectl create secret docker-registry regcred \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=subodh40 \
  --docker-password=<your-password> \
  -n smarttech
```

**Problem**: Services not accessible
```bash
# Check service endpoints
kubectl get endpoints -n smarttech

# Check service configuration
kubectl get svc -n smarttech
kubectl describe svc smarttech-backend -n smarttech

# Port forward for testing
kubectl port-forward svc/smarttech-backend 5000:5000 -n smarttech
```

**Problem**: MongoDB connection issues
```bash
# Check MongoDB pod
kubectl get pods -l app=mongodb -n smarttech

# Check MongoDB logs
kubectl logs -l app=mongodb -n smarttech

# Verify MongoDB URI in secrets
kubectl get secret smarttech-secrets -n smarttech -o jsonpath='{.data.mongodb-uri}' | base64 -d
```

### Jenkins Issues

**Problem**: Pipeline fails at Docker build
- Verify Docker daemon is running on Jenkins server
- Check Docker credentials are correct
- Ensure Jenkins user has Docker permissions

**Problem**: Kubernetes deployment fails
- Verify kubeconfig is correct
- Check namespace exists: `kubectl get namespace smarttech`
- Verify secrets are created
- Check Jenkins has kubectl access

**Problem**: Build hangs
- Check Jenkins server resources (CPU, memory)
- Review pipeline logs for specific error
- Verify network connectivity to Docker Hub

### General Issues

**Problem**: Health checks failing
```bash
# Test backend health
curl http://localhost:5000/api/health

# Test frontend health
curl http://localhost/health

# Check health check configuration in deployment
kubectl get deployment smarttech-backend -n smarttech -o yaml | grep -A 10 livenessProbe
```

**Problem**: Database connection errors
- Verify MongoDB URI is correct
- Check MongoDB is running and accessible
- Verify network connectivity
- Check firewall rules

---

## 📝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the ISC License.

---

## 🔗 Links

- **Docker Hub**: https://hub.docker.com/repositories/subodh40
- **GitHub Repository**: https://github.com/subodh-001/smarttech_connect-main
- **Deployment Guide**: See [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed deployment instructions

---

## 📞 Support

For issues or questions:
1. Check [Troubleshooting](#-troubleshooting) section
2. Review [DEPLOYMENT.md](./DEPLOYMENT.md)
3. Open an issue on GitHub

---

## 🎯 Roadmap

- [x] Docker containerization
- [x] Kubernetes orchestration
- [x] Jenkins CI/CD pipeline
- [ ] WebSocket real-time notifications
- [ ] Payment integration
- [ ] Automated testing suite
- [ ] Monitoring and logging (Prometheus, Grafana)
- [ ] Admin moderation UI

---

**Made with ❤️ for connecting households with trusted technicians**

Happy building! 🚀
