/*TABLA USUARIO*/

/*SP para agregar Usuarios*/
delimiter $$
create procedure agregarUsuario(in nombreU nvarchar(50), in primerNom nvarchar (50), in segundoNom nvarchar(50), in apellidoPat nvarchar (50),
	in apellidoMat nvarchar (50), in correo nvarchar(50), in contra nvarchar(20), in fechaNac date, in sexo enum('Masculino', 'Femenino'),
    in metodoPago enum('DepositoBancario', 'Tarjeta'), idPat smallint unsigned)
    begin 
		insert into usuario(nombreUsuario, primerNombre, segundoNombre, apellidoPaterno, apellidoMaterno, email, contrasena, fechaNacimiento,
		genero, formaPago, fechaRegistro, idPatrocinador) 
		values (nombreU, primerNom, segundoNom, apellidoPat, apellidoMat, correo, contra, fechaNac, sexo, metodoPago, now(), idPat);
	end
$$

/*SP para traer los datos del Usuario*/
delimiter $$
create procedure datosPersonales(in nombreU nvarchar(50))
	begin
		select idUsuario, nombreUsuario, primerNombre, segundoNombre, apellidoPaterno, apellidoMaterno, email, contrasena, fechaNacimiento,
        genero, formaPago, fechaRegistro, idPatrocinador
        from usuario
        where nombreU = nombreUsuario;
	end
$$

/*SP para modificar los datos del Usuario, contraseña y nombre de usuario no se modifican*/
delimiter $$
create procedure modificarDatosPersonales(in nombreU nvarchar(50), in primerNom nvarchar (50), in segundoNom nvarchar(50),
	in apellidoPat nvarchar (50), in apellidoMat nvarchar (50), in correo nvarchar(50), in contra nvarchar(20), in fechaNac date,
    in sexo enum('Masculino', 'Femenino'), in metodoPago enum('DepositoBancario', 'Tarjeta'), idPat smallint unsigned)
    begin
		update usuario
        set primerNombre = primerNom,
			segundoNombre = segundoNom,
            apellidoPaterno = apellidoPat,
            apellidoMaterno = apellidoMat,
            email = correo,
            fechaNacimiento = fechaNac,
            genero = sexo,
            formaPago = metodoPago,
            idPatrocinador = idPat
		where nombreUsuario = nombreU and contrasena = contra;
    end
$$

/*SP para modificar contraseña*/
delimiter $$
create procedure modificarContrasena(in nombreU nvarchar(50), in contraOriginal nvarchar(20), in contraNueva nvarchar(20))
	begin
		update usuario
        set contrasena = contraNueva
        where nombreUsuario = nombreU and contrasena = contraOriginal;
	end
$$

/*SP para traer mi lista de invitados*/
delimiter $$
create procedure misInvitados(in idU smallint unsigned)
	begin
		select idUsuario, nombreUsuario, concat(primerNombre, ' ', segundoNombre, ' ', apellidoPaterno, ' ', apellidoMaterno) as nombre, idPatrocinador
        from usuario
        where idPatrocinador = idU;
	end
$$

/*SP para cambiar forma de pago*/
delimiter $$
create procedure cambiarFormaPago(in nombreU nvarchar(50), in metodoPago enum('DepositoBancario', 'Tarjeta'))
	begin
		update usuario
        set formaPago = metodoPago
        where nombreUsuario = nombreU;
	end
$$


/*TABLA DOMICILIO_ENTREGA*/

/*SP para agregar un domicilio*/
delimiter $$
create procedure agregarDomicilio(in tituloDom nvarchar(50), in nombreCalle nvarchar(255), in numeroDom nvarchar(10),
	in nombreColonia nvarchar(255), in nombreCiudad nvarchar(255), in nombrePais nvarchar(50), in idU smallint unsigned)
	begin
		insert into domicilioEntrega(tituloDomicilio, calle, numeroDomicilio, colonia, ciudad, pais, idUsuario)
        values (tituloDom , nombreCalle, numeroDom, nombreColonia, nombreCiudad, nombrePais, idU);
    end
