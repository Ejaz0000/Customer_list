class Customer {
  final String? imageUrl;
  final String? name;
  final String? email;
   final String? phone;
   final String? address;
   final double? due;

  Customer({required this.imageUrl, required this.name, required this.email,required this.phone,required this.address,required this.due});

  factory Customer.fromJson(Map<String, dynamic> json) {

    return Customer(
      imageUrl: json['ImagePath'],
      name: json['Name'],
      email: json['Email'],
       phone: json['Phone'],
       address: json['PrimaryAddress'],
       due: json['TotalDue'],
    );
  }
}