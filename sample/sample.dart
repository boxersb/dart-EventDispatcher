library VendingMachine;

import "../src/EventDispatcher.dart" as Sample;
import "dart:html";

part "model.dart";
part "view.dart";
part "controller.dart";

class VendingMachine {
  Model _model;
  Model get model {
    if(_model == null){
      _model = new Model();
      new Controller(_model);      
    }
    
    return _model;
  }
  
  void start(int amount) {
    model.amount = amount;
    model.start();
  }
  
  void stop() {
    model.stop();
  }
}


main() {
  VendingMachine app = new VendingMachine();
  
  app.start(10000);
}