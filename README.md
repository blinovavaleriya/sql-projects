# SQL Projects Portfolio

This repository contains a collection of SQL queries focused on user behavior analytics, A/B testing, email engagement, account activity, and marketing performance.  
Each file represents a standalone analytical scenario built on real data-processing and business-oriented logic.

---

## Projects Overview

### 1. A/B Test — Event-Level Metrics  
**File:** `ab_test_event_metrics.sql`  
Creates a unified event-level dataset for A/B test evaluation by combining:  
- session-level data  
- user events  
- new account creation  
- sessions that resulted in orders  

The output is a long-format table (`event_name`, `value`) used for comparing test and control groups across multiple metrics.

**Key Skills:** CTEs, window functions, UNION ALL, event aggregation, experiment segmentation.

---

### 2. Email Analytics — Monthly Account Activity  
**File:** `account_email_activity_by_month.sql`  
Calculates email sending activity per account on a monthly basis, including:  
- total messages sent per account  
- each account’s share of the monthly total  
- the first and last message date within the month  

**Key Skills:** date manipulation, grouping, percentage calculations, monthly aggregations.

---

### 3. Accounts & Emails — Country-Level Overview  
**File:** `accounts_and_emails_overview.sql`  
Combines account metrics with email interaction data to generate a country-level performance summary.  
The query calculates:  
- total accounts  
- total email activity  
- ranking of countries based on activity volume  

**Key Skills:** analytic functions, DENSE_RANK(), window aggregates, performance comparison.

---

### 4. Paid Search — Monthly Cost Distribution  
**File:** `paid_search_monthly_cost_distribution.sql`  
Aggregates paid search expenses by month and calculates:  
- monthly total cost  
- each month’s percentage contribution to the overall spend  

**Key Skills:** SUM() OVER(), time-based aggregation, marketing analytics.

---

## Technologies & SQL Techniques
- SQL (Google BigQuery)  
- Common Table Expressions (CTEs)  
- Window functions  
- Advanced JOIN operations  
- UNION / UNION ALL  
- Event and session modeling  
- Multi-level aggregation  

---

## Analytical Focus Areas
- A/B test evaluation  
- Event and funnel analysis  
- Marketing performance tracking  
- User and account behavior insights  
- Email engagement analytics  
- Cost distribution modeling  
