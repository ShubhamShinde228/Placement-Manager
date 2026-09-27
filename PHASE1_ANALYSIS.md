# PHASE 1 ANALYSIS REPORT
## Placement360 — Complete Project Inspection

---

## 1. CURRENT ARCHITECTURE

```
Browser → JSP → Servlet (Controller) → DAO → JDBC → MySQL (placement_manager)
```

**Package Structure:**
- `com.placement.controller` — 11 Servlets
- `com.placement.dao`        — 9 DAOs
- `com.placement.model`      — 8 Models
- `com.placement.service`    — EligibilityService, ApplicationService, PlacementService
- `com.placement.filter`     — AuthFilter
- `com.placement.util`       — DBConnection, WebUtil

**Technology Stack (Confirmed):**
- Java 17, Jakarta Servlet 6.0, JSP, JSTL 3.0
- Apache Tomcat 10.1 (jakarta.servlet.* confirmed — NO javax.servlet)
- MySQL (database: placement_manager)
- Maven (pom.xml confirms war packaging)
- Bootstrap 5.3.3 + Bootstrap Icons 1.11.3

---

## 2. CURRENT URL / SERVLET MAPPINGS

| Servlet              | URL Pattern     | JSP            |
|----------------------|-----------------|----------------|
| LoginServlet         | /login          | login.jsp      |
| LogoutServlet        | /logout         | (redirect)     |
| StudentServlet       | /students       | students.jsp   |
| CompanyServlet       | /companies      | companies.jsp  |
| DriveServlet         | /drives         | drives.jsp     |
| ApplicationServlet   | /applications   | applications.jsp |
| InterviewServlet     | /interviews     | interviews.jsp |
| SelectionServlet     | /selections     | selections.jsp |
| NotificationServlet  | /notifications  | notifications.jsp |
| ReportServlet        | /reports        | reports.jsp    |
| SettingsServlet      | /settings       | settings.jsp   |

**Welcome File:** login.jsp (unauthenticated users see login directly)

---

## 3. CONFIRMED DATABASE SCHEMA

### Table: `students`
- student_id, name, email, phone, branch, cgpa (DECIMAL 4,2), backlogs (INT)

### Table: `companies`
- company_id, name, sector, hr_name, hr_email, hr_phone
- NOTE: code uses sector/hr_name/hr_email/hr_phone (NOT industry/location/email/website)

### Table: `drives`
- drive_id, company_id (FK), job_role, drive_date (DATE), venue, 
  min_cgpa (DECIMAL), max_backlogs (INT), eligible_branches (VARCHAR), 
  status (UPCOMING|OPEN|CLOSED)

### Table: `applications`
- application_id, student_id (FK), drive_id (FK), applied_date (DATE)
- status: APPLIED | UNDER_REVIEW | SHORTLISTED | INTERVIEW | SELECTED | REJECTED
- UNIQUE constraint on (student_id, drive_id)

### Table: `interviews`
- interview_id, application_id (FK), round_name (Aptitude|Technical|HR), 
  interview_datetime (TIMESTAMP), result (PENDING|PASS|FAIL)

### Table: `selections`
- selection_id, student_id (FK), drive_id (FK), package_lpa (DECIMAL),
  offer_status (OFFERED|ACCEPTED|DECLINED)
- UNIQUE constraint on (student_id, drive_id)

### Table: `notifications`
- id, message, created_at (TIMESTAMP), is_read (BOOLEAN)

### Table: `users`
- user_id, username, password (plaintext), role

---

## 4. CURRENT NAVIGATION (FLAT - NO LOGICAL GROUPING)

Sidebar links (all at same level):
- Dashboard
- Students
- Companies
- Drives
- Applications
- Interviews
- Selections
- Reports
- Settings

**Problems:** No logical grouping. Flat CRUD navigation with no business flow visible.

---

## 5. EXISTING BUSINESS WORKFLOW (CONFIRMED)

Student → (EligibilityService checks) → Application (APPLIED) 
  → UNDER_REVIEW → SHORTLISTED → INTERVIEW → SELECTED / REJECTED

Eligibility checks (in EligibilityService.java):
1. Student exists
2. Drive exists
3. Drive status NOT CLOSED (only OPEN drives accept applications)
4. Student CGPA >= drive min_cgpa
5. Student backlogs <= drive max_backlogs
6. Student branch in eligible_branches (or ALL)
7. Student has NOT already applied (hasApplied in ApplicationDAO)
8. Student NOT already selected (hasBeenSelected in SelectionDAO)

