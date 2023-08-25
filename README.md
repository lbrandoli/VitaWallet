Lo primero que se hizo fue crear las cuentas de GCP y a su vez crear las cuentas de servicios correspondientes con permisos de owner.
Si bien no es recomendable asignar el rol de owner, ya que no cumple con la premisa de "less privileges" decidí hacerlo de esta manera para fines practicos.

En el archivo variables.tf fueron incluidas tambien las variables con informacion sensible con fines practicos ya que de igual forma el archivo tambien iba a ser subido a github.

Lamentablemente no me alcanzó el tiempo para investigar y hacer la parte que tiene que ver con certificados.

Al momento de la prueba es necesario ingresar en ambas cuentas, abrir una consola ssh en cada una de las instancias de compute engine y si estoy en el cliente, hacerle ping
a la ip interna del server o si estoy en la consola del cliente, hacerle ping a la ip interna del server.
De esta forma, si responde, la implementacion de la conexion VPN fue satisfactoria.