# Phase 1: Data Analytics & Business Intelligence

## Objective
This phase focuses on extracting actionable business insights from raw transactional data without relying on predictive modeling. The goal is to provide the executive team with a clear understanding of the financial damage, vulnerable payment instruments, and cyber footprints of the attackers.

## 🛠️ Tech Stack & Workflow
1. **Database Management:** MySQL (Localhost) via DBeaver.
2. **Data Ingestion & Transformation:** Advanced SQL (LEFT JOIN, Correlated Subqueries, Aggregations) to transform highly normalized raw data into business-ready metrics.
3. **Data Visualization:** Microsoft Power BI (Zero-Layouting Strategy with Custom Dark Mode UI).

## Key Actionable Insights
Based on the SQL extractions and Dashboard drill-downs, we identified critical vulnerabilities:
* **Massive Financial Impact:** The system successfully aggregated **20,663 fraud cases**, accounting for a total financial loss of **Rp47.7 Billion**.
* **Targeted Attack (Discover Credit):** While Visa and Mastercard have the highest volume, **Discover Credit** is the most vulnerable instrument with a **7.93% Fraud Rate** and extreme average loss per transaction (Rp5.4 Million).
* **Cyber Footprint (Protonmail):** The domain `protonmail.com` acts as a primary hub for attackers, recording a staggering **40.79% fraud rate** due to its military-grade encryption.
* **The Breakfast Anomaly:** Time-series analysis debunked the midnight-attack myth, revealing a massive spike in automated botnet attacks at **07:00 AM**, reaching a 10.61% fraud vulnerability rate.

## Folder Structure
* `/sql_scripts`: Contains the raw SQL scripts used for data extraction and metric formulation.
* `/dashboard`: Contains the Power BI file (`.pbix`) and a high-resolution screenshot of the final dashboard.
* `/aggregated_data`: Contains the lightweight, processed CSV files ready for BI consumption (Big Data abstracted).