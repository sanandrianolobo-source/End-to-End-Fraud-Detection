ALTER TABLE train_transaction 
ADD PRIMARY KEY (TransactionID);


ALTER TABLE train_identity 
ADD FOREIGN KEY (TransactionID) REFERENCES train_transaction(TransactionID);


SELECT 
    t.TransactionID,
    t.isFraud,
    t.TransactionAmt,
    i.DeviceType,
    i.DeviceInfo
FROM 
    train_transaction t
LEFT JOIN 
    train_identity i ON t.TransactionID = i.TransactionID
WHERE 
    t.isFraud = 1
LIMIT 20;


-- melihat total kerugian
SELECT 
    SUM(TransactionAmt) AS Total_Kerugian,
    COUNT(TransactionID) AS Total_Kasus_Penipuan
FROM 
    train_transaction
WHERE 
    isFraud = 1;


#konversi ke rupiah
SELECT 
    SUM(TransactionAmt * 15500) AS Total_Kerugian_IDR,
    COUNT(TransactionID) AS Total_Kasus_Penipuan
FROM 
    train_transaction
WHERE 
    isFraud = 1;
/* 
 * total kerugian 47.799.595.330
 * total kasus 20.663
 * rata rata kerugian per transaksi 2.316.000
 */



-- cek isi card4
SELECT DISTINCT card4 
FROM train_transaction;


-- cek isi card 4 dan jumlahnya
SELECT 
    card4 AS Jenis_Kartu, 
    COUNT(TransactionID) AS Jumlah_Transaksi
FROM 
    train_transaction
GROUP BY 
    card4
ORDER BY 
    Jumlah_Transaksi DESC;


-- cek head data transaksi
SELECT * 
FROM train_transaction 
LIMIT 10;

SELECT * 
FROM train_identity 
LIMIT 10;


-- kartu card4 apa yg paling sering jadi korban penipuan
SELECT 
    card4 AS Jaringan_Kartu,
    COUNT(TransactionID) AS Jumlah_Kasus_Penipuan,
    ROUND((COUNT(TransactionID) / (SELECT COUNT(TransactionID) FROM train_transaction WHERE isFraud = 1)) * 100, 2) AS Porsi_Dr_Total_Penipuan,
    ROUND((COUNT(TransactionID) / (SELECT COUNT(TransactionID) FROM train_transaction t2 WHERE t2.card4 = train_transaction.card4)) * 100, 2) AS Persentase_Kartu_Dibobol,
    SUM(TransactionAmt * 15500) AS Total_Kerugian_IDR,
    ROUND(AVG(TransactionAmt * 15500), 0) AS Rata_Rata_Kerugian_IDR
FROM 
    train_transaction
WHERE 
    isFraud = 1
GROUP BY 
    card4
ORDER BY 
    Jumlah_Kasus_Penipuan DESC;


-- kartu card6 apa yg paling sering jadi korban penipuan
SELECT 
    card6 AS Tipe_Kartu,
    COUNT(TransactionID) AS Jumlah_Kasus_Penipuan,
    ROUND((COUNT(TransactionID) / (SELECT COUNT(TransactionID) FROM train_transaction WHERE isFraud = 1)) * 100, 2) AS Porsi_Dr_Total_Penipuan,
    ROUND((COUNT(TransactionID) / (SELECT COUNT(TransactionID) FROM train_transaction t2 WHERE t2.card6 = train_transaction.card6)) * 100, 2) AS Persentase_Kartu_Dibobol,
    SUM(TransactionAmt * 15500) AS Total_Kerugian_IDR,
    ROUND(AVG(TransactionAmt * 15500), 0) AS Rata_Rata_Kerugian_IDR
FROM 
    train_transaction
WHERE 
    isFraud = 1
GROUP BY 
    card6
ORDER BY 
    Jumlah_Kasus_Penipuan DESC;



