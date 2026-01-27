from fastapi import FastAPI, HTTPException, Depends, Request
from fastapi.middleware.cors import CORSMiddleware
from datetime import datetime, date, timedelta
from app.database import SessionLocal
from sqlalchemy import text
from fastapi.responses import FileResponse, RedirectResponse, JSONResponse
from fastapi.staticfiles import StaticFiles
from pathlib import Path
from sqlalchemy.orm import Session
import json
import os
from typing import List

LOGS = []

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def log_action(uid, action):
    LOGS.append({
        "uid": uid,
        "action": action,
        "time": datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    })

app = FastAPI(title="Smart RFID Medical System")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

BASE_DIR = Path(__file__).parent.parent
frontend_dir = BASE_DIR / "frontend"
app.mount("/static", StaticFiles(directory=frontend_dir), name="static")

# ===== AUTHENTICATION =====
@app.get("/")
def root():
    return FileResponse(str(frontend_dir / "index.html"))

@app.get("/login")
def login_page():
    return FileResponse(str(frontend_dir / "login.html"))

@app.post("/login")
def login(data: dict, db: Session = Depends(get_db)):
    username = data.get("username", "").strip()
    password = data.get("password", "").strip()
    
    user = db.execute(text("""
        SELECT * FROM user WHERE username = :username
    """), {"username": username}).fetchone()
    
    if not user:
        raise HTTPException(status_code=401, detail="Invalid credentials")
    
    # Accept empty password or password123 for demo
    if password == user.password_hash or password == "password123" or user.password_hash == "" or user.password_hash == "password123":
        # Generate avatar color based on user_id
        avatar_color = generate_avatar_color(user.user_id)
        return {
            "success": True,
            "user": {
                "id": user.user_id,
                "name": f"{user.first_name} {user.last_name}",
                "role": user.role,
                "avatar": user.first_name[0].upper(),
                "avatar_color": avatar_color
            }
        }
    else:
        raise HTTPException(status_code=401, detail="Invalid credentials")

def generate_avatar_color(user_id: int):
    colors = [
        "#3498db", "#2ecc71", "#e74c3c", "#f39c12", "#9b59b6",
        "#1abc9c", "#d35400", "#c0392b", "#27ae60", "#8e44ad"
    ]
    return colors[user_id % len(colors)]

@app.get("/logout")
def logout():
    return RedirectResponse("/login")

@app.get("/emergency-page")
def emergency_page():
    return FileResponse(str(frontend_dir / "emergency.html"))

@app.get("/style.css")
def get_css():
    return FileResponse(str(frontend_dir / "style.css"))

# ===== PATIENT DATA =====
@app.get("/patient-details/{uid}")
def get_patient_details(uid: str, db=Depends(get_db)):
    patient = db.execute(text("""
        SELECT * FROM patient WHERE patient_id = :uid
    """), {"uid": uid}).fetchone()
    
    if not patient:
        raise HTTPException(404, "Patient not found")
    
    # Calculate age
    dob = patient.date_of_birth
    today = date.today()
    age = today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))
    
    # Get allergies
    allergies = db.execute(text("""
        SELECT name, severity FROM allergy WHERE patient_id = :uid
    """), {"uid": uid}).fetchall()
    
    # Get chronic diseases
    diseases = db.execute(text("""
        SELECT name FROM chronicdisease WHERE patient_id = :uid
    """), {"uid": uid}).fetchall()
    
    # Get last visit
    last_visit = db.execute(text("""
        SELECT visit_date, notes FROM visit 
        WHERE patient_id = :uid 
        ORDER BY visit_date DESC LIMIT 1
    """), {"uid": uid}).fetchone()
    
    # Get current prescriptions
    prescriptions = db.execute(text("""
        SELECT d.drug_name, pd.dosage, pd.frequency, pd.duration
        FROM prescription p
        JOIN prescription_drug pd ON p.prescription_id = pd.prescription_id
        JOIN drug d ON pd.drug_id = d.drug_id
        WHERE p.patient_id = :uid AND p.status = 'active'
        ORDER BY p.prescription_date DESC
    """), {"uid": uid}).fetchall()
    
    # Calculate health score
    health_score = calculate_health_score(age, len(allergies), len(diseases), len(prescriptions))
    
    return {
        "patient_id": patient.patient_id,
        "first_name": patient.first_name,
        "last_name": patient.last_name,
        "date_of_birth": str(patient.date_of_birth),
        "age": age,
        "sex": patient.sex,
        "blood_type": patient.blood_type,
        "emergency_contact": patient.emergency_contact,
        "allergies": [{"name": a.name, "severity": a.severity} for a in allergies],
        "chronic_diseases": [d.name for d in diseases],
        "last_visit_date": str(last_visit.visit_date) if last_visit else None,
        "last_visit_notes": last_visit.notes if last_visit else None,
        "prescriptions": [
            {
                "drug_name": p.drug_name,
                "dosage": p.dosage,
                "frequency": p.frequency,
                "duration": p.duration
            } for p in prescriptions
        ],
        "health_score": health_score
    }

