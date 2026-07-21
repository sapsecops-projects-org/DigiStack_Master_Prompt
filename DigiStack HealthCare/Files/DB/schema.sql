-- DigiStack Health Enterprise — PostgreSQL Schema
-- Sprint 1.4 — FHIR-aligned schema design (09_REALISM_ENHANCEMENTS.md Section 1)
-- All data is synthetic. Never store real PHI, even as placeholder-looking data.

CREATE EXTENSION IF NOT EXISTS "pgcrypto"; -- provides gen_random_uuid()

-- ============================================================
-- Concept dictionary (OpenMRS-inspired lookup table — 09_REALISM_ENHANCEMENTS.md
-- Section 4 / Sprint 1.2 module-boundary check). Holds both appointment service
-- types and lab-order/referral codes, distinguished by `category`, instead of
-- hardcoding free text on every row that needs one.
-- ============================================================
CREATE TABLE service_types (
    service_type_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code            VARCHAR(50) NOT NULL UNIQUE,      -- e.g. 'GEN_CHECKUP', 'CBC_PANEL'
    description     VARCHAR(200) NOT NULL,            -- e.g. 'General checkup', 'CBC panel'
    category        VARCHAR(20) NOT NULL CHECK (category IN ('APPOINTMENT', 'LAB_ORDER', 'REFERRAL')),
    created_at      TIMESTAMP NOT NULL DEFAULT now()
);

-- ============================================================
-- Clinicians — staff who log in and provide care (Login, Sprint 2.1)
-- ============================================================
CREATE TABLE clinicians (
    clinician_id    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    role            VARCHAR(30) NOT NULL CHECK (role IN ('PHYSICIAN', 'NURSE', 'FRONT_DESK', 'ADMIN')),
    specialty       VARCHAR(100),                     -- nullable; mainly for PHYSICIAN role
    email           VARCHAR(255) NOT NULL UNIQUE,      -- login username
    password_hash   VARCHAR(255) NOT NULL,
    created_at      TIMESTAMP NOT NULL DEFAULT now()
);

-- ============================================================
-- Patients — maps to FHIR Patient resource, structurally only (Section 1)
-- ============================================================
CREATE TABLE patients (
    patient_id      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    synthetic_mrn   VARCHAR(20) NOT NULL UNIQUE,       -- e.g. 'SYN-000123' — never a real MRN
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    date_of_birth   DATE NOT NULL,
    gender          VARCHAR(10) NOT NULL CHECK (gender IN ('male', 'female', 'other', 'unknown')), -- FHIR administrative-gender
    phone           VARCHAR(20),
    email           VARCHAR(255) UNIQUE,               -- login username (patient portal)
    password_hash   VARCHAR(255),
    address_line    VARCHAR(200),
    city            VARCHAR(100),
    state           VARCHAR(50),
    zip             VARCHAR(20),
    created_at      TIMESTAMP NOT NULL DEFAULT now(),

    CONSTRAINT chk_dob_not_future CHECK (date_of_birth <= CURRENT_DATE)
);

-- ============================================================
-- Appointments — maps to FHIR Appointment resource (Section 1).
-- Also serves as Visit History once status = 'fulfilled' — no separate
-- visits table, kept deliberately simple per Master Context Section 4.
-- ============================================================
CREATE TABLE appointments (
    appointment_id   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id        UUID NOT NULL REFERENCES patients(patient_id),
    clinician_id       UUID NOT NULL REFERENCES clinicians(clinician_id),
    service_type_id     UUID REFERENCES service_types(service_type_id),
    status              VARCHAR(20) NOT NULL DEFAULT 'booked'
                          CHECK (status IN ('booked', 'arrived', 'fulfilled', 'cancelled', 'noshow')), -- FHIR appointment status
    start_time          TIMESTAMP NOT NULL,
    end_time            TIMESTAMP NOT NULL,
    notes               TEXT,
    created_at          TIMESTAMP NOT NULL DEFAULT now(),
    updated_at          TIMESTAMP NOT NULL DEFAULT now(),

    CONSTRAINT chk_appt_time_order CHECK (end_time > start_time)
);

-- ============================================================
-- Service Requests — lab orders & referrals, maps to FHIR ServiceRequest
-- (Section 1). Status lifecycle per Section 2 (feeds Sprint 2.17):
--   SUBMITTED -> QUEUED -> PROCESSING -> ACCEPTED|REJECTED -> COMPLETED
-- ============================================================
CREATE TABLE service_requests (
    request_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    patient_id                 UUID NOT NULL REFERENCES patients(patient_id),
    requesting_clinician_id     UUID NOT NULL REFERENCES clinicians(clinician_id),
    service_type_id             UUID REFERENCES service_types(service_type_id),
    request_type                VARCHAR(20) NOT NULL CHECK (request_type IN ('LAB_ORDER', 'REFERRAL')),
    priority                    VARCHAR(10) NOT NULL DEFAULT 'routine'
                                  CHECK (priority IN ('routine', 'urgent', 'stat')),
    status                      VARCHAR(20) NOT NULL DEFAULT 'SUBMITTED'
                                  CHECK (status IN ('SUBMITTED', 'QUEUED', 'PROCESSING', 'ACCEPTED', 'REJECTED', 'COMPLETED')),
    created_at                   TIMESTAMP NOT NULL DEFAULT now(),
    updated_at                   TIMESTAMP NOT NULL DEFAULT now()
);

-- Indexes for the lookups every module above will actually run
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_clinician_time ON appointments(clinician_id, start_time);
CREATE INDEX idx_service_requests_patient ON service_requests(patient_id);
CREATE INDEX idx_service_requests_status ON service_requests(status);
