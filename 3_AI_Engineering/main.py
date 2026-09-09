from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
import pandas as pd
import numpy as np

# ==============================================================================
# 1. INISIALISASI APLIKASI & MEMUAT MODEL AI
# ==============================================================================
app = FastAPI(
    title="Real-Time Fraud Detection API",
    description="Microservice cerdas untuk mendeteksi penipuan transaksi finansial.",
    version="1.0.0"
)

print("Memanaskan mesin AI...")
try:
    # Memuat model LightGBM dan daftar fitur yang kita ekspor dari Jupyter
    model = joblib.load("lgb_fraud_model.pkl")
    expected_features = joblib.load("model_features.pkl")
    print("✅ Otak AI (Model & Fitur) berhasil dimuat dan siap melayani!")
except Exception as e:
    print(f"❌ Gagal memuat aset AI. Pastikan file .pkl ada di folder yang sama. Error: {e}")

# ==============================================================================
# 2. SKEMA DATA (DATA CONTRACT)
# ==============================================================================
class TransactionRequest(BaseModel):
    """
    Format data yang diwajibkan saat Front-End / Aplikasi Kasir mengirim request.
    Karena kita memakai 168 fitur, kita gunakan struktur 'dict' agar fleksibel.
    """
    features: dict

# ==============================================================================
# 3. ROUTING & LOGIK BISNIS (ENDPOINTS)
# ==============================================================================
@app.get("/")
def health_check():
    return {"status": "ACTIVE", "message": "Fraud API Engine is running. Visit /docs for Swagger UI."}

@app.post("/api/v1/predict")
def predict_fraud(request: TransactionRequest):
    try:
        # 1. Ubah JSON dari front-end menjadi bentuk tabel (DataFrame)
        df_input = pd.DataFrame([request.features])
        
        # 2. Pengamanan Fitur (Bypass Missing Columns)
        # Jika front-end lupa mengirim salah satu kolom, AI otomatis mengisi dengan NaN
        for col in expected_features:
            if col not in df_input.columns:
                df_input[col] = np.nan
                
        # 3. Urutkan kolom secara ketat sesuai dengan urutan saat AI dilatih
        df_input = df_input[expected_features]
        
        # 🛡️ PENGAMANAN EKSTRA: Paksa semua kolom menjadi angka. 
        # Jika ada teks yang tidak bisa diubah (seperti "9999_888_777"), ubah jadi -1
        df_input = df_input.apply(pd.to_numeric, errors='coerce').fillna(-1)
        
        # 4. Prediksi Probabilitas
        probabilitas = float(model.predict_proba(df_input)[0][1])
        
        # 5. Keputusan Bisnis (Menggunakan Sweet Spot Threshold 0.66)
        THRESHOLD = 0.66
        is_fraud = bool(probabilitas >= THRESHOLD)
        
        # 6. Format Balasan (Response) ke Aplikasi Kasir
        return {
            "transaction_status": "BLOCKED ❌" if is_fraud else "APPROVED ✅",
            "fraud_probability": round(probabilitas, 4),
            "threshold_used": THRESHOLD,
            "action_recommended": "Investigate immediately" if is_fraud else "Proceed normally"
        }
        
    except Exception as e:
        # Menangkap error jika format data rusak
        raise HTTPException(status_code=400, detail=str(e))