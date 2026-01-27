# RFID Medical System

A FastAPI-based medical patient management system with RFID integration.

## Features
- Patient information lookup via RFID
- Prescription management with drug conflict checking
- Emergency mode for critical care
- Health scoring system
- Timeline view of patient history

## Setup
1. Clone the repository
2. Install dependencies: `pip install -r requirements.txt`
3. Setup database with `rfid.sql`
4. Run: `uvicorn app.main:app --reload`

## Credentials (Demo)
- Doctor: `drissm` / `password123`
- Pharmacist: `linaf` / `password123`
- Emergency: `samiro` / `password123`

## Patient IDs (RFID001 to RFID050)