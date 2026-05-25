SET SERVEROUTPUT ON
SET LINESIZE 200
SET PAGESIZE 50
SET DEFINE OFF
COLUMN SKU              FORMAT A15
COLUMN NAME             FORMAT A30
COLUMN STATUS           FORMAT A10
COLUMN PRICE_EXPORT_STD FORMAT 999,999,999
COLUMN TOTAL_AMOUNT     FORMAT 999,999,999
COLUMN CURRENT_STOCK    FORMAT 9999
COLUMN ACTION           FORMAT A15
COLUMN ENTITY_NAME      FORMAT A15
COLUMN DETAILS          FORMAT A50
COLUMN RECORD_STATUS    FORMAT A10
COLUMN NOTE             FORMAT A40
COLUMN IMEI             FORMAT A20

-- ============================================================
-- 1. FUNC_CALCULATE_ORDER_TOTAL
--    Tinh tong tien cua tung don hang
-- ============================================================
SELECT
    o.id          AS order_id,
    c.full_name   AS customer,
    o.status,
    FUNC_CALCULATE_ORDER_TOTAL(o.id) AS calculated_total,
    o.total_amount                   AS stored_total
FROM orders o
JOIN customers c ON o.customer_id = c.id
ORDER BY o.id;

-- ============================================================
-- 2. PROC_CREATE_STOCK_MOVEMENT
--    Nhap kho 5 san pham iPhone (product_id = 1, user_id = 1)
-- ============================================================
BEGIN
    PROC_CREATE_STOCK_MOVEMENT(1, 'IMPORT', 'NEW_PURCHASE', 5, 1);
END;
/

-- Kiem tra ton kho sau khi nhap
SELECT id, sku, name, current_stock FROM products WHERE id = 1;

-- Kiem tra ban ghi trong stock_movements
SELECT id, product_id, type, action_type, quantity, created_by
FROM stock_movements
WHERE product_id = 1
ORDER BY id;

-- ============================================================
-- 3. PROC_CHECK_INVENTORY_MATCH
--    Kiem tra ket qua kiem ke theo session
-- ============================================================
BEGIN
    PROC_CHECK_INVENTORY_MATCH(1);
END;
/

-- Xem chi tiet kiem ke session 1
SELECT id, imei, expected_loc, actual_loc, record_status, note
FROM inventory_details
WHERE session_id = 1;

-- ============================================================
-- 4. PROC_CHECK_VALID_EXPORT
--    TH1: Xuat 1000 chiec - vuot qua ton kho
-- ============================================================
BEGIN
    PROC_CHECK_VALID_EXPORT(1, 1000);
END;
/

--    TH2: Xuat 2 chiec - hop le
BEGIN
    PROC_CHECK_VALID_EXPORT(1, 2);
END;
/

-- ============================================================
-- 5. TRG_AUDIT_PRODUCT_PRICE
--    Cap nhat gia san pham de trigger ghi log
-- ============================================================
UPDATE products SET price_export_std = 31000000 WHERE id = 1;
COMMIT;

-- Kiem tra audit_logs sau khi trigger chay
SELECT user_id, action, entity_name, entity_id, status, details
FROM audit_logs
WHERE action = 'UPDATE_PRICE'
ORDER BY id DESC;

-- Khoi phuc gia cu
UPDATE products SET price_export_std = 29900000 WHERE id = 1;
COMMIT;

-- ============================================================
-- 6. TRG_UPDATE_ORDER_TOTAL
--    Insert order_item moi de trigger tu dong cap nhat total
-- ============================================================

-- Kiem tra total truoc khi insert
SELECT id, total_amount FROM orders WHERE id = 1;

-- Insert them 1 dong order_item
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
VALUES (1, 5, 2, 180000);
COMMIT;

-- Kiem tra total sau khi trigger chay
SELECT id, total_amount FROM orders WHERE id = 1;

-- ============================================================
-- 7. CURSOR c_LowStock
--    In danh sach san pham sap het hang
-- ============================================================
DECLARE
    CURSOR c_LowStock IS
        SELECT sku, name, current_stock
        FROM products
        WHERE current_stock <= min_threshold
        AND status = 'ACTIVE';
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- DANH SACH SAN PHAM SAP HET HANG ---');
    FOR r IN c_LowStock LOOP
        DBMS_OUTPUT.PUT_LINE('SKU: ' || r.sku || ' | Ten: ' || r.name || ' | Ton: ' || r.current_stock);
        IF r.current_stock = 0 THEN
            DBMS_OUTPUT.PUT_LINE(' -> CANH BAO: Da het sach hang trong kho!');
        END IF;
    END LOOP;
END;
/

-- Xem bang de doi chieu
SELECT sku, name, current_stock, min_threshold, status
FROM products
WHERE current_stock <= min_threshold
AND status = 'ACTIVE';