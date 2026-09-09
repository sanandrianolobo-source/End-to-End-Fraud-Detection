# Phase 3: AI Engineering & API Deployment

## Objective
To deploy the trained LightGBM model as a scalable, real-time microservice using FastAPI. This bridges the gap between Data Science and Software Engineering, allowing front-end applications to seamlessly consume the AI model.

## Tech Stack
* **Framework:** FastAPI, Uvicorn
* **Language:** Python
* **Data Handling:** Pydantic (Data Validation), Pandas

## Architecture & Features
1. **Real-Time Inference:** Processes transaction payloads and returns intelligent decisions in milliseconds.
2. **Dynamic Data Imputation:** Automatically handles missing columns sent by the client by replacing them with `NaN` (natively handled by LightGBM).
3. **Type Safety & Error Handling:** Coerces dirty string inputs into numeric types, preventing `500 Internal Server Error` caused by Data Type Mismatches.
4. **Business Logic Integration:** Applies the custom threshold (`0.66`) optimized in Phase 2 to ensure maximum Customer Experience (CX) while filtering out fraud.

## API Endpoint Details
* **Route:** `POST /api/v1/predict`
* **Input:** JSON payload containing transaction features.
* **Output:** JSON response providing `transaction_status` (APPROVED/BLOCKED), absolute `fraud_probability`, and actionable recommendations.