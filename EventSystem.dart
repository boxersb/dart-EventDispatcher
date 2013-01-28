library EventSystem;

typedef void Handler(Map e);

class EventDispatcher {
  Map <String, List>_listenerTable = <String, List>{};
  
  void attach(type, [Handler listener]) {
    if(?listener){
      type = type as String;
      
      if(!(_listenerTable.containsKey(type))){
        _listenerTable[type] = [];
      }
      
      _listenerTable[type].add(listener);
    }else{
      Map <String, Handler>listenerList = type as Map;
      
      listenerList.forEach( (String key, Handler hnd) => attach(key, hnd) );
    }
  }
  
  void detach(type, [Handler listener]) {
    if(?listener){
      type = type as String;
      
      if(!_listenerTable.containsKey(type)) return;
      
      List listeners = _listenerTable[type];
      int idx = listeners.indexOf(listener);
      
      if(idx > -1){
        listeners.removeAt(idx);
      }
    }else if(type is String){
      _listenerTable.remove(type);
    }else if(type is Map){
      Map <String, Handler>listenerList = type as Map;
      
      listenerList.forEach( (String key, Handler hnd) => detach(key, hnd) );
    }
  }
  
  bool dispatch(String type, [Map event]) {
    if(!(_listenerTable.containsKey(type))) return false;
    
    
    List listeners = _listenerTable[type];
    Map eventObject = ?event ? event : {};
    eventObject["type"] = type;
    
    listeners.forEach((Handler f) {
      f(eventObject);
    });
    
    return true;
  }
}
