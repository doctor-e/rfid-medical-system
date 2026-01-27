# Enhanced drug interaction rules
DRUG_INTERACTIONS = {
    "ibuprofen": {
        "conflicts_with": ["aspirin", "warfarin", "corticosteroids", "naproxen", "diclofenac"],
        "warnings": ["May increase bleeding risk with blood thinners", 
                    "Avoid in patients with ulcers or kidney disease",
                    "May reduce effectiveness of blood pressure medications"]
    },
    "aspirin": {
        "conflicts_with": ["ibuprofen", "warfarin", "clopidogrel", "corticosteroids"],
        "warnings": ["Severe bleeding risk when combined with other blood thinners",
                    "Avoid in patients with bleeding disorders"]
    },
    "penicillin": {
        "conflicts_with": ["methotrexate", "birth_control_pills"],
        "warnings": ["May reduce effectiveness of birth control", 
                    "Monitor for allergic reactions"]
    },
    "warfarin": {
        "conflicts_with": ["ibuprofen", "aspirin", "antibiotics", "paracetamol", "omeprazole"],
        "warnings": ["Severe bleeding risk with NSAIDs",
                    "Requires frequent INR monitoring"]
    },
    "prednisone": {
        "conflicts_with": ["diabetes_meds", "nsaids", "warfarin"],
        "warnings": ["May increase blood sugar", 
                    "Increased ulcer risk with NSAIDs",
                    "May cause fluid retention"]
    },
    "metformin": {
        "conflicts_with": ["contrast_dyes", "alcohol"],
        "warnings": ["Risk of lactic acidosis with renal impairment",
                    "May interact with certain heart medications"]
    },
    "lisinopril": {
        "conflicts_with": ["nsaids", "diuretics", "potassium_supplements"],
        "warnings": ["Increased risk of kidney damage with NSAIDs",
                    "May cause hyperkalemia"]
    },
    "omeprazole": {
        "conflicts_with": ["warfarin", "clopidogrel", "methotrexate"],
        "warnings": ["May reduce effectiveness of other medications",
                    "Long-term use may cause vitamin B12 deficiency"]
    },
    "simvastatin": {
        "conflicts_with": ["grapefruit_juice", "antibiotics", "antifungals"],
        "warnings": ["Risk of muscle damage when combined with certain antibiotics",
                    "Avoid grapefruit products"]
    },
    "paracetamol": {
        "conflicts_with": ["alcohol", "warfarin"],
        "warnings": ["Liver toxicity risk with high doses or alcohol",
                    "May increase bleeding risk with warfarin"]
    }
}

# Drug-disease contraindications
DISEASE_CONTRAS = {
    "ibuprofen": ["ulcer", "kidney disease", "liver disease", "heart disease", "asthma", "bleeding disorder"],
    "aspirin": ["ulcer", "bleeding disorder", "asthma", "gout"],
    "prednisone": ["diabetes", "osteoporosis", "glaucoma", "hypertension", "infection"],
    "warfarin": ["bleeding disorders", "liver disease", "ulcer", "hypertension"],
    "penicillin": ["penicillin allergy", "kidney disease"],
    "metformin": ["kidney disease", "liver disease", "heart failure"],
    "lisinopril": ["pregnancy", "angioedema", "kidney disease"],
    "omeprazole": ["liver disease", "osteoporosis"],
    "simvastatin": ["liver disease", "kidney disease", "thyroid disorder"],
    "paracetamol": ["liver disease", "alcoholism"]
}

# Allergy cross-reactivity
ALLERGY_CROSS_REACTIONS = {
    "penicillin": ["cephalosporins", "amoxicillin", "ampicillin"],
    "sulfa": ["sulfamethoxazole", "furosemide", "hydrochlorothiazide"],
    "aspirin": ["nsaids", "ibuprofen", "naproxen"],
    "latex": ["banana", "avocado", "kiwi", "chestnut"]
}