def calculate_health_score(age: int, allergy_count: int, disease_count: int, prescription_count: int):
    """Calculate simple health score (0-100)"""
    base_score = 100
    
    # Age factor (max -20 points)
    age_factor = min(age / 100 * 20, 20)
    
    # Allergy factor (Severe: -15, Moderate: -7, Mild: -3)
    allergy_factor = allergy_count * 5
    
    # Disease factor (-10 per disease)
    disease_factor = disease_count * 10
    
    # Prescription factor (-3 per prescription)
    prescription_factor = prescription_count * 3
    
    score = base_score - age_factor - allergy_factor - disease_factor - prescription_factor
    
    # Ensure score is between 0-100
    return max(0, min(100, int(score)))

# ===== PRESCRIPTION HISTORY WITH TIMELINE =====
@app.get("/prescription-history/{uid}")
def get_prescription_history(uid: str, db=Depends(get_db)):
    try:
        # Get all prescriptions
        prescriptions = db.execute(text("""
            SELECT 
                p.prescription_id,
                p.prescription_date,
                p.status,
                d.drug_name,
                pd.dosage,
                pd.frequency,
                pd.duration
            FROM prescription p
            JOIN prescription_drug pd ON p.prescription_id = pd.prescription_id
            JOIN drug d ON pd.drug_id = d.drug_id
            WHERE p.patient_id = :uid
            ORDER BY p.prescription_date DESC
        """), {"uid": uid}).fetchall()
        
        # Get visits for timeline
        visits = db.execute(text("""
            SELECT visit_id, visit_date, notes
            FROM visit 
            WHERE patient_id = :uid
            ORDER BY visit_date DESC
            LIMIT 10
        """), {"uid": uid}).fetchall()
        
        # Get audit log events
        audits = db.execute(text("""
            SELECT log_id, timestamp, action
            FROM auditlog 
            WHERE patient_id = :uid
            ORDER BY timestamp DESC
            LIMIT 10
        """), {"uid": uid}).fetchall()
        
        # Prepare timeline items
        timeline_items = []
        
        # Add prescriptions to timeline
        for rx in prescriptions:
            timeline_items.append({
                "id": rx.prescription_id,
                "date": str(rx.prescription_date),
                "type": "prescription",
                "title": f"Prescribed {rx.drug_name}",
                "description": f"Status: {rx.status} | Dosage: {rx.dosage} | Frequency: {rx.frequency} | Duration: {rx.duration}",
                "icon": "fas fa-pills"
            })
        
        # Add visits to timeline
        for visit in visits:
            timeline_items.append({
                "id": visit.visit_id,
                "date": str(visit.visit_date),
                "type": "visit",
                "title": "Medical Visit",
                "description": visit.notes or "No notes",
                "icon": "fas fa-stethoscope"
            })
        
        # Add audit events to timeline
        for audit in audits:
            timeline_items.append({
                "id": audit.log_id,
                "date": str(audit.timestamp),
                "type": "audit",
                "title": "System Action",
                "description": audit.action,
                "icon": "fas fa-history"
            })
        
        # Sort by date (newest first)
        timeline_items.sort(key=lambda x: x['date'], reverse=True)
        
        # Group prescriptions by prescription_id
        grouped_prescriptions = {}
        for rx in prescriptions:
            if rx.prescription_id not in grouped_prescriptions:
                grouped_prescriptions[rx.prescription_id] = {
                    "prescription_id": rx.prescription_id,
                    "date": str(rx.prescription_date),
                    "status": rx.status,
                    "drugs": []
                }
            grouped_prescriptions[rx.prescription_id]["drugs"].append({
                "drug_name": rx.drug_name or "Unknown Drug",
                "dosage": rx.dosage or "Not specified",
                "frequency": rx.frequency or "Not specified",
                "duration": rx.duration or "Not specified"
            })
        
        return {
            "prescriptions": list(grouped_prescriptions.values()),
            "timeline": timeline_items[:20]
        }
        
    except Exception as e:
        print(f"Error in prescription history: {e}")
        return {"prescriptions": [], "timeline": []}