SELECT 
    card4 AS Jaringan_Kartu,
    card6 AS Tipe_Kartu,
    COUNT(TransactionID) AS Jumlah_Kasus_Penipuan,
    ROUND((COUNT(TransactionID) / (SELECT COUNT(TransactionID) FROM train_transaction WHERE isFraud = 1)) * 100, 2) AS Porsi_Dr_Total_Penipuan,
    ROUND((COUNT(TransactionID) / (SELECT COUNT(TransactionID) FROM train_transaction t2 WHERE t2.card4 = train_transaction.card4 AND t2.card6 = train_transaction.card6)) * 100, 2) AS Persentase_Kombinasi_Dibobol,
    SUM(TransactionAmt * 15500) AS Total_Kerugian_IDR,
    ROUND(AVG(TransactionAmt * 15500), 0) AS Rata_Rata_Kerugian_IDR
FROM 
    train_transaction
WHERE 
    isFraud = 1
GROUP BY 
    card4, 
    card6
ORDER BY 
    Total_Kerugian_IDR DESC;


-- menegcek device pengguna
SELECT 
    i.DeviceType AS Tipe_Perangkat,
    COUNT(t.TransactionID) AS Jumlah_Kasus_Penipuan,
    ROUND((COUNT(t.TransactionID) / (SELECT COUNT(TransactionID) FROM train_transaction WHERE isFraud = 1)) * 100, 2) AS Porsi_Dr_Total_Penipuan,
    SUM(t.TransactionAmt * 15500) AS Total_Kerugian_IDR,
    ROUND(AVG(t.TransactionAmt * 15500), 0) AS Rata_Rata_Kerugian_IDR
FROM 
    train_transaction t
LEFT JOIN 
    train_identity i ON t.TransactionID = i.TransactionID
WHERE 
    t.isFraud = 1
GROUP BY 
    i.DeviceType
ORDER BY 
    Jumlah_Kasus_Penipuan DESC;



-- cek browser yg digunakan
SELECT 
    i.id_31 AS Browser,
    COUNT(t.TransactionID) AS Jumlah_Kasus_Penipuan,
    ROUND((COUNT(t.TransactionID) / (SELECT COUNT(TransactionID) FROM train_transaction WHERE isFraud = 1)) * 100, 2) AS Porsi_Dr_Total_Penipuan,
    SUM(t.TransactionAmt * 15500) AS Total_Kerugian_IDR,
    ROUND(AVG(t.TransactionAmt * 15500), 0) AS Rata_Rata_Kerugian_IDR
FROM 
    train_transaction t
LEFT JOIN 
    train_identity i ON t.TransactionID = i.TransactionID
WHERE 
    t.isFraud = 1
GROUP BY 
    i.id_31
ORDER BY 
    Jumlah_Kasus_Penipuan DESC;


-- cek email pengguna
SELECT 
    P_emaildomain AS Domain_Email,
    COUNT(TransactionID) AS Jumlah_Kasus_Penipuan,
    ROUND((COUNT(TransactionID) / (SELECT COUNT(TransactionID) FROM train_transaction WHERE isFraud = 1)) * 100, 2) AS Porsi_Dr_Total_Penipuan,
    ROUND((COUNT(TransactionID) / (SELECT COUNT(TransactionID) FROM train_transaction t2 WHERE t2.P_emaildomain <=> train_transaction.P_emaildomain)) * 100, 2) AS Persentase_Kerawanan_Domain,
    SUM(TransactionAmt * 15500) AS Total_Kerugian_IDR,
    ROUND(AVG(TransactionAmt * 15500), 0) AS Rata_Rata_Kerugian_IDR
FROM 
    train_transaction
WHERE 
    isFraud = 1
GROUP BY 
    P_emaildomain
ORDER BY 
    Jumlah_Kasus_Penipuan DESC;



-- cek waktu peretasan
SELECT 
    FLOOR(TransactionDT / 3600) % 24 AS Jam_Transaksi,
    SUM(isFraud) AS Jumlah_Kasus_Penipuan,
    ROUND((SUM(isFraud) / COUNT(TransactionID)) * 100, 2) AS Persentase_Kerawanan_Waktu,
    SUM(CASE WHEN isFraud = 1 THEN TransactionAmt * 15500 ELSE 0 END) AS Total_Kerugian_IDR
FROM 
    train_transaction
GROUP BY 
    FLOOR(TransactionDT / 3600) % 24
ORDER BY 
    Jam_Transaksi ASC;
