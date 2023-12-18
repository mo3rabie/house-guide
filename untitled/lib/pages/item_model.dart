class Item{
  String? title;
  String? thumb_url;
  String? location;
  double? price;

Item(this.title, this.location, this.price, this.thumb_url);

static List<Item>recommendation = [
  Item("Student Housing", "Assuit", 3000, 
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbS-P_atZgCNvv2IZjjEkEMQiAVXFgrSMbxw&usqp=CAU"),
  Item("Student Housing", "Assuit", 2500, 
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEm990O43tUORjmMYmCAbzA2_YrSUEMNZwsw&usqp=CAU"),
  Item("Student Housing", "Assuit", 2000, 
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUfVKKevEhOxEg6QBG6dC7oLk3MIc93Moj0g&usqp=CAU"),
  Item("Student Housing", "Assuit", 3500, 
  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbS-P_atZgCNvv2IZjjEkEMQiAVXFgrSMbxw&usqp=CAU"),
  
];
}
