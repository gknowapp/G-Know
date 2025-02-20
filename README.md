# G-Know

G-Know is a native Swift app designed for therapists to create, securely store, and share their genograms with their patients. A genogram is a visual representation of a person's family tree, history, and relationships. 

## Features

### For Therapists
- Secure login system for therapist accounts
- Patient management dashboard
- Custom genogram builder with:
  - Drag-and-drop interface
  - Multiple relationship types (marriage, engagement, separation, etc.)
  - Family member symbols and icons
  - Medical history tracking
  - Relationship status indicators
- Patient information management
- Secure sharing capabilities

### For Patients
- Secure access to shared genograms
- View-only mode for shared genograms
- Personal information management
- Therapist connection via access codes

## Technical Stack

### Core Technologies
- Swift
- SwiftUI
- PencilKit for drawing capabilities
- Airtable for backend database

### Key Components
- Custom drawing engine for genogram creation
- Real-time updates and synchronization
- Secure data storage and transmission
- Multi-device compatibility

## Security Features
- Encrypted data storage
- Secure authentication system
- HIPAA-compliant data handling
- Protected patient information

## Installation

1. Clone the repository
2. Install Xcode (minimum version 14.0)
3. Set up your Airtable credentials in the `Secrets` folder
4. Build and run the project

## Configuration

Create a `Secrets` folder in the project root with your Airtable credentials:

