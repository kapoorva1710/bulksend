# BulkSend 🚀

A premium **Bulk SMS Broadcasting** web application built with **Spring Boot** + **MySQL**.

## Live Demo
> 🌐 Deployed on Render — link coming after first deployment

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

## Local Setup

1. **Clone the repo**
   ```bash
   git clone https://github.com/kapoorva1710/bulksend.git
   cd bulksend
   ```

2. **Set environment variables** (or edit `application.properties`):
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

4. **Open in browser**: [http://localhost:8081/dashboard.html](http://localhost:8081/dashboard.html)

## Deploy to Render
Click the button below to deploy to Render in one click:

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy)
