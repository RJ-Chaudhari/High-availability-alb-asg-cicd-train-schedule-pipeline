# Security Group Configuration

## 1. Jenkins-SG
Inbound:
- SSH (22) → My IP
- 8080 → 0.0.0.0/0 (for webhook testing)

Outbound:
- All traffic allowed

---

## 2. ALB-SG
Inbound:
- HTTP (80) → 0.0.0.0/0

Outbound:
- HTTP (80) → App-Server-SG

---

## 3. App-Server-SG
Inbound:
- HTTP (80) → ALB-SG
- SSH (22) → Jenkins-SG

Outbound:
- All traffic allowed

Security group referencing is used instead of open CIDR rules.