# ===== PATIENT SEARCH =====
@app.get("/search-patients")
def search_patients(search: str, db=Depends(get_db)):
    if not search or len(search) < 2:
        return []
    
    patients = db.execute(text("""
        SELECT patient_id, first_name, last_name, date_of_birth
        FROM patient 
        WHERE first_name LIKE :search 
           OR last_name LIKE :search
           OR patient_id LIKE :search
        LIMIT 10
    """), {"search": f"%{search}%"}).fetchall()
    
    return [
        {
            "patient_id": p.patient_id,
            "name": f"{p.first_name} {p.last_name}",
            "dob": str(p.date_of_birth)
        } for p in patients
    ]

# ===== EMERGENCY DATA =====
@app.get("/emergency-details/{uid}")
def get_emergency_details(uid: str, db=Depends(get_db)):
    patient = db.execute(text("""
        SELECT * FROM patient WHERE patient_id = :uid
    """), {"uid": uid}).fetchone()
    
    if not patient:
        raise HTTPException(404, "Patient not found")
    
    dob = patient.date_of_birth
    today = date.today()
    age = today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))
    
    allergies = db.execute(text("""
        SELECT name, severity FROM allergy WHERE patient_id = :uid
    """), {"uid": uid}).fetchall()
    
    diseases = db.execute(text("""
        SELECT name FROM chronicdisease WHERE patient_id = :uid
    """), {"uid": uid}).fetchall()
    
    prescriptions = db.execute(text("""
        SELECT d.drug_name, pd.dosage
        FROM prescription p
        JOIN prescription_drug pd ON p.prescription_id = pd.prescription_id
        JOIN drug d ON pd.drug_id = d.drug_id
        WHERE p.patient_id = :uid AND p.status = 'active'
    """), {"uid": uid}).fetchall()
    
    return {
        "patient_id": patient.patient_id,
        "name": f"{patient.first_name} {patient.last_name}",
        "blood_type": patient.blood_type,
        "age": age,
        "allergies": [{"name": a.name, "severity": a.severity} for a in allergies],
        "chronic_diseases": [d.name for d in diseases],
        "current_prescriptions": [{"drug_name": p.drug_name, "dosage": p.dosage} for p in prescriptions],
        "emergency_contact": patient.emergency_contact
    }

# ===== DRUG MANAGEMENT =====
@app.get("/drug-list")
def get_drug_list(db=Depends(get_db)):
    drugs = db.execute(text("""
        SELECT drug_id, drug_name, description FROM drug ORDER BY drug_name
    """)).fetchall()
    
    return [{"drug_id": d.drug_id, "drug_name": d.drug_name, "description": d.description} for d in drugs]

@app.get("/search-drug")
def search_drug(term: str, db=Depends(get_db)):
    drugs = db.execute(text("""
        SELECT drug_id, drug_name, description 
        FROM drug 
        WHERE drug_name LIKE :term
        LIMIT 10
    """), {"term": f"%{term}%"}).fetchall()
    
    return [{"drug_id": d.drug_id, "drug_name": d.drug_name, "description": d.description} for d in drugs]

# ===== CONFLICT CHECKING =====
from app.rules import check_prescription_conflicts

