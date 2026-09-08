# Phase 2: Data Science & Machine Learning

## Objective
This phase focuses on building a highly robust, production-ready machine learning model to detect fraudulent transactions. The primary goal is to maximize the detection of true fraud while maintaining a frictionless experience for legitimate customers (Prioritizing Precision).

## Tech Stack & Workflow
* **Environment:** Python (Jupyter Notebook).
* **Core Libraries:** Pandas, Scikit-Learn, LightGBM, XGBoost, CatBoost, SHAP.
* **Architecture:** Super Ensemble (Manual Soft Voting 1:1:1) combined with Time-Aware Splitting to prevent data leakage.

## Engineering Highlights
Instead of using standard textbook methods, this project implements industry-level strategies:
1. **Algorithm-Aware Preprocessing:** Intentionally bypassed manual missing value imputation. Instead, gradient boosting algorithms (XGBoost/LightGBM) were utilized to handle `NaN` values natively, preserving the original footprint of the attackers.
2. **Mega Feature Engineering:** 
   * Formulated `Ultimate_UID` (Card + Address combinations) to track specific entities.
   * Engineered `Time_Since_Last_Txn` (Time-Delta) to capture automated burst/carding attacks.
   * Created financial anomaly ratios like `Rasio_Amt_C13`.

## Model Performance & Business Impact (The Sweet Spot)
Due to extreme data imbalance, Accuracy was discarded in favor of PR-AUC and F1-Score. The decision boundary was strategically tuned to prioritize Customer Experience (CX).
* **Optimal Threshold (0.66):** Strategically set to balance security and user convenience.
* **Precision (69.0%):** Drastically reduces False Positives. When the AI flags a transaction, it is highly accurate. This ensures the investigation team works efficiently and legitimate customers are not wrongfully blocked.
* **Recall (48.9%):** Successfully catches nearly half of all advanced global fraud attempts in a highly imbalanced environment without disrupting normal business operations.
* **F1-Score (0.572):** Proves the model's overall stability.
* **Explainable AI:** SHAP (SHapley Additive exPlanations) analysis confirmed that custom business logic (like Amount Ratios and UID tracking) were the primary drivers for the model's decision-making process.