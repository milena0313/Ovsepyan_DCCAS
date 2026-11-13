DROP VIEW IF EXISTS dm_v22_seller_shipping;
CREATE VIEW dm_v22_seller_shipping AS
SELECT 
    i.order_id,
    i.order_item_id,
    i.seller_id,
    i.seller_state,
    i.seller_region,
    strftime('%Y-%m-01', i.purchase_ts) AS month,
    CASE 
        WHEN i.carrier_ts IS NULL THEN 'Нет данных об отгрузке'
        WHEN i.carrier_ts > i.shipping_limit_ts THEN 'Отгрузка с опозданием'
        ELSE 'Отгрузка вовремя'
    END AS handover_status,
    ROUND((julianday(i.carrier_ts) - julianday(i.shipping_limit_ts)) * 24, 2) AS handover_delay_hours,
    COALESCE(i.is_late, 0) AS customer_late
FROM core_item i
WHERE i.carrier_ts IS NOT NULL
  AND i.purchase_month BETWEEN '2017-01-01' AND '2018-08-01';