def check_drug_conflicts(drug_name, patient_allergies, patient_diseases, existing_drugs=[]):
    """Check for drug-allergy, drug-disease, and drug-drug interactions"""
    warnings = []
    errors = []
    
    drug_lower = drug_name.lower()
    
    # 1. Check allergies
    for allergy in patient_allergies:
        allergy_lower = allergy.lower()
        # Check for exact match
        if drug_lower == allergy_lower:
            errors.append(f"Patient is ALLERGIC to {allergy}")
        
        # Check for cross-reactivity
        if allergy_lower in ALLERGY_CROSS_REACTIONS:
            cross_reactive_drugs = ALLERGY_CROSS_REACTIONS[allergy_lower]
            if any(cross_drug in drug_lower for cross_drug in cross_reactive_drugs):
                warnings.append(f"{drug_name} may cross-react with {allergy} allergy")
    
    # 2. Check disease contraindications
    for disease in patient_diseases:
        disease_lower = disease.lower()
        
        # Check direct contraindications
        if drug_lower in DISEASE_CONTRAS:
            if any(contra in disease_lower for contra in DISEASE_CONTRAS[drug_lower]):
                errors.append(f"{drug_name} is contraindicated in patients with {disease}")
        
        # Special cases
        if drug_lower == "ibuprofen" and any(d in disease_lower for d in ["asthma", "ulcer", "kidney"]):
            warnings.append(f"{drug_name} may worsen {disease}")
        
        if drug_lower == "prednisone" and "diabetes" in disease_lower:
            warnings.append(f"{drug_name} may increase blood sugar in diabetic patients")
    
    # 3. Check drug-drug interactions
    if drug_lower in DRUG_INTERACTIONS:
        for existing_drug in existing_drugs:
            existing_lower = existing_drug.lower()
            if existing_lower in DRUG_INTERACTIONS[drug_lower]["conflicts_with"]:
                errors.append(f"{drug_name} dangerously interacts with {existing_drug}")
        
        # Add general warnings
        for warning in DRUG_INTERACTIONS[drug_lower]["warnings"]:
            warnings.append(warning)
    
    # 4. Specific known dangerous combinations
    dangerous_combos = [
        ("ibuprofen", "warfarin"),
        ("aspirin", "warfarin"),
        ("ibuprofen", "aspirin"),
        ("prednisone", "nsaids")
    ]
    
    for combo in dangerous_combos:
        if drug_lower == combo[0].lower() and any(combo[1].lower() == ed.lower() for ed in existing_drugs):
            errors.append(f"{combo[0]} + {combo[1]} = High risk of bleeding/ulcers")
    
    return {"warnings": warnings, "errors": errors}

def check_prescription_conflicts(prescription_drugs, patient_allergies, patient_diseases):
    """Check conflicts for multiple drugs in a prescription"""
    all_warnings = []
    all_errors = []
    
    # Extract drug names for interaction checking
    drug_names = [drug["name"].lower() for drug in prescription_drugs]
    
    # Check each drug against others
    for i, drug in enumerate(prescription_drugs):
        other_drugs = [pd["name"] for j, pd in enumerate(prescription_drugs) if j != i]
        result = check_drug_conflicts(drug["name"], patient_allergies, patient_diseases, other_drugs)
        all_warnings.extend(result["warnings"])
        all_errors.extend(result["errors"])
    
    # Check for duplicate drugs
    seen_drugs = set()
    for drug in prescription_drugs:
        drug_lower = drug["name"].lower()
        if drug_lower in seen_drugs:
            all_warnings.append(f"{drug['name']} appears multiple times in prescription")
        seen_drugs.add(drug_lower)
    
    # Remove duplicates while preserving order
    all_warnings = list(dict.fromkeys(all_warnings))
    all_errors = list(dict.fromkeys(all_errors))
    
    # Sort errors to show critical ones first
    all_errors.sort(key=lambda x: x, reverse=True)
    
    return {"warnings": all_warnings, "errors": all_errors}