Interview Rounds: Aptitude | Technical | HR (result: PENDING | PASS | FAIL)
Selection requires at least one PASS interview.

---

## 6. PROBLEMS FOUND

### CRITICAL
- No route for dashboard — dashboard.jsp accessed directly (not via servlet), bypasses proper data loading
- Drive status "ACTIVE" referenced in EligibilityService as !CLOSED, but actual DB values are UPCOMING/OPEN/CLOSED — the check only blocks CLOSED, NOT UPCOMING — bug exists where UPCOMING drives may accept applications

### HIGH
- DB password exposed in DBConnection.java (hardcoded "shubham@1234")
- No redirect from / to login — welcome file is login.jsp directly
- Notifications table may not exist if ForceSchemaFix was not re-run

### MEDIUM
- dashboard.jsp loaded via JSP scriptlets hitting DAOs directly (no Servlet controller)
- header.jsp imports NotificationDAO directly — if notifications table missing, crashes entire header for all pages
- header.jsp unread count query runs on EVERY page load
- No breadcrumbs on any page
- Empty states exist in some pages but inconsistent styling

### LOW
- e.printStackTrace() throughout all DAOs (no proper logging)
- ForceSchemaFix.java, TestDB.java, ModuleSchemaUpdate.java are leftover utility files in project root

---

## 7. FILES THAT WILL BE MODIFIED (Phase 1)

| File | Reason |
|------|--------|
| `includes/header.jsp` | New grouped sidebar navigation |
| `includes/footer.jsp` | No changes needed |
| `dashboard.jsp` | Redesign as Placement Command Center |
| `students.jsp` | Add page header, breadcrumb, empty state |
| `companies.jsp` | Add page header, breadcrumb, empty state |
| `drives.jsp` | Add page header, breadcrumb, tab structure |
| `applications.jsp` | Improve status visibility, page header |
| `interviews.jsp` | Improve pipeline visualization |
| `selections.jsp` | Add page header, offer status prep |
| `reports.jsp` | Rename to Analytics, add categories |
| `settings.jsp` | Add page header |
| `notifications.jsp` | Add page header |

---

## 8. FILES THAT MUST NOT BE MODIFIED

| File | Reason |
|------|--------|
| All DAO classes | Business logic is correct |
| All Servlet classes | URL mappings are correct |
| EligibilityService.java | Working business rules |
| ApplicationService.java | Working workflow |
| PlacementService.java | Working selection logic |
| AuthFilter.java | Security is correct |
| WebUtil.java | Utilities are correct |
| DBConnection.java | Leave as-is for local dev |
| pom.xml | Dependencies are correct |
| web.xml | Mappings are correct |
| All Model classes | Correct data structures |

---

## 9. PROPOSED NEW NAVIGATION

```
🏠 Dashboard

── PLACEMENT MANAGEMENT ──
   👨‍🎓 Students
   🏢 Companies
   💼 Placement Drives

── RECRUITMENT PROCESS ──
   📋 Applications
   🎤 Interviews

── OUTCOMES ──
   🏆 Selections

── ANALYTICS ──
   📊 Reports / Analytics

── ADMINISTRATION ──
   🔔 Notifications
   ⚙ Settings
```

Future placeholders (disabled/coming-soon badges):
- Eligibility Checker (under Recruitment Process)
- Assessments (under Recruitment Process)
- Shortlisting (under Recruitment Process)
- Offers (under Outcomes)

---

## 10. DASHBOARD RESTRUCTURE PLAN

**Top:** Welcome greeting + date

**KPI Cards (live DB data):**
- Total Students (StudentDAO.getAllStudents().size())
- Total Companies (CompanyDAO.getAllCompanies().size())
- Active Drives (drives with status=OPEN — needs new DriveDAO method)
- Total Applications (ApplicationDAO.getAllApplications().size())
- Total Interviews (InterviewDAO.getAllInterviews().size())
- Final Selections (SelectionDAO.getAllSelections().size())

**Pipeline Visual:** Horizontal step indicator using existing data counts

**Active Drives Table:** Shows OPEN drives with company, role, date, status

**No fake numbers anywhere.**

---

Analysis complete. Ready to implement Phase 1.
