part of VendingMachine;

class Controller {
  Model _model;
  Model get model => _model;
  
  View _view;
  View get view {
    if(_view == null){
      _view = new View();
    }
    
    return _view;
  }

  Controller(this._model) {
    _attachEvent();
  }

  void _attachEvent() {
    model.attach({
      "start" : _onStart,
      "stop" : _onStop,
      "sale" : _onSale,
      "return" : _onReturn
    });
  }
  
  void _onStart(e) {
    drawView();
  }
  
  void _onStop(e) {
    view.suspend();
    
    model.detach({
      "start" : _onStart,
      "stop" : _onStop,
      "sale" : _onSale,
      "return" : _onReturn
    });
    view.detach({
      "buy": buyProduct,
      "sell": sellProduct
    });
  }
  
  void _onSale(e) {
    view.changeAmount(e.detail["amount"]);
  }
  
  void _onReturn(e) {
    view.changeAmount(e.detail["amount"]);
  }

  void drawView() {
    view.attach({
      "buy": buyProduct,
      "sell": sellProduct,
      "clickStop": (e) {
        print("stop");
        model.stop();
      }
    });
    
    view.draw();
  }
  
  void buyProduct(Sample.CustomEvent e) {
    model.saleProduct(e.detail["product"]);
  }
  
  void sellProduct(Sample.CustomEvent e) {
    model.returnProduct(e.detail["product"]);
  }
}