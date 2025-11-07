CREATE TABLE customers (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	city VARCHAR(50)
);

CREATE TABLE orders (
	id SERIAL PRIMARY KEY,
	customer_id INT REFERENCES customers(id),
	order_date DATE,
	total_price NUMERIC(10,2)
);

CREATE TABLE order_items(
	id SERIAL PRIMARY KEY,
	order_id INT REFERENCES orders(id),
	product_id INT REFERENCES products(id),
	quantity INT,
	price NUMERIC(10,2)
);

INSERT INTO customers (name, city) VALUES
    ( 'Nguyễn Văn A', 'Hà Nội'),
    ( 'Trần Thị B', 'Đà Nẵng'),
    ( 'Lê Văn C', 'Hồ Chí Minh'),
    ( 'Phạm Thị D', 'Hà Nội');

INSERT INTO orders ( customer_id, order_date, total_price) VALUES
    ( 1, '2024-12-20', 3000),
    ( 2, '2025-01-05', 1500),
    ( 1, '2025-02-10', 2500),
    ( 3, '2025-02-15', 4000),
    ( 4, '2025-03-01', 800);

INSERT INTO order_items ( order_id, product_id, quantity, price) VALUES
    ( 1, 1, 2, 1500),
    ( 2, 2, 1, 1500),
    ( 3, 3, 5, 500),
    ( 4, 2, 4, 1000);

SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM order_items; 

-- Tính tổng chi tiêu và tổng số đơn hàng của mỗi khách hàng
SELECT c.id "Mã khách hàng",
c.name "Tên khách hàng",
c.city "Địa chỉ khách hàng",
SUM(o.total_price) "Tổng chi tiêu",
COUNT (o.total_price) "Số đơn hàng đã đặt" 
FROM customers AS c
LEFT JOIN orders AS o 
ON c.id = o.customer_id
GROUP BY c.id ORDER BY c.id; 

-- Tính chi tiêu trung bình của tất cả các khách hàng 
SELECT AVG(total_expense) "Chi tiêu trung bình"  FROM
(
	SELECT customer_id, SUM(total_price) AS total_expense
	FROM orders 
	GROUP BY customer_id
); 

-- Hiển thị tất cả các khách hàng có mức doanh thu lớn hơn trung bình 

SELECT c.id "Mã khách hàng",
c.name "Tên khách hàng",
c.city "Địa chỉ khách hàng",
SUM(o.total_price) "Tổng chi tiêu",
COUNT (o.total_price) "Số đơn hàng đã đặt" 
FROM customers AS c
LEFT JOIN orders AS o 
ON c.id = o.customer_id
GROUP BY c.id HAVING SUM(o.total_price) > 
(
	SELECT AVG(total_expense) "Chi tiêu trung bình"  FROM
	(
		SELECT customer_id, SUM(total_price) AS total_expense
		FROM orders 
		GROUP BY customer_id
	)
); 


-- Tìm thành phố có tổng doanh thu cao nhất 
	-- Tạo bảng tổng chi tiêu cho từng thành phố 
	SELECT
	c.city "Địa chỉ khách hàng",
	SUM(o.total_price) "Tổng chi tiêu"
	FROM customers AS c
	LEFT JOIN orders AS o 
	ON c.id = o.customer_id
	GROUP BY c.city HAVING SUM(o.total_price) >= ALL (
		SELECT
		SUM(o.total_price) "Tổng chi tiêu"
		FROM customers AS c
		LEFT JOIN orders AS o 
		ON c.id = o.customer_id
		GROUP BY c.city
	); 



	

