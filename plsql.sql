SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION FUNC_CALCULATE_ORDER_TOTAL (
    p_OrderId IN NUMBER
) RETURN NUMBER IS
    v_Total NUMBER := 0;
BEGIN
    SELECT SUM(quantity * unit_price)
    INTO v_Total
    FROM ORDER_ITEMS
    WHERE order_id = p_OrderId;
    RETURN NVL(v_Total, 0);
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN 0;
END;
/

CREATE OR REPLACE PROCEDURE PROC_CREATE_STOCK_MOVEMENT (
    p_ProductId IN NUMBER,
    p_Type      IN VARCHAR2,
    p_Action    IN VARCHAR2,
    p_Quantity  IN NUMBER,
    p_UserId    IN NUMBER
) IS
    v_CurrentStock NUMBER;
BEGIN
    SELECT current_stock INTO v_CurrentStock FROM products WHERE id = p_ProductId;
    IF p_Type = 'EXPORT' AND p_Quantity > v_CurrentStock THEN
        DBMS_OUTPUT.PUT_LINE('Loi: So luong xuat vuot qua ton kho!');
        RETURN;
    END IF;
    INSERT INTO stock_movements (product_id, type, action_type, quantity, created_by)
    VALUES (p_ProductId, p_Type, p_Action, p_Quantity, p_UserId);
    IF p_Type = 'IMPORT' THEN
        UPDATE products SET current_stock = current_stock + p_Quantity WHERE id = p_ProductId;
    ELSIF p_Type = 'EXPORT' THEN
        UPDATE products SET current_stock = current_stock - p_Quantity WHERE id = p_ProductId;
    END IF;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Da ghi nhan bien dong kho thanh cong.');
END;
/

CREATE OR REPLACE PROCEDURE PROC_CHECK_INVENTORY_MATCH (
    p_SessionId IN NUMBER
) IS
    v_MismatchCount NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_MismatchCount
    FROM inventory_details
    WHERE session_id = p_SessionId
    AND record_status IN ('MISMATCH', 'MISSING');
    IF v_MismatchCount > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Canh bao: Co ' || v_MismatchCount || ' san pham nam sai vi tri hoac that lac trong kho!');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Kiem ke hoan tat. 100% san pham dung vi tri luu tru.');
    END IF;
END;
/

CREATE OR REPLACE PROCEDURE PROC_CHECK_VALID_EXPORT (
    p_ProductId IN NUMBER,
    p_Quantity  IN NUMBER
) IS
    v_CurrentStock NUMBER;
    e_OutOfStock EXCEPTION;
BEGIN
    SELECT current_stock INTO v_CurrentStock FROM products WHERE id = p_ProductId;
    IF v_CurrentStock < p_Quantity THEN
        RAISE e_OutOfStock;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Hop le: Du dieu kien xuat kho.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Loi: San pham khong ton tai trong he thong.');
    WHEN e_OutOfStock THEN
        DBMS_OUTPUT.PUT_LINE('Loi Nghiep vu: So luong yeu cau xuat (' || p_Quantity || ') vuot qua ton kho thuc te (' || v_CurrentStock || ')!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Loi he thong khong xac dinh: ' || SQLERRM);
END;
/

CREATE OR REPLACE TRIGGER TRG_AUDIT_PRODUCT_PRICE
AFTER UPDATE OF price_export_std ON products
FOR EACH ROW
BEGIN
    IF :OLD.price_export_std != :NEW.price_export_std THEN
        INSERT INTO audit_logs (user_id, action, entity_name, entity_id, status, details)
        VALUES (
            1,
            'UPDATE_PRICE',
            'PRODUCTS',
            TO_CHAR(:NEW.id),
            'SUCCESS',
            'San pham ' || :OLD.sku || ' thay doi gia tu ' || :OLD.price_export_std || ' thanh ' || :NEW.price_export_std
        );
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TRG_UPDATE_ORDER_TOTAL
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET total_amount = NVL(total_amount, 0) + (:NEW.quantity * :NEW.unit_price)
    WHERE id = :NEW.order_id;
END;
/

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

BEGIN
    PROC_CHECK_VALID_EXPORT(1, 1000);
END;
/