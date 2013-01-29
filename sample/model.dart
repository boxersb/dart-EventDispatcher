part of VendingMachine;

class Model extends Sample.EventDispatcher {
  num _amount = 0;
  set amount(num a) => _amount = a;
  num get amount => _amount;
  
  void start() {
    dispatch("start");
  }
  
  void stop() {
    dispatch("stop");
  }
  
  bool saleProduct(Product product) {
    int price = product.price;
    
    amount -= price;
    
    dispatch("sale", {
      "amount": amount
    });
    
    return true;
  }
  
  bool returnProduct(Product product) {
    int price = product.price;
    double returnPrice = price * 0.75;
    
    amount += returnPrice;
    
    dispatch(new Sample.CustomEvent("return", {
      "amount": amount
    }));
    
    return true;
  }
}