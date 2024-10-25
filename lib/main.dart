import 'package:flutter/material.dart';

void main() {
  runApp(VendingMachineApp());
}

class VendingMachineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VendingMachineScreen(),
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blueAccent,
        hintColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}

class VendingMachineScreen extends StatefulWidget {
  @override
  _VendingMachineScreenState createState() => _VendingMachineScreenState();
}

class _VendingMachineScreenState extends State<VendingMachineScreen> {
  int balance = 0;
  String selectedProduct = '';
  int productPrice = 0;
  int change = 0;

  // Lista de productos con sus precios e imágenes asociadas
  final List<Map<String, dynamic>> products = [
    {'name': 'COCA COLA', 'price': 5, 'image': 'assets/images/coca_cola.jpg'},
    {'name': 'Fanta', 'price': 5, 'image': 'assets/images/fanta.jpg'},
    {'name': 'Grapette', 'price': 5, 'image': 'assets/images/grapette.jpg'},
    {'name': 'Jumex', 'price': 6, 'image': 'assets/images/jumex.jpg'},
    {'name': 'Arizona', 'price': 8, 'image': 'assets/images/arizona.png'},
    {'name': 'Raptor Zero', 'price': 10, 'image': 'assets/images/raptor.png'},
    {'name': 'Agua mineral Pierrer', 'price': 12, 'image': 'assets/images/perrier.jpg'},
    {'name': 'Jugo Pippa', 'price': 15, 'image': 'assets/images/pippa.png'},
    {'name': 'Jugo del valle', 'price': 15, 'image': 'assets/images/del_valle.png'},
    {'name': 'Mineral San Pellegrino', 'price': 16, 'image': 'assets/images/san_pellegrino.jpg'},
    {'name': 'Monster Ultra', 'price': 18, 'image': 'assets/images/monster.jpg'},
    {'name': 'Redbull', 'price': 20, 'image': 'assets/images/redbull.jpg'},
  ];

  // Lista de monedas aceptadas
  final List<int> coins = [1, 5, 10, 20];

  // Insertar monedas y actualizar el saldo
  void insertCoin(int coin) {
    setState(() {
      balance += coin;});
    //si el saldo es mayor a 20 se le regresa el cambio
    if(balance > 20){
      change= balance - 20;
      balance = 20;
      showDialog(context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text('Cambio devuelto'),
              content: Text('Cambio: Q$change'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          } );

    }


  }

  // Seleccionar un producto y procesar la compra
  void selectProduct(String productName, int price) {
    setState(() {
      selectedProduct = productName;
      productPrice = price;
      if (balance >= price) {
        change = balance - price;
        balance = 0; // Resetear saldo tras la compra
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Compra exitosa'),
              content: Text('Has comprado $productName. Cambio: Q$change'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Fondos insuficientes'),
              content: Text('No tienes suficiente saldo para comprar $productName.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Usamos MediaQuery para obtener el ancho y ajustar la cantidad de columnas
    double screenWidth = MediaQuery.of(context).size.width;

    // Determinamos el número de columnas basados en el ancho de la pantalla
    int crossAxisCount = screenWidth < 600
        ? 2
        : screenWidth < 900
        ? 3
        : 4; // Ajustamos las columnas en función del ancho disponible

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Máquina Expendedora', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Pantalla de información simulada alineada a la derecha con un contenedor
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo: Q$balance',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Producto seleccionado: $selectedProduct',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Cambio devuelto: Q$change',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('Selecciona:', style: TextStyle(color: Colors.blueAccent, fontSize: 50)),
            SizedBox(height: 10),
            // Cuadrícula de productos
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, // Ajusta las columnas automáticamente
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2, // Ajuste de proporción para evitar overflow
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      selectProduct(products[index]['name'], products[index]['price']);
                    },

                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),

                      elevation: 3,
                      shadowColor: Colors.blueAccent,
                      child: Column(
                        children: [
                          // Ajuste de la imagen con tamaño proporcional
                          Flexible(
                            child: Image.asset(
                              products[index]['image'],
                              fit: BoxFit.contain, // Asegurarse de que la imagen se ajuste correctamente
                            ),
                          ),
                          SizedBox(height: 10),
                          // Nombre del producto
                          Text(
                            products[index]['name'],
                            style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                          ),
                          // Precio del producto
                          Text(
                            'Q${products[index]['price']}',
                            style: TextStyle(color: Colors.blue[900], fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
      // Botones de monedas
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: coins.map((coin) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadowColor: Colors.black,
                elevation: 5,
              ),
              child: Text('Q$coin', style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
              onPressed: () {
                insertCoin(coin);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}