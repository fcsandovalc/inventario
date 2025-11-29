--2.
CREATE DATABASE evaluaciON_m5;
\c evaluaciON_m5

--Crear tabla Empresa
CREATE TABLE empresa (id_empresa SERIAL PRIMARY KEY, nombre VARCHAR(100) NOT NULL, direcciON VARCHAR(150) NOT NULL,
 telefONo VARCHAR(50) NOT NULL, email VARCHAR(100) NOT NULL, tipo VARCHAR(20) NOT NULL);

-- Crear tabla Productos
CREATE TABLE productos (id_producto SERIAL PRIMARY KEY, nombre VARCHAR(100) NOT NULL, descripciON VARCHAR(150) NOT NULL, 
cantidad INT NOT NULL, precio NUMERIC(10,2) NOT NULL);

--Crear tabla TransacciONes
 CREATE TABLE transacciONes(id_transacciON SERIAL PRIMARY KEY, id_producto INT, id_empresa INT, 
 tipo VARCHAR(20) NOT NULL, fecha DATE NOT NULL, cantidad INT NOT NULL, CONSTRAINT fk_producto FOREIGN KEY(id_producto) REFERENCES productos(id_producto), 
 CONSTRAINT fk_empresa FOREIGN KEY (id_empresa) REFERENCES empresa(id_empresa));


-- 8. Agregar restricciONes para ingresar datos validos
ALTER TABLE productos ADD CONSTRAINT precio_posiivo CHECK (preci
o > 0);

 ALTER TABLE productos ADD CONSTRAINT inventario_positivo CHECK (
cantidad >= 0);

--Insertar datos a Empresa
INSERT INTO empresa(nombre, direcciON, telefONo, email, tipo) VALUES
('VerdurAS del Valle', 'Av Campestre 123', ' 5552220058', 'cONtacto@valleverde.com', 'proveedor'),
('DulceMania', 'Calle Central 45', '+5698487589', 'info@dulcemania.cl', 'cliente'),
('Minimarket Miriam', 'CONde de CAStellar 321', '+56987895581', 'mmarketm@cONtacto.com', 'proveedor'),
('VerdurAS La Finca', 'Av. Norte 77', '+56988775123', 'verdurAS@info.cl', 'cliente'),
('CONfites Arcoíris', 'Av. SimpsON 101', '+652898569', 'cONfites@gmail.com', 'proveedor'),
('Mayorista NaturalFood', 'Calle Mercado 88', '5+56987878745', 'cONtact@naturalfood.com', 'proveedor'),
('Tiendita Martina', 'Av. 25 de Mayo 190', '63220014', 'martina@tienda.com', 'cliente'),
('Supermercado AlPASo', 'Av. Libertad 10', '+56998580010', 'ventAS@alpASo.com', 'cliente'),
('Kiosco La Esquina', 'Calle 12', '56320005', 'esquina@kiosco.com', 'proveedor'),
('Distribuidora CONfites', 'ZONa Industrial 88', '+56985520006', 'admin@cONfiteplus.com', 'proveedor');

--INSERTar datos a Producto
INSERT INTO productos(nombre, descripciON, cantidad, precio) VALUES
('Manzana fuji', 'Fruta fresca de temporada', 80, 1.50),
('Platano', 'Banana madura por unidad', 100, 1.20),
('Zanahoria', 'Zanahoria orgánica por kilo', 50, 1.50),
('Lechuga', 'Lechuga crespa fresca', 90, 1.40),
('Tomate', 'Tomate rojo por kilo', 30, 1.70),
('Caramelos acidos', 'Caramelos sabor fresa', 10, 1.75),
('Lolipop', 'Chupetín sabor surtido', 300, 1.00),
('GomitAS', 'GomitAS de frutAS surtidAS', 150, 4 ),
('Chocolate Leche', 'Mini barra de chocolate', 200, 1.80),
('PalomitAS Mantequilla', 'Bolsa de palomitAS caramelizadAS', 15, 0.9);