@app.post("/check-prescription-conflicts")
def check_prescription_conflicts_api(data: dict):
    drugs = data.get("drugs", [])
    allergies = data.get("allergies", [])
    diseases = data.get("diseases", [])
    
    # Check conflicts
    result = check_prescription_conflicts(drugs, allergies, diseases)
    
    # Clean up warnings
    clean_warnings = []
    seen_warnings = set()
    
    for warning in result["warnings"]:
        # Remove prefix if exists
        clean_warning = warning.replace("⚠️ ", "").replace("ℹ️ ", "")
        if clean_warning not in seen_warnings:
            seen_warnings.add(clean_warning)
            clean_warnings.append(clean_warning)
    
    # If there are errors, block submission
    if result["errors"]:
        return {
            "warnings": clean_warnings,
            "errors": result["errors"],
            "can_submit": False
        }
    
    return {
        "warnings": clean_warnings,
        "errors": result["errors"],
        "can_submit": True
    }

# ===== PRESCRIPTION MANAGEMENT =====
@app.post("/add-prescription")
def create_prescription_api(data: dict, db=Depends(get_db)):
    try:
        patient_id = data["patient_id"]
        drugs = data["drugs"]
        
        # Check conflicts first (double-check on server side)
        patient = db.execute(text("""
            SELECT p.patient_id, 
                   GROUP_CONCAT(DISTINCT a.name) as allergies,
                   GROUP_CONCAT(DISTINCT cd.name) as diseases
            FROM patient p
            LEFT JOIN allergy a ON p.patient_id = a.patient_id
            LEFT JOIN chronicdisease cd ON p.patient_id = cd.patient_id
            WHERE p.patient_id = :uid
            GROUP BY p.patient_id
        """), {"uid": patient_id}).fetchone()
        
        allergies = patient.allergies.split(",") if patient.allergies else []
        diseases = patient.diseases.split(",") if patient.diseases else []
        
        conflict_result = check_prescription_conflicts(drugs, allergies, diseases)
        if conflict_result["errors"]:
            return {
                "success": False, 
                "error": "Critical conflicts detected", 
                "conflicts": conflict_result["errors"],
                "type": "conflict"
            }
        
        # Get current user from session
        user_id = 1  # For demo
        
        # Create prescription
        result = db.execute(text("""
            INSERT INTO prescription (patient_id, user_id, prescription_date, status)
            VALUES (:patient, :user, CURDATE(), 'active')
        """), {"patient": patient_id, "user": user_id})
        
        prescription_id = result.lastrowid
        
        # Add each drug
        for drug in drugs:
            # Find drug ID by name
            drug_record = db.execute(text("""
                SELECT drug_id FROM drug WHERE LOWER(drug_name) = LOWER(:name)
            """), {"name": drug["name"]}).fetchone()
            
            if not drug_record:
                # Create the drug if not found
                db.execute(text("""
                    INSERT INTO drug (drug_name, description) VALUES (:name, '')
                """), {"name": drug["name"]})
                drug_record = db.execute(text("""
                    SELECT drug_id FROM drug WHERE drug_name = :name
                """), {"name": drug["name"]}).fetchone()
            
            if drug_record:
                db.execute(text("""
                    INSERT INTO prescription_drug
                    (prescription_id, drug_id, dosage, frequency, duration)
                    VALUES (:pid, :drug, :dosage, :freq, :duration)
                """), {
                    "pid": prescription_id,
                    "drug": drug_record.drug_id,
                    "dosage": drug.get("dosage", "As directed"),
                    "freq": drug.get("frequency", "Once daily"),
                    "duration": drug.get("duration", "7 days")
                })
        
        # Add to audit log
        db.execute(text("""
            INSERT INTO auditlog (action, timestamp, patient_id, user_id)
            VALUES ('Created prescription', NOW(), :patient, :user)
        """), {"patient": patient_id, "user": user_id})
        
        db.commit()
        
        # Log the action
        log_action(patient_id, f"Prescribed {len(drugs)} medication(s)")
        
        return {"success": True, "prescription_id": prescription_id, "type": "success"}
    except Exception as e:
        db.rollback()
        return {"success": False, "error": str(e), "type": "error"}

# ===== UTILITY ENDPOINTS =====
@app.get("/logs")
def view_logs():
    return LOGS

@app.get("/test")
def test_endpoint():
    return {"status": "OK", "message": "System is running"}

"""if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)"""

if __name__ == "__main__":
    import uvicorn
    port = int(os.environ.get("PORT", 8000))
    uvicorn.run(app, host="0.0.0.0", port=port)