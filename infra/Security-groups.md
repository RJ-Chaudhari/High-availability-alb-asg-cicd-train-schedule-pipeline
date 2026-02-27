# Security Group Design – Reference-Based Model

Security groups are configured using SG-to-SG references instead of wide CIDR rules.

---

## Jenkins-SG

Purpose: CI server access

Inbound:
- TCP 22 → Admin IP only
- TCP 8080 → Public (temporary for webhook testing)

Outbound:
- All traffic allowed

---

## ALB-SG

Purpose: Public entry point

Inbound:
- TCP 80 → 0.0.0.0/0

Outbound:
- TCP 80 → App-Server-SG (Security Group reference)

---

## App-Server-SG

Purpose: Application runtime instances

Inbound:
- TCP 80 → ALB-SG
- TCP 22 → Jenkins-SG (optional for controlled access)

Outbound:
- All traffic allowed (required for DockerHub image pull)

---

## Security Principles Applied

- No public exposure of application instances
- Layered access control
- SG referencing instead of open CIDR
- Separation of CI and runtime layers