--4. 5. Actualiza la cantidad de inventario de un producto después de una venta o compra.
BEGIN;
INSERT INTO transacciONes(id_producto, id_empresa, tipo, fecha, cantidad) VALUES
(1, 1, 'compra', '2025-10-03', 3);
UPDATE productos SET cantidad = cantidad + 3 WHERE id_producto = 1;

INSERT INTO transacciONes(id_producto, id_empresa, tipo, fecha, cantidad) VALUES
(2, 3, 'venta', '2025-05-25', 10);
UPDATE productos SET cantidad = cantidad - 10 WHERE id_producto = 2;

INSERT INTO transacciONes(id_producto, id_empresa, tipo, fecha, cantidad) VALUES
(3, 2, 'compra', '2025-07-14', 8);
UPDATE productos SET cantidad = cantidad + 8 WHERE id_producto = 3;

INSERT INTO transacciONes(id_producto, id_empresa, tipo, fecha, cantidad) VALUES
(4, 6, 'compra', '2025-08-21', 80);
UPDATE productos SET cantidad = cantidad + 80 WHERE id_producto = 4;

INSERT INTO transacciONes(id_producto, id_empresa, tipo, fecha, cantidad) VALUES
(2, 5, 'venta', '2025-02-08', 15);
UPDATE productos SET cantidad = cantidad - 15 WHERE id_producto = 2;

INSERT INTO transacciONes(id_producto, id_empresa, tipo, fecha, cantidad) VALUES
(5, 5, 'venta', '2025-10-25', 20);
UPDATE productos SET cantidad = cantidad - 20 WHERE id_producto = 5;

COMMIT;

-- 4.Elimina un producto de la bASe de datos si ya no está dispONible.
DELETE FROM productos WHERE id_producto = 7 ;


--3.Realiza cONsultAS básicAS utilizANDo el lenguaje SQL.
--Recupera todos los productos dispONibles en el inventario.

SELECT nombre, cantidad FROM productos; 

--Recupera todos los proveedores que suministran productos específicos, en este cASo lechuga.

SELECT empresa.nombre AS proveedor, productos.nombre AS producto, productos.cantidad AS cantidad_inventario 
FROM empresa JOIN transacciONes ON empresa.id_empresa = transacciONes.id_empresa 
JOIN productos ON productos.id_producto = transacciONes.id_producto 
WHERE productos.nombre ilike 'Lechuga' AND transacciONes.tipo = 'compra' AND empresa.tipo = 'proveedor';

--CONsulta lAS transacciONes realizadAS en una fecha específica. Ej: mes de octubre.

SELECT transacciONes.tipo, transacciONes.fecha, empresa.nombre, productos.nombre FROM transacciONes JOIN empresa ON transacciONes.id_empresa = empresa.id_empresa JOIN productos ON productos.id_producto = transacciONes.id_producto WHERE transacciONes.fecha >= ' 2025-10-01' AND transacciONes.fecha <= '2025-10-31';

--Realiza cONsultAS de selección cON funciONes de agrupación, como COUNT() y SUM(), para calcular el número total de productos vendidos o el valor total de lAS comprAS. 
--Ejemplo sumar todAS lAS comprAS de 2025 hASta octubre y a cuanto dinero equivale.

SELECT sum(transacciONes.cantidad) AS total_comprAS, sum(transacciONes.cantidad * productos.precio) AS valor_total 
FROM transacciONes JOIN productos ON transacciONes.id_producto = productos.id_producto
WHERE transacciONes.fecha >= '2025-01-01' AND transacciONes.fecha <= '2025-10-31' 
AND transacciONes.tipo = 'compra';

--CONtar cuantAS veces se vendio o compro en octubre y agrupar por proveedor.

SELECT count(transacciONes.cantidad) AS total_productos, transacciONes.fecha, transacciONes.tipo, empresa.nombre 
FROM transacciONes JOIN empresa ON transacciONes.id_empresa = empresa.id_empresa 
WHERE transacciONes.fecha >= ' 2025-10-01' AND transacciONes.fecha <= '2025-10-31'
GROUP BY empresa.nombre, transacciONes.fecha, transacciONes.tipo;

