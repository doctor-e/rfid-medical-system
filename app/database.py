"""from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.ext.declarative import declarative_base

DATABASE_URL = "mysql+pymysql://root:fe=1-vts/vTd@localhost/rfid"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()"""
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.ext.declarative import declarative_base
import os
from urllib.parse import urlparse

# Get database URL from environment variable
DATABASE_URL = os.getenv('DATABASE_URL')

if DATABASE_URL and DATABASE_URL.startswith('mysql://'):
    # Convert mysql:// to mysql+pymysql:// for SQLAlchemy
    DATABASE_URL = DATABASE_URL.replace('mysql://', 'mysql+pymysql://', 1)

if not DATABASE_URL:
    # Fallback to local database for development
    DATABASE_URL = "mysql+pymysql://root:password@localhost/rfid"

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()