$$

/*SP para traer la lista de domicilios de un usuario*/
delimiter $$
create procedure mostrarDomicilios(in idU smallint unsigned)
	begin
		select idDomicilio, tituloDomicilio
        from domicilioEntrega
        where idUsuario = idU;
	end
$$

/*SP para traer la información del domicilio seleccionado*/
delimiter $$
create procedure obtenerDomicilio(in idD smallint unsigned, in idU smallint unsigned)
	begin
		select tituloDomicilio, concat(calle, ' ', numeroDomicilio, ', ', colonia, ', ', ciudad, ', ', pais) as domicilio
        from domicilioEntrega
        where idDomicilio = idD and idUsuario = idU;
	end
$$

/*SP para modificar un domicilio*/
delimiter $$
create procedure modificarDomicilio(in idD smallint unsigned, in tituloDom nvarchar(50), in nombreCalle nvarchar(255), in numeroDom nvarchar(10),
	in nombreColonia nvarchar(255), in nombreCiudad nvarchar(255), in nombrePais nvarchar(50), in idU smallint unsigned)
    begin
		update domicilioEntrega
		set tituloDomicilio = tituloDom,
			calle = nombreCalle,
			numeroDomicilio = numeroDom,
			colonia = nombreColonia,
			ciudad = nombreCiudad,
			pais = nombrePais
		where idDomicilio = idD and idUsuario = idU;
    end
$$


/*TABLA PRODUCTO*/

/*SP para traer los productos de una categoría*/
delimiter $$
create procedure productosCategoria(in cat nvarchar(50))
	begin
		select idProducto, nombreProducto, costo, puntaje, descripcion, direccionFoto
        from producto
        where categoria = cat;
	end
$$

/*SP para traer la información de un producto en específico*/
delimiter $$
create procedure mostrarProducto(in idP smallint unsigned)
	begin
		select nombreProducto, costo, puntaje, descripcion, direccionFoto
        from producto
        where idProducto = idP;
    end
$$


/*TABLA DESCUENTO*/

/*SP para traer los productos que tienen descuento y su porcentaje de descuento*/
delimiter $$
create procedure ofertas()
	begin
		select P.nombreProducto, P.costo, P.puntaje, P.direccionFoto, D.descuento
        from producto P
        inner join descuento D on P.idProducto = D.idProducto
        where fechaInicio < curdate() and fechaFinal > curdate();
    end
$$


/*TABLA FAVORITOS*/

/*SP para traer los productos favoritos de un usuario*/
delimiter $$
create procedure mostrarFavoritos(in idU smallint unsigned)
	begin
		select P.nombreProducto, P.costo, P.puntaje, P.descripcion, P.direccionFoto
        from favoritos F
        inner join producto P on F.idProducto = P.idProducto
        where F.idUsuario = idU;
    end
$$


/*TABLA PRODUCTO_COMPRA*/

/*SP para traer los 20 productos más comprados*/
delimiter $$
create procedure masComprados()
	begin
		select P.nombreProducto, P.costo, P.puntaje, P.descripcion, P.direccionFoto, count(P.idProducto) as ventas
        from productoCompra C
        inner join producto P on P.idProducto = C.idProducto
        order by ventas
        limit 20;
    end
$$

/*SP para traer los últimos 10 productos comprados por el usuario*/
delimiter $$
create procedure ultimasCompras(in idU smallint unsigned)
	begin
		select P.nombreProducto, P.costo, P.puntaje, P.descripcion, P.direccionFoto
        from productoCompra PC
        inner join producto P on P.idProducto = PC.idProducto
        inner join compra C on C.idCompra = PC.idCompra
        where C.idUsuario = idU
        order by C.fechaCompra
        limit 10;
	end
$$

