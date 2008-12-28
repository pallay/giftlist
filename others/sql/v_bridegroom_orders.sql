CREATE VIEW `shaadigiftlist_development`.`v_bridegroom_orders` AS
 SELECT			p1.first_name AS p1_first_name,
						p2.first_name AS p2_first_name,
						p1.order_id,
						p1.customer_number,
						p1.id AS p1_id,
						p2.id AS p2_id,
						p1.last_name AS p1_last_name,
						p2.last_name AS p2_last_name
FROM				v_bridegroom_details AS p1
INNER JOIN	v_bridegroom_details AS p2
ON					p1.order_id = p2.order_id AND p1.id <> p2.id
Group By		order_id
Order By 		order_id;