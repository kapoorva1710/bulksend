# BulkSend 🚀

A premium **Bulk SMS Broadcasting** web application built with **Spring Boot** + **MySQL**.

---

## ⚡ One-Click Run on Any Windows PC

Open **PowerShell** on any PC and paste this single command — it will automatically clone, build, and open BulkSend in your browser:

```powershell
irm https://raw.githubusercontent.com/kapoorva1710/bulksend/master/run.ps1 | iex
```

> **Requirements:** [Git](https://git-scm.com) · [Java 17+](https://adoptium.net) · [Maven](https://maven.apache.org/download.cgi)

---

## 🌐 Live Demo
> Deployed on Render — link coming after first deployment

## Features
- 📋 Manage contacts (add manually or upload via CSV)
- ✉️ Create and send bulk SMS campaigns
- 📊 View campaign history
- 💎 Premium glassmorphic dark-mode UI

## Tech Stack
| Layer | Technology |
|---|---|
| Backend | Java 17 + Spring Boot 3.2.5 |
| Database | MySQL (JPA/Hibernate) |
| Frontend | HTML, CSS, Vanilla JS |
| Hosting | Render (Docker) |

---

## 🌿 Branch Strategy

| Branch | Purpose |
|---|---|
| `master` | Stable, production-ready code |
| `dev` | Active development — make changes here, then PR to master |

**Workflow:**
```
dev  →  (test & verify)  →  master  →  auto-deploys to Render
```

---

## Local Setup (Manual)

1. **Clone the repo**
   ```bash
   git clone https://github.com/kapoorva1710/bulksend.git
   cd bulksend
   ```

2. **Set environment variables**
   ```bash
   export DB_URL=jdbc:mysql://localhost:3306/bulksend
   export DB_USERNAME=root
   export DB_PASSWORD=yourpassword
   export SMS_GATEWAY_URL=http://your-sms-gateway/send
   ```

3. **Run the app**
   ```bash
   cd bulksender
   mvn spring-boot:run
   ```

4. **Open in browser:** [http://localhost:8081/dashboard.html](http://localhost:8081/dashboard.html)

---

## Deploy to Render
[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy)
